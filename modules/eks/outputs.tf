output "cluster_id" {
  description = "The name/id of the EKS cluster"
  value       = aws_eks_cluster.this.id
}

output "cluster_arn" {
  description = "The Amazon Resource Name (ARN) of the cluster"
  value       = aws_eks_cluster.this.arn
}

output "cluster_endpoint" {
  description = "Endpoint for your Kubernetes API server"
  value       = aws_eks_cluster.this.endpoint
}

output "cluster_security_group_id" {
  description = "Security group ID attached to the EKS cluster"
  value       = aws_eks_cluster.this.vpc_config[0].cluster_security_group_id
}

output "node_group_security_group_id" {
  description = "Security group ID of the EKS node group"
  value       = aws_eks_node_group.this["general"].resources[0].remote_access_security_group_id
}

output "cluster_iam_role_name" {
  description = "Name of the IAM role associated with EKS cluster"
  value       = aws_iam_role.eks_cluster.name
}

output "cluster_iam_role_arn" {
  description = "ARN of the IAM role associated with EKS cluster"
  value       = aws_iam_role.eks_cluster.arn
}

output "node_groups" {
  description = "Map of EKS node groups"
  value = {
    for k, v in aws_eks_node_group.this : k => {
      id                  = v.id
      arn                 = v.arn
      status             = v.status
      node_group_name    = v.node_group_name
      node_role_arn      = v.node_role_arn
      subnet_ids         = v.subnet_ids
      instance_types     = v.instance_types
      desired_size       = v.scaling_config[0].desired_size
      min_size           = v.scaling_config[0].min_size
      max_size           = v.scaling_config[0].max_size
      disk_size          = v.disk_size
      capacity_type      = v.capacity_type
      labels             = v.labels
    }
  }
}

output "oidc_provider_url" {
  description = "URL of the EKS OIDC provider (without https://)"
  value       = replace(aws_eks_cluster.this.identity[0].oidc[0].issuer, "https://", "")
}

output "oidc_provider_arn" {
  description = "ARN of the EKS OIDC provider"
  value       = aws_iam_openid_connect_provider.this.arn
} 