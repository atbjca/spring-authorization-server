# component-release Specification

## Purpose
TBD - created by archiving change release-0-4-5-nes-patch-1. Update Purpose after archive.
## Requirements
### Requirement: Exclusive and safe component preparation

The release process MUST assign one active owner to `spring-authorization-server-0.4` and MUST inspect branch, origin, tracked and untracked changes, and active OpenSpec changes before modifying `spring-authorization-server-0.4`.

#### Scenario: Worktree is safe
- **WHEN** the owner lease is active and all tracked changes are covered by the approved release change
- **THEN** preparation may update the component release version and dependencies

#### Scenario: Unrelated work exists
- **WHEN** unrelated tracked changes or another active owner are detected
- **THEN** preparation stops without cleaning, discarding, staging, or committing that work

### Requirement: Complete internal RELEASE metadata

Every generated RELEASE POM or BOM for `0.4.5-nes.patch.1` MUST use approved RELEASE versions for internal `cn.bjca.footstone` dependencies, parents, imported BOMs, and plugins.

#### Scenario: Generated metadata is clean
- **WHEN** the complete local publication set contains no internal version ending in `-SNAPSHOT`
- **THEN** the metadata gate passes

#### Scenario: Internal SNAPSHOT remains
- **WHEN** any generated publication contains an internal SNAPSHOT reference
- **THEN** local verification fails and deploy is forbidden

### Requirement: Proportional local verification

The component MUST provide approved build/test evidence or an explicit operator exception, plus local publication or effective-POM generation, POM scan, and representative consumer validation against the release commit.

#### Scenario: All local gates pass
- **WHEN** build/test evidence or an explicit exception is recorded and incremental local publication, the metadata scan, and consumer validation succeed
- **THEN** commands and evidence are recorded and the component may become `locally-verified`

#### Scenario: A local gate fails
- **WHEN** a required command fails or is skipped without an approved exception
- **THEN** the component cannot be committed for release or deployed

### Requirement: Auditable release commit and documentation

The component SHALL have one dedicated release commit containing `0.4.5-nes.patch.1`, internal RELEASE dependency updates, `README.adoc`, `doc/SUMMARY.md`, `doc/GAV_MAPPING.md`, approved exclusions, and no unrelated source changes.

#### Scenario: Release diff is approved
- **WHEN** the staged diff matches this OpenSpec and all local gates pass
- **THEN** the release commit SHA is recorded in the central manifest

#### Scenario: Documentation or diff is incomplete
- **WHEN** component documentation still presents the target as SNAPSHOT or the diff contains unapproved files
- **THEN** release commit creation is blocked

### Requirement: Target absence before immutable deployment

Immediately before deployment, the coordinator MUST verify that every GAV discovered in the local publication set is absent from Nexus RELEASE.

#### Scenario: Complete target set is absent
- **WHEN** no POM, binary, checksum, metadata, or partial module asset exists for `0.4.5-nes.patch.1`
- **THEN** the coordinator may authorize the single deploy after reviewing all other gates

#### Scenario: Any target asset exists
- **WHEN** Nexus contains any complete or partial target-version asset
- **THEN** deploy is blocked and the existing assets are recorded for investigation

### Requirement: Coordinator-controlled deployment and remote verification

Only the coordinating main session SHALL execute the incremental Nexus publication without `clean`, and only after explicit execution confirmation. After deployment, it MUST download and verify representative POM and binary assets, metadata, checksums, and RELEASE-only consumer resolution.

#### Scenario: Remote release is valid
- **WHEN** all expected assets are downloadable, metadata is RELEASE-only, checksums are recorded, and the consumer smoke test passes
- **THEN** the component advances to `nexus-verified`

#### Scenario: Publication is incomplete or uncertain
- **WHEN** expected assets are missing, inconsistent, or only partially present
- **THEN** the component becomes `partial-failure`, is not redeployed at the same version, and cannot be tagged

### Requirement: Exact annotated release tag

After Nexus verification, the coordinator MUST create annotated tag `v0.4.5-nes.patch.1` on the exact release commit used to build and deploy `0.4.5-nes.patch.1`.

#### Scenario: Tag and push are valid
- **WHEN** the annotated tag points to the recorded release commit and both commit and tag are verified on `origin`
- **THEN** tag object IDs and remote evidence are recorded

