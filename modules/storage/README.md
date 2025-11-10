# S3 Storage Module

This Terraform module creates an S3 bucket with versioning and server-side encryption enabled, along with an IAM user that has permissions to manage objects in the bucket.

## Features

- Creates an S3 bucket with versioning enabled
- Enables server-side encryption using AES256
- Creates an IAM user with appropriate permissions
- Generates access keys for the IAM user
- Applies tags to all resources

## Usage

```hcl
module "storage" {
  source = "./modules/storage"

  bucket_name = "my-backend-storage"
  tags = {
    Environment = "production"
    Project     = "my-project"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| bucket_name | Name of the S3 bucket | `string` | n/a | yes |
| tags | Tags to apply to all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| bucket_name | Name of the created S3 bucket |
| bucket_arn | ARN of the created S3 bucket |
| access_key_id | Access key ID for the service user (sensitive) |
| secret_access_key | Secret access key for the service user (sensitive) |

## Security

- The bucket has server-side encryption enabled by default
- The IAM user has minimal required permissions (PutObject, GetObject, DeleteObject, ListBucket)
- Access keys are marked as sensitive in Terraform outputs 