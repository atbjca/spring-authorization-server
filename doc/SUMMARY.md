# Spring Authorization Server 0.4.x 安全补丁 — 阶段性总结

## 项目概述

**项目目标：** 在 Spring Authorization Server 0.4.x 分支基础上，针对已知 CVE 漏洞进行安全修复，生成可用于内部部署的安全补丁分支。

**工作分支：** `0.4.x-bjca-patch`（基于 `origin/0.4.x`，基础 commit `ee19c396`）

**修复原则：**
- 移植官方修复方案，确保与上游修复逻辑一致
- 所有代码注释和文档使用中文
- 每个 CVE 修复配备完整的测试用例和技术文档

---

## 已完成工作

### Phase 1：项目环境搭建

| 步骤 | 内容 | 状态 |
|------|------|------|
| 创建修复分支 | 从 `origin/0.4.x` 创建 `0.4.x-bjca-patch` | 已完成 |
| 初始化文档目录 | 创建 `doc/CVE/` 目录和 `doc/REQUIREMENTS.md` | 已完成 |

### Phase 2：CVE-2024-22258 修复

**漏洞信息：**
- **CVE 编号：** CVE-2024-22258
- **漏洞类型：** PKCE 降级攻击（PKCE Downgrade Attack）
- **严重程度：** Moderate（CVSS 6.1）
- **影响范围：** 使用 PKCE 的机密客户端（Confidential Client）

**漏洞原理：**
`CodeVerifierAuthenticator` 中 `codeVerifier` 的提取位于 `codeChallenge` 条件判断之后，导致当攻击者从授权请求中移除 `code_challenge` 参数时，令牌请求阶段的 PKCE 验证会被完全跳过，从而绕过机密客户端的 PKCE 安全保护。

**修复方案（移植自官方 commit `a7035d22`）：**
1. 将 `codeVerifier` 提取提前至 `codeChallenge` 条件判断之前
2. 在 `codeChallenge` 为空时增加 `codeVerifier` 存在性检查，检测并拒绝降级攻击

| 步骤 | 内容 | 状态 |
|------|------|------|
| 研究官方修复方案 | 定位官方 commit，分析 backport 策略 | 已完成 |
| Backport 代码修复 | 移植修复逻辑，添加中文注释 | 已完成 |
| 编写测试用例 | 验证 PKCE 降级攻击被正确拒绝 | 已完成（测试通过） |
| 创建 CVE 文档 | 编写技术文档，更新修复跟踪清单 | 已完成 |
| Git Commit | 提交所有修复内容 | 已完成 |

---

## 变更文件清单

### 代码修复

| 文件 | 变更类型 | 说明 |
|------|----------|------|
| `CodeVerifierAuthenticator.java` | 修改 | 提前提取 codeVerifier + 扩展条件判断 |
| `OAuth2AuthorizationCodeGrantTests.java` | 修改 | 新增 PKCE 降级攻击测试方法 |

### 文档

| 文件 | 变更类型 | 说明 |
|------|----------|------|
| `doc/REQUIREMENTS.md` | 新增 | CVE 修复进度跟踪清单 |
| `doc/CVE/CVE-2024-22258.md` | 新增 | CVE-2024-22258 完整技术文档 |

---

## Git 提交记录

| Commit SHA | 日期 | 说明 |
|------------|------|------|
| `25661fbf` | 2026-03-02 | 修复 CVE-2024-22258：阻止机密客户端 PKCE 降级攻击 |

---

## 测试验证

| 测试方法 | 测试类 | 结果 |
|----------|--------|------|
| `requestWhenConfidentialClientWithPkceAndMissingCodeChallengeButCodeVerifierProvidedThenBadRequest` | `OAuth2AuthorizationCodeGrantTests` | 通过 |

**测试场景：** 机密客户端授权请求不含 `code_challenge`，但令牌请求携带 `code_verifier` 时，服务器返回 400 Bad Request。

---

## 后续计划

当前分支 `0.4.x-bjca-patch` 已完成已知 CVE 的修复与文档维护。如有新的 CVE 需要修复，可在此分支上继续开展后续 Phase，遵循相同的流程：

1. 研究官方修复方案
2. Backport 代码修复并添加中文注释（源码级漏洞），或升级 BOM 约束（依赖级漏洞）
3. 编写测试用例（源码级漏洞）或执行回归测试（依赖级漏洞）
4. 创建 CVE 技术文档
5. 更新 `doc/REQUIREMENTS.md` 修复跟踪清单
6. 提交变更

