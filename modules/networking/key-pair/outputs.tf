output "key_name" {
  description = "The name of the key pair"
  value       = aws_key_pair.this.key_name
}

output "key_pair_id" {
  description = "The ID of the key pair"
  value       = aws_key_pair.this.id
} 