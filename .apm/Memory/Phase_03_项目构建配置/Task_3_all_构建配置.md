# Task 3 (All) – 项目构建配置 — 私服、Makefile、自定义 Group
**Status:** Completed
**Agent:** Agent_BuildConfig

## 完成内容

### Task 3.1 — gradle.properties
- 添加 `projectGroup=libiao.test.org.springframework.security`
- 版本改为 `0.4.5-bjca-patch-SNAPSHOT`（基于上一正式版本 0.4.5）

### Task 3.2 — settings.gradle
- `pluginManagement.repositories` 中 `gradlePluginPortal()` 之前添加 nexus 配置
- `dependencyResolutionManagement.repositories` 中 `mavenCentral()` 之前添加 nexus 配置

### Task 3.3 — build.gradle
- `group` 改为引用 `projectGroup` 变量
- 添加 `allprojects` 块配置 nexus 仓库（含 SNAPSHOT 仓库条件判断）
- 添加 `subprojects` 块配置发布仓库（MavenPublishPlugin，根据版本选择 release/snapshot 仓库）

### Task 3.4 — buildSrc/build.gradle
- 在 `gradlePluginPortal()` 之前添加 nexus 私服配置

### Task 3.5 — Makefile
- 创建 Makefile，包含 help/clean/build/build-thin/install/deploy/stop/projects/tree 目标

### Task 3.6 — 验证构建
- 配置结构验证通过（所有关键配置项正确就位）
- 实际构建因 Nexus 私服（192.168.131.36:8088）在当前网络不可达而无法执行，需在内网环境验证

## Nexus 配置前置条件
`~/.gradle/gradle.properties` 中需配置：
- `nexusPublicUrl` — Nexus 公共仓库地址
- `nexusReleaseUrl` — Release 发布仓库地址
- `nexusSnapshotUrl` — Snapshot 发布仓库地址
- `nexusUsername` / `nexusPassword` — 认证信息
