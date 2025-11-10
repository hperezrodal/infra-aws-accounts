output "db_credentials_secret_arn" {
  description = "ARN of the database credentials secret"
  value       = aws_secretsmanager_secret.db_credentials.arn
}

output "db_endpoint" {
  description = "Database endpoint"
  value       = var.db_host
} 