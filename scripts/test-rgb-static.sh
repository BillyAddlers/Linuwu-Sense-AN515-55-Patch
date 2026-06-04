#!/usr/bin/env bash
set -euo pipefail

BASE="/sys/module/linuwu_sense/drivers/platform:acer-wmi/acer-wmi"
RGB_PATH="$BASE/four_zoned_kb/per_zone_mode"

if [[ ! -w "$RGB_PATH" ]]; then
  echo "RGB path tidak bisa ditulis: $RGB_PATH" >&2
  echo "Jalankan dengan sudo dan pastikan linuwu_sense aktif." >&2
  exit 1
fi

printf '%s\n' 'ff0000,00ff00,0000ff,ffffff,100' > "$RGB_PATH"
cat "$RGB_PATH"

