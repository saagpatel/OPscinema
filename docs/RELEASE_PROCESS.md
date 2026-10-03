# OpsCinema Release Process

This runbook describes how to cut, validate, publish, and notarize OpsCinema releases.
For local synthetic checks before any release action, use the
[verification instructions](../README.md#verification).

## Prerequisites

1. Local environment (run commands from the repository root):
   - macOS with Xcode Command Line Tools
   - Rust stable toolchain, Node 20+, npm, and make
   - UI dependencies installed with `npm --prefix apps/desktop/ui ci`
   - tauri-cli (`cargo tauri`) for `make package-bundle`
   - `gh` CLI authenticated to the target repo
2. Release validation commands available:
   - `make release-final`
   - `make package-bundle`
3. GitHub repository configured with release workflows:
   - `.github/workflows/release.yml`
   - `.github/workflows/notarize.yml`

## Required GitHub Secrets (Notarization)

Set these repository secrets before using notarization automation:

1. `APPLE_ID`
2. `APPLE_TEAM_ID`
3. `APPLE_APP_SPECIFIC_PASSWORD`
4. `MACOS_CERT_BASE64` (base64-encoded `.p12` Developer ID Application cert)
5. `MACOS_CERT_PASSWORD`
6. `MACOS_SIGNING_IDENTITY` (for example: `Developer ID Application: Team Name (TEAMID)`)

## Standard Release Flow

1. Sync and verify release branch:
   - `make release-final`
2. Merge to `main` with explicit merge commit (`--no-ff`).
3. Push `main`:
   - `git push origin main`
4. Create and push release tag:
   - `git tag -a vX.Y.Z -m "Release vX.Y.Z"`
   - `git push origin vX.Y.Z`
5. Create GitHub release:
   - `gh release create vX.Y.Z --repo saagpatel/OPscinema --title "vX.Y.Z" --notes "<release notes>"`

## Notarization Automation

`.github/workflows/notarize.yml` supports:

1. Automatic run on GitHub Release publication (`release.published`).
2. Manual run via `workflow_dispatch` for an existing tag.

Workflow behavior:

1. Validates required notarization secrets.
2. Optionally runs `make release-final`.
3. Runs `make package-bundle` to create `.app` and `.dmg`.
4. Imports signing cert into temporary keychain and signs app bundle.
5. Submits `.dmg` to Apple notarization and staples tickets.
6. Uploads notarized `.zip` and `.dmg` to workflow artifacts and the GitHub release.

## Post-Release Checks

1. Confirm release is published and assets are attached:
   - `gh release view vX.Y.Z --repo saagpatel/OPscinema`
2. Confirm security baseline:
   - `gh api "/repos/saagpatel/OPscinema/dependabot/alerts?state=open"`
3. Confirm local and remote tags align:
   - `git ls-remote --tags origin | rg "refs/tags/vX.Y.Z$"`

## Rollback

1. Keep current DB/assets read-only for verification.
2. Revert to previous release tag and redeploy.
3. Re-run:
   - `make verify`
   - `make bundle-verify-smoke`
   - `cargo test -p opscinema_desktop_backend phase11_fixture_ -- --nocapture`
