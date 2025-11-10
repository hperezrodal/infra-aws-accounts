variable "database_name" {
  description = "Name of the PostgreSQL database to create"
  type        = string
}

variable "db_username" {
  description = "Username for the PostgreSQL database user"
  type        = string
}

variable "db_host" {
  description = "Hostname of the PostgreSQL instance"
  type        = string
}

variable "master_username" {
  description = "Master username for the PostgreSQL instance"
  type        = string
}

variable "master_password" {
  description = "Master password for the PostgreSQL instance"
  type        = string
  sensitive   = true
}

variable "environment" {
  description = "Environment name"
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