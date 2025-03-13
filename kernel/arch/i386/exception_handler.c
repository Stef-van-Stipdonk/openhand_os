#include <stdint.h>
#include <stdio.h>
__attribute__((__noreturn__))
	      void exception_handler(uint32_t error_code);

void exception_handler(uint32_t error_code) {
	if (error_code) {
		printf("test");
	}

	printf("Interrupt handled\n");
	__asm__ volatile ("cli; hlt"); // hang
	
	__builtin_unreachable();
}
