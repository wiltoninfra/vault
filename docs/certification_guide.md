## Vault Associate Exam Objectives

### 1 Compare Authentication Methods
- 1.A Describe authentication methods\
https://www.vaultproject.io/docs/auth/index.html\
https://www.vaultproject.io/docs/concepts/auth.html

- 1.B Choose an authentication method based on use case\
https://www.vaultproject.io/docs/concepts/auth.html

- 1.C Differentiate human vs. system auth methods\
https://www.vaultproject.io/docs/concepts/auth.html

### 2 Create Vault Policies
- 2.A Illustrate the value of Vault policy\
https://www.vaultproject.io/docs/concepts/policies.html

- 2.B Describe Vault policy syntax: path\
https://www.vaultproject.io/docs/concepts/policies.html#policy-syntax

- 2.C Describe Vault policy syntax: capabilities\
https://www.vaultproject.io/docs/concepts/policies.html#capabilities

- 2.D Craft a Vault policy based on requirements\
https://learn.hashicorp.com/vault/getting-started/policies#writing-the-policy

### 3 Assess Vault Tokens
- 3.A Describe Vault token\
https://www.vaultproject.io/docs/concepts/tokens.html

- 3.B Differentiate between service and batch tokens. Choose one based on use-case\
https://www.vaultproject.io/docs/concepts/tokens.html#service-tokens\
https://www.vaultproject.io/docs/concepts/tokens.html#batch-tokens\
https://www.vaultproject.io/docs/concepts/tokens.html#token-type-comparison

- 3.C Describe root token uses and lifecycle\
https://www.vaultproject.io/docs/concepts/tokens.html#root-tokens

- 3.D Define token accessors\
https://www.vaultproject.io/docs/concepts/tokens.html#token-accessors

- 3.E Explain time-to-live\
https://www.vaultproject.io/docs/concepts/tokens.html#token-time-to-live-periodic-tokens-and-explicit-max-ttls

- 3.F Explain orphaned tokens\
https://www.vaultproject.io/docs/concepts/tokens.html#token-hierarchies-and-orphan-tokens

- 3.G Create tokens based on need\
https://learn.hashicorp.com/vault/identity-access-management/tokens#step-1-create-service-tokens-with-use-limit

### 4 Manage Vault Leases
- 4.A Explain the purpose of a lease ID\
https://www.vaultproject.io/docs/concepts/lease.html#lease-ids

- 4.B Renew leases\
https://www.vaultproject.io/docs/commands/lease/renew.html

- 4.C Revoke leases\
https://www.vaultproject.io/docs/commands/lease/revoke.html

### 5 Compare and Configure Vault Secrets Engines
- 5.A Choose a secret method based on use case
- 5.B Contrast dynamic secrets vs. static secrets and their use cases
- 5.C Define transit engine\
https://www.vaultproject.io/docs/secrets/transit/index.html

- 5.D Define secrets engines\
https://www.vaultproject.io/docs/secrets/index.html#secrets-engines

### 6 Utilize Vault CLI
- 6.A Authenticate to Vault\
https://www.vaultproject.io/docs/commands/auth/index.html

- 6.B Configure authentication methods\
https://www.vaultproject.io/docs/commands/auth/enable.html\
https://www.vaultproject.io/docs/commands/auth/disable.html

- 6.C Configure Vault policies\
https://www.vaultproject.io/docs/commands/policy/index.html

- 6.D Access Vault secrets\
https://www.vaultproject.io/docs/commands/secrets/index.html

- 6.E Enable Secret engines\
https://www.vaultproject.io/docs/commands/secrets/enable.html

- 6.F Configure environment variables\
https://www.vaultproject.io/docs/commands/index.html#environment-variables

### 7 Utilize Vault UI
https://www.hashicorp.com/resources/vault-oss-ui-introduction\
https://vault-ui.io/

- 7.A Authenticate to Vault
- 7.B Configure authentication methods
- 7.C Configure Vault policies
- 7.D Access Vault secrets
- 7.E Enable Secret engines

### 8 Be Aware of the Vault API
- 8.A Authenticate to Vault via Curl\
https://learn.hashicorp.com/vault/getting-started/apis

- 8.B Access Vault secrets via Curl\
https://www.vaultproject.io/api/overview.html#api-operations

### 9 Explain Vault Architecture
- 9.A Describe the encryption of data stored by Vault\
https://www.vaultproject.io/docs/internals/security.html#external-threat-overview

- 9.B Describe cluster strategy\
https://www.vaultproject.io/docs/internals/high-availability.html

- 9.C Describe storage backends\
https://www.vaultproject.io/docs/configuration/storage/index.html

- 9.D Describe the Vault agent\
https://www.vaultproject.io/docs/agent/index.html

- 9.E Describe secrets caching\
https://www.vaultproject.io/docs/agent/caching/index.html

- 9.F Be aware of identities and groups\
https://www.vaultproject.io/docs/secrets/identity/index.html#identity-groups\
https://www.vaultproject.io/docs/secrets/identity/index.html#group-hierarchical-permissions\
https://www.vaultproject.io/docs/secrets/identity/index.html#external-vs-internal-groups

- 9.G Describe Shamir secret sharing and unsealing\
https://en.wikipedia.org/wiki/Shamir’s_Secret_Sharing

- 9.H Be aware of replication\
https://www.vaultproject.io/docs/internals/replication.html

- 9.I Describe seal/unseal\
https://www.vaultproject.io/docs/concepts/seal.html

- 9.J Explain response wrapping\
https://www.vaultproject.io/docs/concepts/response-wrapping.html

- 9.K Explain the value of short-lived, dynamically generated secrets

### 10 Explain Encryption as a Service
- 10.A Configure transit secret engine\
https://www.vaultproject.io/docs/secrets/transit/index.html#setup

- 10.B Encrypt and decrypt secrets\
https://www.vaultproject.io/api/secret/transit/index.html#encrypt-data\
https://www.vaultproject.io/api/secret/transit/index.html#decrypt-data

- 10.C Rotate the encryption key\
https://www.vaultproject.io/api/secret/transit/index.html#rotate-key