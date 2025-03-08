#!/usr/bin/env bash
set -e
CODE_PATH="$1"
. $IDF_PATH/export.sh
cd "${CODE_PATH}"
idf.py build
cd build 
esptool.py --chip esp32 merge_bin --fill-flash-size 4MB -o flash_image.bin @flash_args
timeout 5m /opt/qemu/bin/qemu-system-xtensa -machine esp32 -nographic -no-reboot -watchdog-action shutdown -drive file=flash_image.bin,if=mtd,format=raw -m 4 -serial file:output.log  || echo "error"
