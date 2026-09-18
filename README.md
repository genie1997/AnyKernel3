# AnyKernel3 — Vajra (redwood)

AnyKernel3 packer for the [Vajra kernel](https://github.com/genie1997/android_kernel_xiaomi_redwood)
(Xiaomi redwood — Redmi Note 13 Pro 5G / POCO X5 Pro 5G).

Kernel-only install: it swaps the boot Image and leaves the ROM's ramdisk alone, so it flashes on
top of any redwood ROM without a wipe.

## Pack a zip

```bash
./pack.sh out/arch/arm64/boot/Image 1.0
# -> Vajra-1.0-ksu-redwood-HHMM.zip
```

Or drop your `Image` in the root and `zip -r9 my.zip * -x .git README.md pack.sh`.

## Credits

AnyKernel3 by [osm0sis](https://github.com/osm0sis/AnyKernel3).
