#!/bin/bash
source $BASH_LIBRARY_PATH/lib-loader.sh

SECRET_JSON=$(lib_aws_get_secret platform-sqlserver-$ENV-db-credentials)
if [ $? -ne 0 ]; then
    echo "Error: Failed to fetch secret from AWS Secrets Manager"
    exit 1
fi

USER=$(echo $SECRET_JSON | jq -r '.username')
PASS=$(echo $SECRET_JSON | jq -r '.password')
HOST="platform-sqlserver-${ENV}-db.c6ze8qm621uq.us-east-1.rds.amazonaws.com"
# Extract values from the secret JSON
DB="master"

echo "HOST=$HOST"
echo "USER=$USER"
echo "DB=$DB"

lib_k8s_run_sql_client $HOST $USER $PASS $DB
  