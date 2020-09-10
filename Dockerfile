FROM alpine

ENV VAULT_VERSION 1.5.3
ENV AWSCLI_VERSION "1.14.10"
LABEL NAME="vault"
LABEL version=1.5.3

## 
RUN apk update && apk add ca-certificates jq vim openssl curl aws-cli gcc  python3 py-pip python3-dev \
    && pip install hvac vault-cli \
    && rm -rf /var/cache/apk/* \
    && wget -qO /tmp/vault.zip "https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip" \
    && unzip -d /bin /tmp/vault.zip \
    && chmod 755 /bin/vault \
    && rm /tmp/vault.zip

EXPOSE 8200
VOLUME "/config"
ENTRYPOINT ["/bin/vault"]
CMD ["server", "-dev-listen-address=0.0.0.0:8200", "-dev"]