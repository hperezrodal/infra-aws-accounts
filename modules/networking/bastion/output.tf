output "public_ip" {
  description = "Public IP of the Bastion host"
  value       = aws_instance.bastion.public_ip
}

output "instance_id" {
  description = "Instance ID of the Bastion host"
  value       = aws_instance.bastion.id
}

output "security_group_id" {
  description = "The ID of the bastion security group"
  value       = aws_security_group.bastion.id
} 