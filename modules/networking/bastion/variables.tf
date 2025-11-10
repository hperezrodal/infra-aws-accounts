variable "name" {
  description = "Name prefix for the bastion host"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "subnet_id" {
  description = "Public subnet ID"
  type        = string
}

variable "ami_id" {
  description = "AMI ID to use for bastion (Amazon Linux or Ubuntu)"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "default_key_pair_name" {
  description = "Optional default EC2 key pair name (for admin use)"
  type        = string
}

variable "allowed_ssh_cidr_blocks" {
  description = "CIDR blocks allowed to SSH"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}

variable "hosted_zone_id" {
  description = "The ID of the Route53 hosted zone"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, stg, uat)"
  type        = string
}

variable "domain_name" {
  description = "The base domain name (e.g., mycompany.com)"
  type        = string
}
