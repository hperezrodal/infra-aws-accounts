# EKS Module

This Terraform module creates an Amazon Elastic Kubernetes Service (EKS) cluster with managed node groups.

## Features

- Creates an EKS cluster with configurable version
- Supports both private and public cluster endpoints
- Creates managed node groups with customizable configurations
- Handles IAM roles and policies for both cluster and node groups
- Supports node group taints and labels
- Configurable instance types and capacity types (ON_DEMAND/SPOT)
- Automatic scaling configuration for node groups

## Usage

```hcl
module "eks" {
  source = "./modules/eks"

  cluster_name    = "my-eks-cluster"
  cluster_version = "1.27"
  vpc_id         = "vpc-12345678"
  subnet_ids     = ["subnet-1", "subnet-2", "subnet-3"]

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = false

  eks_managed_node_groups = {
    general = {
      name           = "general"
      min_size       = 1
      max_size       = 3
      desired_size   = 2
      instance_types = ["t3.medium"]
      capacity_type  = "ON_DEMAND"
      disk_size      = 50
      labels = {
        Environment = "production"
      }
      taints = []
    }
  }

  tags = {
    Environment = "production"
    Terraform   = "true"
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13.0 |
| aws | ~> 4.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cluster_name | Name of the EKS cluster | `string` | n/a | yes |
| cluster_version | Kubernetes version to use for the EKS cluster | `string` | `"1.27"` | no |
| vpc_id | ID of the VPC where the EKS cluster will be created | `string` | n/a | yes |
| subnet_ids | List of subnet IDs for the EKS cluster | `list(string)` | n/a | yes |
| cluster_endpoint_private_access | Indicates whether or not the Amazon EKS private API server endpoint is enabled | `bool` | `true` | no |
| cluster_endpoint_public_access | Indicates whether or not the Amazon EKS public API server endpoint is enabled | `bool` | `false` | no |
| cluster_endpoint_public_access_cidrs | List of CIDR blocks which can access the Amazon EKS public API server endpoint | `list(string)` | `["0.0.0.0/0"]` | no |
| eks_managed_node_groups | Map of EKS managed node group definitions | `map(object)` | `{}` | no |
| tags | A map of tags to add to all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| cluster_id | The name/id of the EKS cluster |
| cluster_arn | The Amazon Resource Name (ARN) of the cluster |
| cluster_endpoint | Endpoint for your Kubernetes API server |
| cluster_security_group_id | Security group ID attached to the EKS cluster |
| cluster_iam_role_name | Name of the IAM role associated with EKS cluster |
| cluster_iam_role_arn | ARN of the IAM role associated with EKS cluster |
| node_groups | Map of EKS node groups with their configurations |

## License

This module is licensed under the MIT License. 