### 已知不在修复范围内的问题

| 类别 | 说明 |
|------|------|
| CVE-2026-41008 / CVE-2026-22752 | 仅影响 Spring Authorization Server 1.3+ / 1.5+ 及 Spring Security 7.0，0.4.x 分支不包含相关代码路径 |
| buildSrc 传递依赖 | Gson、Guava、XStream 等仅用于 Gradle 构建插件，不进入运行时产物；SCA 重命名后已不再报红 |
| 内部 BOM 传递依赖 | `cn.bjca.footstone.bpring` 系列 Spring Framework/Security 补丁版本的 CVE 由对应内部仓库维护 |

---

### Phase 3：项目构建配置 — 私服、Makefile、自定义 Group

**目标：** 为支持内部部署，添加 Nexus 私服支持、自定义 Group ID、创建 Makefile 简化构建操作。

| 步骤 | 内容 | 状态 |
|------|------|------|
| 修改 gradle.properties | 添加 `projectGroup`，版本改为 `0.4.5-bjca-patch-SNAPSHOT` | 已完成 |
| 修改 settings.gradle | pluginManagement 和 dependencyResolutionManagement 添加 nexus 私服 | 已完成 |
| 修改 build.gradle | group 引用变量 + allprojects/subprojects nexus 配置 | 已完成 |
| 修改 buildSrc/build.gradle | repositories 添加 nexus 私服 | 已完成 |
| 创建 Makefile | clean/build/build-thin/install/deploy/stop/projects/tree | 已完成 |
| 验证构建 | 配置结构验证通过（实际构建需在内网环境执行） | 已完成 |

**构建配置详情：**

- **自定义 Group ID：** `libiao.test.org.springframework.security`（区分官方构件）
- **版本号：** `0.4.5-bjca-patch-SNAPSHOT`（基于上一正式版本 0.4.5）
- **Nexus 私服：** 通过 `~/.gradle/gradle.properties` 中的 `nexusPublicUrl`、`nexusReleaseUrl`、`nexusSnapshotUrl`、`nexusUsername`、`nexusPassword` 配置
- **Makefile 常用命令：**
  - `make build-thin` — 编译打包（跳过测试和文档）
  - `make install` — 安装到本地 Maven 仓库
  - `make deploy` — 发布到 Nexus 私服

### 变更文件清单（Phase 3）

| 文件 | 变更类型 | 说明 |
|------|----------|------|
| `gradle.properties` | 修改 | 添加 projectGroup，更新版本号 |
| `settings.gradle` | 修改 | pluginManagement/dependencyResolutionManagement 添加 nexus |
| `build.gradle` | 修改 | group 引用变量 + allprojects/subprojects 配置 |
| `buildSrc/build.gradle` | 修改 | repositories 添加 nexus 私服 |
| `Makefile` | 新增 | 构建操作快捷命令 |

---

### Phase 4：依赖漏洞第二轮修复 — 2026-06-25

**背景：** 3 月 OpenSCA 扫描（`opensca-spring-authorization-server-20260306_095853.html`）在 SCA 重命名前报告了 25 个 CVE；SCA 重命名后最新扫描已无报红，但直接依赖约束中仍有可升级项。

| 依赖 | 旧版本 | 新版本 | 关联 CVE |
|------|--------|--------|----------|
| `jackson-bom` | 2.15.4 | 2.18.7 | CVE-2025-52999、GHSA-72hv-8253-57qq |
| `nimbus-jose-jwt` | 10.8 | 10.9.1 | CVE-2023-52428、CVE-2025-53864 |
| `bcprov-jdk18on` / `bcpkix-jdk18on` | （传递依赖） | 1.79 | CVE-2025-8916 |
| `json-path` | 2.7.0 | 2.9.0 | CVE-2023-51074 |
| `assertj-core` | 3.23.1 | 3.27.7 | CVE-2026-24400 |

**文档：** 补齐 `doc/CVE/` 下 6 份技术文档（此前仅 CVE-2024-22258 有完整文档）。

---

- 官方修复 Commit：`a7035d22bd2de6c24e7125623d38fb83d8f659a9`
- 官方仓库：[spring-projects/spring-authorization-server](https://github.com/spring-projects/spring-authorization-server)
- CVE 详情文档：[doc/CVE/CVE-2024-22258.md](CVE/CVE-2024-22258.md)
- 修复跟踪清单：[doc/REQUIREMENTS.md](REQUIREMENTS.md)
