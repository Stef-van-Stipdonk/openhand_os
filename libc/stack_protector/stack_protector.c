#include <stdio.h>
#include <stdint.h>
#include <stack_protector.h>


__attribute__((noreturn)) void __stack_chk_fail(void)
{
    printf("Stack overflow detected! Aborting program.");
    for (;;) {
        // either halt the CPU or spin forever
    }
}

