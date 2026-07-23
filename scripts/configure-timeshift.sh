#!/usr/bin/env bash
#########################
# configure-timeshift.sh
# Permanent Timeshift on / (RSYNC): exclude /home, 2 daily + boot snapshots.
# Requires sudo. Idempotent: overwrites schedule/exclude in timeshift.json.
#########################

set -euo pipefail

CONF=/etc/timeshift/timeshift.json

if [[ "${EUID:-$(id -u)}" -ne 0 ]]; then
    echo "Re-running with sudo..."
    exec sudo bash "$0" "$@"
fi

if [[ ! -f "$CONF" ]]; then
    echo "error: $CONF not found. Run timeshift-gtk once to create it." >&2
    exit 1
fi

# Resolve UUID of root filesystem
ROOT_SRC=$(findmnt -n -o SOURCE /)
ROOT_UUID=$(findmnt -n -o UUID /)
if [[ -z "$ROOT_UUID" ]]; then
    echo "error: could not get UUID of /" >&2
    exit 1
fi

echo "==> Root: $ROOT_SRC (UUID=$ROOT_UUID)"
echo "==> Writing Timeshift schedule: 2 daily + boot; exclude /home and /root"

python3 - <<PY
import json
from pathlib import Path

conf_path = Path("$CONF")
data = json.loads(conf_path.read_text())

data["backup_device_uuid"] = "$ROOT_UUID"
data["btrfs_mode"] = "false"
data["do_first_run"] = "false"
data["include_btrfs_home_for_backup"] = "false"
data["include_btrfs_home_for_restore"] = "false"

# Strict retention (Fase 3)
data["schedule_monthly"] = "false"
data["schedule_weekly"] = "false"
data["schedule_daily"] = "true"
data["schedule_hourly"] = "false"
data["schedule_boot"] = "true"
data["count_monthly"] = "0"
data["count_weekly"] = "0"
data["count_daily"] = "2"
data["count_hourly"] = "0"
data["count_boot"] = "2"

# Exclude home (Restic owns /home). Keep system only.
data["exclude"] = [
    "/home/**",
    "/root/**",
    "/media/**",
    "/mnt/**",
    "/tmp/**",
    "/var/tmp/**",
    "/var/cache/**",
    "/var/log/**",
]

conf_path.write_text(json.dumps(data, indent=2) + "\n")
print("Wrote", conf_path)
PY

echo "==> Creating baseline snapshot (may take several minutes)..."
timeshift --create --comments "fase3-baseline-no-home" --scripted

echo "==> Current snapshots:"
timeshift --list

echo "Done. Verify in timeshift-gtk: Location = /, Home excluded, Daily=2, Boot=on."
