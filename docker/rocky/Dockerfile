# Dropbear Image (Rocky Variant)
# Extends snowdreamtech/rocky with additional tooling and configuration.

FROM snowdreamtech/rocky:10.2.0 AS builder

ENV OPENSSH_VERSION=9.9p1-23.el10_2.rocky.0.1

RUN set -eux \
    && dnf makecache \
    && dnf -y --allowerasing install \
    openssh-server=${OPENSSH_VERSION} \
    openssh-clients=${OPENSSH_VERSION} \
    && cp $(find /usr/lib /usr/libexec -name sftp-server 2>/dev/null | head -n 1) $(which sftp) /root/

FROM snowdreamtech/rocky:10.2.0

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
    DROPBEAR_VERSION=2025.89-1.el10_2

# Standard OCI Metadata (https://github.com/opencontainers/image-spec)
LABEL org.opencontainers.image.authors="Snowdream Tech" \
    org.opencontainers.image.title="Dropbear Image Based On Rocky" \
    org.opencontainers.image.description="Docker Images for Dropbear on Rocky. (amd64, arm64, ppc64le, s390x)" \
    org.opencontainers.image.documentation="https://hub.docker.com/r/snowdreamtech/dropbear" \
    org.opencontainers.image.base.name="snowdreamtech/rocky:10.2.0" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.source="https://github.com/snowdreamtech/dropbear" \
    org.opencontainers.image.vendor="Snowdream Tech" \
    org.opencontainers.image.created="${BUILDTIME}" \
    org.opencontainers.image.revision="${REVISION}" \
    org.opencontainers.image.url="https://github.com/snowdreamtech/dropbear"

# x-release-please-start-version
LABEL org.opencontainers.image.version="${VERSION:-10.2.0}"
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

# Additional tooling and configuration for Dropbear on Rocky
RUN set -eux \
    && dnf makecache \
    && dnf -y --allowerasing install \
    epel-release \
    && dnf -y --allowerasing install \
    dropbear=${DROPBEAR_VERSION} \
    fastfetch \
    xauth \
    && mkdir -p /usr/libexec \
    && dnf -y --allowerasing autoremove \
    && dnf -y --allowerasing clean all \
    && rm -rf /var/cache/dnf \
    && rm -rf /tmp/* \
    && rm -rf /var/tmp/*

COPY --from=builder /root/sftp* /usr/libexec/

RUN mkdir -p /usr/lib/ssh/ \
    && ln -s /usr/libexec/sftp-server /usr/lib/ssh/sftp-server \
    && printf '%s\n' '#!/bin/sh' '/usr/libexec/sftp -S /usr/bin/dbclient -s /usr/libexec/sftp-server "$@"' > /usr/local/bin/sftp \
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
