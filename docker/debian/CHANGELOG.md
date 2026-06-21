# Changelog

## [13.5.0](https://github.com/snowdreamtech/dropbear/compare/debian-v13.5.0...debian-v13.5.0) (2026-06-21)


### 🚀 Features

* **docker:** modernize Dockerfiles with SFTP support and version pinning ([e21bdf8](https://github.com/snowdreamtech/dropbear/commit/e21bdf8af4cbe9367d87e0712348f01b75b27cff))
* **docker:** modernize Dropbear entrypoint credentials and MOTD handling ([659d480](https://github.com/snowdreamtech/dropbear/commit/659d4809927d0fff7d0320c1d59c7a0b70988797))


### 🐛 Bug Fixes

* **docker:** comprehensive compliance fixes and cleanup ([e1f566e](https://github.com/snowdreamtech/dropbear/commit/e1f566e87610e055c1abaf6bbd020858f2468095))
* **docker:** correct DROPBEAR_VERSION for Debian 13 (Trixie) base image ([c4f8de9](https://github.com/snowdreamtech/dropbear/commit/c4f8de9e3670d77dc09b48f965951dcd0590083f))
* **docker:** dynamically locate sftp-server using find ([3c0c3e7](https://github.com/snowdreamtech/dropbear/commit/3c0c3e7d751085aa588bb299ba7f7b62dd32f9d6))
* **docker:** ensure dropbear start scripts are executable ([decf124](https://github.com/snowdreamtech/dropbear/commit/decf12402fec951e4f1d85f54865f66cdff2fb4b))
* **docker:** explicitly use OPENSSH_VERSION for openssh packages in builder stages ([7008af6](https://github.com/snowdreamtech/dropbear/commit/7008af6dcb3c1de21c0056d95d8a0936faf228e3))
* **docker:** remove client ssh keys generation and align debian motd mechanism ([ca6dbaa](https://github.com/snowdreamtech/dropbear/commit/ca6dbaa2dc736ea14f77829ded533bfa8e09a936))
* **docker:** restore strict version locking per user request ([8495f18](https://github.com/snowdreamtech/dropbear/commit/8495f185f2bc872777e2323f3f5cee4a72ae5316))
* **docker:** revert overly strict package version pinning for subpackages and fallbacks ([48a6830](https://github.com/snowdreamtech/dropbear/commit/48a6830bfad28d1a3136adf829f7ec2b67ace9ee))
* **docker:** update OPENSSH_VERSION in builder stages to match latest package versions ([aeb2329](https://github.com/snowdreamtech/dropbear/commit/aeb2329856ac3fbd29f842f8700710992b510fc5))


### 🛠 Refactoring

* **docker:** align Dockerfiles with base image structure ([232574f](https://github.com/snowdreamtech/dropbear/commit/232574fed8418f8c7f257d001e951361dfa467a0))
* remove redundant docker-entrypoint.sh files ([87c576b](https://github.com/snowdreamtech/dropbear/commit/87c576b27731ad11c5bc0ebc661e07c5a09ff1c1))
* reorganize distribution variants into docker directory ([67a8c91](https://github.com/snowdreamtech/dropbear/commit/67a8c911e21801bf12b3e83d02e22f3b3f59a2ba))


### 📖 Documentation

* add detailed comments to entrypoint initialization scripts ([f42cbaa](https://github.com/snowdreamtech/dropbear/commit/f42cbaab6edfbc5c38c2a636dfd8651fea900940))


### ♻️ Miscellaneous Chores

* clear previous changelog entries ([8340e2b](https://github.com/snowdreamtech/dropbear/commit/8340e2b8ab9837cb20699f27a89bcc0bd700a46f))
* **deps:** bump base images to alpine 3.24.0, debian 13.5.0, rocky 10.2.0 ([1688969](https://github.com/snowdreamtech/dropbear/commit/168896956d2f4c7f91309c4c98ffef36ca7e8546))
* **docker:** bump dropbear to the latest package versions ([90dd38d](https://github.com/snowdreamtech/dropbear/commit/90dd38d95be9eb86e50f90420edab78853cd1edc))
* **docker:** clean up legacy placeholder scripts ([5a731d6](https://github.com/snowdreamtech/dropbear/commit/5a731d64c1271a3ffd32da46a7c1f6355f9ab974))
* release main ([deb8454](https://github.com/snowdreamtech/dropbear/commit/deb8454df7518d56939ab3851245a4cd7b03d709))
* release main ([d87cb81](https://github.com/snowdreamtech/dropbear/commit/d87cb815685ad9b5b43d4b9a195c68dee2fd8065))
* release main ([78328d2](https://github.com/snowdreamtech/dropbear/commit/78328d20bd3697d48ea90aee8d0eaa6af4ccc09c))
* release main ([b720ad5](https://github.com/snowdreamtech/dropbear/commit/b720ad57dd1691d8ae07dcac7d46d0bd257af3a0))
* release main ([32dd84d](https://github.com/snowdreamtech/dropbear/commit/32dd84de4be973395d0867b5d527d528948a35df))
* release main ([725c69f](https://github.com/snowdreamtech/dropbear/commit/725c69fdcc222b5b83d0690629ce213a68c586ab))
* release main ([070b694](https://github.com/snowdreamtech/dropbear/commit/070b694a702763b60fc6b057a81418320418cafa))
* release main ([36d1211](https://github.com/snowdreamtech/dropbear/commit/36d1211036847a8c6aaa01a21a1c695a47b71d45))
* release main ([9ad4f94](https://github.com/snowdreamtech/dropbear/commit/9ad4f9490832efdc310f2ebbd8c77f3404daf07f))
* release main ([b0684a3](https://github.com/snowdreamtech/dropbear/commit/b0684a32a652e83506451e6056168cfec8b9142c))
* release main ([495e18a](https://github.com/snowdreamtech/dropbear/commit/495e18a4babcb06a12c2f5aec9ea571d97cb32e3))
* release main ([d4a3a34](https://github.com/snowdreamtech/dropbear/commit/d4a3a34b00a6b9f381cd5d556749c257516b2f08))
* release main ([28d9426](https://github.com/snowdreamtech/dropbear/commit/28d94263f4374017274707faef7183917b689be9))
* **release:** deduplicate CHANGELOG headers ([d47fb44](https://github.com/snowdreamtech/dropbear/commit/d47fb44cb105b368722d7d0e210a27b525f82d87))
* **release:** deduplicate CHANGELOG headers ([e795177](https://github.com/snowdreamtech/dropbear/commit/e79517795d98b9f8292ef956586a6dc03932d03c))
* **release:** deduplicate CHANGELOG headers ([27919e4](https://github.com/snowdreamtech/dropbear/commit/27919e4baf4aab5b2a2bf32a7d437b05a717c11b))
* **release:** deduplicate CHANGELOG headers ([438190d](https://github.com/snowdreamtech/dropbear/commit/438190d297c151c75eca4912fdc22c285d5ec1ea))
* **release:** deduplicate CHANGELOG headers ([256f043](https://github.com/snowdreamtech/dropbear/commit/256f04311b2344f2648ca5bcf407146f8c690258))
* **release:** deduplicate CHANGELOG headers ([d263aae](https://github.com/snowdreamtech/dropbear/commit/d263aae7b223103a01dd0e114430381c5d863dd7))
* **release:** deduplicate CHANGELOG headers ([133954e](https://github.com/snowdreamtech/dropbear/commit/133954e95cfae85cbba2fb9c1ac5acbc677ca39d))
* **release:** deduplicate CHANGELOG headers ([1d82410](https://github.com/snowdreamtech/dropbear/commit/1d82410d6038be22d7741f1519826f30023b0f3e))
* **release:** deduplicate CHANGELOG headers ([5e1a539](https://github.com/snowdreamtech/dropbear/commit/5e1a5390319933b48d20ad993714587d826c0aa7))
* **release:** implement automatic changelog deduplication step ([282c220](https://github.com/snowdreamtech/dropbear/commit/282c22081e1ad7a1a010a7f297d20bc7c9b416a7))

## Changelog
