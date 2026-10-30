# Dropbear

[![CI Pipeline](https://img.shields.io/github/actions/workflow/status/snowdreamtech/dropbear/ci.yml?branch=main&label=CI%20Pipeline)](https://github.com/snowdreamtech/dropbear/actions/workflows/ci.yml)
[![CD Pipeline](https://img.shields.io/github/actions/workflow/status/snowdreamtech/dropbear/cd.yml?branch=main&label=CD%20Pipeline)](https://github.com/snowdreamtech/dropbear/actions/workflows/cd.yml)
[![CodeQL](https://img.shields.io/github/actions/workflow/status/snowdreamtech/dropbear/codeql.yml?branch=main&label=CodeQL&logo=github)](https://github.com/snowdreamtech/dropbear/actions/workflows/codeql.yml)
[![Security Audit](https://img.shields.io/badge/Security-Zizmor%20%7C%20Trivy%20%7C%20Gitleaks-brightgreen)](https://github.com/snowdreamtech/dropbear/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/license/MIT)
![Docker Image Version](https://img.shields.io/docker/v/snowdreamtech/dropbear)
![Docker Image Size](https://img.shields.io/docker/image-size/snowdreamtech/dropbear/latest)
![Docker Pulls](https://img.shields.io/docker/pulls/snowdreamtech/dropbear)
![Docker Stars](https://img.shields.io/docker/stars/snowdreamtech/dropbear)

[English](README.md) | [简体中文](README_zh-CN.md)

Dropbear SSH server Docker images providing standardized container foundations with flexible entrypoint systems, multi-architecture support, and consistent configuration patterns across Alpine, Debian, and Rocky Linux distributions.

## Overview

These Dropbear Docker images serve as a lightweight, secure SSH 2 server container with SFTP support. They provide:

- **Standardized Dockerfiles** with OCI annotations and best practices
- **Pre-configured Dropbear SSH server** with sensible defaults and SFTP support
- **Automatic host key generation** (ed25519, rsa, ecdsa)
- **Flexible entrypoint system** supporting custom initialization scripts
- **Consistent environment variable configuration** across all variants
- **Multi-architecture support** for diverse hardware platforms
- **User/group management** with PUID/PGID support for permission handling
- **Three distribution variants**: Alpine (lightweight), Debian (default/widely-compatible), Rocky (enterprise)

## Quick Start

```bash
# Pull and run the default Debian variant
docker pull snowdreamtech/dropbear:debian
docker run -d --name=dropbear -p 22:22 -e TZ=Asia/Shanghai snowdreamtech/dropbear:debian

# Or use docker compose
docker compose up -d
```

## Usage

### 1. Passwordless Login (Recommended)

Mount your public key to `/root/.ssh/authorized_keys` for key-based authentication:

```bash
docker run -d \
  --name=dropbear \
  -e TZ=Asia/Shanghai \
  -p 22:22 \
  -v ~/.ssh/id_rsa.pub:/root/.ssh/authorized_keys:ro \
  --restart unless-stopped \
  snowdreamtech/dropbear:latest
```

Login:

```bash
ssh root@localhost -p 22
```

### 2. Password Login

When the container starts without `SSH_ROOT_CRED`, it automatically generates a random password and prints it in the logs:

```bash
docker logs dropbear
```

To set a fixed password:

```bash
docker run -d \
  --name=dropbear \
  -e SSH_ROOT_CRED=your_secure_password \
  -p 22:22 \
  --restart unless-stopped \
  snowdreamtech/dropbear:latest
```

## Distribution Variants

### Debian (Default)

The recommended variant for most use cases, providing wide compatibility and extensive package availability.

```bash
docker run -d \
  --name=dropbear \
  -e TZ=Asia/Shanghai \
  -p 22:22 \
  --restart unless-stopped \
  snowdreamtech/dropbear:debian
```

**Supported Architectures**: amd64, arm32v7, arm64, ppc64le, riscv64, s390x

**Base Image**: `snowdreamtech/debian:13.6.0`

### Alpine

Lightweight variant optimized for minimal image size and fast startup times.

```bash
docker run -d \
  --name=dropbear \
  -e TZ=Asia/Shanghai \
  -p 22:22 \
  --restart unless-stopped \
  snowdreamtech/dropbear:alpine
```

**Supported Architectures**: i386, amd64, arm32v6, arm32v7, arm64, ppc64le, riscv64, s390x

**Base Image**: `snowdreamtech/alpine:3.24.1`

### Rocky

Enterprise-focused variant based on Rocky Linux, ideal for production environments requiring RHEL compatibility.

```bash
docker run -d \
  --name=dropbear \
  -e TZ=Asia/Shanghai \
  -p 22:22 \
  --restart unless-stopped \
  snowdreamtech/dropbear:rocky
```

**Supported Architectures**: amd64, arm64, ppc64le, s390x

**Base Image**: `snowdreamtech/rocky:10.2.0`

## Build Instructions

### Single Architecture Build

```bash
# Build Debian variant
docker build -t snowdreamtech/dropbear:debian ./docker/debian/

# Build Alpine variant
docker build -t snowdreamtech/dropbear:alpine ./docker/alpine/

# Build Rocky variant
docker build -t snowdreamtech/dropbear:rocky ./docker/rocky/
```

### Multi-Architecture Build

Build images for multiple architectures using `docker buildx`:

```bash
# Create and use a buildx builder
docker buildx create --use --name build --node build --driver-opt network=host

# Build Debian for multiple architectures
docker buildx build \
  --platform=linux/amd64,linux/arm/v7,linux/arm64,linux/ppc64le,linux/riscv64,linux/s390x \
  -t snowdreamtech/dropbear:debian \
  ./docker/debian/ \
  --push

# Build Alpine for multiple architectures
docker buildx build \
  --platform=linux/386,linux/amd64,linux/arm/v6,linux/arm/v7,linux/arm64,linux/ppc64le,linux/riscv64,linux/s390x \
  -t snowdreamtech/dropbear:alpine \
  ./docker/alpine/ \
  --push

# Build Rocky for multiple architectures
docker buildx build \
  --platform=linux/amd64,linux/arm64,linux/ppc64le,linux/s390x \
  -t snowdreamtech/dropbear:rocky \
  ./docker/rocky/ \
  --push
```

## Environment Variables

All variants support the following environment variables for runtime configuration:

| Variable               | Default   | Description                                              |
| ---------------------- | --------- | -------------------------------------------------------- |
| `SSH_ROOT_CRED`        | -         | Root password (generated randomly if not set)            |
| `KEEPALIVE`            | `0`       | Keep container running (1=enabled, 0=disabled)           |
| `CAP_NET_BIND_SERVICE` | `0`       | Enable binding to privileged ports (<1024)               |
| `LANG`                 | `C.UTF-8` | Locale setting for UTF-8 character support               |
| `UMASK`                | `022`     | Default file creation mask                               |
| `DEBUG`                | `false`   | Enable debug output in entrypoint scripts                |
| `PASSWORDLESS_SUDO`    | `false`   | Enable passwordless sudo for non-root users (true/false) |
| `PGID`                 | `0`       | Primary group ID for custom user creation                |
| `PUID`                 | `0`       | User ID for custom user creation                         |
| `USER`                 | `root`    | Username for custom user creation                        |
| `WORKDIR`              | `/root`   | Working directory path                                   |
| `TZ`                   | -         | Timezone (e.g., `Asia/Shanghai`, `America/New_York`)     |

**Debian-specific**:

| Variable          | Default          | Description                      |
| ----------------- | ---------------- | -------------------------------- |
| `DEBIAN_FRONTEND` | `noninteractive` | Debian package installation mode |

## Docker Compose Examples

```yaml
services:
  dropbear:
    image: snowdreamtech/dropbear:debian
    container_name: dropbear
    ports:
      - "22:22"
    environment:
      - TZ=Asia/Shanghai
    volumes:
      - ~/.ssh/id_rsa.pub:/root/.ssh/authorized_keys:ro
    restart: unless-stopped
```

## Semantic Versioning Tags

Images follow semantic versioning with the format: `{version}-{variant}`

Examples:

- `snowdreamtech/dropbear:2025.89.0-debian`
- `snowdreamtech/dropbear:2026.91.0-alpine`
- `snowdreamtech/dropbear:2025.89.0-rocky`

## Architecture Support

Each distribution variant supports multiple CPU architectures:

| Variant    | Architectures                                                 |
| ---------- | ------------------------------------------------------------- |
| **Debian** | amd64, arm32v7, arm64, ppc64le, riscv64, s390x                |
| **Alpine** | i386, amd64, arm32v6, arm32v7, arm64, ppc64le, riscv64, s390x |
| **Rocky**  | amd64, arm64, ppc64le, s390x                                  |

## Entrypoint System

The image includes a flexible entrypoint system that executes custom initialization scripts in `/usr/local/bin/entrypoint.d/` before starting Dropbear.

## Development

### Prerequisites

- Docker (>= 20.10) with Docker Buildx plugin
- [UniRTM](https://github.com/snowdreamtech/UniRTM) for workspace quality guard and toolchain management

### Quality & Verification

```bash
# Setup toolchain and verify environment
unirtm run setup

# Run comprehensive workspace quality check (formatters, linters, security)
unirtm run verify

# Run security audits (Zizmor, Gitleaks, OSV-Scanner, Trivy)
unirtm run audit

# Automatically fix linting and formatting issues where supported
unirtm run fix
```

## Reference

1. [Dropbear SSH](https://matt.ucc.asn.au/dropbear/dropbear.html)
2. [使用 buildx 构建多平台 Docker 镜像](https://icloudnative.io/posts/multiarch-docker-with-buildx/)
3. [docker/buildx](https://github.com/docker/buildx)

## Contact (备注：dropbear)

- Email: <sn0wdr1am@qq.com>
- QQ: 3217680847
- QQ群: 949022145
- WeChat/微信群: sn0wdr1am

## License

MIT
