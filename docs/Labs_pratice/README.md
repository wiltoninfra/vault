## Part1

1. Starting vault dev mode: vault server -dev
2. Setting environment variables for Linux and Mac: export VAULT_ADDR="http://127.0.0.1:8200"
3. KV Secret Engine Commands:
   
Create multiple versions of secret
	vault kv put secret/second-secret user=admin01
	vault kv put secret/second-secret user=admin02
	vault kv put secret/second-secret user=admin03
Read Secret:
	vault kv get secret/second-secret
Read specific version of secret
	vault kv get -version=2 secret/second-secret
Delete specific version of secret
	vault kv delete -versions=2 secret/second-secret
Undelete version of secret
	vault kv undelete -versions=2 secret/second-secret
Permanently delete version of secret:
	vault kv destroy -versions=2 secret/second-secret
Delete the secret
	vault kv metadata delete secret/second-secret

4. Enable a new KV Secret Engine: https://www.vaultproject.io/docs/secrets
    vault secrets enable -path=demopath -version=2 kv 
    OR 
    vault secrets enable kv-v2
	
	vault secrets disable demopath/

5. Secrets Engine Lifecycle: Most secrets engine can be enabled, disabled, tuned or moved via the CLI or API.
  a) Enable : This enables secret engine at given path. By default they are enabled at their "type" (i.e "aws" enables at "aws/").
  b) Disable : This disables an existing secret engine. When an secret engine is disabled, all the secrets are revoked.
  c) Move : This moves the path of existing secrets engine.

6. Dynamic Secrets: In KV secrets engine we have to manually store the data. In opposed to that, certain engine works based on dynamic secrets. These secrets do not exist until they are generated.

7. Revoking Secrets: Vault will automatically revoke dynamic credentials and this can further be tuned by setting the lease duration. Once 	secret is revoked, the access keys are no longer valid. (i.e dynamically generated aws secrets).

8. Lease management:
	vault lease renew -increment=36000 demopath/creds/admini-role/wT7Nuleh1RUW5XTKUuemxwZ2
	vault lease revoke -h

9. There are 2 ways to revoke lease:
     a) vault lease revoke my-lease-id : Revoke a specific lease
     b) vault lease revoke -prefix aws/ : Revoke all aws access keys.

10. Transit Secrets Engine: Vault transit secrets engine handles cryptographic functions on data-in-transit. Vault doesn't store the data sent to the secret engine, so it can always be viewed as encryption as service.
    a) CLI Command:
         Encrypting Data
          vault write transit/encrypt/demo-key plaintext=<Base64 encoded text>
         Decrypting Data
          vault write transit/decrypt/demo-key ciphertext=<YOUR-CIPHERTEXT-HERE> (resultant output in base64)


## Part 2

1. login via userpass auth method using cli:
		vault login -method=userpass username=admin password=password
2. Policites are written is HCL format and are often referred as ACL policies. Everything in vault is path based and admins write policies to grant or forbid access to certain paths and operation in vault.
   path "auth/*" {
   	capabilities = ["create","read","update","delete","list","sudo"]
   }

3. List of important capabilities:
   > Create, Read, Update, Delete, List, Sudo, Deny

4. Commands:

```json
   > path "sys/mounts" {
     capabilities = ["read"]
     }
   > vault login -method=userpass username=admin password=password
   > vault secrets list


   > path "sys/policies/acl" {
      capabilities = ["read","list"]
     }  
   > vault policy list


   > path "secret/*" {
      capabilities = ["read"]
     }
   > vault kv get secret/firstsecret

   > vault kv get secret/supersecret [should be denied]
   > path "secret/+/supersecret" {
 		 capabilities = ["deny"]
	 }
```

5. Root protected API endpoints: Some of the paths are more restrictive and required root token or sudo capability in the policy.
  > auth/token/accessors
  > auth/token
  > sys/audit
  > sys/rotate
  > sys/seal

6. AppRole Auth Method: Some of supported auth methods are targeted towards human and some towards machine i.e Approle. For AppRole Authentication RoleId and SecretId is used for authentication. If authentication is successful token is generated and this token is used to perform operation on vault. Steps to use AppRole:
  a) Create AppRole Auth Method from browser dashboard.
  b) Create a policy (enkins-role-policy).
     path "secret/*" {
      capabilities = ["create","read","update","delete"]
     }
  c) Create a new Role with associated policy:
      vault write auth/approle/role/jenkins token_policies="jenkins-role-policy"
  d) Fetch Information About Role:
      vault read auth/approle/role/jenkins
  e) Fetch the Role ID
      vault read auth/approle/role/jenkins/role-id
  f) Fetch the Secret ID
       vault write -f auth/approle/role/jenkins/secret-id
  g) Authenticate with AppRole
       vault write auth/approle/login role_id="YOUR-ROLE-ID" secret_id="YOUR-SECRET-ID"

