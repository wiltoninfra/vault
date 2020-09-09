#!/bin/sh

chave_acesso=$( curl -s -X GET -H "X-Vault-Token: $VAULT_TOKEN" http://localhost:8200/v1/aws/creds/lambda-deploy |  jq -r  '.data.access_key' ) 
chave_secreta=$( curl -s -X GET -H "X-Vault-Token: $VAULT_TOKEN" http://localhost:8200/v1/aws/creds/lambda-deploy |  jq -r  '.data.secret_key' )
idlease=$( curl -s -X GET -H "X-Vault-Token: $VAULT_TOKEN" http://localhost:8200/v1/aws/creds/lambda-deploy |  jq -r  '.lease_id' )

export ACCESS_KEY=$chave_acesso
export SECRET_KEY=$chave_secreta
export LEASEID=$idlease

printenvaws

sleep 30

vault lease revoke -prefix $LEASEID

export VAULT_ADDR=http://localhost:8200/

export VAULT_CREDENTIALS_PATH=aws/creds/lambda-deploy

export VAULT_CREDENTIALS_DURATION=12h

