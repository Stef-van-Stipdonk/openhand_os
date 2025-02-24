#!/bin/sh

objdump -t ./isodir/boot/openhand.kernel | grep "boot_page_directory" | awk '{print $1}'

#!/bin/bash

# Step 1: Extract the virtual and physical addresses of boot_page_directory
VIRTUAL_ADDR=$(objdump -t ./isodir/boot/openhand.kernel | grep "boot_page_directory" | awk '{print $1}')
PHYSICAL_ADDR=$(printf "0x%08x" $((0x${VIRTUAL_ADDR} - 0xC0000000)))

echo "Virtual Address of boot_page_directory: $VIRTUAL_ADDR"
echo "Physical Address of boot_page_directory: $PHYSICAL_ADDR"

# Step 2: Start QEMU in the background
qemu-system-i386 -cdrom ./openhand.iso -s -S -daemonize

QEMU_PID=$!

# Give QEMU a moment to start
sleep 2

# Step 3: Use GDB to connect to QEMU and inspect cr3
gdb -batch -ex "target remote localhost:1234" \
    -ex "symbol-file ./isodir/boot/openhand.kernel" \
    -ex "b _start" \
    -ex "c" \
    -ex "info registers cr3" \
    -ex "quit" > gdb_output.txt

# Step 4: Extract the value of cr3 from GDB output
CR3_VALUE=$(grep "cr3" gdb_output.txt | awk '{print $2}')

# Step 5: Compare cr3 with the expected physical address
if [ "$CR3_VALUE" = "$PHYSICAL_ADDR" ]; then
    echo "Test Passed: cr3 contains the correct physical address ($PHYSICAL_ADDR)."
else
    echo "Test Failed: cr3 contains $CR3_VALUE, expected $PHYSICAL_ADDR."
fi

# Clean up
kill $QEMU_PID
rm gdb_output.txt
