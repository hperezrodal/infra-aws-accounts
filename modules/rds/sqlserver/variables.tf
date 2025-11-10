variable "service_name" {
  description = "Name of the service"
  type        = string
}

variable "db_username" {
  description = "Username for the database"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for the database"
  type        = list(string)
}

variable "db_security_group_ids" {
  description = "List of security group IDs for the database"
  type        = list(string)
}

variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "cluster_sg_id" {
  description = "Security group ID of the EKS cluster"
  type        = string
}

variable "bastion_sg_id" {
  description = "Security group ID of the bastion host"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

variable "hosted_zone_id" {
  description = "ID of the Route53 hosted zone"
  type        = string
}

variable "domain_name" {
  description = "Domain name for the Route53 record"
  type        = string
} 