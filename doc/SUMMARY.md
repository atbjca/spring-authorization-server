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

当前分支 `0.4.x-bjca-patch` 已完成 CVE-2024-22258 的修复。如有新的 CVE 需要修复，可在此分支上继续开展后续 Phase，遵循相同的流程：

1. 研究官方修复方案
2. Backport 代码修复并添加中文注释
3. 编写测试用例
4. 创建 CVE 技术文档
5. 更新 `REQUIREMENTS.md` 修复跟踪清单
6. 提交变更

---

## 参考资料

- 官方修复 Commit：`a7035d22bd2de6c24e7125623d38fb83d8f659a9`
- 官方仓库：[spring-projects/spring-authorization-server](https://github.com/spring-projects/spring-authorization-server)
- CVE 详情文档：[doc/CVE/CVE-2024-22258.md](CVE/CVE-2024-22258.md)
- 修复跟踪清单：[doc/REQUIREMENTS.md](REQUIREMENTS.md)
