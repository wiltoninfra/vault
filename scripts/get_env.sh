#!/bin/bash

access_key=$( curl -s -X GET -H "X-Vault-Token: s.emGLEdWOrXz1GclcXq9cWHA2" http://localhost:8200/v1/aws/creds/ec2|  jq -r  '.data.access_key' ) 
secret_key=$( curl -s -X GET -H "X-Vault-Token: s.emGLEdWOrXz1GclcXq9cWHA2" http://localhost:8200/v1/aws/creds/ec2|  jq -r  '.data.secret_key' )

echo 'access_key='$access_key
echo 'secret_key='$secret_key