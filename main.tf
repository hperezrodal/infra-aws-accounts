terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
  ##assume_role {
  ##  role_arn = "arn:aws:iam::${var.aws_account_id}:role/OrganizationAccountAccessRole"
  ##}
}

output "workspace" {
  value = terraform.workspace
}

module "vpc" {
  source = "./modules/networking/vpc"

  environment  = terraform.workspace
  project_name = var.project_name
  vpc_cidr     = var.vpc_cidr
  azs          = var.availability_zones
  tags         = var.tags
}

module "eks" {
  source = "./modules/eks"

  cluster_name    = "${var.project_name}-${terraform.workspace}-cluster"
  cluster_version = "1.32"
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.private_subnet_ids
  assume_role_arn = "arn:aws:iam::${var.aws_account_id}:role/OrganizationAccountAccessRole"
  environment     = terraform.workspace
  domain          = var.domain_name
  hosted_zone_id  = var.hosted_zone_id
  aws_account_id  = var.aws_account_id

  cluster_endpoint_private_access      = true
  cluster_endpoint_public_access       = true
  cluster_endpoint_public_access_cidrs = ["0.0.0.0/0"]

  eks_managed_node_groups = {
    general = {
      name           = "general-${terraform.workspace}"
      min_size       = var.eks_min_size
      max_size       = var.eks_max_size
      desired_size   = var.eks_desired_size
      instance_types = var.eks_instance_types
      capacity_type  = "ON_DEMAND"
      disk_size      = 50
      labels = {
        Environment = "${terraform.workspace}"
        NodeGroup   = "general"
      }
      taints = []
    }
  }

  tags = merge(
    var.tags,
    {
      Component = "eks"
    }
  )
}

# Shared DB
module "rds_sqlserver" {
  source = "./modules/rds/sqlserver"

  service_name          = "platform-sqlserver-${terraform.workspace}"
  db_username           = "dbadmin"
  private_subnet_ids    = module.vpc.private_subnet_ids
  db_security_group_ids = [module.eks.cluster_security_group_id]
  vpc_id                = module.vpc.vpc_id
  cluster_sg_id         = module.eks.cluster_security_group_id
  bastion_sg_id         = module.bastion.security_group_id
  environment           = terraform.workspace
  project_name          = var.project_name
  tags                  = var.tags
  hosted_zone_id        = var.hosted_zone_id
  domain_name           = var.domain_name
}

# Create the database master password secret if it doesn't exist
resource "random_password" "db_master_password" {
  length  = 32
  special = true
}

resource "aws_secretsmanager_secret" "db_master_password" {
  name = "/${var.project_name}/${terraform.workspace}/db/master-password"
}

resource "aws_secretsmanager_secret_version" "db_master_password" {
  secret_id     = aws_secretsmanager_secret.db_master_password.id
  secret_string = random_password.db_master_password.result
}

# Get the database master password from Secrets Manager
data "aws_secretsmanager_secret" "db_master_password" {
  name       = "/${var.project_name}/${terraform.workspace}/db/master-password"
  depends_on = [aws_secretsmanager_secret.db_master_password]
}

data "aws_secretsmanager_secret_version" "db_master_password" {
  secret_id  = data.aws_secretsmanager_secret.db_master_password.id
  depends_on = [aws_secretsmanager_secret_version.db_master_password]
}

module "backend_service" {
  source = "./modules/microservices/sqlserver"

  service_name = "backend-${terraform.workspace}"

  # Database configuration
  db_username     = "backend"
  db_host         = module.rds_sqlserver.db_endpoint
  master_username = "dbadmin"
  master_password = data.aws_secretsmanager_secret_version.db_master_password.secret_string

  # EKS configuration
  cluster_sg_id       = module.eks.cluster_security_group_id
  oidc_provider_url   = module.eks.oidc_provider_url
  oidc_provider_arn   = module.eks.oidc_provider_arn
  k8s_namespace       = "backend"
  k8s_service_account = "backend-service-account"

  # VPC configuration
  vpc_id = module.vpc.vpc_id

  # General configuration
  environment  = terraform.workspace
  project_name = var.project_name
  tags         = merge(var.tags, { Component = "backend-service" })

  # Source account for ECR access
  source_account_id = var.source_account_id

  hosted_zone_id = var.hosted_zone_id
  domain_name    = var.domain_name
}

module "frontend" {

  source       = "./modules/frontend"
  service_name = "frontend-${terraform.workspace}"

  # EKS configuration
  cluster_sg_id       = module.eks.cluster_security_group_id
  oidc_provider_url   = module.eks.oidc_provider_url
  oidc_provider_arn   = module.eks.oidc_provider_arn
  k8s_namespace       = "frontend"
  k8s_service_account = "frontend-account"

  # VPC configuration
  vpc_id = module.vpc.vpc_id

  # General configuration
  environment  = terraform.workspace
  project_name = var.project_name
  tags         = merge(var.tags, { Component = "frontend" })

