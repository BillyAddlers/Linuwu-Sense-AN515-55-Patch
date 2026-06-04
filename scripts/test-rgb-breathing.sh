#!/usr/bin/env bash
set -euo pipefail

BASE="/sys/module/linuwu_sense/drivers/platform:acer-wmi/acer-wmi"
RGB_PATH="$BASE/four_zoned_kb/four_zone_mode"

if [[ ! -w "$RGB_PATH" ]]; then
  echo "RGB path tidak bisa ditulis: $RGB_PATH" >&2
  echo "Jalankan dengan sudo dan pastikan linuwu_sense aktif." >&2
  exit 1
fi

# mode,speed,brightness,direction,red,green,blue
printf '%s\n' '1,4,100,0,255,0,255' > "$RGB_PATH"
cat "$RGB_PATH"

