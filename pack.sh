#!/usr/bin/env bash
# Pack a built Vajra kernel Image into a flashable AnyKernel3 zip.
#   ./pack.sh <path/to/Image> [version]
# Produces Vajra-<version>-ksu-redwood-<HHMM>.zip in the parent directory.
set -euo pipefail
IMG="${1:?usage: ./pack.sh <path/to/Image> [version]}"
VER="${2:-1.0}"
[ -f "$IMG" ] || { echo "no such Image: $IMG" >&2; exit 1; }
cp -f "$IMG" Image
OUT="Vajra-${VER}-ksu-redwood-$(date +%H%M).zip"
rm -f "../$OUT"
zip -r9 "../$OUT" . -x '.git/*' 'pack.sh' 'README.md' 'Image' >/dev/null
zip -g9 "../$OUT" Image >/dev/null
echo "packed ../$OUT"
