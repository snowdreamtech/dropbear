FROM snowdreamtech/build-essential:3.20.0 AS builder

ARG OpenSSH_VERSION 9.7p1

RUN mkdir /workspace
WORKDIR /workspace
RUN wget https://cdn.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-$OpenSSH_VERSION.tar.gz  \ 
&& tar zxvf openssh-$OpenSSH_VERSION.tar.gz  \ 
&& cd openssh-$OpenSSH_VERSION  \ 
&& ./configure  \ 
&& make sftp-server \
&& cp sftp-server ../




FROM snowdreamtech/alpine:3.20.0

LABEL maintainer="snowdream <sn0wdr1am@qq.com>"

ENV SSH_ROOT_PASSWORD=

RUN apk add --no-cache fastfetch dropbear \
&& mkdir -p /usr/libexec 

COPY --from=builder /workspace/sftp-server /usr/libexec/

EXPOSE 22

COPY docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]