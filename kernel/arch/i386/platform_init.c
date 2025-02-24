#include <kernel/platform_init.h>
#include "gdt.h"

void init_platform_specifics() {
	init_gdt();
}
