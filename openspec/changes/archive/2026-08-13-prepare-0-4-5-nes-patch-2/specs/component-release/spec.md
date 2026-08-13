## ADDED Requirements

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
