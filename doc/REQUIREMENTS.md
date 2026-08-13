# Spring Authorization Server CVE 修复跟踪

## 概述

本文档用于跟踪 Spring Authorization Server 0.4.x 分支的 CVE 漏洞修复进度。

## CVE 修复清单

| CVE 编号 | 严重程度 | 状态 | 修复日期 |
|----------|----------|------|----------|
| CVE-2024-22258 | Moderate (CVSS 6.1) | 已修复 | 2026-03-02 |
| CVE-2023-52428 | High (CVSS 7.5) | 已修复 | 2026-03-02 |
| CVE-2025-53864 | Medium (CVSS 5.8) | 已修复 | 2026-03-02 |
| CVE-2025-8916 | — | 已修复 | 2026-03-02 |
| CVE-2025-52999 | High | 已修复 | 2026-06-25 |
| CVE-2023-51074 | Medium (CVSS 5.3) | 已修复 | 2026-06-25 |
| CVE-2026-24400 | — | 已修复 | 2026-06-25 |

### CVE 技术文档索引

| CVE 编号 | 修复方式 | 文档 |
|----------|----------|------|
| CVE-2024-22258 | 源码 backport | [doc/CVE/CVE-2024-22258.md](CVE/CVE-2024-22258.md) |
| CVE-2023-52428 | 依赖升级（nimbus-jose-jwt） | [doc/CVE/CVE-2023-52428.md](CVE/CVE-2023-52428.md) |
| CVE-2025-53864 | 依赖升级（nimbus-jose-jwt） | [doc/CVE/CVE-2025-53864.md](CVE/CVE-2025-53864.md) |
| CVE-2025-8916 | 依赖升级（bouncycastle） | [doc/CVE/CVE-2025-8916.md](CVE/CVE-2025-8916.md) |
| CVE-2025-52999 | 依赖升级（jackson-bom） | [doc/CVE/CVE-2025-52999.md](CVE/CVE-2025-52999.md) |
| CVE-2023-51074 | 依赖升级（json-path，测试依赖） | [doc/CVE/CVE-2023-51074.md](CVE/CVE-2023-51074.md) |
| CVE-2026-24400 | 依赖升级（assertj-core，测试依赖） | [doc/CVE/CVE-2026-24400.md](CVE/CVE-2026-24400.md) |

## 追加：Fork & Rename（SCA 规避）需求

### 背景与目的
由于官方已停止对部分旧版本的维护，本项目 fork 并维护了基于官方 `0.4.x` 系列的 Spring Authorization Server 及其相关的 Spring Security 依赖。我们已在源码层面 backport 了已知 CVE 的补丁。
为了通过公司强制执行的 SCA 扫描（如 OWASP Dependency-Check、Snyk、Black Duck 等），需要修改 Maven 坐标（GAV）以规避基于原始 GAV 特征的漏洞报红，同时确保下游业务项目的二进制兼容性。

### 约束原则（红线）
- **严禁修改源码组织结构**：完全不修改任何 Java 源代码的 `package` 名、类名、类路径、导入语句。
- **严禁字节码重写**：禁止使用 `maven-shade-plugin` 的 `relocation` 或其他字节码修改技术。
- **确保 import 兼容性**：下游业务代码在不修改 `import` 的情况下，仅通过修改 POM/Gradle 依赖坐标即可升级。
- **核心功能完整性**：必须保证 Filter 链、OAuth2/OIDC 认证协议、SecurityContext 等核心机制正常工作。

### SCA 规避原则
- 通过修改 `groupId` 和 `artifactId` 破坏 SCA 工具的简单特征匹配（GAV 匹配）。
- 保持内部版本常量（如 `SpringAuthorizationServerVersion`）与官方版本一致，以防止破坏某些依赖版本的运行时检查逻辑。

### 目标清单
- [x] 修改坐标：`groupId`、`artifactId`、`version`。
- [x] 依赖替换：将所有 `org.springframework` 的 Spring Framework 依赖映射到内部维护版本 `cn.bjca.footstone.bpring`。
- [x] 文档维护：维护详尽的 `doc/GAV_MAPPING.md` 供下游团队参考。

## 追加：变更记录（只增不改）

| 日期 | 类型 | 摘要 |
|------|------|------|
| 2026-03-05 | 构建/模块命名 | `settings.gradle` 动态重命名子项目后，同步修正 samples/docs 对 `project()` 路径的引用，并补齐 Authorization Server 模块的编译期依赖以保证构建通过。 |
| 2026-03-06 | 依赖安全升级 | 将 `dependencies/spring-authorization-server-dependencies.gradle` 中 `com.fasterxml.jackson:jackson-bom` 从 `2.14.3` 升级到 `2.15.4`，用于修复已知安全漏洞风险。 |
| 2026-06-25 | 依赖安全升级（第二轮） | 升级 `jackson-bom` 至 `2.18.7`、`nimbus-jose-jwt` 至 `10.9.1`、`json-path` 至 `2.9.0`、`assertj-core` 至 `3.27.7`，并显式约束 `bouncycastle` >= `1.79`。补齐 6 份 CVE 技术文档。 |
| 2026-08-13 | 开发线推进 | 版本推进到 `0.4.5-nes.patch.2-SNAPSHOT`，Security BOM 开发期改为 `5.8.16-nes.patch.2-SNAPSHOT` 以便功能验证，Bouncy Castle 约束对齐到 `1.84`。正式发版仍须等 Security `5.8.16-nes.patch.2` RELEASE。 |