7. All the vault capabilities are accessible via HTTP API. Even most call from CLI actually invokes HTTP Api. Some of the vault features are not available via CLI and can only be accessed via HTTP Api. With the help of curl we can send request to vault and can get appropriate response. client token can be used to make the call, client token can be set with X-Vault-Token http header within request.

8. vault print token:
     vault print token

   Read the firstsecret:
      curl --header "X-Vault-Token: s.D4mEpn77EhyLvDOrAy2egr8g" https://127.0.0.1:8200/v1/secret/data/firstsecret?version=1

   Create a new secret:
     curl --header "X-Vault-Token: s.D4mEpn77EhyLvDOrAy2egr8g" --request POST --data @payload.json http://127.0.0.1:8200/v1/secret/data/api-secret

     payload.json
		{
		  "data": {
		  "course": "vault-associate",
		  "instructor": "zeal"
		  }
		} 

9. All api routes are prefixed with /v1/.
   Example: /v1/secret/foo - This maps to secret/foo where foo is the key in the secret/ mount.
   curl --header "X-Vault-Token: s.D4mEpn77EhyLvDOrAy2egr8g" https://127.0.0.1:8200/v1/secret/foo

   For listing related aspects, like vault secrets list, you can either issue a GET with the query parameter list=true, or you can use the LIST HTTP verb.
   curl -H "X-Vault-Token: s.D4mEpn77EhyLvDOrAy2egr8g" -X LIST http://127.0.0.1:8200/v1/secret/

10. Http verb to capability mapping: (https://www.vaultproject.io/api-docs/secret/kv/kv-v2)
     capability | Associated HTTP Verb
    a) create - POST/PUT
    b) list - GET
    c) update - POST/PUT
    d) delete - DELETE
    e) list - LIST

11. The token capabilities command fetches the capability of a token for a given path.
      vault login -method=userpass username=demouser password=password
	  vault token capabilities sys/
	  vault login [ROOT-TOKEN]
	  vault token capabilities [YOUR-TOKEN] sys/

	If a token is provided as an argument, the "/sys/capabilities" endpoint and permission is used.
	If no token is provided, the "/sys/capabilities-self" endpoint and permission is used with the locally authenticated token.

12. Authentication for multiple Users: Each vault client may have multiple accounts with various identity providers that are enabled on the vault server. In this case an entity can be created with name "bob" and create alias that represents each of the account and associate them as an entity member.
    
     Policy ---> bob-smith (Entity) ---> bob alias
                                    ---> mrbob alias

    Base Policy Used For Entities and Users:
      path "secret/*" {
       capabilities = ["read"]
      }

    Policy Names:
      entity-policy (base policy)
	  bob-policy
      bsmith-policy

    Login to bob and bsmith user
      vault login -method=userpass username=bob password=password
      vault login -method=userpass username=bsmith password=password

13. Identity Secret Engine: The identity secret engine maintains the client who are recognized by vault.
Each client is internally termed as Entity. An entity can have multiple aliases. The secrets engine will be mounted by default. This Secret engine cannot be disabled or moved.

14. Identity Groups:
      A group can contain multiple entities as its members. Policies set on the group is granted to all membersof the group.

15. Internal and External Groups:
        By default vault creates an internal group. Many organization already have group defined within their external identity providers like Active Directory.

        External Groups allows to link vault with the external identity provider (auth provider) and attach appropriate policies to the group.

## Part 3
1. Tokens are the core methods for authentication within Vault. With vault server -dev, we have been using 	the root token. This is the first method of authentication for Vault. It is alos the only auth method that cannot be disabled.

2. Mapping of token to Policies: Within vault, tokens map to information. The most important information mapped to a token is a set of one or more attached policies.

3. Lookup token information: You can explore the details of an given token with the help of vault token lookup command.

vault login -method=userpass username=demouser password=password

path "secret/*" {
  capabilities = ["list","read"]
}

path "auth/token/lookup-self" {
   capabilities = ["read"]
   }

