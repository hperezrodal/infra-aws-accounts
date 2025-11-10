output "db_instance_endpoint" {
  description = "The connection endpoint for the database"
  value       = aws_db_instance.this.endpoint
}

output "db_security_group_id" {
  description = "The ID of the database security group"
  value       = aws_security_group.database.id
}

output "db_credentials_secret_arn" {
  description = "The ARN of the database credentials secret"
  value       = aws_secretsmanager_secret.db_credentials.arn
}

output "db_endpoint" {
  description = "The endpoint of the RDS instance"
  value       = split(":", aws_db_instance.this.endpoint)[0]
}

output "db_username" {
  description = "The master username for the RDS instance"
  value       = aws_db_instance.this.username
}

output "db_password" {
  description = "The master password for the RDS instance"
  value       = random_password.db_password.result
  sensitive   = true
}

output "db_dns_record" {
  description = "The DNS record for the database"
  value       = aws_route53_record.db.fqdn
} 