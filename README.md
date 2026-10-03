# OpsCinema Suite

[![Rust](https://img.shields.io/badge/rust-%23dea584?style=flat-square&logo=rust)](#) [![License](https://img.shields.io/badge/license-MIT-blue?style=flat-square)](#)

> Professional video export pipelines that run entirely on your machine — deterministic, resumable, and auditable.

OpsCinema is a local-first macOS desktop suite for video production workflows with deterministic, resumable export pipelines and comprehensive bundle verification. Built on a modular Rust workspace with Tauri 2 for the desktop shell, it emphasizes correctness — every export produces a verifiable manifest, every bundle can be re-verified post-facto.

## Features

- **Deterministic export pipelines** — same input + same config always produces the same output bundle
- **Resumable exports** — interrupted jobs pick up from the last verified checkpoint
- **Bundle verification** — BLAKE3 content hashing with SDK-level verifier for export integrity
- **IPC command surface** — all operations exposed as typed Tauri IPC commands
- **Soak testing** — configurable soak validation for capture pipeline reliability
- **Modular crate architecture** — types, IPC, export manifest, and verifier SDK in separate crates

## Quick Start

### Prerequisites
- macOS with Xcode Command Line Tools for the desktop runtime and full verification ladder
- Rust stable toolchain (including rustfmt and clippy), Node.js 20+, npm, and make
- `cargo tauri` (tauri-cli) only for actual `.app`/`.dmg` bundle creation

### Installation
```bash
git clone https://github.com/saagpatel/OPscinema
cd OPscinema
npm --prefix apps/desktop/ui ci
```

### Run the desktop app

From the repository root, after installing UI dependencies:

```bash
npm --prefix apps/desktop/ui run build
cargo run --locked -p opscinema_desktop_backend --features runtime --bin opscinema-desktop
```

This launches the real macOS app and creates `state.sqlite` and `assets` in its
Tauri app-data directory. Use a dedicated macOS test account for manual capture/export
checks; screen recording and accessibility permissions are separate from the
synthetic checks below. Do not launch it against personal sessions as a smoke test.

## Verification

Run commands from the repository root with the checked-in `Cargo.lock` and UI
`package-lock.json`. Install UI dependencies with the `npm ci` command above.

For a focused check without starting the desktop app or capturing the screen,
use a clean isolated checkout. The Rust IPC test writes the tracked
`apps/desktop/ui/src/ipc/generated.ts` before reading it back; preserve any pending
edits to that file before running it. The same test also runs under `make test`
and `make verify`.

```bash
# Generated IPC contract/determinism test (rewrites the generated client).
cargo test --locked -p opscinema_ipc generated_client_has_no_any_and_is_deterministic

# TypeScript check, typed IPC guard, and an integration flow with mocked IPC.
npm --prefix apps/desktop/ui run test
```

For broader changes, `make verify` runs Rust format/clippy/workspace tests, the UI
checks, runtime-feature compilation, and the synthetic fixture regressions. The
[macOS CI workflow](.github/workflows/ci.yml) defines the corresponding checks.

```bash
# Prevent an inherited fixture-acceptance flag from rewriting expected hashes.
env -u OPSCINEMA_ACCEPT_FIXTURE_HASH make verify

# Focus on the stub-provider fixture matrix when export/capture logic changes.
env -u OPSCINEMA_ACCEPT_FIXTURE_HASH make fixture-regression
```

The fixture tests use in-memory storage, stub providers, and temporary outputs.
They establish synthetic behavior, not live macOS capture or release readiness.
`make fmt`, `make clippy`, `make test`, `make ui-test`, and `make runtime-check`
select individual parts of the ladder. `npm --prefix apps/desktop/ui run build`
checks the production frontend build; no separate JavaScript lint script exists.

For UI changes, also inspect the affected screens in the desktop app using a
dedicated macOS test account and synthetic sessions. A browser preview from
`npm --prefix apps/desktop/ui run dev -- --host 127.0.0.1` can check layout, but
Tauri IPC is unavailable there unless explicitly mocked; it does not verify the
native capture/export flow. Documentation-only changes do not require a browser.

`make soak` is an optional 30-second stub-provider soak test (`SOAK_SECS=...`
changes its duration). `make package` validates the Tauri build path with
`--no-bundle`, or falls back to runtime compilation if tauri-cli is absent; it
does **not** produce an app bundle. `make package-bundle` requires tauri-cli and
creates `.app`/`.dmg` bundles. Signing, notarization, and publication are separate
operator actions in the [release runbook](docs/RELEASE_PROCESS.md).

## Tech Stack

| Layer | Technology |
|-------|------------|
| Desktop shell | Tauri 2 |
| Backend | Rust 2021 workspace — opscinema_types, opscinema_ipc, opscinema_export_manifest, opscinema_verifier_sdk |
| Hashing | BLAKE3 |
| Persistence | SQLite via rusqlite (bundled) |
| IPC | Tauri typed command surface |

## License

MIT
