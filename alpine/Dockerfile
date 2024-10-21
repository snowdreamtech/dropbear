FROM snowdreamtech/alpine:3.20.3 AS builder

ENV OPENSSH_VERSION=9.9_p1-r1

RUN mkdir /workspace
WORKDIR /workspace

RUN apk add --no-cache openssh@main=$OPENSSH_VERSION \
    && cp $(which sftp-server) $(which sftp) /workspace/



FROM snowdreamtech/alpine:3.20.3

# OCI annotations to image
LABEL org.opencontainers.image.authors="Snowdream Tech" \
    org.opencontainers.image.title="Dropbear Image Based On Alpine" \
    org.opencontainers.image.description="Docker Images for Dropbear on Alpine. (i386, amd64, arm32v6, arm32v7, arm64, ppc64le,riscv64, s390x)" \
    org.opencontainers.image.documentation="https://hub.docker.com/r/snowdreamtech/dropbear" \
    org.opencontainers.image.base.name="snowdreamtech/dropbear:alpine" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.source="https://github.com/snowdreamtech/dropbear" \
    org.opencontainers.image.vendor="Snowdream Tech" \
    org.opencontainers.image.version="3.20.3" \
    org.opencontainers.image.url="https://github.com/snowdreamtech/dropbear"

# keep the docker container running
ENV KEEPALIVE=1 \
    SSH_ROOT_PASSWORD=

RUN apk add --no-cache \
    fastfetch \
    dropbear=2024.85-r0 \
    && mkdir -p /usr/libexec

COPY --from=builder /workspace/sftp* /usr/libexec/

RUN mkdir -p /usr/lib/ssh/ \
    && ln -s /usr/libexec/sftp-server /usr/lib/ssh/sftp-server \
    && echo -e '#!/bin/sh\n/usr/libexec/sftp -S /usr/bin/dbclient -s /usr/libexec/sftp-server "$@"' > /usr/local/bin/sftp \
    && chmod +x /usr/local/bin/sftp

EXPOSE 22

COPY docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]