# Codex Workflow Bundle

This directory defines the reusable Codex workflow bundle for OPscinema.

## Contracts

- Secret: `OPENAI_API_KEY`
- PR label gate: `codex-review`
- Action version: `openai/codex-action@v1`
- Sandbox: `read-only`
- Review flow: PR comment only, no patch generation
- Release readiness flow: manual report only, no release mutation

## Layout

- `prompts/`: prompt contracts for each Codex workflow
- `schemas/`: structured output schemas enforced by the action
- `scripts/`: helper utilities for sanitizing untrusted metadata

## Notes

- PR title and body are treated as untrusted input before being appended to the runtime prompt.
- Structured output is required before posting review feedback back to GitHub.
- This bundle is the pilot standard for future repo rollout.

## Rollout To Another Repo

1. Copy `.github/codex/` into the target repo.
2. Copy `codex-pr-review.yml` and `codex-release-readiness.yml` into `.github/workflows/`.
3. Add the `OPENAI_API_KEY` repository secret.
4. Create or reuse a `codex-review` label.
5. Open a PR, apply the `codex-review` label, and confirm the review workflow posts or updates a single Codex comment.
6. Trigger the manual release-readiness workflow once and confirm the JSON artifact and job summary are readable.
