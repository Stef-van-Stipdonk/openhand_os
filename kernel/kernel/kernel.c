#include <stdio.h>
#include <kernel/tty.h>
#include <stdint.h>
#include <stdnoreturn.h>
#include <string.h>
#include <multiboot.h>

__attribute__((noinline))
void protected(char *arg) {
    union {
        char dummy[5 * 5];
        char a[5][5];
    } u;
    memcpy(u.a[4], arg, (strlen(arg) + 1));
}

void kernel_main(unsigned long magic, unsigned long addr) {
	terminal_initialize();
        if (MULTIBOOT_BOOTLOADER_MAGIC != magic) {
            printf("Multiboot signature error, exiting\n");
            return;
        }
        printf("Hello, kernel World!\n");
        printf("Hello, kernel World!\n");
        printf("Hello, kernel World!\n");
}
