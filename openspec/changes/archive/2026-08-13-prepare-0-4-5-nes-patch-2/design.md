## Context

`spring-authorization-server-0.4` 已发布并打标 `0.4.5-nes.patch.1`。现行 `gradle.properties` 仍使用该 RELEASE 坐标，并把 Spring Security 钉在 `5.8.16-nes.patch.1`。Security 维护线已积累 2026 CVE 回移，并把发布基线中的 Bouncy Castle 提升到 1.84，开发版本为 `5.8.16-nes.patch.2-SNAPSHOT`，正式 RELEASE 尚未入 Nexus。

本仓库的发布红线禁止内部 `cn.bjca.footstone` SNAPSHOT 进入 RELEASE 元数据。因此本 change 只推进开发坐标和对齐将要消费的 Security RELEASE，不完成本组件发版。

## Goals / Non-Goals

**Goals:**

- 将本仓库 Gradle 版本设为 `0.4.5-nes.patch.2-SNAPSHOT`。
- 将 `springSecurityVersion` 设为当前 Security 开发坐标 `5.8.16-nes.patch.2-SNAPSHOT`，以便功能验证。
- 将本仓库显式约束的 Bouncy Castle `jdk18on` 对齐到 1.84。
- 更新现行文档，区分不可变的 patch.1 与当前 patch.2-SNAPSHOT 开发线。
- 保持 nimbus `10.9.1`、jackson-bom `2.18.7`、Framework `5.3.39-nes.patch.1` 不变。

**Non-Goals:**

- 不去掉本组件 `-SNAPSHOT`，不部署 Nexus，不创建 `v0.4.5-nes.patch.2`。
- 不修改 SAS Java 源码，不在本仓库 backport Security 的七项 CVE。
- 不改已归档的 patch.1 证据，不覆写 `0.4.5-nes.patch.1` 或 `5.8.16-nes.patch.1` 制品。
- 不等待或代替 Security 完成其正式发版。
- 不把完整 `./gradlew test` 或消费验证当作本 change 的门禁；Security RELEASE 到位前解析会失败，这是预期。

## Decisions

### 1. 开发期两边都用 SNAPSHOT，正式发版再去掉

本组件必须离开已发布的 `0.4.5-nes.patch.1`，否则后续提交和本地发布会复用不可变坐标。采用 `0.4.5-nes.patch.2-SNAPSHOT`。

为了立刻做功能验证，`springSecurityVersion` 钉当前已有的 `5.8.16-nes.patch.2-SNAPSHOT`，而不是尚未入仓的 RELEASE 坐标。解析走 Nexus SNAPSHOT 仓库（本组件版本已是 SNAPSHOT 时，`build.gradle` 会加入 `nexusSnapshotUrl`）。正式发版另开 change，同时去掉两边的 `-SNAPSHOT`。

备选（已拒绝）：继续停在 patch.1——开发坐标与已发布制品冲突。备选（已拒绝）：Security 钉尚未存在的 RELEASE——本地无法解析，也就无法验证。

### 2. SNAPSHOT 只用于验证，不用于发版

开发期允许解析内部 Security SNAPSHOT。本 change 仍禁止把 `0.4.5-nes.patch.2-SNAPSHOT` 部署到 Nexus RELEASE，也禁止在 RELEASE POM 里留下 Security SNAPSHOT。

### 3. 同步抬高本仓库的 Bouncy Castle 约束

SAS platform 目前显式约束 `bcprov-jdk18on` / `bcpkix-jdk18on` 为 1.79。Security patch.2 BOM 导出 1.84。两个 platform 同时约束同一模块时，可能解析回 1.79 或直接冲突。1.84 仍是 `jdk18on`（Java 8+），且满足 CVE-2025-8916 的“>= 1.79”。本 change 把 SAS 约束改成 1.84，并更新 CVE-2025-8916 文档中的当前基线，不改该 CVE 的最低修复版本说明。

### 4. 只改现行文件，不动归档

`openspec/changes/archive/**` 和已发布 tag 是 patch.1 的审计记录。版本推进只改 `gradle.properties`、依赖约束和现行文档。`openspec/specs/component-release/spec.md` 里针对 `0.4.5-nes.patch.1` 的历史发版要求保留，本 change 只新增“发版后必须推进 SNAPSHOT、等待 Security patch.2”的要求。

## Risks / Trade-offs

- [改完后本地构建因缺少 Security patch.2 而失败] → 视为预期；文档写明须等 Nexus RELEASE。不因此回退版本钉。
- [有人把 `0.4.5-nes.patch.2-SNAPSHOT` 发到 Nexus RELEASE] → 本 change 明确禁止 deploy 和去 SNAPSHOT；正式发版另开 change。
- [有人把带 Security SNAPSHOT 的 POM 发到 Nexus RELEASE] → 正式发版门禁扫描内部 SNAPSHOT，命中即失败。
- [下游仍按文档锁定 Security patch.1] → 现行 GAV/SUMMARY 改为指向 patch.2，并保留 patch.1 为历史 RELEASE。
- [误改归档证据] → 任务范围排除 `openspec/changes/archive/**`。

## Migration Plan

1. 更新 `gradle.properties`、Bouncy Castle 约束和现行文档。
2. 核对版本字符串，不运行依赖 Security patch.2 的完整构建门禁。
3. 等 Security `5.8.16-nes.patch.2` 进入 Nexus RELEASE 后，另开 release change：去掉本组件 `-SNAPSHOT`，做解析/测试/本地发布/Nexus 门禁，再打 `v0.4.5-nes.patch.2`。

## Open Questions

无。Security 正式发版时间和 Nexus 授权仍由发布协调方决定。
