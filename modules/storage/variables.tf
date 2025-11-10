variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "enable_versioning" {
  description = "Enable versioning for the bucket"
  type        = bool
  default     = true
}

variable "sse_algorithm" {
  description = "Server-side encryption algorithm to use"
  type        = string
  default     = "AES256"
}

variable "enable_lifecycle_rules" {
  description = "Enable lifecycle rules for the bucket"
  type        = bool
  default     = false
}

variable "lifecycle_rules" {
  description = "List of lifecycle rules for the bucket"
  type = list(object({
    id     = string
    status = string
    transitions = list(object({
      days          = number
      storage_class = string
    }))
    expiration = optional(object({
      days = number
    }))
  }))
  default = []
}

variable "create_service_user" {
  description = "Whether to create an IAM user for service access"
  type        = bool
  default     = false
}

variable "service_user_permissions" {
  description = "List of S3 permissions to grant to the service user"
  type        = list(string)
  default     = ["s3:PutObject", "s3:GetObject", "s3:DeleteObject", "s3:ListBucket"]
} 

variable "project_name" {
  description = "Name of the project"
  type        = string
}
