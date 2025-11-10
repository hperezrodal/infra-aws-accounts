#! /bin/bash

# Check if ENV is set
if [ -z "$ENV" ]; then
    echo "Error: ENV environment variable is not set"
    exit 1
fi

echo "ENV=$ENV"

# Initialize Terraform
terraform init -backend-config=backend-config.hcl

# Select workspace and plan
terraform workspace select $ENV
terraform plan -var-file="$ENV.tfvars" -lock=false
