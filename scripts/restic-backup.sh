#!/usr/bin/env bash
#########################
# restic-backup.sh
# Backup $HOME to a restic repo (local or B2) using exclude.txt + forget/prune.
#
# Requires: RESTIC_REPOSITORY and RESTIC_PASSWORD (or RESTIC_PASSWORD_FILE)
# Optional B2: B2_ACCOUNT_ID, B2_ACCOUNT_KEY
#
# Usage:
#   source ~/.config/restic/restic.env   # or export vars yourself
#   ./scripts/restic-backup.sh
#########################

set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
EXCLUDE="${RESTIC_EXCLUDE_FILE:-$HOME/.config/restic/exclude.txt}"

if [[ -z "${RESTIC_REPOSITORY:-}" ]]; then
    echo "error: RESTIC_REPOSITORY is not set" >&2
    echo "  source ~/.config/restic/restic.env first" >&2
    exit 1
fi

if [[ -z "${RESTIC_PASSWORD:-}" && -z "${RESTIC_PASSWORD_FILE:-}" ]]; then
    echo "error: set RESTIC_PASSWORD or RESTIC_PASSWORD_FILE" >&2
    exit 1
fi

if [[ ! -f "$EXCLUDE" ]]; then
    echo "error: exclude file not found: $EXCLUDE" >&2
    exit 1
fi

KEEP_DAILY="${RESTIC_KEEP_DAILY:-7}"
KEEP_WEEKLY="${RESTIC_KEEP_WEEKLY:-4}"
KEEP_MONTHLY="${RESTIC_KEEP_MONTHLY:-6}"

echo "==> restic backup $HOME -> $RESTIC_REPOSITORY"
restic backup "$HOME" \
    --exclude-file "$EXCLUDE" \
    --exclude-caches \
    --one-file-system

echo "==> restic forget + prune (daily=$KEEP_DAILY weekly=$KEEP_WEEKLY monthly=$KEEP_MONTHLY)"
restic forget \
    --keep-daily "$KEEP_DAILY" \
    --keep-weekly "$KEEP_WEEKLY" \
    --keep-monthly "$KEEP_MONTHLY" \
    --prune

echo "==> restic check"
restic check --read-data-subset=5%

echo "Done."
