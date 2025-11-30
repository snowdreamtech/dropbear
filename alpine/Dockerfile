FROM snowdreamtech/alpine:3.22.2 AS builder

ENV OPENSSH_VERSION=9.9_p2-r0

RUN apk add --no-cache openssh@main=$OPENSSH_VERSION \
    && cp $(which sftp-server) $(which sftp) /root/


FROM snowdreamtech/alpine:3.22.2

# OCI annotations to image
LABEL org.opencontainers.image.authors="Snowdream Tech" \
    org.opencontainers.image.title="Dropbear Image Based On Alpine" \
    org.opencontainers.image.description="Docker Images for Dropbear on Alpine. (i386, amd64, arm32v6, arm32v7, arm64, ppc64le,riscv64, s390x)" \
    org.opencontainers.image.documentation="https://hub.docker.com/r/snowdreamtech/dropbear" \
    org.opencontainers.image.base.name="snowdreamtech/dropbear:alpine" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.source="https://github.com/snowdreamtech/dropbear" \
    org.opencontainers.image.vendor="Snowdream Tech" \
    org.opencontainers.image.version="2025.88" \
    org.opencontainers.image.url="https://github.com/snowdreamtech/dropbear"
    
# Switch to the user
USER root

# Set the workdir
WORKDIR /root

# keep the docker container running
ARG KEEPALIVE=0 \
    # The cap_net_bind_service capability in Linux allows a process to bind a socket to Internet domain privileged ports, 
    # which are port numbers less than 1024. 
    CAP_NET_BIND_SERVICE=0 \
    # Ensure the container exec commands handle range of utf8 characters based of
    # default locales in base image (https://github.com/docker-library/docs/tree/master/debian#locales)
    LANG=C.UTF-8\
    UMASK=022 \
    DEBUG=false \
    PGID=0 \
    PUID=0  \
    USER=root \
    WORKDIR=/root 

# keep the docker container running
ENV KEEPALIVE=${KEEPALIVE} \
    # The cap_net_bind_service capability in Linux allows a process to bind a socket to Internet domain privileged ports, 
    # which are port numbers less than 1024. 
    CAP_NET_BIND_SERVICE=${CAP_NET_BIND_SERVICE} \
    # Ensure the container exec commands handle range of utf8 characters based of
    # default locales in base image (https://github.com/docker-library/docs/tree/master/debian#locales)
    LANG=${LANG} \
    UMASK=${UMASK} \
    DEBUG=${DEBUG} \
    PGID=${PGID} \
    PUID=${PUID}  \
    USER=${USER} \
    WORKDIR=${WORKDIR} 

ENV DROPBEAR_VERSION=2025.88-r1 \
    SSH_ROOT_PASSWORD=

# Create a user with PUID and PGID
RUN if [ "${USER}" != "root" ] && [ ! -d "/home/${USER}" ] && [ "${PUID}" -ne 0 ] && [ "${PGID}" -ne 0 ]; then \
    addgroup -g ${PGID} ${USER}; \
    adduser -h /home/${USER} -u ${PUID} -g ${USER} -G ${USER} -s /bin/sh -D ${USER}; \
    # sed -i "/%sudo/c ${USER} ALL=(ALL:ALL) NOPASSWD:ALL" /etc/sudoers; \
    fi

RUN apk add --no-cache \
    fastfetch \
    xauth \
    dropbear=${DROPBEAR_VERSION} \
    dropbear-convert=${DROPBEAR_VERSION} \
    dropbear-dbclient=${DROPBEAR_VERSION} \
    dropbear-scp=${DROPBEAR_VERSION} \
    dropbear-ssh=${DROPBEAR_VERSION} \
    && mkdir -p /usr/libexec
    
COPY --from=builder /root/sftp* /usr/libexec/

RUN mkdir -p /usr/lib/ssh/ \
    && ln -s /usr/libexec/sftp-server /usr/lib/ssh/sftp-server \
    && echo -e '#!/bin/sh\n/usr/libexec/sftp -S /usr/bin/dbclient -s /usr/libexec/sftp-server "$@"' > /usr/local/bin/sftp \
    && chmod +x /usr/local/bin/sftp
    
COPY motd.sh /etc/periodic/15min/motd.sh

# Enable CAP_NET_BIND_SERVICE
# RUN if [ "${USER}" != "root" ] && [ "${CAP_NET_BIND_SERVICE}" -eq 1 ]; then \
    # setcap 'cap_net_bind_service=+ep' `which nginx`; \
    # fi

EXPOSE 22

COPY entrypoint.d /usr/local/bin/entrypoint.d

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

RUN chmod +x /usr/local/bin/docker-entrypoint.sh \
    && chmod +x /usr/local/bin/entrypoint.d/*

ENTRYPOINT ["docker-entrypoint.sh"]