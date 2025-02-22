#!/bin/sh
set -e
. ./headers.sh

DEF_ARGS=install

if [ ! $# -eq 0 ]; then
  DEF_ARGS=$@
fi

for PROJECT in $PROJECTS; do
  (cd $PROJECT && DESTDIR="$SYSROOT" $MAKE $DEF_ARGS -j $(nproc))
done
