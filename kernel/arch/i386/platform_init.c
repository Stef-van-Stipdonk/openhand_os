#include <kernel/platform_init.h>
#include "gdt.h"
#include "idt.h"

void init_platform_specifics() {
	init_gdt();
	init_idt();
}
