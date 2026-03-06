# GAV Mapping Table (Spring Authorization Server & Security)

本项目维护的自定义版本与官方版本的 GAV 映射关系如下表所示。

## 1. Spring Authorization Server 模块映射

| 原始模块 (artifactId)                           | 新模块 (artifactId)                                                         | 新 GroupId                            | 新 Version                     |
| :---------------------------------------------- | :-------------------------------------------------------------------------- | :------------------------------------ | :----------------------------- |
| `spring-security-oauth2-authorization-server` | `bjca-footstone-bpring-security-oauth2-authorization-server`              | `cn.bjca.footstone.bpring.security` | `0.4.5-nes.patch.1-SNAPSHOT` |
| `spring-authorization-server-dependencies`    | `bjca-footstone-bpring-security-spring-authorization-server-dependencies` | `cn.bjca.footstone.bpring.security` | `0.4.5-nes.patch.1-SNAPSHOT` |

> [!NOTE]
> 在本项目的 `settings.gradle` 中，模块名已动态映射。

## 2. Spring Security 依赖映射 (参考)

以下是下游项目在引入本项目时，建议在 `dependencyManagement` 中统一替换的 Spring Security 坐标。

| 原始 GAV (org.springframework.security)    | 新 GAV (cn.bjca.footstone.bpring.security)                |
| :----------------------------------------- | :-------------------------------------------------------- |
| `spring-security-core`                   | `bjca-footstone-bpring-security-core`                   |
| `spring-security-web`                    | `bjca-footstone-bpring-security-web`                    |
| `spring-security-config`                 | `bjca-footstone-bpring-security-config`                 |
| `spring-security-oauth2-client`          | `bjca-footstone-bpring-security-oauth2-client`          |
| `spring-security-oauth2-core`            | `bjca-footstone-bpring-security-oauth2-core`            |
| `spring-security-oauth2-jose`            | `bjca-footstone-bpring-security-oauth2-jose`            |
| `spring-security-oauth2-resource-server` | `bjca-footstone-bpring-security-oauth2-resource-server` |
| `spring-security-test`                   | `bjca-footstone-bpring-security-test`                   |

## 3. Spring Framework 依赖映射

本项目强制要求配合以下内部维护的 Spring Framework 版本使用：

| 原始 GroupId            | 原始 ArtifactId 前缀 | 新 GroupId                   | 新 ArtifactId 前缀         | 新 Version                      |
| :---------------------- | :------------------- | :--------------------------- | :------------------------- | :------------------------------ |
| `org.springframework` | `spring-`          | `cn.bjca.footstone.bpring` | `bjca-footstone-bpring-` | `5.3.39-nes.patch.1-SNAPSHOT` |

例如：`org.springframework:spring-core` → `cn.bjca.footstone.bpring:bjca-footstone-bpring-core:5.3.39-nes.patch.1-SNAPSHOT`
