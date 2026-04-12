#!/usr/bin/env bash
set -euo pipefail

# codex-os-managed
max_bytes="${ASSET_MAX_BYTES:-350000}"
dist_root="apps/desktop/ui/dist"
dist_assets="$dist_root/assets"

if [[ ! -d "$dist_root" ]]; then
  echo "No built UI dist found at $dist_root; run the UI build before asset checks." >&2
  exit 1
fi

fail=0
checked=0
while IFS= read -r file; do
  checked=1
  size=$(wc -c < "$file")
  if (( size > max_bytes )); then
    echo "Asset too large (>${max_bytes} bytes): $file"
    fail=1
  fi
done < <(
  {
    if [[ -d "$dist_assets" ]]; then
      find "$dist_assets" -type f ! -name "*.map"
    fi
    find "$dist_root" -maxdepth 1 -type f -name "*.html"
  } | sort
)

if [[ "$checked" -eq 0 ]]; then
  echo "No shipped UI asset files found under $dist_root; skipping asset size enforcement."
fi

exit $fail
