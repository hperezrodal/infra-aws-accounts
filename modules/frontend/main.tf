resource "aws_ecr_repository" "this" {
  name                 = "${var.service_name}"
  image_scanning_configuration {
    scan_on_push = true
  }
  lifecycle {
    ignore_changes = [image_tag_mutability]
  }
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
