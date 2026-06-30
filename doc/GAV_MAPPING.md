# GAV 映射表（Spring Authorization Server 1.5.x）

本项目维护的自定义版本与官方版本的 GAV 映射关系如下表所示。

## 1. Spring Authorization Server 模块映射

| 原始 artifactId | 新 artifactId | 新 groupId | 新 version |
| :-- | :-- | :-- | :-- |
| `spring-security-oauth2-authorization-server` | `bjca-footstone-bpring-security-oauth2-authorization-server` | `cn.bjca.footstone.bpring.security` | `1.5.8-nes.patch.1-SNAPSHOT` |
| `spring-authorization-server-dependencies` | `bjca-footstone-bpring-security-spring-authorization-server-dependencies` | `cn.bjca.footstone.bpring.security` | `1.5.8-nes.patch.1-SNAPSHOT` |

> 模块重命名由 `settings.gradle` 动态完成，下游仅需替换 Maven/Gradle 坐标，**无需修改 import 语句**。

## 2. Spring Security 依赖映射

| 原始 GAV (`org.springframework.security`) | 新 GAV (`cn.bjca.footstone.bpring.security`) |
| :-- | :-- |
| `spring-security-core` | `bjca-footstone-bpring-security-core` |
| `spring-security-web` | `bjca-footstone-bpring-security-web` |
| `spring-security-config` | `bjca-footstone-bpring-security-config` |
| `spring-security-oauth2-client` | `bjca-footstone-bpring-security-oauth2-client` |
| `spring-security-oauth2-core` | `bjca-footstone-bpring-security-oauth2-core` |
| `spring-security-oauth2-jose` | `bjca-footstone-bpring-security-oauth2-jose` |
| `spring-security-oauth2-resource-server` | `bjca-footstone-bpring-security-oauth2-resource-server` |
| `spring-security-test` | `bjca-footstone-bpring-security-test` |

## 3. Spring Framework 依赖映射

| 原始 | 新 groupId | 新 artifactId 前缀 | 新 version |
| :-- | :-- | :-- | :-- |
| `org.springframework:spring-*` | `cn.bjca.footstone.bpring` | `bjca-footstone-bpring-` | `6.2.19-nes.patch.1-SNAPSHOT` |

例如：`org.springframework:spring-core` → `cn.bjca.footstone.bpring:bjca-footstone-bpring-core:6.2.19-nes.patch.1-SNAPSHOT`

## 4. 下游 Gradle 示例

```gradle
dependencyManagement {
    imports {
        mavenBom "cn.bjca.footstone.bpring:bjca-footstone-bpring-framework-bom:6.2.19-nes.patch.1-SNAPSHOT"
        mavenBom "cn.bjca.footstone.bpring.security:bjca-footstone-bpring-security-bom:6.5.11-nes.patch.1-SNAPSHOT"
    }
}

dependencies {
    implementation "cn.bjca.footstone.bpring.security:bjca-footstone-bpring-security-oauth2-authorization-server:1.5.8-nes.patch.1-SNAPSHOT"
}
```

## 5. 下游 Maven 示例

```xml
<dependencyManagement>
    <dependencies>
        <dependency>
            <groupId>cn.bjca.footstone.bpring</groupId>
            <artifactId>bjca-footstone-bpring-framework-bom</artifactId>
            <version>6.2.19-nes.patch.1-SNAPSHOT</version>
            <type>pom</type>
            <scope>import</scope>
        </dependency>
        <dependency>
            <groupId>cn.bjca.footstone.bpring.security</groupId>
            <artifactId>bjca-footstone-bpring-security-bom</artifactId>
            <version>6.5.11-nes.patch.1-SNAPSHOT</version>
            <type>pom</type>
            <scope>import</scope>
        </dependency>
    </dependencies>
</dependencyManagement>
```

## 6. 构建与发布

| 命令 | 说明 |
| :-- | :-- |
| `make test` | 运行全项目单元测试（跳过文档生成） |
| `make build-thin` | 本地编译（跳过测试与文档） |
| `make install` | 安装到 `~/.m2/repository` |
| `make deploy` | 发布到 Nexus 私服（SNAPSHOT → snapshots 仓库） |

Nexus 地址与凭证配置在 `~/.gradle/gradle.properties`（`nexusPublicUrl`、`nexusSnapshotUrl`、`nexusReleaseUrl`、`nexusUsername`、`nexusPassword`）。
