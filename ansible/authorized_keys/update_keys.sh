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

# Create the authorized_keys file for the environment
cat > $ENV << EOF
# Authorized keys for $ENV environment
# Add SSH public keys below, one per line
EOF

echo "Created authorized_keys file for $ENV environment at ansible/authorized_keys/$ENV"
echo "Please add the SSH public keys to this file" 