vault token lookup
OR
vault token lookup <token-id>
To switch to root token: vault login [root-token-identifier]

4. Token Helper: By default vault CLI uses a token helper to cache the token after authentication. The default token helper stores the token in ~/.vault-token. you can delete this file at anytime  to logout of vault.

5. Time-to-Live: Time to live limits the lifetime of the data. USed extensively in dns. Every non-root token have ttl associated with it. After the current ttl is up, the token will no longer function, and its associated lease are revoked. 
     a) you can create a ttl that has user defined ttl:
   		vault token create --ttl=600
   	 b) vault token renew command can be used to extend the validity of the renewable tokens.
   	     vault token renew --increment=30m <token-id>

   	 Useful Commands:
   	 	vault login -method=userpass username=demouser password=password
		vault token create
		vault token create --tl=60
		vault token lookup [TOKEN]
		vault token renew -increment=99999m [TOKEN]

	c) Default token value comes from:  vault read sys/auth/token/tune

6. Service Token Lifecycle: Normally when a token holder creates a new token, these tokens will be created as children of original token.

   parent token -> vault token create : Child token

In this knind of hirarchy, If parent is revoked or expires, so do all its children regardless of their own ttls.

7. Token Accessors: When token is created, a token accessor is also created and returned. This accessor is a value that acts as a reference to a token and can only be used to perform limited actions:
     a) Lookup's a token properties.
     b) Lookup a token's capability on a path.
     c) Renew the token.
     d) Revoke the token.

     List the Token Accessors:
		vault list auth/token/accessors

	 Perform Lookup Based on Accessor:
       vault token lookup -accessor [YOUR-ACCESSOR]

8. orphan-token: Orphan tokens are not children of their parent, therefore orphan token do not expire when their parent does. They are root of their own token tree. Orphan token still expire when their own max ttl is reached.

  Useful Commands:
    Capabilities Assigned to demouser:
		path "auth/token/create" {
		  capabilities = ["create","read","update","sudo"]
		}

		path "auth/token/lookup" {
		  capabilities = ["create","read","update"]
		}
    Commands used to create orphan token: This cli command requires root token or sudo capability on the /auth/token/create path.
		vault token create -orphan
	Performing a lookup for the token:
		vault token lookup s.eiaBtk4aF7mikTZ6a6kc5sBq

9. Secret Engine -Cubby Hole: The cubbyhole secret engine provides your own private secret storage space where no one else can read (including root). It is not possible to reach into another token's cubbyhole even as the root user. The cubbyhole secret engine is enabled by default. It cannot be disabled, moved or enabled multiple times.
       In cubbyhole, paths are scoped per token. No token can access another token's cubbyhole. When the token expires, its cubbyhole is expired.

10. wrapped token: When response wrapping is requested, vault creates a temporary single use token(wrapping-token) and insert the response into token's cubbyhole with short ttl. Only the expecting client who has the wrapping token can unwrap this secret. If wrapping token is compromised and attacker unwraps the secret, the application will not be able to unwrap again and this can sounds an alarm and you can revoke things accordingly.

	Useful Command:
	    Creating a response wrapped token:
			vault token create -wrap-ttl=600
		Unwrap token from wrap:
			vault unwrap [wrapping-token] 

## Part 4
Overview of Vault for production:\
=================================
Till now we have been making using vault under development mode where all data was stored under memory.
For Production, We need a better storage class to store the data.
There are multiple storage class that can be used, some of these includes:
1) Filesystem
2) S3
3) Consul
4) Databases (Mysql, dynamodb, PostgreSQL)

Steps involved to deploy vault in production:\
=============================================
1. Create a configuration file. The format of the file is HCL or Json.
storage "file" {
	path = "/root/vault-data"
}

listener "tcp" {
	address = "0.0.0.0:8200"
	tls_disable = 1
}

2. Start Vault from configuration file.
> vault server -config demo.hcl

If you will try vault list /auth/token/accessors, it will fail with error "vault is sealed"

3. Initialize the vault:
This only happens once when the server is started against a new backend that has never been used with vault before. During initialization, the encryption keys are generated, unseal keys are created, and the initial root token is setup.

