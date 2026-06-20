#!/bin/sh
set -e

# Generate a random password for root if not provided
if [ -z "${SSH_ROOT_CRED}" ]; then
    SSH_ROOT_CRED=$(openssl rand -base64 33)
    echo "Generate random ssh root password: ${SSH_ROOT_CRED}"
fi

# Change the password for root
echo "root:$SSH_ROOT_CRED" | chpasswd >/dev/null 2>&1

# Create dropbear config directory if it doesn't exist
mkdir -p /etc/dropbear

# ssh-keygen -A (equivalent for dropbear)
if [ ! -f "/etc/dropbear/dropbear_rsa_host_key" ]; then
  dropbearkey -t ed25519 -f /etc/dropbear/dropbear_ed25519_host_key >/dev/null 2>&1
  dropbearkey -t rsa -s 4096 -f /etc/dropbear/dropbear_rsa_host_key >/dev/null 2>&1
  dropbearkey -t ecdsa -s 521 -f /etc/dropbear/dropbear_ecdsa_host_key >/dev/null 2>&1
fi

# generate ssh keys
if [ ! -d "/root/.ssh" ]; then
  mkdir -p /root/.ssh
  chmod 700 /root/.ssh
  dropbearkey -t ed25519 -f /root/.ssh/id_ed25519 >/dev/null 2>&1 || true
  dropbearkey -t rsa -s 4096 -f /root/.ssh/id_rsa >/dev/null 2>&1 || true
  dropbearkey -t ecdsa -s 521 -f /root/.ssh/id_ecdsa >/dev/null 2>&1 || true
  chmod 600 /root/.ssh/id_* >/dev/null 2>&1 || true
fi
