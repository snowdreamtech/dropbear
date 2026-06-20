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


# Generate motd and update it periodically in background
(
    while true; do
        /usr/local/bin/motd.sh >/dev/null 2>&1
        sleep 180
    done
) &