> vault operator init
Unseal Key 1: LKiR4yU3RJQIIQQzb/MjRh8+Q520KoTKnAN5xiEwclLH
Unseal Key 2: D0+8/fQpgEKdhlmK/U4CqWv1C9gV80OD/KF6rsVMqn+Q
Unseal Key 3: E48Lxcil0Ssy8vc6YaWX2PP0MbA876I9OES6LQ8zF0tE
Unseal Key 4: TSKBqo9ZEjasZjIMOVjYw1VIRsKCwo5qyT7ISqhRVYeV
Unseal Key 5: wjFhnE2JjEzWH1+eePNivqTmviX9HF8qPuVcJiqNp12w

Initial Root Token: s.lV7avnZvJHcLselqpClj3GHL


Make sure to store these 5 unseal keys and root token at secure place, after this you will not get this. At this stage vault is till in sealed mode, so even with root token you will not be able to perform any operation. So you have to unseal your vault now.

4. Unseal the vault:
Every initialized vault server starts in the sealed state. From the configuration, vault can access the physical storage, but it can't read any of it because it doesn't know how to decrypt it.
The process of teaching vault how to decrypt the data is known as unsealing the vault.

You need to any one of three unseal keys.
> user@THBSLAPTOP-838:~/Documents/Personal/Vault-certification/Part4$ vault operator unseal
Unseal Key (will be hidden): 
Key                Value
---                -----
Seal Type          shamir
Initialized        true
Sealed             true
Total Shares       5
Threshold          3
Unseal Progress    1/3
Unseal Nonce       fe8fb5ee-9b6d-37af-dc15-6b993b2bf112
Version            1.4.2
HA Enabled         false
user@THBSLAPTOP-838:~/Documents/Personal/Vault-certification/Part4$ vault operator unseal
Unseal Key (will be hidden): 
Key                Value
---                -----
Seal Type          shamir
Initialized        true
Sealed             true
Total Shares       5
Threshold          3
Unseal Progress    2/3
Unseal Nonce       fe8fb5ee-9b6d-37af-dc15-6b993b2bf112
Version            1.4.2
HA Enabled         false
user@THBSLAPTOP-838:~/Documents/Personal/Vault-certification/Part4$ vault operator unseal
Unseal Key (will be hidden): 
Key             Value
---             -----
Seal Type       shamir
Initialized     true
Sealed          false
Total Shares    5
Threshold       3
Version         1.4.2
Cluster Name    vault-cluster-d7d6f8f6
Cluster ID      c29ba800-fc3c-e824-0425-68eeab7ea182
HA Enabled      false



user@THBSLAPTOP-838:~/Documents/Personal/Vault-certification/Part4$ vault list /auth/token/accessors

Error listing auth/token/accessors/: Error making API request.

URL: GET http://127.0.0.1:8200/v1/auth/token/accessors?list=true

Code: 403. Errors:

* permission denied
* 
user@THBSLAPTOP-838:~/Documents/Personal/Vault-certification/Part4$ vault login s.lV7avnZvJHcLselqpClj3GHL

Success! You are now authenticated. The token information displayed below

is already stored in the token helper. You do NOT need to run "vault login"

again. Future Vault requests will automatically use this token.

```
Key                  Value
---                  -----
token                s.lV7avnZvJHcLselqpClj3GHL
token_accessor       yoB7BSNoHsi7rrf37RhIhY4b
token_duration       ∞
token_renewable      false
token_policies       ["root"]
identity_policies    []
policies             ["root"]
user@THBSLAPTOP-838:~/Documents/Personal/Vault-certification/Part4$ vault list /auth/token/accessors
Keys
----
yoB7BSNoHsi7rrf37RhIhY4b
```

>> After restarting vault again it goes to sealed state, so need to unseal it.

Important Pointers: Iniialization state:
1. Initialization outouts two incredibly important pieces of information: The unseal keys and the initial root token.

This is the only time ever that all of these data is shown by vault, and also the only time that the unseal keys should ever be so close together.

Vault UI for Production:
==========================
1. Required Configuration:

 ```
listener "tcp" {
  address     = "0.0.0.0:8200"
  tls_disable = 1
}

ui = "true"
```

Then restart the vault server.


Vault Agent:
============
For the application that needs to intract with Vault, it first needs to authenticate and then use the 	tokens for performing required tasks.
Apart from this, Application also needs to have a logic related to token renewal and others.
Instead of building custom logic in application, you can instead make use of Vault agent.

Vault agent is client daemon which automates the workflow of client login and token refresh.
> Automatically authenticates to Vault for those supported auth methods.
> Keeps token renewed (re-authenticates as needed) until the renewal is no longer allowed.
> Designed with robustness and fault tolerance.

