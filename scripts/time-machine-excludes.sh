#!/usr/bin/env bash
#
# time-machine-excludes.sh
#
# Tell Time Machine to skip directories that are large, easily regenerated,
# or simply not worth backing up (build artefacts, package caches, etc.).
# Run once after Time Machine is configured for the first time.
#
# Usage:
#   ./scripts/time-machine-excludes.sh
#
# Idempotent — `tmutil addexclusion` is a no-op when the path is already
# excluded.
#
# Requires sudo for system-wide exclusions; falls back to per-user only
# if sudo isn't available.

set -u
set -o pipefail

excludes=(
  # Dev caches
  "$HOME/Library/Caches"
  "$HOME/.cache"
  "$HOME/.npm"
  "$HOME/.pnpm-store"
  "$HOME/Library/pnpm"
  "$HOME/.yarn/cache"
  "$HOME/.cargo"
  "$HOME/Library/Containers/com.docker.docker"
  "$HOME/Library/Group Containers/group.com.docker"

  # Language toolchains (rebuildable)
  "$HOME/.asdf"

  # Homebrew (everything's reinstallable)
  "/opt/homebrew/Cellar"
  "/opt/homebrew/Caskroom"

  # Per-project node_modules under ~/code — pattern via globbing, see below
)

# Static excludes
for path in "${excludes[@]}"; do
  if [ -e "$path" ]; then
    if tmutil addexclusion "$path" 2>/dev/null; then
      echo "  ✓ $path"
    else
      echo "  ! $path (try with sudo)"
    fi
  fi
done

# Project-level excludes — anything under ~/code/* matching common build dirs.
# Walk one level deep to find <project>/<excluded>.
for project in "$HOME"/code/*/; do
  [ -d "$project" ] || continue
  for sub in node_modules .next dist build .turbo target out .nuxt .svelte-kit .venv __pycache__; do
    if [ -d "${project}${sub}" ]; then
      tmutil addexclusion "${project}${sub}" 2>/dev/null && echo "  ✓ ${project}${sub}"
    fi
  done
done

echo
echo "Done. Verify with: tmutil isexcluded <path>"
