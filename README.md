# AnyKernel3 — Vajra (redwood)

AnyKernel3 packer for the [Vajra kernel](https://github.com/genie1997/android_kernel_xiaomi_redwood)
(Xiaomi `redwood` — the POCO X5 Pro 5G and Redmi Note 12 Pro Speed).

Kernel-only install: it writes the Image and leaves the ROM's ramdisk alone, so it flashes on top of
any redwood ROM without a wipe. It also writes the device tree — `dtbo`, and the `dtb` inside
`vendor_boot` — with the same bytes a supported redwood ROM already runs.

## Pack a zip

```bash
./pack.sh ../out-vajra/arch/arm64/boot/Image 2.1
# -> ../Vajra-2.1.zip
```

`dtbo.img` and `yupik.dtb` are read from the `dts` output next to the Image, and the pack stops if
either drifts from the shipping bytes.

## Credits

AnyKernel3 by [osm0sis](https://github.com/osm0sis/AnyKernel3).
