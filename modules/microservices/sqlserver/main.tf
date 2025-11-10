resource "aws_ecr_repository" "this" {
  name                 = "${var.service_name}"
  image_scanning_configuration {
    scan_on_push = true
  }
  lifecycle {
    ignore_changes = [image_tag_mutability]
  }
}

module "sqlserver_database" {
  source = "../../rds/sqlserver-database"

  database_name   = var.db_username
  db_username     = var.db_username
  db_host         = var.db_host
  master_username = var.master_username
  master_password = var.master_password
  environment     = var.environment

  hosted_zone_id        = var.hosted_zone_id
  domain_name           = var.domain_name

}

data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = [var.oidc_provider_arn]
    }
    condition {
      test     = "StringEquals"
      variable = "${var.oidc_provider_url}:sub"
      values   = ["system:serviceaccount:${var.k8s_namespace}:${var.k8s_service_account}"]
    }
  }
}

resource "aws_iam_role" "irsa_role" {
  name               = "${var.service_name}-irsa"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_policy" "secret_access" {
  name        = "${var.service_name}-secret-access"
  description = "Allow access to Secrets Manager secret"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action   = [
           "secretsmanager:GetSecretValue",
           "secretsmanager:DescribeSecret"
           ],
        Effect   = "Allow",
        Resource = module.sqlserver_database.db_credentials_secret_arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.irsa_role.name
  policy_arn = aws_iam_policy.secret_access.arn
}

resource "aws_iam_policy" "external_dns" {
  name        = "${var.service_name}-external-dns"
  description = "Allow External-DNS to manage Route53 records"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "route53:ChangeResourceRecordSets",
          "route53:ListHostedZones",
          "route53:ListResourceRecordSets"
        ]
        Resource = [
          "arn:aws:route53:::hostedzone/${var.hosted_zone_id}",
          "*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "external_dns" {
  role       = aws_iam_role.irsa_role.name
  policy_arn = aws_iam_policy.external_dns.arn
} 
