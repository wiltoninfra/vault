## Cluster Vault / Consul / Telemetry

Test environment for Cluster Vault using Consul as Backend.

**Start Environment**
`docker-compose up -d --build`

Access containers `vault-server1 and vault-server2` because is necessary unsealed services.

**In Vault Server 1**
```
> export VAULT_ADDR='http://172.42.10.5:8200'
> vault operator init
> export VAULT_TOKEN="s.m0QtEVSQNFdhXnGPVJYLCHJg"
> vault operator unseal <Unseal Key-1> 
> vault operator unseal <Unseal Key-2> 
> vault operator unseal <Unseal Key-3> 
```
**In Vault Server 2**
```
> export VAULT_ADDR='http://172.42.10.6:8200'
> export VAULT_TOKEN="TOKEN_HERE"
> vault operator unseal <Unseal Key-4> 
> vault operator unseal <Unseal Key-5>
> vault operator unseal <Unseal Key-X>
```

**Servers Unsealed**

### Web Access Server

- **Consul**\
http://localhost:18501

- **Vault**\
http://localhost:8200

- **Prometheus**\
http://localhost:9090

- **Grafana**\
http://localhost:3000

**Enable Audit**
```
vault audit enable file file_path=/vault/vault-audit.log
vault audit list -detailed
```

**Enable Secret**
```
vault secrets enable -version=2 <path_name>
```


## Enable SSH Auth

```
> vault mount ssh
> vault secrets enable ssh
> vault write ssh/roles/otp key_type=otp default_user=ubuntu cidr_list=172.42.10.0/24
> vault write ssh/creds/otp ip=172.42.10.50
> vault ssh -role otp -mode otp -strict-host-key-checking=no root@172.42.10.50
```