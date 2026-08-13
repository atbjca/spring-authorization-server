## 1. Advance development coordinates

- [x] 1.1 Set `version` in `gradle.properties` to `0.4.5-nes.patch.2-SNAPSHOT`
- [x] 1.2 Set `springSecurityVersion` in `gradle.properties` to `5.8.16-nes.patch.2-SNAPSHOT`

## 2. Align Bouncy Castle with Security patch 2

- [x] 2.1 Update `dependencies/spring-authorization-server-dependencies.gradle` so `bcprov-jdk18on` and `bcpkix-jdk18on` are `1.84`
- [x] 2.2 Update the current baseline in `doc/CVE/CVE-2025-8916.md` to `1.84` while keeping the minimum fixed version as `1.79`

## 3. Distinguish live docs from the immutable patch 1 release

- [x] 3.1 Update `README.adoc` so the current line is `0.4.5-nes.patch.2-SNAPSHOT` waiting for Security `5.8.16-nes.patch.2`, and keep patch.1 as the last immutable RELEASE
- [x] 3.2 Update `doc/GAV_MAPPING.md` current versions to `0.4.5-nes.patch.2-SNAPSHOT` and Security BOM `5.8.16-nes.patch.2`
- [x] 3.3 Update `doc/SUMMARY.md` to describe the current development line and retain the historical `0.4.5-nes.patch.1` section
- [x] 3.4 Leave `openspec/changes/archive/**` and existing patch.1 tags/assets unchanged

## 4. Verify metadata only

- [x] 4.1 Confirm live files no longer present `0.4.5-nes.patch.1` or `5.8.16-nes.patch.1` as the current development target
- [x] 4.2 Do not run a full resolve/test/publish gate that requires Security `5.8.16-nes.patch.2` to already exist in Nexus
