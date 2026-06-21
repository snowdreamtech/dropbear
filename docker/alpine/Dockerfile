# Dropbear Image (Alpine Variant)
# Extends snowdreamtech/alpine with additional tooling and configuration.

FROM snowdreamtech/alpine:3.24.0 AS builder

ENV OPENSSH_VERSION=10.3_p1-r0

RUN apk add --no-cache openssh@main=$OPENSSH_VERSION \
    || apk add --no-cache openssh=${OPENSSH_VERSION} \
    && cp $(find /usr/lib /usr/libexec -name sftp-server 2>/dev/null | head -n 1) $(which sftp) /root/

FROM snowdreamtech/alpine:3.24.0

# Build-time Configuration
ARG BUILDTIME \
    VERSION \
    REVISION \
    KEEPALIVE=0 \
    CAP_NET_BIND_SERVICE=0 \
    LANG=C.UTF-8 \
    UMASK=022 \
    DEBUG=false \
    PASSWORDLESS_SUDO=false \
    PGID=0 \
    PUID=0 \
    USER=root \
    WORKDIR=/root \
    DROPBEAR_VERSION=2026.91-r0

# Standard OCI Metadata (https://github.com/opencontainers/image-spec)
LABEL org.opencontainers.image.authors="Snowdream Tech" \
    org.opencontainers.image.title="Dropbear Image Based On Alpine" \
    org.opencontainers.image.description="Docker Images for Dropbear on Alpine. (i386, amd64, arm32v6, arm32v7, arm64, ppc64le, riscv64, s390x)" \
    org.opencontainers.image.documentation="https://hub.docker.com/r/snowdreamtech/dropbear" \
    org.opencontainers.image.base.name="snowdreamtech/alpine:3.24.0" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.source="https://github.com/snowdreamtech/dropbear" \
    org.opencontainers.image.vendor="Snowdream Tech" \
    org.opencontainers.image.created="${BUILDTIME}" \
    org.opencontainers.image.revision="${REVISION}" \
    org.opencontainers.image.url="https://github.com/snowdreamtech/dropbear"

# x-release-please-start-version
LABEL org.opencontainers.image.version="${VERSION:-3.24.0}"
# x-release-please-end

# Runtime Environment Configuration
ENV KEEPALIVE=${KEEPALIVE} \
    CAP_NET_BIND_SERVICE=${CAP_NET_BIND_SERVICE} \
    LANG=${LANG} \
    UMASK=${UMASK} \
    DEBUG=${DEBUG} \
    PASSWORDLESS_SUDO=${PASSWORDLESS_SUDO} \
    PGID=${PGID} \
    PUID=${PUID} \
    USER=${USER} \
    WORKDIR=${WORKDIR} \
    DROPBEAR_VERSION=${DROPBEAR_VERSION}

# Additional tooling and configuration for Dropbear image
RUN apk update \
    && apk add --no-cache \
    dropbear=${DROPBEAR_VERSION} \
    dropbear-convert=${DROPBEAR_VERSION} \
    dropbear-dbclient=${DROPBEAR_VERSION} \
    dropbear-scp=${DROPBEAR_VERSION} \
    dropbear-ssh=${DROPBEAR_VERSION} \
    fastfetch \
    xauth \
    && mkdir -p /usr/libexec

COPY --from=builder /root/sftp* /usr/libexec/

RUN mkdir -p /usr/lib/ssh/ \
    && ln -s /usr/libexec/sftp-server /usr/lib/ssh/sftp-server \
    && echo -e '#!/bin/sh\n/usr/libexec/sftp -S /usr/bin/dbclient -s /usr/libexec/sftp-server "$@"' > /usr/local/bin/sftp \
    && chmod +x /usr/local/bin/sftp

# Container Orchestration Files
COPY motd.sh /usr/local/bin/motd.sh

COPY entrypoint.d /usr/local/bin/entrypoint.d

RUN chmod +x /usr/local/bin/motd.sh \
    && chmod +x /usr/local/bin/entrypoint.d/*

# Standard Healthcheck (Verification of core system responsiveness)
HEALTHCHECK NONE

# Process Execution
EXPOSE 22
USER root
WORKDIR /root
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["/usr/sbin/dropbear", "-R", "-F", "-E", "-p", "22"]
