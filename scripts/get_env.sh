#!/bin/sh

ACCESS_KEY=$( curl -s -X GET -H "X-Vault-Token: $VAULT_TOKEN" http://localhost:8200/v1/aws/creds/lambda-deploy |  jq -r  '.data.access_key' ) 
SECRET_KEY=$( curl -s -X GET -H "X-Vault-Token: $VAULT_TOKEN" http://localhost:8200/v1/aws/creds/lambda-deploy |  jq -r  '.data.secret_key' )
LEASEID=$( curl -s -X GET -H "X-Vault-Token: $VAULT_TOKEN" http://localhost:8200/v1/aws/creds/lambda-deploy |  jq -r  '.lease_id' )

sleep 30

vault lease revoke -prefix $LEASEID
export VAULT_ADDR=http://localhost:8200/
export VAULT_CREDENTIALS_PATH=aws/creds/lambda-deploy
export VAULT_CREDENTIALS_DURATION=1h

