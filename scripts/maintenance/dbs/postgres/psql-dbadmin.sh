#!/bin/bash
source $BASH_LIBRARY_PATH/lib-loader.sh

SECRET_JSON=$(lib_aws_get_secret platform-postgres-$ENV-db-credentials)
if [ $? -ne 0 ]; then
    echo "Error: Failed to fetch secret from AWS Secrets Manager"
    exit 1
fi

USER=$(echo $SECRET_JSON | jq -r '.username')
PASS=$(echo $SECRET_JSON | jq -r '.password')
HOST="platform-postgres-${ENV}-db.c6ze8qm621uq.us-east-1.rds.amazonaws.com"
# Extract values from the secret JSON
DB="postgres"

# URL-encode the password to handle special characters like %
PASS_ENCODED=$(printf '%s' "$PASS" | jq -sRr @uri)

echo "HOST=$HOST"
echo "USER=$USER"
echo "DB=$DB"

lib_k8s_connect_to_postgres $HOST $USER "$PASS_ENCODED" $DB
  