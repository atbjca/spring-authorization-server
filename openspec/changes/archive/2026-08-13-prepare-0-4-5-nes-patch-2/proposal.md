## Why

`0.4.5-nes.patch.1` 已是不可变的 Nexus RELEASE，但分支仍停在该坐标，且 Spring Security 仍锁定已发布的 `5.8.16-nes.patch.1`。Security 维护线已推进到 `5.8.16-nes.patch.2`（当前仍为 SNAPSHOT，尚未发 RELEASE）。继续在已发布坐标上开发有覆写风险，也会让下一补丁吃不到 Security 的 2026 CVE 回移和 Bouncy Castle 1.84 基线。

## What Changes

- 将本仓库开发版本从 `0.4.5-nes.patch.1` 推进到 `0.4.5-nes.patch.2-SNAPSHOT`，保留已发布的 patch.1 制品和 `v0.4.5-nes.patch.1` 标签不动。
- 将 `springSecurityVersion` 从 `5.8.16-nes.patch.1` 改为当前 Security 开发坐标 `5.8.16-nes.patch.2-SNAPSHOT`，以便本地功能验证。
- 将本仓库显式约束的 Bouncy Castle `jdk18on` 从 `1.79` 对齐到 `1.84`，避免与 Security patch.2 BOM 冲突。
- 更新现行文档（`README.adoc`、`doc/SUMMARY.md`、`doc/GAV_MAPPING.md`、CVE-2025-8916 当前基线）以区分不可变的 patch.1 和当前 patch.2-SNAPSHOT 开发线。
- 不在本 change 中去掉 `-SNAPSHOT`、不部署 Nexus、不创建 `v0.4.5-nes.patch.2`。SAS 正式发版必须另开 release change，且须等 Security `5.8.16-nes.patch.2` 已在 Nexus RELEASE 可解析。

## Capabilities

### New Capabilities

None.

### Modified Capabilities

- `component-release`: 不可变 RELEASE 之后，维护分支必须推进到下一 SNAPSHOT，禁止复用已发布坐标；当前开发线将 Security BOM 目标改为 `5.8.16-nes.patch.2-SNAPSHOT` 以便验证，并在 Security RELEASE 可解析之前禁止本组件发版。

## Impact

- 构建元数据：`gradle.properties` 的 `version` 与 `springSecurityVersion`。
- 依赖约束：`dependencies/spring-authorization-server-dependencies.gradle` 中的 Bouncy Castle 版本。
- 现行文档：`README.adoc`、`doc/SUMMARY.md`、`doc/GAV_MAPPING.md`、`doc/CVE/CVE-2025-8916.md`。
- 不改 SAS Java 源码、OAuth2/OIDC 行为、Framework `5.3.39-nes.patch.1`、nimbus `10.9.1`、jackson-bom `2.18.7`，以及已归档的 patch.1 证据。
- 开发期通过 Nexus SNAPSHOT（或本地已发布的 Security SNAPSHOT）解析 `5.8.16-nes.patch.2-SNAPSHOT`。正式发版仍须改回 Security RELEASE，且不得把内部 SNAPSHOT 写进 RELEASE 元数据。
