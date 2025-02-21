#!/bin/sh

gdb \
  isodir/boot/openhand.kernel \
  -ex 'target remote localhost:1234' \
  -tui
