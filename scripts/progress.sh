# progress.sh — shared stepped-progress reporter for provisioning scripts.
# Sourced (not executed) by install.sh and scripts/set-defaults.sh.
#
# Set PROGRESS_TOTAL to the number of steps, then call `progress` once per
# step. Works under both bash and zsh.
#
#   PROGRESS_TOTAL=8
#   progress "Installing Homebrew"     # → [1/8] Installing Homebrew

PROGRESS_STEP=0

progress() {
  PROGRESS_STEP=$((PROGRESS_STEP + 1))
  printf "\n\033[1;34m[%d/%d]\033[0m \033[1m%s\033[0m\n" \
    "$PROGRESS_STEP" "$PROGRESS_TOTAL" "$1"
}