Running Vault Agent:
===================
In order to make use of vault agent, you can run the vault binary in agent mode.
vault agent config=<config-file>

The agent configuration file must specify the auth method and sink locations where the token to be written.

When agent is started, it will attempt to acquire a vault token using the auth method specified in agent configuration file. On successful authentication, the resulting token is written to the sink locations.
Whenever current token value changes, the agent writes to the sink. 

Practical:
==========
1. First enable approle based authentication.
vault auth enable approle

2. From GUI, go and create agent-policy

path "auth/token/create" {
	capabilities: ["update"]
}

3. Once policy is available, we will create a role name would be vaultagent.
> vault write auth/approle/role/vaultagent token_policies="agent-policy"
Success! Data written to: auth/approle/role/vaultagent

4. Fetch the role-id:
> vault read auth/approle/role/vaultagent/role-id
Key        Value
---        -----
role_id    0c5f2bb1-b72b-a935-c2ba-7764147b8f65

5. Lets fetch the secret-id:
```
> vault write -f auth/approle/role/vaultagent/secret-id

Key                   Value
---                   -----
secret_id             4d50b65a-4edd-afba-af89-a8aff2d5a5dd
secret_id_accessor    e3ea534b-773f-eb9d-c4ff-3c0a7aa90572
```

1. Vault Agent Configuration File: agent.hcl
```
exit_after_auth = false
pid_file = "./pidfile"

auto_auth {
   method "approle" {
       mount_path = "auth/approle"
       config = {
           role_id_file_path = "/tmp/role-id"
           secret_id_file_path = "/tmp/secret-id"
           remove_secret_id_file_after_reading = false
       }
   }

   sink "file" {
       config = {
           path = "/tmp/token"
       }
   }
}

vault {
   address = "http://127.0.0.1:8200"
}
```
7. vault agent -config=agent.hcl

8. cat /tmp/token
s.uDHxngbmGqnEALxBIpbale3T

9. Now use the token:
>vault token lookup s.uDHxngbmGqnEALxBIpbale3T
Key                  Value
---                  -----
accessor             0IXwunqtbvGEFycToZEcIvXy
creation_time        1593888908
creation_ttl         768h
display_name         approle
entity_id            1818808b-33e5-5cd8-a049-57368b7034cb
expire_time          2020-08-05T19:55:08.961266556+01:00
explicit_max_ttl     0s
id                   s.uDHxngbmGqnEALxBIpbale3T
issue_time           2020-07-04T19:55:08.959418907+01:00
last_renewal         2020-07-04T19:55:08.961266703+01:00
last_renewal_time    1593888908
meta                 map[role_name:vaultagent]
num_uses             0
orphan               true
path                 auth/approle/login
policies             [agent-policy default]
renewable            true
ttl                  767h57m39s
type                 service


Vault Agent Caching:
====================
There are 2 primary functionalities related to vault agent:
1. Auto-Auth: Automatically authenticate to vault and manage the token renewal process.
2. caching: Allows client side caching of responses containing newly created tokens.

Overview of vault caching:
Allows client side caching of responses containing newly created tokens and responses containing leased secrets generated off of these newly created tokens.

Practical:
=========

1. Agent Configuration File: agent.hcl
exit_after_auth = false
pid_file = "./pidfile"

auto_auth {
   method "approle" {
       mount_path = "auth/approle"
       config = {
           role_id_file_path = "/tmp/role-id"
           secret_id_file_path = "/tmp/secret-id"
           remove_secret_id_file_after_reading = false
       }
   }

   sink "file" {
       config = {
           path = "/tmp/token"
       }
   }
}

cache {
  use_auto_auth_token = true
}

listener "tcp" {
   address = "127.0.0.1:8007"
   tls_disable = true
}


vault {
   address = "http://127.0.0.1:8200"
}

2. Start vault agent:
vault agent -config=agent.hcl


3. Run vault token create command:
VAULT_TOKEN=$(cat /tmp/token) vault token create
Key                  Value
---                  -----
token                s.GtK7fbCukL5uL4VS45VPrLsH
token_accessor       QdSANFrxXY2ADadoES2Pl4tL
token_duration       768h
token_renewable      true
token_policies       ["agent-policy" "default"]
identity_policies    []
policies             ["agent-policy" "default"]

