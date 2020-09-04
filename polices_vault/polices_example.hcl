path "secret/foo" {
  capabilities = ["read"]
}

# Esta seção concede todos os acessos em "secret / *". Outras restrições podem ser
# aplicada a esta política ampla, conforme mostrado abaixo.
path "secret/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

# Embora tenhamos permitido secret / *, esta linha nega explicitamente
# secreto / supersecreto. Isso tem precedência.
path "secret/super-secret" {
  capabilities = ["deny"]
}

# As políticas também podem especificar parâmetros permitidos, não permitidos e obrigatórios. Aqui
# a chave "secreto / restrito" só pode conter "foo" (qualquer valor) e "bar" (um
# de "zip" ou "zap").
path "secret/restricted" {
  capabilities = ["create"]
  allowed_parameters = {
    "foo" = []
    "bar" = ["zip", "zap"]
  }
}