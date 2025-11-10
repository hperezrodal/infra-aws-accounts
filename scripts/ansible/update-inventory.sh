#! /bin/bash

# Check if ENV is set
if [ -z "$ENV" ]; then
    echo "Error: ENV environment variable is not set"
    exit 1
fi

echo "ENV=$ENV"

./ansible/update-inventory.sh $ENV