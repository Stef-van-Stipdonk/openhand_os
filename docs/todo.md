# Todo items

 - Actually use multiboot info in `kernel_main", parse memory map, modules etc
 - Zero out .bss memory, this is not always done by the bootloader
 - Setup GDT (Global Descriptor Table)
 - Setup IDT (Interrupt Descriptor Table) with handlers for CPU exceptions (page feaults, general protection faults etc)
 - Setup ISR (Interrupt Service Routines), setup a basic stub that prints an error message or halts in the case of an unhandled triple-fault
 - Recursive paging put the `page directory` in its own `page directory entry`, commonly this is #1023 (makes dynamic page allocation easier due to standard virtual address)
 - Dynamic heap, after parsing the multiboot memory map, setup a basic page-frame allocator or buddy allocator so that more pages can be mapped on demand commonly `kmalloc`.
 - Device drivers, keyboard, timer (PIT / HPET), serial port for debugging etc
 - File systems, start with RAM-based and/or a simple disk driver
 - Scheduler/multitasking, switch tasks, manage threads, signals, etc
 - User-mode idk how to elaborate on this, to new to know how :laugh:
