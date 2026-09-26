#!/usr/bin/env bash
# pack a built Vajra kernel into an AnyKernel3 zip
#   ./pack.sh <path/to/Image> [version]
set -euo pipefail
IMG="${1:?usage: ./pack.sh <path/to/Image> [version]}"
VER="${2:-1.0}"
[ -f "$IMG" ] || { echo "no such Image: $IMG" >&2; exit 1; }

# dtbo and dtb sit next to the Image in the dts output
BOOT="$(cd "$(dirname "$IMG")" && pwd)"
DTBO="$BOOT/dts/vendor/qcom/dtbo.img"
DTB="$BOOT/dts/vendor/qcom/yupik.dtb"
[ -f "$DTBO" ] || { echo "no dtbo.img next to the Image: $DTBO" >&2; exit 1; }
[ -f "$DTB" ]  || { echo "no yupik.dtb next to the Image: $DTB" >&2; exit 1; }

# stop if the dtb or dtbo drifts from the shipping bytes
WANT_DTBO=4b573c5d23afbae0f6d5ae7d8603d256c65c13078bc998e9de2158830661e5d8
WANT_DTB=ee93220116d7f59664edf41f43dfae69d036f26faa21e55f9e5ba3c1187f6cef
# grep -m1 with || true so pipefail does not trip when grep exits early
BANNER="$(strings "$IMG" | grep -m1 'Linux version 5.4' || true)"
HOMELEAK="$(strings "$IMG" | grep -m1 '/home/' || true)"
case "$BANNER" in *Vajra*) : ;; *) echo "not a Vajra Image ($BANNER)" >&2; exit 1;; esac
[ -z "$HOMELEAK" ] || { echo "build path leaked into the Image: $HOMELEAK" >&2; exit 1; }
GOT_DTBO="$(sha256sum "$DTBO" | cut -d' ' -f1)"
GOT_DTB="$(sha256sum "$DTB" | cut -d' ' -f1)"
[ "$GOT_DTBO" = "$WANT_DTBO" ] || { echo "dtbo.img changed: $GOT_DTBO" >&2; exit 1; }
[ "$GOT_DTB"  = "$WANT_DTB"  ] || { echo "yupik.dtb changed: $GOT_DTB" >&2; exit 1; }

cp -f "$IMG"  Image
cp -f "$DTBO" dtbo.img
cp -f "$DTB"  dtb

OUT="Vajra-${VER}.zip"
rm -f "../$OUT"
zip -r9 "../$OUT" . -x '.git/*' 'pack.sh' 'README.md' 'Image' 'dtbo.img' 'dtb' >/dev/null
zip -g9 "../$OUT" Image dtbo.img dtb >/dev/null
echo "packed ../$OUT"