#### Scenario: Nexus is not verified
- **WHEN** remote artifact verification is incomplete or failed
- **THEN** no release tag is created or pushed

### Requirement: Explicit exclusions

The release process MUST honor and verify these exclusions: none.

#### Scenario: Exclusions are honored
- **WHEN** local publications, deploy tasks, and remote assets omit every excluded item and no included POM depends on it
- **THEN** exclusion verification passes

#### Scenario: Excluded content is present
- **WHEN** an excluded module is published or referenced by an included RELEASE POM
- **THEN** finalization fails and the immutable failure procedure applies

### Requirement: Evidence-backed documentation and archive

The component OpenSpec MUST remain active until Nexus assets, remote Git references, component documentation, and the central run manifest agree.

#### Scenario: Completion evidence agrees
- **WHEN** the component is `nexus-verified`, tagged, remotely verified, documented, and reconciled in the manifest
- **THEN** the OpenSpec change may be archived and its archive path recorded

#### Scenario: Evidence is missing or mismatched
- **WHEN** any required Git, Nexus, documentation, or manifest evidence is absent or inconsistent
- **THEN** archive is blocked

### Requirement: Immutable partial-failure handling

Existing RELEASE assets MUST NOT be overwritten, deleted, or blindly redeployed.

#### Scenario: Partial assets exist
- **WHEN** a failed or interrupted deployment leaves any target-version asset in Nexus
- **THEN** the component records `partial-failure` and requires a newly approved NES patch version

#### Scenario: Nexus succeeded but Git push failed
- **WHEN** Nexus verification is complete and only commit or tag push failed
- **THEN** the coordinator retries only the Git operation without redeploying

### Requirement: Released coordinates advance to the next development snapshot

After an immutable NES patch release is Nexus-verified and tagged, the maintained branch MUST advance to the next NES patch `-SNAPSHOT` before accepting additional implementation commits or generating new candidate publications.

#### Scenario: Patch 1 is already released

- **WHEN** `0.4.5-nes.patch.1` exists as a Nexus-verified release with tag `v0.4.5-nes.patch.1`
- **THEN** subsequent branch development MUST use `0.4.5-nes.patch.2-SNAPSHOT`
- **AND** no subsequent candidate or deployment MAY reuse `0.4.5-nes.patch.1`

#### Scenario: Patch 2 is prepared for formal release

- **WHEN** the coordinator begins the explicit patch.2 release workflow
- **THEN** a dedicated release change MUST remove `-SNAPSHOT`, verify the complete `0.4.5-nes.patch.2` target set is absent from Nexus RELEASE, and bind deployment and tagging to one release commit

### Requirement: Development line waits for the next Security RELEASE

The maintained development branch MUST declare `springSecurityVersion` as `5.8.16-nes.patch.2-SNAPSHOT` so functional verification can resolve the current Security line, and MUST NOT publish a SAS RELEASE until the Security BOM is a Nexus RELEASE.

#### Scenario: Security patch 2 is not yet released

- **WHEN** `5.8.16-nes.patch.2` is absent from Nexus RELEASE
- **THEN** the branch MUST use `0.4.5-nes.patch.2-SNAPSHOT` and `springSecurityVersion=5.8.16-nes.patch.2-SNAPSHOT`
- **AND** it MUST NOT deploy `0.4.5-nes.patch.2`

#### Scenario: Security patch 2 is released

- **WHEN** `cn.bjca.footstone.bpring.security:bjca-footstone-bpring-security-bom:5.8.16-nes.patch.2` is resolvable from Nexus RELEASE
- **THEN** a later SAS release change MAY freeze `0.4.5-nes.patch.2` and consume that Security RELEASE

### Requirement: Bouncy Castle constraint matches the Security patch 2 baseline

The Authorization Server dependency platform MUST constrain `org.bouncycastle:bcprov-jdk18on` and `org.bouncycastle:bcpkix-jdk18on` to `1.84` or a newer approved compatible patch, and MUST NOT keep `1.79` as the declared consumer-visible baseline.

#### Scenario: Platform exports 1.84

- **WHEN** the dependency platform is applied
- **THEN** both Bouncy Castle `jdk18on` artifacts resolve to `1.84` or newer
- **AND** no `jdk15on` coordinate is declared

