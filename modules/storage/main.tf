resource "aws_s3_bucket" "this" {
  bucket = "${var.project_name}-${var.bucket_name}"
  tags = var.tags
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id
  versioning_configuration {
    status = var.enable_versioning ? "Enabled" : "Disabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = var.sse_algorithm
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "this" {
  count  = var.enable_lifecycle_rules ? 1 : 0
  bucket = aws_s3_bucket.this.id

  dynamic "rule" {
    for_each = var.lifecycle_rules
    content {
      id     = rule.value.id
      status = rule.value.status

      dynamic "transition" {
        for_each = rule.value.transitions
        content {
          days          = transition.value.days
          storage_class = transition.value.storage_class
        }
      }

      dynamic "expiration" {
        for_each = rule.value.expiration != null ? [rule.value.expiration] : []
        content {
          days = expiration.value.days
        }
      }
    }
  }
}

resource "aws_iam_user" "service_user" {
  count = var.create_service_user ? 1 : 0
  name  = "${var.bucket_name}-service-user"
  tags  = var.tags
}

resource "aws_iam_access_key" "service_user" {
  count = var.create_service_user ? 1 : 0
  user  = aws_iam_user.service_user[0].name
}

resource "aws_iam_user_policy" "service_user" {
  count = var.create_service_user ? 1 : 0
  name  = "${var.bucket_name}-policy"
  user  = aws_iam_user.service_user[0].name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = var.service_user_permissions
        Resource = [
          aws_s3_bucket.this.arn,
          "${aws_s3_bucket.this.arn}/*"
        ]
      }
    ]
  })
} 