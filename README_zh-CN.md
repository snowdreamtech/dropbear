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

Dropbear SSH 服务端 Docker 镜像，提供标准化的容器基础，具有灵活的入口点系统、多架构支持以及跨 Alpine、Debian 和 Rocky Linux 发行版的一致配置模式。

## 概述

这些 Dropbear Docker 镜像作为轻量级且安全的 SSH 2 服务端容器，内置 SFTP 支持。它提供：

- **标准化的 Dockerfile**，包含 OCI 注释和最佳实践
- **预配置的 Dropbear SSH 服务端**，具备合理的默认配置并集成 SFTP 支持
- **自动主机密钥生成**（ed25519、rsa、ecdsa）
- **灵活的入口点系统**，支持自定义初始化脚本
- **一致的环境变量配置**，适用于所有变体
- **多架构支持**，适用于多样化的硬件平台
- **用户/组管理**，支持 PUID/PGID 进行权限处理
- **三种发行版变体**：Alpine（轻量级）、Debian（默认/广泛兼容）、Rocky（企业级）

## 快速开始

```bash
# 拉取并运行默认的 Debian 变体
docker pull snowdreamtech/dropbear:debian
docker run -d --name=dropbear -p 22:22 -e TZ=Asia/Shanghai snowdreamtech/dropbear:debian

# 或使用 docker compose
docker compose up -d
```

## 使用方法

### 1. 免密登录（推荐）

将您的公钥挂载到 `/root/.ssh/authorized_keys` 以使用密钥认证：

```bash
docker run -d \
  --name=dropbear \
  -e TZ=Asia/Shanghai \
  -p 22:22 \
  -v ~/.ssh/id_rsa.pub:/root/.ssh/authorized_keys:ro \
  --restart unless-stopped \
  snowdreamtech/dropbear:latest
```

登录：

```bash
ssh root@localhost -p 22
```

### 2. 密码登录

当容器启动未设置 `SSH_ROOT_CRED` 时，它会自动生成一个随机密码并在日志中输出：

```bash
docker logs dropbear
```

若要设置固定密码：

```bash
docker run -d \
  --name=dropbear \
  -e SSH_ROOT_CRED=your_secure_password \
  -p 22:22 \
  --restart unless-stopped \
  snowdreamtech/dropbear:latest
```

## 发行版变体

### Debian（默认）

推荐用于大多数用例的变体，提供广泛的兼容性和丰富的软件包可用性。

```bash
docker run -d \
  --name=dropbear \
  -e TZ=Asia/Shanghai \
  -p 22:22 \
  --restart unless-stopped \
  snowdreamtech/dropbear:debian
```

**支持的架构**：amd64、arm32v7、arm64、ppc64le、riscv64、s390x

**基础镜像**：`snowdreamtech/debian:13.6.0`

### Alpine

轻量级变体，针对极简镜像尺寸和快速启动时间进行了优化。

```bash
docker run -d \
  --name=dropbear \
  -e TZ=Asia/Shanghai \
  -p 22:22 \
  --restart unless-stopped \
  snowdreamtech/dropbear:alpine
```

**支持的架构**：i386、amd64、arm32v6、arm32v7、arm64、ppc64le、riscv64、s390x

**基础镜像**：`snowdreamtech/alpine:3.24.1`

### Rocky

基于 Rocky Linux 的企业级变体，适合需要与 RHEL 兼容的生产环境。

```bash
docker run -d \
  --name=dropbear \
  -e TZ=Asia/Shanghai \
  -p 22:22 \
  --restart unless-stopped \
  snowdreamtech/dropbear:rocky
```

**支持的架构**：amd64、arm64、ppc64le、s390x

**基础镜像**：`snowdreamtech/rocky:10.2.0`

## 构建说明

### 单架构构建

```bash
# 构建 Debian 变体
docker build -t snowdreamtech/dropbear:debian ./docker/debian/

# 构建 Alpine 变体
docker build -t snowdreamtech/dropbear:alpine ./docker/alpine/

# 构建 Rocky 变体
docker build -t snowdreamtech/dropbear:rocky ./docker/rocky/
```

### 多架构构建

使用 `docker buildx` 构建多架构镜像：

