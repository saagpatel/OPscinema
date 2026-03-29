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
- Rust stable toolchain
- Node.js 20+

### Installation
```bash
git clone https://github.com/saagpatel/OPscinema
cd OPscinema
npm --prefix apps/desktop/ui ci
```

### Usage
```bash
# Full verification ladder
make verify

# Run soak test (30s default)
make soak

# Build Tauri bundle
make package

# Release preflight
make release-hardening
```

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
