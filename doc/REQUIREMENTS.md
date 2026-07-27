# Spring Authorization Server 1.5.x CVE 修复跟踪

## 概述

本文档跟踪 `1.5.x-bjca-patch` 分支的安全修复与依赖升级进度。  
工作分支基于 `origin/1.5.x`（Release 1.5.8），自定义 RELEASE 版本号为 `1.5.8-nes.patch.1`。

## CVE 修复清单

| CVE 编号 | 严重程度 | 状态 | 修复方式 | 修复日期 |
|----------|----------|------|----------|----------|
| CVE-2024-22258 | Moderate | 上游已修复 | 无需 backport（1.5.x 已含官方补丁） | — |
| CVE-2026-22752 | — | 上游已修复 | 1.5.7 官方修复 | — |
| CVE-2026-41008 | — | 上游已修复 | 1.5.8 官方修复 | — |
| CVE-2023-52428 | High | 已修复 | nimbus-jose-jwt 9.47（>= 9.37.2） | 2026-06-30 |
| CVE-2025-53864 | Medium | 已修复 | nimbus-jose-jwt 9.47（>= 9.37.4） | 2026-06-30 |
| CVE-2025-8916 | — | 已修复 | bouncycastle 1.79 显式约束 | 2026-06-30 |
| CVE-2025-52999 | High | 已修复 | jackson-bom 2.18.8 | 2026-06-30 |
| CVE-2023-51074 | Medium | 已修复 | json-path 2.9.0（测试依赖） | 2026-06-30 |
| CVE-2026-24400 | — | 已修复 | assertj-core 3.27.7（测试依赖） | 2026-06-30 |

### CVE 技术文档索引

| CVE 编号 | 文档 |
|----------|------|
| CVE-2023-52428 | [doc/CVE/CVE-2023-52428.md](CVE/CVE-2023-52428.md) |
| CVE-2025-53864 | [doc/CVE/CVE-2025-53864.md](CVE/CVE-2025-53864.md) |
| CVE-2025-8916 | [doc/CVE/CVE-2025-8916.md](CVE/CVE-2025-8916.md) |
| CVE-2025-52999 | [doc/CVE/CVE-2025-52999.md](CVE/CVE-2025-52999.md) |
| CVE-2023-51074 | [doc/CVE/CVE-2023-51074.md](CVE/CVE-2023-51074.md) |
| CVE-2026-24400 | [doc/CVE/CVE-2026-24400.md](CVE/CVE-2026-24400.md) |

## SCA 规避与内部 BOM

| 组件 | 坐标 |
|------|------|
| Spring Framework BOM | `cn.bjca.footstone.bpring:bjca-footstone-bpring-framework-bom:6.2.19-nes.patch.1` |
| Spring Security BOM | `cn.bjca.footstone.bpring.security:bjca-footstone-bpring-security-bom:6.5.11-nes.patch.1` |
| 本项目 groupId | `cn.bjca.footstone.bpring.security` |
| 本项目 version | `1.5.8-nes.patch.1` |

详细 GAV 映射见 [doc/GAV_MAPPING.md](GAV_MAPPING.md)。

## 变更记录

| 日期 | 类型 | 摘要 |
|------|------|------|
| 2026-06-30 | 构建/发布 | 移植 Nexus 私服、Makefile、SCA 模块重命名、内部 BOM 替换 |
| 2026-06-30 | 依赖安全 | assertj-core 升级至 3.27.7；补齐 CVE 技术文档 |
