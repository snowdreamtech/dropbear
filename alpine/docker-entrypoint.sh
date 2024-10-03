#!/bin/sh
set -e


# ssh-keygen -A
if [ ! -f "/etc/dropbear/dropbear_rsa_host_key" ]; then
  dropbearkey -t ed25519 -f /etc/dropbear/dropbear_ed25519_host_key >/dev/null 2>&1
  dropbearkey -t rsa -s 4096 -f /etc/dropbear/dropbear_rsa_host_key >/dev/null 2>&1
  dropbearkey -t ecdsa -s 521 -f /etc/dropbear/dropbear_ecdsa_host_key >/dev/null 2>&1
fi

# fastfetch from https://github.com/fastfetch-cli/fastfetch
fastfetch --pipe false >/etc/motd 2>&1

# change the password for root
echo "root:$SSH_ROOT_PASSWORD" | chpasswd >/dev/null 2>&1

# generate ssh keys
if [ ! -d "$HOME/.ssh" ]; then
  mkdir -p $HOME/.ssh
  dropbearkey -t ed25519 -C "user@example.com" -f $HOME/.ssh/id_ed25519 >/dev/null 2>&1
  dropbearkey -t rsa -s 4096 -C "user@example.com" -f $HOME/.ssh/id_rsa >/dev/null 2>&1
  dropbearkey -t ecdsa -s 521 -C "user@example.com" -f $HOME/.ssh/id_ecdsa >/dev/null 2>&1
fi

# start dropbear
/usr/sbin/dropbear

# exec commands
if [ -n "$*" ]; then
    sh -c "$*"
fi

# keep the docker container running
# https://github.com/docker/compose/issues/1926#issuecomment-422351028
if [ "${KEEPALIVE}" -eq 1 ]; then
    trap : TERM INT
    tail -f /dev/null & wait
    # sleep infinity & wait
fi