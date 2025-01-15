#!/bin/bash

if grub-file --is-x86-multiboot ./bin/$BUILD_NAME; then
  exit 0
else
  exit 1
fi

