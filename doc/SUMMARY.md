# Spring Authorization Server 1.5.x 安全补丁 — 项目总结

## 项目概述

**目标：** 在 Spring Authorization Server 1.5.x 基础上，对接内部 BOM 与 Nexus 私服，完成 SCA 规避与依赖安全约束，供内部部署使用。

**工作分支：** `1.5.x-bjca-patch`（基于 `origin/1.5.x` / Release 1.5.8）

**自定义版本：** `1.5.8-nes.patch.1` RELEASE

## 快速入门（Quick Start）

### 前置条件

- Java 17+（推荐 sdkman 管理）
- 本地 Gradle：`~/dev/gradle-8.14.5`
- `~/.gradle/gradle.properties` 已配置 Nexus 凭证

### 常用命令

```bash
# 运行单元测试
make test

# 精简构建（跳过测试与文档）
make build-thin

# 安装到本地 Maven 仓库
make install

# 发布到 Nexus 私服
make deploy

# 系统盘空间紧张时指定 Gradle 缓存目录
GRADLE_USER_HOME=~/Downloads/DELETE/tmp/gradle-home make build-thin
```

### 下游引用

见 [doc/GAV_MAPPING.md](GAV_MAPPING.md) 中的 Gradle/Maven 示例。

## 用户手册（User Manual）

### 1. 获取制品

从 Nexus releases 仓库引入：

```text
cn.bjca.footstone.bpring.security:bjca-footstone-bpring-security-oauth2-authorization-server:1.5.8-nes.patch.1
```

须同时 import 已在 Nexus RELEASE 仓库验证的 Spring Framework
`6.2.19-nes.patch.1` 和 Spring Security `6.5.11-nes.patch.1` BOM（见 GAV_MAPPING）。

### 2. 与官方版的差异

| 维度 | 官方 1.5.x | 本分支 |
|------|-----------|--------|
| groupId / artifactId | `org.springframework.security` | `cn.bjca.footstone.bpring.security` / `bjca-footstone-bpring-security-*` |
| Spring BOM | 官方 Maven Central | 内部 Nexus 补丁 BOM |
| Java package | 不变 | **不变**（无需改 import） |
| 源码级 CVE | 1.5.7 / 1.5.8 已修复 | 沿用上游修复，不重复 backport |

### 3. 发布流程

1. 在 `1.5.x-bjca-patch` 分支完成 RELEASE 版本与内部依赖准备
2. 不执行 `clean` 或重复全量测试，运行增量 `publishToMavenLocal`
3. 扫描全部生成 POM，并完成最小下游消费验证
4. 核对全部目标 GAV 在 Nexus RELEASE 中不存在
5. 仅由协调主会话执行一次 RELEASE 部署，并验证远程 POM/制品/校验和

本版本无显式发布排除项。Git 标签只能在 Nexus 验证完成后创建。

### 4. 约束原则（红线）

- 不修改 Java `package`、类名、字节码结构
- 不使用 shade relocation
- `SpringAuthorizationServerVersion` 序列化常量保持与官方 1.5.x 一致（PATCH=0）

## 已完成工作

| Phase | 内容 | 状态 |
|-------|------|------|
| 1 | 创建 `1.5.x-bjca-patch` 分支 | 已完成 |
| 2 | Nexus 私服、Makefile、本地 Gradle | 已完成 |
| 3 | SCA 模块重命名、内部 BOM 替换 | 已完成 |
| 4 | assertj 3.27.7、CVE 文档 | 已完成 |
| 5 | doc/ 文档体系 | 已完成 |

## 上游已覆盖、无需 backport 的 CVE

| CVE | 官方修复版本 |
|-----|-------------|
| CVE-2024-22258 | 1.5.x 已含 PKCE 降级修复 |
| CVE-2026-22752 | 1.5.7 |
| CVE-2026-41008 | 1.5.8 |

## 参考链接

- 修复跟踪：[doc/REQUIREMENTS.md](REQUIREMENTS.md)
- GAV 映射：[doc/GAV_MAPPING.md](GAV_MAPPING.md)
- 官方仓库：[spring-projects/spring-authorization-server](https://github.com/spring-projects/spring-authorization-server)
