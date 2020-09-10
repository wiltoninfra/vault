# Study guide Hashicorp Vault
This document contains information about studies carried out with hashicorp Vault.

Website: https://www.vaultproject.io/

## Start Vault with Docker Local Study
```ssh
> docker run -d -p 8200:8200 --name vault-dev --hostname vault-dev wilton/vault:1.5.3
> docker exec vault-dev | grep
> docker logs container_id
```
###  Install vault local
```ssh
> wget https://releases.hashicorp.com/vault/1.2.3/vault_VERSAO_linux_amd64.zip
> unzip vault_1.2.3_linux_amd64.zip
> mv vault /usr/bin
> vault
```

Use the Token with the root key to pass your queries via API and enable external access

```ssh
> docker exec -ti vault-dev sh
> export VAULT_TOKEN="s.zCI5ZL1xjifUJvCb9FoA6XOr"
> export VAULT_ADDR='http://0.0.0.0:8200'
```
Access the console UI url:  http://localhost:8200

The root password is the automatically generated token, but it is possible to change it.

```ssh
curl \
--request POST \
--header "X-Vault-Token: s.emGLEdWOrXz1GclcXq9cWHA2" \
--data '{"policy":"path \"...\" {...} "}' \
https://vault.hashicorp.rocks/v1/sys/policy/policy-name
```
## Comands Vault
 
**Secrets**
```ssh
> vault secrets enable -path=name-path kv
> vault secrets enable -path=aws aws
> vault auth enable approle
```
**Write secret**
```ssh
> vault kv put secret/envs-qa/sv_myappp APP_NAME=myapp
> vault kv put env-qa/myapp1 APP_NAME="appbao"
```


**Read Secret**
```ssh
> vault read aws/creds/ec2
> vault read identity/entity/id/id_here
```
**Paths**
```ssh
> vault path-help secret
> vault path-help sys
```

**Polices**
```ssh
> vault policy write policy_name policy_file
> vault policy list
> vault auth list -detailed
> vault policy read policy_name
```
**Create AWS Config**
```ssh
> vault write auth/github/config organization=devinfrabr
> vault write auth/github/map/teams/dev value=dev-policy
```
```ssh
> vault write aws/config/root \
  access_key="ACCESS_KEY_AWS_HERE" \
  secret_key="SECRETE_KEY_AWS_HERE" \
  region=us-east-1
```  
**Include policy**
```ssh  
> vault write aws/roles/ec2 \
  credential_type=iam_user \
  policy_document=-<<EOF\
  {
	"Version": "2012-10-17",
		"Statement": [
	{
		"Effect": "Allow",
		"Action": "ec2:*",
		"Resource": "*"
		}
	]
  }
  EOF
```

## Example

**Create user and password**

```ssh
> vault write auth/userpass/users/wilton password="123456" policies="devops"
> vault auth list -format=json | jq -r '.["userpass/"].accessor' > accessor.txt
> vault login -method=userpass username=wilton password=123456
```
 
**Create Entity**
```ssh
> vault write identity/entity name="team" policies="devops" \
  metadata=organization="DEVINFRA BR." \
  metadata=team="DevOps"
```  
** Create Alias Entity**
```ssh
> vault write identity/entity-alias name="user" \
  canonical_id=9d02bbc8-cb96-d201-f656-e8960c363311 \
  mount_accessor=auth_userpass_95aa918c
```
**Groups**  
```ssh
> vault write identity/group-alias name="training" \
  mount_accessor=$(cat accessor.txt) \
  canonical_id="7d5821f2-0757-a6e1-96ba-6d377e35ae01"
```
  
```ssh
> vault init --key-shares=1 --key-threshold=1
> vault unseal <unseal_key_1>
> vault auth <initial_root_token>
```