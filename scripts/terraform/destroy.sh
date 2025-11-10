#! /bin/bash

# Check if ENV is set
if [ -z "$ENV" ]; then
    echo "Error: ENV environment variable is not set"
    exit 1
fi

echo "ENV=$ENV"

terraform destroy -var-file="env/$ENV.tfvars" -lock=false
