### AnyKernel3 Ramdisk Mod Script
## osm0sis @ xda-developers

# redwood - kernel-only install (replaces the Image, leaves the ROM's ramdisk alone), so it
# flashes cleanly on top of any redwood ROM.

properties() { '
kernel.string=Vajra Kernel - redwood - Scarlet v6.0 base + KernelSU-Next + SuSFS - by genie1997
do.devicecheck=1
do.modules=0
do.systemless=0
do.cleanup=1
do.cleanuponabort=0
device.name1=redwood
device.name2=
supported.versions=
supported.patchlevels=
'; } # end properties

block=/dev/block/bootdevice/by-name/boot;
is_slot_device=1;
ramdisk_compression=auto;
patch_vbmeta_flag=auto;

## AnyKernel methods (DO NOT CHANGE)
# import patching functions/variables
. tools/ak3-core.sh;

## AnyKernel install
dump_boot;

write_boot;
## end install
