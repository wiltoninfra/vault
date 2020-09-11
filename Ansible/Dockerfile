

FROM debian:10.5-slim


RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y --no-install-recommends \
      ca-certificates && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /etc/ssl/certs/* && \
    mkdir /additional_certs

VOLUME /etc/ssl/certs

ENTRYPOINT set -eu; \
    cp -a /additional_certs/. /usr/local/share/ca-certificates/; \
    CERT_VARS=$(env | cut -d '=' -f 1 | egrep '^CA_CERT_[0-9]+$'); \
    for cert_var in $CERT_VARS; do \
    cert_contents="$(eval echo \"\$$cert_var\")"; \
    eval "cert_filename=\${${cert_var}_NAME:-$cert_var}"; \
    filename="/usr/local/share/ca-certificates/${cert_filename}.crt"; \
        echo "$cert_contents" > "$filename"; \
    done; \
    rm -rf /etc/ssl/certs/*; \
    update-ca-certificates; \
   TRUSTED_CERTS=$(find /etc/ssl/certs/ -type l -exec readlink -f {} \; | sort | uniq); \
    for cert_source in $TRUSTED_CERTS; do \
        new_name=$(basename $cert_source | sed 's/\.crt/\.pem/'); \
        cp --remove-destination -v "$cert_source" "/etc/ssl/certs/$new_name"; \
    done