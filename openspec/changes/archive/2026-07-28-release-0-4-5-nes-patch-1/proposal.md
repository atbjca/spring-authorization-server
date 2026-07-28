## Why

`spring-authorization-server-0.4` currently targets `0.4.5-nes.patch.1` but does not yet have a complete, immutable, and independently auditable RELEASE lifecycle. The release must survive session loss, preserve unrelated work, and publish metadata that references only approved internal RELEASE dependencies.

## What Changes

- Freeze and inventory the `spring-authorization-server-0.4` worktree before release edits.
- Create RELEASE metadata for `0.4.5-nes.patch.1` and replace all internal SNAPSHOT references with approved RELEASE versions.
- Reuse approved build/test evidence or an explicit operator exception, then run local publication/effective-POM scanning and consumer verification.
- Form a dedicated release commit containing component release documentation and no unrelated changes.
- Verify every discovered target GAV is absent from Nexus RELEASE before the coordinator-authorized deploy.
- Download and verify published POM/binary assets and checksums from Nexus, then run RELEASE-only consumption.
- Create annotated tag `v0.4.5-nes.patch.1` on the exact release commit only after Nexus verification.
- Record Git, Nexus, documentation, and manifest evidence before archiving this change.

## Capabilities

### New Capabilities

- `component-release-spring-authorization-server-0.4`: Release `spring-authorization-server-0.4` `0.4.5-nes.patch.1` with reproducible local gates, immutable Nexus publication, exact Git tagging, documentation, and archive evidence.

### Modified Capabilities

None.

## Impact

- **Repository:** `spring-authorization-server-0.4`
- **Release version:** `0.4.5-nes.patch.1`
- **Representative GAVs:** `cn.bjca.footstone.bpring.security:bjca-footstone-bpring-security-oauth2-authorization-server:0.4.5-nes.patch.1`
- **Internal RELEASE dependencies:** `spring-framework-5.3`, `spring-security-5.8`
- **Explicit exclusions:** none
- **Release documentation:** `README.adoc`, `doc/SUMMARY.md`, `doc/GAV_MAPPING.md`
- **External systems:** Nexus RELEASE and the repository's configured `origin`
- **Credentials:** Remain exclusively in user-level Gradle/Maven configuration and are never copied into this change or Git
