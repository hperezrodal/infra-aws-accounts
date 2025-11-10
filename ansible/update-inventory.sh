#!/bin/bash

# Check if environment is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <environment>"
    echo "Environment must be one of: dev, qa, uat"
    exit 1
fi

ENV=$1

# Validate environment
if [[ ! "$ENV" =~ ^(dev|qa|uat)$ ]]; then
    echo "Invalid environment. Must be one of: dev, qa, uat"
    exit 1
fi

# Switch to the environment's Terraform workspace
terraform workspace select $ENV

# Get the bastion public IP from Terraform output
BASTION_IP=$(terraform output -raw bastion_public_ip)

# Update the Ansible inventory file for the specific environment
cat > ansible/inventory/$ENV/hosts << EOF
[bastion]
$BASTION_IP

[all:vars]
ansible_ssh_private_key_file=./secrets/keys/admin-key-$ENV.pem
ansible_user=ec2-user
EOF

echo "Ansible inventory updated for $ENV environment with bastion IP: $BASTION_IP" 