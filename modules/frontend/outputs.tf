output "ecr_repository_url" {
  description = "URL of the ECR repository"
  value       = aws_ecr_repository.this.repository_url
}

output "irsa_role_arn" {
  description = "ARN of the IAM role for service account"
  value       = aws_iam_role.irsa_role.arn
}
