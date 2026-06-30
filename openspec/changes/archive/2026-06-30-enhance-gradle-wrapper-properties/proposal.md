## Why

The project's `gradle-wrapper.properties` is missing two properties available in newer Gradle versions that improve reliability and security. Meanwhile the reference project `spring-boot-3.5` already includes them. Adding them brings this project in line with current Gradle best practices.

## What Changes

- Add `networkTimeout=10000` to `gradle/wrapper/gradle-wrapper.properties`
- Add `validateDistributionUrl=true` to `gradle/wrapper/gradle-wrapper.properties`

## Capabilities

### New Capabilities
(None)

### Modified Capabilities
(None — configuration property additions, not capability changes)

## Impact

- **File**: `gradle/wrapper/gradle-wrapper.properties`
- **No breaking changes** — these are additive properties with safe defaults
- Aligns with `spring-boot-3.5` reference project configuration