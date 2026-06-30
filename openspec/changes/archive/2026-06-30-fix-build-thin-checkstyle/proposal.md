## Why

`make build-thin` runs `build -x test -x asciidoctor -x javadoc` but does not exclude `checkstyleNohttp`. The task fails because it cannot load `etc/nohttp/allowlist.lines` (a path resolution issue) and separately reports a 403 from the Spring Ge server remote cache. This blocks local development builds.

## What Changes

- `Makefile` `build-thin` target: add `-x checkstyleNohttp` to the Gradle arguments
- No code, spec, or architecture changes

## Capabilities

### New Capabilities
(None)

### Modified Capabilities
(None — this is a Makefile target fix, not a capability requirement change)

## Impact

- **File**: `Makefile` line 37 — one flag added to `build-thin` Gradle invocation
- **Downstream**: `build`, `install`, `deploy` targets are unaffected
- **No breaking changes**