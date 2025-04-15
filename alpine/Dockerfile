FROM snowdreamtech/alpine:3.21.3 AS builder

ENV OPENSSH_VERSION=9.9_p2-r0

RUN mkdir /workspace
WORKDIR /workspace

RUN apk add --no-cache openssh@main=$OPENSSH_VERSION \
    && cp $(which sftp-server) $(which sftp) /workspace/



FROM snowdreamtech/alpine:3.21.3

# OCI annotations to image
LABEL org.opencontainers.image.authors="Snowdream Tech" \
    org.opencontainers.image.title="Dropbear Image Based On Alpine" \
    org.opencontainers.image.description="Docker Images for Dropbear on Alpine. (i386, amd64, arm32v6, arm32v7, arm64, ppc64le,riscv64, s390x)" \
    org.opencontainers.image.documentation="https://hub.docker.com/r/snowdreamtech/dropbear" \
    org.opencontainers.image.base.name="snowdreamtech/dropbear:alpine" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.source="https://github.com/snowdreamtech/dropbear" \
    org.opencontainers.image.vendor="Snowdream Tech" \
    org.opencontainers.image.version="2024.86" \
    org.opencontainers.image.url="https://github.com/snowdreamtech/dropbear"

# keep the docker container running
ENV KEEPALIVE=1 \
    DROPBEAR_VERSION=2024.86-r0 \
    SSH_ROOT_PASSWORD=
    
ARG GID=1000 \
    UID=1000  \
    USER=root \
    WORKDIR=/root

# Create a user with UID and GID
RUN if [ "${USER}" != "root" ]; then \
    addgroup -g ${GID} ${USER}; \
    adduser -h /home/${USER} -u ${UID} -g ${USER} -G ${USER} -s /bin/sh -D ${USER}; \
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
    
COPY --from=builder /workspace/sftp* /usr/libexec/

RUN mkdir -p /usr/lib/ssh/ \
    && ln -s /usr/libexec/sftp-server /usr/lib/ssh/sftp-server \
    && echo -e '#!/bin/sh\n/usr/libexec/sftp -S /usr/bin/dbclient -s /usr/libexec/sftp-server "$@"' > /usr/local/bin/sftp \
    && chmod +x /usr/local/bin/sftp
    
COPY motd.sh /etc/periodic/15min/
    
# Switch to the user
USER ${USER}

# Set the workdir
WORKDIR ${WORKDIR}

EXPOSE 22

COPY docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]