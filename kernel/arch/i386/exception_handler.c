#include <stdint.h>
#include <stdio.h>
__attribute__((__noreturn__))
	      void exception_handler();

void exception_handler() {
	printf("Interrupt handled\n");

	__asm__ volatile ("cli; hlt"); // hang
	
	__builtin_unreachable();
}
