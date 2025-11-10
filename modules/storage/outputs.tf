output "bucket_name" {
  description = "Name of the created S3 bucket"
  value       = aws_s3_bucket.this.id
}

output "bucket_arn" {
  description = "ARN of the created S3 bucket"
  value       = aws_s3_bucket.this.arn
}

output "access_key_id" {
  description = "Access key ID for the service user"
  value       = var.create_service_user ? aws_iam_access_key.service_user[0].id : null
  sensitive   = true
}

output "secret_access_key" {
  description = "Secret access key for the service user"
  value       = var.create_service_user ? aws_iam_access_key.service_user[0].secret : null
  sensitive   = true
}

output "service_user_name" {
  description = "Name of the created service user"
  value       = var.create_service_user ? aws_iam_user.service_user[0].name : null
} 