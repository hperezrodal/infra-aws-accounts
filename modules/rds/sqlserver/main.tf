resource "random_password" "db_password" {
  length  = 16
  special = true
}

resource "aws_secretsmanager_secret" "db_credentials" {
  name = "${var.service_name}-db-credentials"
}

resource "aws_secretsmanager_secret_version" "db_credentials_version" {
  secret_id     = aws_secretsmanager_secret.db_credentials.id
  secret_string = jsonencode({
    username = var.db_username
    password = random_password.db_password.result
  })
}

resource "aws_db_subnet_group" "this" {
  name       = "${var.service_name}-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "${var.service_name}-db-subnet-group"
  }
}

resource "aws_db_instance" "this" {
  identifier              = "${var.service_name}-db"
  engine                  = "sqlserver-ex"
  engine_version          = "15.00.4073.23.v1"
  instance_class          = "db.t3.medium"
  allocated_storage       = 20
  username                = var.db_username
  password                = random_password.db_password.result
  db_subnet_group_name    = aws_db_subnet_group.this.name
  vpc_security_group_ids  = concat(var.db_security_group_ids, [aws_security_group.database.id])
  skip_final_snapshot     = true
  publicly_accessible     = false
  multi_az                = false
}

resource "aws_security_group" "database" {
  name_prefix = "${var.project_name}-${var.environment}-db"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 1433  # SQL Server port
    to_port         = 1433
    protocol        = "tcp"
    security_groups = [var.cluster_sg_id]
    description     = "Allow traffic from EKS cluster"
  }

  ingress {
    from_port       = 1433  # SQL Server port
    to_port         = 1433
    protocol        = "tcp"
    security_groups = [var.bastion_sg_id]
    description     = "Allow traffic from Bastion Host"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-${var.environment}-db"
    }
  )
}

resource "aws_route53_record" "db" {
  zone_id = var.hosted_zone_id
  name    = "${var.environment}.${var.service_name}-db.${var.domain_name}"
  type    = "CNAME"
  ttl     = "300"
  records = [split(":", aws_db_instance.this.endpoint)[0]]
} 