4. Till now we are directly sending request to vault server and not to vault agent. To send request to vault agent:
export VAULT_AGENT_ADDR="http://127.0.0.1:8007"
VAULT_TOKEN=$(cat /tmp/token) vault token create
Key                  Value
---                  -----
token                s.YF7A75AlGX1ITRqn2VU0rq81
token_accessor       XhyCGeEQgYbULuLElSTDm3Yi
token_duration       768h
token_renewable      true
token_policies       ["agent-policy" "default"]
identity_policies    []
policies             ["agent-policy" "default"]

Notice in vault agent logs:
==============
2020-07-04T20:38:20.316+0100 [INFO]  cache: received request: method=POST path=/v1/auth/token/create
2020-07-04T20:38:20.316+0100 [INFO]  cache.apiproxy: forwarding request: method=POST path=/v1/auth/token/create

5. Try the command again and you will see that request is served from cache:
VAULT_TOKEN=$(cat /tmp/token) vault token create
2020-07-04T20:40:45.701+0100 [INFO]  cache: received request: method=POST path=/v1/auth/token/create


Shamir's Secret:
===============
The storage backend in vault is considered to be untrested. The data stored in storage backend is within the encrypted state.

When the vault is initialized it generates an encryption key which is used to protect all the data. The key is protected by a master key.

Vault uses a technique known as Shamir's secret sharing algorithm to split the master key in 5 shares, any 3 of which are required to reconstruct the master key.

Important Pointers:
1. The number of shares and the minimum threshold required can both be specified.
2. Shamir's technique can be disabled, and the master key used directly for unsealing.
3. Once vault retrieves the encryption key, it is able to decrypt the data in the storage backend, and enters the unsealed state.

Seal Stanza:
============
The seal stanza configures the seal type to use for additional data protection, such as HSM or cloud KMS solutions to encrypt and decrypt the master key.

The stanza is optional, and in the case of the master key, Vault will use the Shamir's algorithm to cryptographically split the master key if this is not configured.

seal [NAME] {
	#...
}


Vault Replication:
==================
A single vault cluster can impose various challanges related to high latency, connectivity failures, availability loss and others.

In performance replication, secondaries keep track of their own tokens and leases but share the underlying configuration, policies and supporting secrets (K/V values, encryption keys for transit etc.)

Disaster recovery replication: Ability to fully restore all types of data (local and the cluster data).
Secondary cluster does not handle any client request and can be promoted to be the new primary in case of disaster.


Audit Devices:
==============
Audit devices are components in vault that keep a detailed log of all request and response to vault.
Because every operation with vault is an API request/response, the audit log contains every authenticated interaction with Vault, including errors. 

Enabling Auditing: When a vault server is first initialized, no auditing is enabled. Audit devices must be enabled by a root user using: vault audit enable.

Practical:
==========
1. Start vault server in dev environment: vault server -dev
2. From a different screen enable vault logging.

>vault audit list
No audit devices are enabled.

> vault audit enable file file_path=vault-audit.log
Success! Enabled the file audit device at: file/

OR

vault audit enable -path="audit_path" file file_path=~/vault-audit.log
Success! Enabled the file audit device at: audit_path/


> vault audit list
Path     Type    Description
----     ----    -----------
file/    file    n/a

3. Lets do some activity.
> vault auth enable userpass
Success! Enabled userpass auth method at: userpass/

4. Where vault server is running, within that folder check vault-audit.log file.

NOTE: (https://www.vaultproject.io/api-docs/system/audit-hash)-In the response log, there is a filed client_token which is hashed value not the exact token.

> vault print token
s.lwqgIcs6MyuHjPtefRBKKJ3v

> curl --header "X-Vault-Token: s.lwqgIcs6MyuHjPtefRBKKJ3v" --request POST --data @audit.json http://127.0.0.1:8200/v1/sys/audit-hash/audit_path
{"hash":"hmac-sha256:b9791373454e37f1be30bce149c5469967d041e21b778b0c1417fcedb8591c71","request_id":"d726bc43-60b7-74aa-3546-d11d6207dcc4","lease_id":"","renewable":false,"lease_duration":0,"data":{"hash":"hmac-sha256:b9791373454e37f1be30bce149c5469967d041e21b778b0c1417fcedb8591c71"},"wrap_info":null,"warnings":null,"auth":null}


Important Points:
1. If there are any audit devices enabled, Vault requires that atleast one be able to persist the log before completing the vault request.
2. If you have one one audit device enabled, and its blocked (network block etc), then vault will be unresponsive. Vault will not complete any requests until audit device can write.
3. If you have more than one audit device, then vault will complete the request as long as one audit device persists the log.                     