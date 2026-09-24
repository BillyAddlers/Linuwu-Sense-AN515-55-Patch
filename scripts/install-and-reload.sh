#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

cd "$ROOT_DIR"

make
make install

systemctl stop linuwu_sense.service 2>/dev/null || true
rmmod linuwu_sense 2>/dev/null || true
modprobe linuwu_sense
systemctl start linuwu_sense.service 2>/dev/null || true

echo "Runtime module:"
cat /sys/module/linuwu_sense/srcversion

echo "Installed module:"
# Locate the module either via DKMS (updates/dkms) or a direct make install.
INSTALLED_KO=""
for candidate in \
  "/lib/modules/$(uname -r)/updates/dkms/linuwu_sense.ko" \
  "/lib/modules/$(uname -r)/kernel/drivers/platform/x86/linuwu_sense.ko"; do
  if [ -f "$candidate" ]; then
    INSTALLED_KO="$candidate"
    break
  fi
done
if [ -n "$INSTALLED_KO" ]; then
  echo "Module file: $INSTALLED_KO"
  modinfo "$INSTALLED_KO" | grep '^srcversion'
else
  echo "(module file not found in expected locations)"
fi
if command -v dkms >/dev/null 2>&1; then
  echo "DKMS status:"
  dkms status linuwu_sense 2>/dev/null || true
fi

