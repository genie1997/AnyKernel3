### AnyKernel3 Ramdisk Mod Script
## osm0sis @ xda-developers

# redwood - kernel-only install (replaces the Image, leaves the ROM's ramdisk alone), so it
# flashes cleanly on top of any redwood ROM.

properties() { '
kernel.string=Vajra Kernel
do.devicecheck=1
do.modules=0
do.systemless=0
do.cleanup=1
do.cleanuponabort=0
device.name1=redwood
device.name2=redwoodin
supported.versions=
supported.patchlevels=
'; } # end properties

BLOCK=/dev/block/bootdevice/by-name/boot;
IS_SLOT_DEVICE=1;
RAMDISK_COMPRESSION=auto;
PATCH_VBMETA_FLAG=auto;
# keep the raw /dev/block/... paths off the screen; they cut the banner in half
NO_BLOCK_DISPLAY=1;

## AnyKernel methods (DO NOT CHANGE)
# import patching functions/variables
. tools/ak3-core.sh;

## AnyKernel install
# read the version out of the Image being flashed, so the banner is never a hardcoded guess
kver="$(grep -a -o 'Linux version [0-9][^ ]*' "$AKHOME/Image" 2>/dev/null | head -1 | cut -d' ' -f3)";
# same for the toolchain, so a compiler bump can never leave a stale line on screen
kcc="$(grep -a -o '[A-Za-z]* clang version [0-9]*' "$AKHOME/Image" 2>/dev/null | head -1 | sed 's/clang version/Clang/')";
[ "$kcc" ] || kcc="Neutron Clang 24";

# the panel is ~60 columns and redraws on every ui_print, so the banner is drawn a line at a
# time. fractional sleep only if this busybox has it, otherwise draw at full speed.
if sleep 0.1 >/dev/null 2>&1; then frame="sleep 0.1"; else frame=":"; fi;
draw() { ui_print "$1"; $frame; }

ui_print " ";
draw ' _    _____       ______  ___';
draw '| |  / /   |     / / __ \/   |';
draw '| | / / /| |__  / / /_/ / /| |';
draw '| |/ / ___ / /_/ / _, _/ ___ |';
draw '|___/_/  |_\____/_/ |_/_/  |_|';
draw '    __ __ __________  _   __________';
draw '   / //_// ____/ __ \/ | / / ____/ /';
draw '  / ,<  / __/ / /_/ /  |/ / __/ / /';
draw ' / /| |/ /___/ _, _/ /|  / /___/ /___';
draw '/_/ |_/_____/_/ |_/_/ |_/_____/_____/';
ui_print " ";
draw "-- Device               : redwood";
draw "-- Kernel Version       : $kver";
draw "-- Root                 : KernelSU-Next + SuSFS";
draw "-- Compiler             : $kcc";
draw "-- Maintainer           : genie1997";
ui_print "_________________________________________________";
ui_print " ";
# write_boot, decomposed, so each step marks work that actually just happened
ui_print " [1/3]  unpacking boot";
dump_boot;
repack_ramdisk;
ui_print " [2/3]  writing kernel";
flash_boot;
flash_generic vendor_dlkm;
flash_generic system_dlkm;
ui_print " [3/3]  writing dtbo";
flash_generic dtbo;
## end install
