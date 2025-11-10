output "ecr_repository_url" {
  description = "URL of the ECR repository"
  value       = aws_ecr_repository.this.repository_url
}

output "irsa_role_arn" {
  description = "ARN of the IAM role for service account"
  value       = aws_iam_role.irsa_role.arn
}

output "db_endpoint" {
  description = "Database endpoint"
  value       = module.postgres_database.db_endpoint
}

output "db_secret_arn" {
  description = "ARN of the database credentials secret"
  value       = module.postgres_database.db_credentials_secret_arn
}
