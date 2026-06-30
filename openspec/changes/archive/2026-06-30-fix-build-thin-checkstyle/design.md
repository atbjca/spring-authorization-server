## Context

`make build-thin` invokes Gradle with `-x test -x asciidoctor -x javadoc`. The `checkstyleNohttp` task (part of the no-http checkstyle plugin) is not excluded and fails because:

1. It cannot resolve `etc/nohttp/allowlist.lines` via the relative path used in the project
2. It additionally fails a 403 from `ge.spring.io` remote build cache (authentication not configured)

## Goals / Non-Goals

**Goals:**
- Unblock `make build-thin` so developers can build locally without CI-grade checks

**Non-Goals:**
- Fixing the underlying path resolution issue in `checkstyleNohttp`
- Adding ge.spring.io authentication
- Changing any other Makefile targets

## Decisions

- Add `-x checkstyleNohttp` to `build-thin`. The `build` task already excludes `test`, `asciidoctor`, `javadoc`; `checkstyleNohttp` is a code-quality check inappropriate for a local thin build and belongs in CI.

## Risks / Trade-offs

- **Risk**: `checkstyleNohttp` will never run in `build-thin`. → **Mitigation**: This is intentional; CI pipeline runs full checks separately.
- **Risk**: None. Single-line Makefile change, no architectural impact.