  # Source account for ECR access
  source_account_id = var.source_account_id

}

module "data_capture" {

  source       = "./modules/frontend"
  service_name = "data-capture-${terraform.workspace}"

  # EKS configuration
  cluster_sg_id       = module.eks.cluster_security_group_id
  oidc_provider_url   = module.eks.oidc_provider_url
  oidc_provider_arn   = module.eks.oidc_provider_arn
  k8s_namespace       = "data-capture"
  k8s_service_account = "data-capture-account"

  # VPC configuration
  vpc_id = module.vpc.vpc_id

  # General configuration
  environment  = terraform.workspace
  project_name = var.project_name
  tags         = merge(var.tags, { Component = "data-capture" })

  # Source account for ECR access
  source_account_id = var.source_account_id

}

module "backend_storage" {
  source = "./modules/storage"

  bucket_name  = "backend-${terraform.workspace}-storage"
  project_name = "${var.project_name}"

  enable_versioning = false
  sse_algorithm    = "AES256"
  
  create_service_user = true
  service_user_permissions = [
    "s3:PutObject",
    "s3:GetObject",
    "s3:DeleteObject",
    "s3:ListBucket"
  ]

  enable_lifecycle_rules = false

  tags = merge(
    var.tags,
    {
      Component = "backend-storage"
      Service   = "backend"
    }
  )
}

module "key_pair" {
  source = "./modules/networking/key-pair"

  key_name = "admin-key-${terraform.workspace}"
  tags     = var.tags
}

module "bastion" {
  source                = "./modules/networking/bastion"
  name                  = "bastion-${terraform.workspace}"
  vpc_id                = module.vpc.vpc_id
  subnet_id             = module.vpc.public_subnet_ids[0]
  ami_id                = "ami-00a929b66ed6e0de6" # Amazon Linux 2023 AMI
  instance_type         = "t3.micro"
  default_key_pair_name = module.key_pair.key_name
  hosted_zone_id        = var.hosted_zone_id
  environment           = terraform.workspace
  domain_name           = var.domain_name
  tags                  = var.tags
}

output "bastion_public_ip" {
  value = module.bastion.public_ip
}

output "backend_storage_access_key" {
  description = "Access key ID for the backend storage service user"
  value       = module.backend_storage.access_key_id
  sensitive   = true
}

output "backend_storage_secret_key" {
  description = "Secret access key for the backend storage service user"
  value       = module.backend_storage.secret_access_key
  sensitive   = true
}

output "backend_storage_bucket_name" {
  description = "Name of the backend storage bucket"
  value       = module.backend_storage.bucket_name
}


# Shared DB PostgreSQL
module "rds_postgres" {
  source = "./modules/rds/postgres"

  service_name          = "platform-postgres-${terraform.workspace}"
  db_username           = "dbadmin"
  private_subnet_ids    = module.vpc.private_subnet_ids
  db_security_group_ids = [module.eks.cluster_security_group_id]
  vpc_id                = module.vpc.vpc_id
  cluster_sg_id         = module.eks.cluster_security_group_id
  bastion_sg_id         = module.bastion.security_group_id
  environment           = terraform.workspace
  project_name          = var.project_name
  tags                  = var.tags
  hosted_zone_id        = var.hosted_zone_id
  domain_name           = var.domain_name
}


module "massive_load_service" {
  source = "./modules/microservices/postgres"

  service_name = "massive-load-${terraform.workspace}"

  # Database configuration
  db_username     = "massiveload"
  db_host         = module.rds_postgres.db_endpoint
  master_username = "dbadmin"
  master_password = data.aws_secretsmanager_secret_version.db_master_password.secret_string

  # EKS configuration
  cluster_sg_id       = module.eks.cluster_security_group_id
  oidc_provider_url   = module.eks.oidc_provider_url
  oidc_provider_arn   = module.eks.oidc_provider_arn
  k8s_namespace       = "massive-load"
  k8s_service_account = "massive-load-service-account"

  # VPC configuration
  vpc_id = module.vpc.vpc_id

  # General configuration
  environment  = terraform.workspace
  project_name = var.project_name
  tags         = merge(var.tags, { Component = "massive-load-service" })

  # Source account for ECR access
  source_account_id = var.source_account_id

  hosted_zone_id = var.hosted_zone_id
  domain_name    = var.domain_name
}

module "massive_load_storage" {
  source = "./modules/storage"

  bucket_name  = "massive-load-${terraform.workspace}-storage"
  project_name = "${var.project_name}"

  enable_versioning = false
  sse_algorithm    = "AES256"
  
  create_service_user = true
  service_user_permissions = [
    "s3:PutObject",
    "s3:GetObject",
    "s3:DeleteObject",
    "s3:ListBucket"
  ]

  enable_lifecycle_rules = false

  tags = merge(
    var.tags,
    {
      Component = "massive-load-storage"
      Service   = "massive-load"
    }
  )
}
