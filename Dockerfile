FROM snowdreamtech/build-essential:3.20.2 AS builder

ENV OpenSSH_VERSION=9.8_p1-r1

RUN mkdir /workspace
WORKDIR /workspace

RUN apk add --no-cache openssh@main=$OpenSSH_VERSION \
    && cp $(which sftp-server) $(which sftp) /workspace/


    

FROM snowdreamtech/alpine:3.20.2

LABEL maintainer="snowdream <sn0wdr1am@qq.com>"

ENV SSH_ROOT_PASSWORD=

RUN apk add --no-cache fastfetch dropbear=2024.85-r0 \
    && mkdir -p /usr/libexec 

COPY --from=builder /workspace/sftp* /usr/libexec/

RUN mkdir -p /usr/lib/ssh/ \
    && ln -s /usr/libexec/sftp-server /usr/lib/ssh/sftp-server \
    && echo -e '#!/bin/sh\n/usr/libexec/sftp -S /usr/bin/dbclient -s /usr/libexec/sftp-server "$@"' > /usr/local/bin/sftp \
    && chmod +x /usr/local/bin/sftp

EXPOSE 22

COPY docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]