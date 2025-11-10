resource "aws_security_group" "bastion" {
  name        = "${var.name}-sg"
  description = "Allow SSH access to Bastion Host"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_ssh_cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

resource "aws_instance" "bastion" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  associate_public_ip_address = true
  key_name               = var.default_key_pair_name
  vpc_security_group_ids = [aws_security_group.bastion.id]
  tags = merge(var.tags, {
    Name = var.name
  })
}

resource "aws_route53_record" "bastion" {
  zone_id = var.hosted_zone_id
  name    = "${var.environment}.bastion.${var.domain_name}"
  type    = "A"
  ttl     = "300"
  records = [aws_instance.bastion.public_ip]
} 