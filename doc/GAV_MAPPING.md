# GAV Mapping Table (Spring Authorization Server & Security)

本项目维护的自定义版本与官方版本的 GAV 映射关系如下表所示。

## 1. Spring Authorization Server 模块映射

| 原始模块 (artifactId)                           | 新模块 (artifactId)                                                         | 新 GroupId                            | 新 Version                     |
| :---------------------------------------------- | :-------------------------------------------------------------------------- | :------------------------------------ | :----------------------------- |
| `spring-security-oauth2-authorization-server` | `bjca-footstone-bpring-security-oauth2-authorization-server`              | `cn.bjca.footstone.bpring.security` | `0.4.5-nes.patch.2-SNAPSHOT` |

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
| `org.springframework` | `spring-`          | `cn.bjca.footstone.bpring` | `bjca-footstone-bpring-` | `5.3.39-nes.patch.1` |

例如：`org.springframework:spring-core` → `cn.bjca.footstone.bpring:bjca-footstone-bpring-core:5.3.39-nes.patch.1`

Spring Security 依赖由 BOM
`cn.bjca.footstone.bpring.security:bjca-footstone-bpring-security-bom:5.8.16-nes.patch.2-SNAPSHOT`
统一约束。当前开发线用该 SNAPSHOT 做功能验证；正式发版时两个上游 BOM 仍必须从 Nexus RELEASE 解析，禁止把内部 SNAPSHOT 写进 RELEASE 元数据。上一不可变 RELEASE 仍是 `0.4.5-nes.patch.1`（当时消费 `5.8.16-nes.patch.1`）。

## 4. 发布与验证约束

- 完整发布集合只有上表中的 Authorization Server JAR，无排除项。`dependencies` 工程仅用于构建约束，未应用 `maven-publish`，不产生 RELEASE BOM。
- Nexus RELEASE 地址：`http://192.168.131.36:8088/repository/releases`。
- 推荐增量本地发布命令：

  ```shell
  JAVA_TOOL_OPTIONS=-Dfile.encoding=UTF-8 GRADLE_OPTS='-Xmx3g -Dfile.encoding=UTF-8 -Dorg.gradle.workers.max=3' ./gradlew publishToMavenLocal -x test -x asciidoctor -x javadoc --max-workers=3
  ```

- 本地发布后必须扫描生成的 POM，确认所有 `cn.bjca.footstone` 依赖均为 RELEASE。
- 正式部署前必须确认目标 GAV 在 Nexus RELEASE 中完全不存在；正式部署由协调主会话串行执行。
