backend "consul" {
  address = "172.42.10.10:8500"
  redirect_addr = "http://172.42.10.5:8200"
  scheme = "http"
  tls_skip_verify = 1
}

ui = true

listener "tcp" {
  address = "172.42.10.5:8200"
  tls_disable = 1
}


telemetry {
  prometheus_retention_time = "30s",
  disable_hostname = true
}

disable_mlock = true