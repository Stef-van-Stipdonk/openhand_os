#!/bin/sh
set -e
. ./build.sh

mkdir -p isodir
mkdir -p isodir/boot
mkdir -p isodir/boot/grub

cp sysroot/boot/openhand.kernel isodir/boot/openhand.kernel
cat > isodir/boot/grub/grub.cfg << EOF
menuentry "openhand" {
	multiboot /boot/openhand.kernel
}
EOF
grub-mkrescue -o openhand.iso isodir
