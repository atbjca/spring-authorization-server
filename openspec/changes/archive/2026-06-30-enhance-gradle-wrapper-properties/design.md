## Context

`gradle/wrapper/gradle-wrapper.properties` currently contains only four lines (distributionBase, distributionPath, distributionUrl, zipStoreBase, zipStorePath). Two Gradle 7.x+ properties are missing.

## Goals / Non-Goals

**Goals:**
- Add `networkTimeout=10000` — prevents wrapper download hang on slow/unreliable networks
- Add `validateDistributionUrl=true` — validates distribution URL against known security rules (Gradle 7.6+)

**Non-Goals:**
- Upgrading Gradle version (currently 7.6.3, staying at that version)
- Any other configuration changes

## Decisions

- Both properties are added with safe values matching `spring-boot-3.5` reference project
- `networkTimeout=10000` (10 seconds) is the Gradle default; explicit value helps in constrained network environments
- `validateDistributionUrl=true` is a Gradle 7.6+ feature that verifies the distribution URL

## Risks / Trade-offs

- **Risk**: None. These are well-tested Gradle properties with safe defaults.
- **Trade-off**: Adding properties slightly increases file size — negligible.