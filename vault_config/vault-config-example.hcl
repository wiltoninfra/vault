# Storage Consult
storage "consul" {
  address = "127.0.0.1:8500"
  path    = "vault"
}

# Storage DynamoDB
storage "dynamodb" {
  table = "my-vault-data"

  read_capacity  = 10
  write_capacity = 15
}

# Enable HA DynamiDB

api_addr = "https://vault-leader.my-company.internal"

storage "dynamodb" {
  ha_enabled    = "true"
  table = "my-vault-data"
  max_parallel = 128 
  region = "us-east-1"
  read_capacity  = 10
  write_capacity = 15
  access_key = ""
  secret_key = ""
  session_token = ""
}


listener "tcp" {
  address     = "127.0.0.1:8200"
  tls_disable = 1
  telemetry {
    unauthenticated_metrics_access = true
  }
}

telemetry {
  statsite_address = "127.0.0.1:8125"
  disable_hostname = true
}

telemetry {
  prometheus_retention_time = "30s"
  disable_hostname = true
}

seal "awskms" {
  region     = "us-east-1"
  access_key = "AKIAIOSFODNN7EXAMPLE"
  secret_key = "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
  kms_key_id = "19ec80b0-dfdd-4d97-8164-c6examplekey"
  endpoint   = "https://vpce-0e1bb1852241f8cc6-pzi0do8n.kms.us-east-1.vpce.amazonaws.com"
}


