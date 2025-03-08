#!/usr/bin/env bash
set -e
CODE_PATH="$1"
. $IDF_PATH/export.sh
cd "${CODE_PATH}"

echo >> main/tunables.h
echo '#define TESTS_REBOOT_AFTERWARDS' >> main/tunables.h
echo '#define TESTS_NO_HANG_ON_FAIL' >> main/tunables.h
echo '#define RUN_TESTS' >> main/tunables.h

idf.py build | tee /github/workspace/run.log
cd build 
esptool.py --chip esp32 merge_bin --fill-flash-size 4MB -o flash_image.bin @flash_args
timeout 5m /opt/qemu/bin/qemu-system-xtensa -machine esp32 -nographic -no-reboot -watchdog-action shutdown -drive file=flash_image.bin,if=mtd,format=raw -m 4 -serial mon:stdio | tee -a /github/workspace/run.log
