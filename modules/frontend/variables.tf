variable "service_name" {
  description = "Name of the microservice"
  type        = string
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
