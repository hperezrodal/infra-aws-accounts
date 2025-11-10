variable "service_name" {
  description = "Name of the microservice"
  type        = string
}

variable "db_username" {
  description = "Username for the SQL Server DB"
  type        = string
}

variable "db_host" {
  description = "Hostname of the SQL Server instance"
  type        = string
}

variable "master_username" {
  description = "Master username for the SQL Server instance"
  type        = string
}

variable "master_password" {
  description = "Master password for the SQL Server instance"
  type        = string
  sensitive   = true
}

variable "cluster_sg_id" {
  description = "The security group ID of the EKS cluster"
  type        = string
}

variable "oidc_provider_url" {
  description = "EKS OIDC provider URL (without https://)"
  type        = string
}

variable "oidc_provider_arn" {
  description = "ARN of the EKS OIDC provider"
  type        = string
}

variable "k8s_namespace" {
  description = "Kubernetes namespace for the service"
  type        = string
}

variable "k8s_service_account" {
  description = "Service account name that will access the secret"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "environment" {
  description = "The environment (terraform workspace)"
  type        = string
}

variable "project_name" {
  description = "The name of the project"
  type        = string
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "source_account_id" {
  description = "AWS account ID of the source account that needs ECR access"
  type        = string
}

variable "hosted_zone_id" {
  description = "The ID of the Route53 hosted zone"
  type        = string
}

variable "domain_name" {
  description = "The base domain name (e.g., mycompany.com)"
  type        = string
}