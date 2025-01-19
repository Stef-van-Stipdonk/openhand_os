#include <stdio.h>

#include <kernel/tty.h>
#include <stdint.h>
#include <stdnoreturn.h>
#include <string.h>

__attribute__((noinline))
void protected(char *arg) {
    union {
        char dummy[5 * 5];
        char a[5][5];
    } u;
    memcpy(u.a[4], arg, (strlen(arg) + 1));
}

void kernel_main(void) {
	terminal_initialize();
	
	protected("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
	printf("Hello, kernel World!\n");
}
