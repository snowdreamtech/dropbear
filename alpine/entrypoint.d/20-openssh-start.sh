#!/bin/sh
set -e

# ssh-keygen -A
if [ ! -f "/etc/dropbear/dropbear_rsa_host_key" ]; then
  dropbearkey -t ed25519 -f /etc/dropbear/dropbear_ed25519_host_key >/dev/null 2>&1
  dropbearkey -t rsa -s 4096 -f /etc/dropbear/dropbear_rsa_host_key >/dev/null 2>&1
  dropbearkey -t ecdsa -s 521 -f /etc/dropbear/dropbear_ecdsa_host_key >/dev/null 2>&1
fi

# start cornd
crond >/dev/null 2>&1

# generate motd
/etc/periodic/15min/motd.sh >/dev/null 2>&1

# openssl rand -base64 33
if [ -z "${SSH_ROOT_CRED}" ]; then {
    SSH_ROOT_CRED=$(openssl rand -base64 33)
    echo "Generate random ssh root password:${SSH_ROOT_CRED}"
}
fi

# change the password for root
echo "root:$SSH_ROOT_CRED" | chpasswd >/dev/null 2>&1

# generate ssh keys
if [ ! -d "$HOME/.ssh" ]; then
  mkdir -p "$HOME/.ssh"
  dropbearkey -t ed25519 -C "user@example.com" -f "$HOME/.ssh/id_ed25519" >/dev/null 2>&1&1
  dropbearkey -t rsa -s 4096 -C "user@example.com" -f "$HOME/.ssh/id_rsa" >/dev/null 2>&1
  dropbearkey -t ecdsa -s 521 -C "user@example.com" -f "$HOME/.ssh/id_ecdsa" >/dev/null 2>&1
fi

# start dropbear
/usr/sbin/dropbear