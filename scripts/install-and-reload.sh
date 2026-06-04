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
modinfo "/lib/modules/$(uname -r)/kernel/drivers/platform/x86/linuwu_sense.ko" | grep '^srcversion'

echo "Platform profiles:"
cat /sys/firmware/acpi/platform_profile_choices
cat /sys/firmware/acpi/platform_profile

