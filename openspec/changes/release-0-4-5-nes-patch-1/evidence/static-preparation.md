# Static RELEASE Preparation Evidence

## Scope and ownership

- Component: `spring-authorization-server-0.4`
- Change: `release-0-4-5-nes-patch-1`
- Coordinator-assigned owner lease: `wave3-auth-04`
- Evidence timestamp: `2026-07-27T17:24:01+0800`
- This session did not edit the central manifest. Manifest lease recording remains a coordinator responsibility.
- Explicit publication exclusions: none.

## Repository baseline

- Branch: `0.4.x-bjca-patch`
- Baseline HEAD: `21a4c1493cfca46e1cc15edc8b7321bf486acdba`
- `origin` fetch/push URL: `https://github.com/atbjca/spring-authorization-server.git`
- Active OpenSpec change: `release-0-4-5-nes-patch-1` (`spec-driven`, apply-ready)
- Baseline tracked changes: none.
- Baseline untracked content: only `openspec/changes/release-0-4-5-nes-patch-1/`.
- Local tool directories `.claude/`, `.codex/`, and `.cursor/` are preserved and excluded from release staging.
- Java: OpenJDK Corretto `17.0.17`.
- Gradle wrapper: `7.6.3` (read from `gradle/wrapper/gradle-wrapper.properties`; Gradle was not executed in this session).
- Previous component version: `0.4.5-nes.patch.1-SNAPSHOT`.
- Target component version: `0.4.5-nes.patch.1`.

## Verified internal RELEASE dependencies

Both required upstream BOMs returned HTTP 200 from Nexus RELEASE on 2026-07-27:

| Upstream | Required GAV | Nexus POM evidence |
|----------|--------------|--------------------|
| Spring Framework 5.3 | `cn.bjca.footstone.bpring:bjca-footstone-bpring-framework-bom:5.3.39-nes.patch.1` | `http://192.168.131.36:8088/repository/releases/cn/bjca/footstone/bpring/bjca-footstone-bpring-framework-bom/5.3.39-nes.patch.1/bjca-footstone-bpring-framework-bom-5.3.39-nes.patch.1.pom` (`ETag` SHA-1 `8a8647d343c5f12f57093ca0b5774281de71eefd`) |
| Spring Security 5.8 | `cn.bjca.footstone.bpring.security:bjca-footstone-bpring-security-bom:5.8.16-nes.patch.1` | `http://192.168.131.36:8088/repository/releases/cn/bjca/footstone/bpring/security/bjca-footstone-bpring-security-bom/5.8.16-nes.patch.1/bjca-footstone-bpring-security-bom-5.8.16-nes.patch.1.pom` (`ETag` SHA-1 `5e3474ea64b2221174680bbcd1f98271935faed9`) |

`gradle.properties` pins exactly these RELEASE versions. The dependencies platform imports both BOMs, and the Authorization Server module imports both BOMs while consuming their managed internal Framework and Security modules.

## Verified publication set

The incremental local publication completed successfully in `2m 1s` with 15
actionable tasks (7 executed, 8 up-to-date). It produced exactly one Maven POM:

| Type | GAV |
|------|-----|
| JAR | `cn.bjca.footstone.bpring.security:bjca-footstone-bpring-security-oauth2-authorization-server:jar:0.4.5-nes.patch.1` |

The core module applies `io.spring.convention.spring-module`, which applies
Maven Publish. The dependencies project applies `java-platform` but not
`maven-publish`; it supplies build constraints and does not create a release
publication. The docs and samples are also not publications. There are no
excluded modules.

The generated POM was parsed with `xmllint`; internal SNAPSHOT findings were
`0`. Its dependency management imports Framework `5.3.39-nes.patch.1` and
Security `5.8.16-nes.patch.1`, and its concrete internal dependencies use those
same RELEASE lines.

## Recommended next command

Run only after the coordinating session acquires the single Gradle command slot:

```shell
JAVA_TOOL_OPTIONS=-Dfile.encoding=UTF-8 GRADLE_OPTS='-Xmx3g -Dfile.encoding=UTF-8 -Dorg.gradle.workers.max=3' ./gradlew publishToMavenLocal -x test -x asciidoctor -x javadoc --max-workers=3
```

This command is incremental: it does not invoke `clean`, `make build`, or `make test`. It was executed by the coordinator as recorded above.

The first offline Maven consumer attempt stopped because external
`com.fasterxml.jackson.core:jackson-databind:2.18.7` was not cached. A retry
using the configured Nexus public proxy completed successfully in `3.388s`.
The tree resolved Authorization Server `0.4.5-nes.patch.1`, Security
`5.8.16-nes.patch.1` modules, Framework `5.3.39-nes.patch.1` modules, and
external Jackson/Nimbus RELEASEs. No internal SNAPSHOT was selected.

## Static review result

- `git diff --check`: passed.
- Target-version scan: no active configuration or component documentation references `0.4.5-nes.patch.1-SNAPSHOT`, `5.3.39-nes.patch.1-SNAPSHOT`, or `5.8.16-nes.patch.1-SNAPSHOT`. The previous component version above is retained only as baseline evidence.
- Credential scan: no credential value, authorization header, or token was added. Existing documentation names user-level Gradle property keys only.
- Reviewed changes are limited to release version metadata, the three required component documents, and this component OpenSpec change. No source file, build logic, or local tool directory was modified.
