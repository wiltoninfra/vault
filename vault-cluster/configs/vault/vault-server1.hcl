backend "consul" {
  address = "172.42.10.10:8500"
  redirect_addr = "http://172.42.10.5:8200"
  scheme = "http"
  tls_skip_verify = 0
}

ui = true

listener "tcp" {
  address = "172.42.10.5:8200"
  tls_cert_file = "/certs/server-cert.pem"
  tls_key_file = "/certs/server-key.pem"
  tls_disable = 0
}

#listener "tcp" {
#  tls_cert_file = "/certs/server.crt.pem"
#  tls_key_file  = "/certs/server.key.pem"
#}

telemetry {
  prometheus_retention_time = "30s",
  disable_hostname = true
}

disable_mlock = true