```bash
# 创建并使用 buildx 构建器
docker buildx create --use --name build --node build --driver-opt network=host

# 构建 Debian 多架构镜像
docker buildx build \
  --platform=linux/amd64,linux/arm/v7,linux/arm64,linux/ppc64le,linux/riscv64,linux/s390x \
  -t snowdreamtech/dropbear:debian \
  ./docker/debian/ \
  --push

# 构建 Alpine 多架构镜像
docker buildx build \
  --platform=linux/386,linux/amd64,linux/arm/v6,linux/arm/v7,linux/arm64,linux/ppc64le,linux/riscv64,linux/s390x \
  -t snowdreamtech/dropbear:alpine \
  ./docker/alpine/ \
  --push

# 构建 Rocky 多架构镜像
docker buildx build \
  --platform=linux/amd64,linux/arm64,linux/ppc64le,linux/s390x \
  -t snowdreamtech/dropbear:rocky \
  ./docker/rocky/ \
  --push
```

## 环境变量

所有变体均支持以下环境变量用于运行时配置：

| 变量                   | 默认值    | 描述                                      |
| ---------------------- | --------- | ----------------------------------------- |
| `SSH_ROOT_CRED`        | -         | Root 密码（未设置时自动随机生成）         |
| `KEEPALIVE`            | `0`       | 保持容器持续运行（1=启用，0=禁用）        |
| `CAP_NET_BIND_SERVICE` | `0`       | 允许绑定特权端口（<1024）                 |
| `LANG`                 | `C.UTF-8` | 区域设置，支持 UTF-8 字符                 |
| `UMASK`                | `022`     | 默认文件创建掩码                          |
| `DEBUG`                | `false`   | 在入口点脚本中启用调试输出                |
| `PASSWORDLESS_SUDO`    | `false`   | 为非 root 用户启用免密 sudo（true/false） |
| `PGID`                 | `0`       | 自定义用户的组 ID                         |
| `PUID`                 | `0`       | 自定义用户的用户 ID                       |
| `USER`                 | `root`    | 自定义用户名                              |
| `WORKDIR`              | `/root`   | 工作目录路径                              |
| `TZ`                   | -         | 时区（例如 `Asia/Shanghai`）              |

**Debian 特有**：

| 变量              | 默认值           | 描述                  |
| ----------------- | ---------------- | --------------------- |
| `DEBIAN_FRONTEND` | `noninteractive` | Debian 软件包安装模式 |

## Docker Compose 示例

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

## 语义化版本标签

镜像遵循语义化版本规范，格式为：`{version}-{variant}`

示例：

- `snowdreamtech/dropbear:2025.89.0-debian`
- `snowdreamtech/dropbear:2026.91.0-alpine`
- `snowdreamtech/dropbear:2025.89.0-rocky`

## 架构支持

每个发行版变体支持多种 CPU 架构：

| 变体       | 架构                                                          |
| ---------- | ------------------------------------------------------------- |
| **Debian** | amd64、arm32v7、arm64、ppc64le、riscv64、s390x                |
| **Alpine** | i386、amd64、arm32v6、arm32v7、arm64、ppc64le、riscv64、s390x |
| **Rocky**  | amd64、arm64、ppc64le、s390x                                  |

## 入口点系统

镜像包含灵活的入口点系统，在启动 Dropbear 之前会按字典顺序执行 `/usr/local/bin/entrypoint.d/` 中的所有可执行脚本。

## 开发与验证

### 环境要求

- Docker (>= 20.10)，已启用 Docker Buildx 插件
- [UniRTM](https://github.com/snowdreamtech/UniRTM) 用于工作区代码质量守卫与工具链管理

### 代码质量与验证

```bash
# 安装并配置工具链
unirtm run setup

# 运行全面的工作区质量检查（格式化、Lint、安全审计）
unirtm run verify

# 运行安全审计（Zizmor、Gitleaks、OSV-Scanner、Trivy）
unirtm run audit

# 自动修复支持的问题
unirtm run fix
```

## 参考文档

1. [Dropbear SSH](https://matt.ucc.asn.au/dropbear/dropbear.html)
2. [使用 buildx 构建多平台 Docker 镜像](https://icloudnative.io/posts/multiarch-docker-with-buildx/)
3. [docker/buildx](https://github.com/docker/buildx)

## 联系方式 (备注：dropbear)

- 邮箱: <sn0wdr1am@qq.com>
- QQ: 3217680847
- QQ群: 949022145
- 微信/微信群: sn0wdr1am

## 许可证

MIT
