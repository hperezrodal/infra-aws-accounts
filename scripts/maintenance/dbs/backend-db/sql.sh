#!/bin/bash
source $BASH_LIBRARY_PATH/lib-loader.sh

SECRET_JSON=$(lib_aws_get_secret backend-$ENV-credentials)
if [ $? -ne 0 ]; then
    echo "Error: Failed to fetch secret from AWS Secrets Manager"
    exit 1
fi

# Extract values from the secret JSON
HOST=$(echo $SECRET_JSON | jq -r '.host')
USER=$(echo $SECRET_JSON | jq -r '.username')
PASS=$(echo $SECRET_JSON | jq -r '.password')
DB=$(echo $SECRET_JSON | jq -r '.database')

echo "HOST=$HOST"
echo "USER=$USER"
echo "DB=$DB"

lib_k8s_run_sql_client $HOST $USER $PASS $DB
  