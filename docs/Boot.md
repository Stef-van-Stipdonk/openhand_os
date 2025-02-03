Functionalty handled by the boot.S file is as follows:\
 - Setting up the multiboot header as needed by the multiboot standard to be able to use grub
 - Setup a default canary `0xDEADBEEF`, this to check for stack smashing
 - Setup `16 KiB` stack for initial thread
 - Setup page directory and the first page table
 - Enable paging
 - Set the kernel to physical address `0x00010000`
 - Set kernel virtual address `0xC0000000`
 - Handoff to kernel_main