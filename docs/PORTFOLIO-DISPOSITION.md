# OPscinema — Portfolio Disposition

**Status:** Release Frozen — substantial Tauri 2 + Rust workspace
product on `origin/main` with a published notarization workflow and
release runbook. Awaiting operator-only Apple credentials. Joins the
signing-frozen cluster (now 8 repos).

> Disposition uses strict `origin/main` verification — critical given
> this repo has a `legacy-origin` remote (the trap that produced wrong
> dispositions for FreeLanceInvoice and PersonalKBDrafter earlier in
> the session).

---

## Verification posture

This repo has both `origin` (`saagpatel/OPscinema`) and `legacy-origin`
(`saagar210/OPscinema`) remotes. The disposition reads `origin/main`
exclusively.

Specifically verified:
- `origin/main` tip: `02a908a` Merge pull request #11 from saagpatel
  (dependabot — confirms `saagpatel` is the active publisher)
- Last substantive feature commits on `origin/main`:
  - `a987a5f feat(release): add notarization workflow and release runbook`
  - `9cb4937 feat(release): harden build metadata and packaging paths`
  - `e00db05 fix(security): tighten allowlist and verifier guardrails`
  - `1f8c501 fix(ci): build UI dist before runtime checks (#3)`
- Source tree on `origin/main` includes Rust workspace (`Cargo.toml`,
  `Cargo.lock`), Tauri shell, and 12+ architecture spec docs
  (`00-readme.md` through `99-one-shot-codex-prompt.md`)
- README on `origin/main` describes OpsCinema Suite product accurately

Operator-side recommendation: a one-time `legacy-origin` audit before
signing, in case orphaned work exists there:
`git log --oneline origin/main..legacy-origin/main | head -20`

---

## Current state in one paragraph

OPscinema (also spelled OpsCinema in the README) is a local-first
macOS desktop suite for video production workflows. Built as a
modular Rust workspace + Tauri 2 shell, it emphasizes correctness:
every export produces a verifiable manifest (BLAKE3 content
hashing), exports are deterministic + resumable from the last
verified checkpoint, and bundles can be re-verified post-facto via a
verifier SDK. Soak testing exists for capture pipeline reliability.
The repo has 12 architecture specs covering data models, IPC
contracts, security/privacy verifiers, testing fixtures, and the
implementation phase order. Recent commits add a notarization
workflow + release runbook, harden build metadata and packaging
paths, tighten allowlist and verifier guardrails.

For full detail (in priority order):
- `00-readme.md` through `09-security-privacy-verifiers.md` (12
  architecture specs)
- `README.md`
- Cargo workspace under `crates/` (modular: types, IPC, export
  manifest, verifier SDK)

---

## Portfolio operating system instructions

| Aspect | Posture |
|---|---|
| Portfolio status | `Release Frozen` |
| Review cadence | Suspend overdue counting |
| Resurface conditions | (a) Apple Developer ID + notarization credentials wired in CI, (b) operator runs a `legacy-origin` audit, or (c) operator opens a new feature packet on a specific architecture spec |
| Co-batch with | Signing cluster: DesktopPEt, ContentEngine, AIGCCore, Relay, FreeLanceInvoice, Nexus, DeepTank, **OPscinema** — **now 8 repos**. |

---

## Why "Release Frozen" instead of other dispositions

- **Active** — wrong. The notarization workflow and release runbook
  exist; only credentials are missing.
- **Cold Storage / Archived** — wrong. Recent fix and feat commits
  show active operational hardening within the last few weeks.
- **Scaffold-stop** — wrong, and worth restating from the DeepTank
  disposition: `codex/chore/bootstrap-codex-os` branch + 58 dirty
  local files looked like scaffold-stop superficially, but
  `origin/main` is a fully-shipped product. **Always read
  `origin/main`, never pattern-match on branch names or dirty file
  counts.**
- **Release Frozen** — correct.

---

## Unblock trigger (operator)

When ready to ship:

1. Wire Apple Developer ID + notarization credentials per the
   notarization workflow added in commit `a987a5f`.
2. Run the release runbook end-to-end.
3. Verify the signed/notarized DMG opens cleanly with no
   Gatekeeper warnings.
4. Cut v0.1.0 release.

Estimated operator time once credentials are in hand: ~4 hours
including notarization round-trip.

---

## Reactivation procedure (for the next code session)

1. **Verify local clone tracking.** `git branch -vv` — if `main`
   tracks `legacy-origin/main`, retarget to `origin/main`. This is
   the trap that produced FreeLanceInvoice and PersonalKBDrafter
   corrections earlier.
2. Delete stale `codex/*` branches (most are merged-history).
3. Re-run the canonical verify command to confirm the toolchain
   works after the freeze.
4. Optional but recommended: one-time `legacy-origin` audit to
   confirm no orphaned work exists.

---

## Last known reference

| Field | Value |
|---|---|
| `origin/main` tip | `02a908a` Merge PR #11 (dependabot) |
| Notarization workflow | `a987a5f feat(release): add notarization workflow and release runbook` |
| Security hardening | `e00db05 fix(security): tighten allowlist and verifier guardrails` |
| Build/packaging | `9cb4937 feat(release): harden build metadata and packaging paths` |
| Architecture specs | 12 files (`00-` through `09-` plus `98-vp-stamp.md` and `99-one-shot-codex-prompt.md`) on `origin/main` |
| Build verification status | green (per `1f8c501 fix(ci): build UI dist before runtime checks`) |
| Blocker | Apple signing + notarization (operator-only) |
| Migration note | `legacy-origin` points at frozen `saagar210/OPscinema`; do not push there |
