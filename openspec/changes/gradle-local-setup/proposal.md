# Proposal: 统一 Gradle Wrapper 策略，添加 setup-gradle 支持

## Status
已完成 | 2026-06-30

## Summary
将当前项目的 Gradle 本地化配置方式与 spring-boot-3.5 保持一致，采用 Gradle Wrapper + `setup-gradle` 预热脚本实现完全离线构建。

## Motivation

### 问题 1：版本错配
- Makefile 默认调用 `~/dev/gradle-8.14.5/bin/gradle`
- `gradle-wrapper.properties` 声明使用 `gradle-8.6-bin.zip`
- 两者版本不一致，团队成员必须同时具备两个版本才能正常工作

### 问题 2：离线构建能力缺失
- 执行 `./gradlew`（绕过 Makefile）会触发网络下载 gradle-8.6
- `~/.gradle/wrapper/dists/` 中从未缓存过 gradle-8.6
- 无法在无网络环境下使用 wrapper

### 问题 3：缺乏标准化
- spring-boot-3.5 已通过 `scripts/setup-gradle-local.sh` 实现本地 Gradle zip 注入 wrapper 缓存
- 当前项目没有对应机制

## Approach

采用与 spring-boot-3.5 完全一致的方式：

1. **新增 `scripts/setup-gradle-local.sh`**
   - 扫描 `~/dev/gradle-*-bin.zip` 和 `gradle-*-all.zip`
   - 计算 Gradle Wrapper 缓存路径（MD5(url) → base36 hash）
   - 将 zip 复制到 `~/.gradle/wrapper/dists/` 并解压
   - 生成 `.zip.ok` 标记文件

2. **改造 Makefile**
   - `GRADLE ?= ./gradlew`（默认使用 wrapper）
   - 所有构建 target 依赖 `setup-gradle`
   - 保留 `GRADLE` 变量覆盖机制，供特殊场景绕过 wrapper

## Impact Analysis

| 受影响模块 | 说明 |
|-----------|------|
| `Makefile` | 重写，统一用 `./gradlew` |
| `scripts/setup-gradle-local.sh` | 新建 |
| `gradle-wrapper.properties` | 无需改动（版本已是 8.6） |
| `gradle.properties` | 无需改动 |
| `build.gradle` / `settings.gradle` | 无需改动 |

**风险：** 无破坏性变更。首次执行 `setup-gradle` 时会解压 gradle-8.6 到 wrapper 缓存（约 130MB），之后全程离线。

## Verification

```bash
# 验证离线构建
make setup-gradle   # 注入缓存
./gradlew --version  # 无网络，成功启动 Gradle 8.6
make build-thin      # 完整离线构建
```

## Related
- 参考实现：`spring-boot-3.5` 项目的 `scripts/setup-gradle-local.sh` 和 `Makefile`
