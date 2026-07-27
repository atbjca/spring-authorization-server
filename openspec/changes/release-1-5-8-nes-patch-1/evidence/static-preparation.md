# Static RELEASE preparation evidence

Recorded: 2026-07-27 (Asia/Shanghai)

## Ownership and repository

- Assigned owner lease: `wave3-auth-15` (confirmed by the coordinating session).
- Repository: `spring-authorization-server-1.5`.
- Branch: `1.5.x-bjca-patch`.
- Preparation base HEAD: `6edfa2d9db83ddd0990f610f923213d3a9eedadb`.
- `origin` fetch/push: `https://github.com/atbjca/spring-authorization-server.git`.
- Additional remote `gitlab` fetch/push: `git@192.168.131.1:NES/spring-authorization-server.git`.
- Active OpenSpec change: `release-1-5-8-nes-patch-1` (`spec-driven`, apply-ready).
- Toolchain inspected without invoking Gradle: Amazon Corretto JDK `17.0.17`; wrapper distribution `gradle-8.6-bin.zip`.
- Credentials remain exclusively in user-level Gradle configuration and were neither read nor recorded.

## Worktree inventory

Before RELEASE edits there were no tracked worktree changes. Untracked paths were:

- `.claude/`
- `.codex/`
- `.cursor/`
- `openspec/changes/release-1-5-8-nes-patch-1/`

The first three local tool directories must remain untracked and excluded from all release staging. The OpenSpec directory belongs to this release change.

## Version and upstream RELEASE dependencies

- Component: `1.5.8-nes.patch.1`.
- Spring Framework BOM: `cn.bjca.footstone.bpring:bjca-footstone-bpring-framework-bom:6.2.19-nes.patch.1`.
- Spring Security BOM: `cn.bjca.footstone.bpring.security:bjca-footstone-bpring-security-bom:6.5.11-nes.patch.1`.

Nexus RELEASE verification:

- Framework BOM POM returned HTTP 200, `Last-Modified: Mon, 27 Jul 2026 05:54:25 GMT`, SHA-1 ETag `0ba9c054c128b2e5743e3fe088f05f8c0eaa1974`.
- Security BOM POM returned HTTP 200, `Last-Modified: Mon, 27 Jul 2026 08:02:10 GMT`, SHA-1 ETag `19ba4006e3fccd707346bf43f422e45c887d4605`.
- Both downloaded POM bodies declare the expected RELEASE version; their internal `cn.bjca.footstone` dependency-management entries contain no `-SNAPSHOT` version.

Immutable URLs:

- `http://192.168.131.36:8088/repository/releases/cn/bjca/footstone/bpring/bjca-footstone-bpring-framework-bom/6.2.19-nes.patch.1/bjca-footstone-bpring-framework-bom-6.2.19-nes.patch.1.pom`
- `http://192.168.131.36:8088/repository/releases/cn/bjca/footstone/bpring/security/bjca-footstone-bpring-security-bom/6.5.11-nes.patch.1/bjca-footstone-bpring-security-bom-6.5.11-nes.patch.1.pom`

## Static publication assessment

The statically confirmed representative publication is:

- `cn.bjca.footstone.bpring.security:bjca-footstone-bpring-security-oauth2-authorization-server:jar:1.5.8-nes.patch.1`

No explicit publication exclusions are approved or configured. The complete publication set is deliberately not declared verified until `publishToMavenLocal` runs and every generated POM is enumerated.

Recommended incremental local publication command (not executed in this preparation session):

```bash
JAVA_TOOL_OPTIONS=-Dfile.encoding=UTF-8 GRADLE_OPTS='-Xmx4g -Dfile.encoding=UTF-8 -Dorg.gradle.workers.max=3' ./gradlew publishToMavenLocal -x test -x asciidoctor -x javadoc --max-workers=3
```

The command intentionally omits `clean`, `make build`, and `make test`. Local POM scanning and a minimal consumer check remain required before release commit and deployment.

## Reused development validation

The operator explicitly directed this release run not to repeat `make build`
or `make test`. Review of the release diff found no executable production code
or test change. The sole Java-file edit makes an existing comment
version-independent by referring to `gradle.properties`; it does not alter the
runtime version constants or behavior. Release-specific local publication,
complete generated-POM scanning, and a representative consumer remain required.

## Local RELEASE publication

At `2026-07-27T18:26+08:00`, the coordinator ran the incremental publication:

```text
JAVA_HOME=/Users/anan/.sdkman/candidates/java/17.0.17-amzn JAVA_TOOL_OPTIONS=-Dfile.encoding=UTF-8 GRADLE_OPTS='-Xmx4g -Dfile.encoding=UTF-8 -Dorg.gradle.workers.max=3' ./gradlew publishToMavenLocal -x test -x asciidoctor -x javadoc --max-workers=3
```

It completed successfully in `1m 35s`: 12 actionable tasks, 7 executed and 5
up-to-date. The remote Gradle build cache returned HTTP 403 and was disabled;
this did not affect the local publication.

The complete publication set contains exactly one Maven publication:

- `cn.bjca.footstone.bpring.security:bjca-footstone-bpring-security-oauth2-authorization-server:jar:1.5.8-nes.patch.1`

The local version directory contains the main JAR, sources JAR, Javadoc JAR,
POM, and Gradle module metadata. No dependencies-platform publication was
generated. The sole generated POM was parsed and scanned; internal
`cn.bjca.footstone` SNAPSHOT findings were `0`. Its dependency management
imports Framework `6.2.19-nes.patch.1` and Security `6.5.11-nes.patch.1`, and
all concrete internal dependencies use those RELEASE versions.

An initial offline Maven consumer attempt stopped in `0.438s` only because the
external `com.fasterxml.jackson.core:jackson-databind:2.18.8` was not cached.
After downloading that external RELEASE through the configured Nexus public
proxy, the representative dependency-tree consumer completed successfully in
`3.090s`. It resolved Authorization Server `1.5.8-nes.patch.1`, Security
`6.5.11-nes.patch.1`, and Framework `6.2.19-nes.patch.1`, with no internal
SNAPSHOT selected.
