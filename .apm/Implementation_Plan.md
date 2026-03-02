# Spring Authorization Server CVE 修复 – APM Implementation Plan
**Memory Strategy:** Dynamic-MD
**Last Modification:** Phase 2 全部完成 — CVE-2024-22258 修复已提交至 0.4.x-bjca-patch 分支（commit 25661fbf），包含代码修复、测试、中文文档。
**Project Overview:** 在 spring-authorization-server 0.4.x 分支基础上创建 0.4.x-bjca-patch 分支，针对 CVE-2024-22258（PKCE 降级攻击）进行修复。修复包含完备的中文注释、CVE 文档（含官方修复方案及 commitId）、测试用例，并维护 doc/REQUIREMENTS.md。后续可能追加更多 CVE。

## Phase 1: 项目环境搭建

### Task 1.1 – 创建修复分支 - Agent_CVERemediation
**Objective:** 从 origin/0.4.x 创建 0.4.x-bjca-patch 工作分支。
**Output:** 可用的 0.4.x-bjca-patch 本地分支。
**Guidance:** 确保基于最新的 origin/0.4.x 创建分支。

- 执行 `git fetch origin 0.4.x` 获取最新的 0.4.x 分支
- 执行 `git checkout -b 0.4.x-bjca-patch origin/0.4.x` 创建并切换到修复分支

### Task 1.2 – 初始化文档目录结构 - Agent_CVERemediation
**Objective:** 创建 doc 目录结构和初始 REQUIREMENTS.md 文件。
**Output:** doc/CVE/ 目录和 doc/REQUIREMENTS.md 文件。
**Guidance:** 所有文档使用中文。REQUIREMENTS.md 作为 CVE 修复进度跟踪文件。**Depends on: Task 1.1 Output**

- 创建 `doc/CVE/` 目录
- 创建 `doc/REQUIREMENTS.md`，包含项目标题、CVE 修复清单表格（列：CVE 编号、严重程度、状态、修复日期）
- 在 REQUIREMENTS.md 中添加 CVE-2024-22258 条目，状态标记为"待修复"

## Phase 2: CVE-2024-22258 修复

### Task 2.1 – 研究官方修复方案 - Agent_CVERemediation
**Objective:** 查找并分析 CVE-2024-22258 的官方修复 commit，制定 backport 策略。
**Output:** 官方 commitId、修复方案摘要、backport 策略分析。
**Guidance:** 在 GitHub spring-projects/spring-authorization-server 仓库中查找。重点关注 1.0.x 分支的修复（与 0.4.x 代码结构最接近）。

1. Ad-Hoc Delegation — 查找官方修复 commit（参考 apm-7-delegate-research.md）
2. 在 GitHub 仓库中定位 CVE-2024-22258 的修复 commit，记录 commitId 和修改的文件列表
3. 阅读官方修复 commit 的代码变更，理解 PKCE 降级攻击的修复逻辑
4. 对比 0.4.x 分支中对应文件的代码结构，分析 backport 差异并制定 backport 策略

### Task 2.2 – Backport 代码修复并添加中文注释 - Agent_CVERemediation
**Objective:** 将官方修复逻辑移植到 0.4.x 代码中，并添加完备的中文注释。
**Output:** 修复后的源码文件。
**Guidance:** 确保在 Confidential Client 使用 PKCE 时不会被降级攻击。所有注释使用中文。**Depends on: Task 2.1 Output**

1. 根据 Task 2.1 的 backport 策略，在 0.4.x 代码中定位需要修改的文件和方法
2. 实施代码修复：移植官方修复逻辑，确保在 Confidential Client 使用 PKCE 时不会被降级攻击
3. 在修复代码处添加完备的中文注释，说明漏洞原因、修复逻辑和安全考量

### Task 2.3 – 编写测试用例 - Agent_CVERemediation
**Objective:** 编写测试用例验证 PKCE 降级攻击已被阻止。
**Output:** 测试类/方法，测试执行结果记录。
**Guidance:** 沿用项目已有的 JUnit + Spring Test 框架。参考官方 commit 中的测试策略。**Depends on: Task 2.2 Output**

1. 参考官方修复 commit 中的测试用例，理解测试策略
2. 在 0.4.x 测试结构中编写对应的测试用例，覆盖：Confidential Client PKCE 降级攻击场景应被拒绝、正常 PKCE 流程不受影响
3. 运行测试用例，确认全部通过
4. 记录测试执行结果（测试名称、通过/失败状态），供文档使用

### Task 2.4 – 创建 CVE 文档并更新 REQUIREMENTS.md - Agent_CVERemediation
**Objective:** 创建 CVE-2024-22258 技术文档并更新修复状态。
**Output:** doc/CVE/CVE-2024-22258.md 文件，更新后的 REQUIREMENTS.md。
**Guidance:** 文档全部中文撰写。需整合 Task 2.1（commitId）、Task 2.2（修复方案）、Task 2.3（测试结果）的输出。**Depends on: Task 2.1 Output, Task 2.2 Output, Task 2.3 Output**

1. 在 `doc/CVE/` 下创建 `CVE-2024-22258.md`，包含：漏洞编号与描述、严重程度（CVSS 评分）、影响分析、官方修复方案与 commitId、本项目修复方案说明、测试用例与执行结果
2. 文档全部使用中文撰写
3. 更新 `doc/REQUIREMENTS.md` 中 CVE-2024-22258 条目状态为"已修复"，填写修复日期

### Task 2.5 – 用户确认并执行 git commit - Agent_CVERemediation
**Objective:** 获取用户确认后提交所有修复内容。
**Output:** git commit。
**Guidance:** commit message 使用中文。必须在 commit 前获得用户明确确认。**Depends on: Task 2.4 Output**

1. 使用 `git add` 暂存所有修改和新增的文件
2. 向用户展示修复摘要（修改的文件列表、修复内容概述），请求 commit 确认
3. 用户确认后，执行 `git commit`，commit message 使用中文描述修复内容
