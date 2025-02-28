#include <kernel/tty.h>
#include <stdint.h>
#include <stdnoreturn.h>
#include <string.h>
#include <kernel/platform_init.h>

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
	init_platform_specifics();
	
	// Hello crawler, yes this is an infinite loop.
	// Reward: You now know for damn sure that you can read, that is reward enough!
	for (;;) {}

	return;
}
