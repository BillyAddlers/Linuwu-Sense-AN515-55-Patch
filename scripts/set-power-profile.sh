#!/usr/bin/env bash
set -euo pipefail

PROFILE="${1:-}"
PROFILE_PATH="/sys/firmware/acpi/platform_profile"
CHOICES_PATH="/sys/firmware/acpi/platform_profile_choices"

if [[ -z "$PROFILE" ]]; then
  echo "Usage: sudo $0 <quiet|balanced|balanced-performance>" >&2
  exit 2
fi

if [[ ! -r "$CHOICES_PATH" || ! -w "$PROFILE_PATH" ]]; then
  echo "Platform profile sysfs tidak tersedia/tertulis." >&2
  exit 1
fi

if ! grep -qw -- "$PROFILE" "$CHOICES_PATH"; then
  echo "Profile tidak tersedia: $PROFILE" >&2
  echo "Pilihan: $(cat "$CHOICES_PATH")" >&2
  exit 2
fi

printf '%s\n' "$PROFILE" > "$PROFILE_PATH"
cat "$PROFILE_PATH"

