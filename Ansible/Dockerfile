FROM ubuntu

RUN apt-get update -y && apt-get install -y openssh-server curl unzip
RUN mkdir /var/run/sshd && mkdir -p /etc/vault-ssh-helper.d 

COPY config.hcl /etc/vault-ssh-helper.d/config.hcl
COPY sshd_config /etc/ssh/sshd_config
COPY sshd /etc/pam.d/sshd

RUN wget --no-check-cert https://releases.hashicorp.com/vault-ssh-helper/0.2.0/vault-ssh-helper_0.2.0_linux_amd64.zip \
   && unzip -q vault-ssh-helper_0.2.0_linux_amd64.zip -d /usr/local/bin \
   && rm -f vault-ssh-helper_0.2.0_linux_amd64.zip \
   && chmod 0755 /usr/local/bin/vault-ssh-helper

RUN service ssh restart

RUN useradd -rm -d /home/ubuntu -s /bin/bash -g root -G sudo -u 1001 ubuntu

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]