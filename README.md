# Hashicorp Vault

Este material é de uso pessoal nos estudos pesquisas e testes realizados com Vault da Hashicorp maiores informações:
https://www.vaultproject.io/


## Start Vault with Docker Local Study

```ssh
$ docker run -d -p 8200:8200 --name vault-dev --hostname vault-dev wilton/vault:1.5.3
$ docker exec vault-dev | grep
$ docker logs container_id
```
Utilize o Token com a chave root para passar nas suas consultas via API e habilite o acesso externo

```ssh
$ docker exec -ti vault-dev sh
# export VAULT_TOKEN="TOKEN_ROOT_HERE"
# export VAULT_ADDR='http://0.0.0.0:8200'
```
Agora acesse o console via http
http://localhost:8200

A Senha root é o token gerado automaticamente, mas é possível mudar.

```ssh
curl \
--request POST \
--header "X-Vault-Token: s.emGLEdWOrXz1GclcXq9cWHA2" \
--data '{"policy":"path \"...\" {...} "}' \
https://vault.hashicorp.rocks/v1/sys/policy/policy-name

```



  

  

## comands Vault

```ssh
## Enable Secret
vault secrets enable -path=name-path kv

## Create AWS Config

vault write aws/config/root \
access_key=ACCESS_KEY_HERE \
secret_key=SECRET_KEY_HERE \
region=us-east-1  

## Include police 

vault write aws/roles/ec2 \
credential_type=iam_user \
policy_document=-<<EOF
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

## Consultando Credential
vault read aws/creds/ec2
```

## Install Vault

```ssh
$ wget https://releases.hashicorp.com/vault/1.2.3/vault_VERSAO_linux_amd64.zip
$ unzip vault_1.2.3_linux_amd64.zip
$ mv vault /usr/bin
$ vault
```

### Create Secret Engine
 
### Create Root Access AWS

### Create Role in Vault


##### Pesquisar
- vault auth enable approle
  



  {
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:DescribeInstances",
        "iam:GetInstanceProfile",
        "iam:GetUser",
        "iam:GetRole"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": ["sts:AssumeRole"],
      "Resource": ["arn:aws:iam::<AccountId>:role/<VaultRole>"]
    }
  ]
}


## Polices Vault Commands

vault policy write policy_name policy_file 
vault policy list
vault auth list -detailed
vault policy read policy_name


## Create Entity

vault write identity/entity name="bob-smith" policies="base" \
        metadata=organization="ACME Inc." \
        metadata=team="QA"

vault write identity/entity-alias name="bob" \
        canonical_id=9d02bbc8-cb96-d201-f656-e8960c363311 \
        mount_accessor=auth_userpass_95aa918c

vault write identity/entity-alias name="bob" \
        canonical_id="631256b1-8523-9838-5501-d0a1e2cdad9c" \
        mount_accessor=$(cat accessor.txt)

 vault write identity/entity-alias name="bsmith" \
        canonical_id="9d02bbc8-cb96-d201-f656-e8960c363311" \
        mount_accessor=$(cat accessor.txt)


vault write identity/group-alias name="training" \
        mount_accessor=$(cat accessor.txt) \
        canonical_id="7d5821f2-0757-a6e1-96ba-6d377e35ae01"

vault auth list -format=json | jq -r '.["userpass/"].accessor' > accessor.txt

vault read identity/entity/id/bob-smith
