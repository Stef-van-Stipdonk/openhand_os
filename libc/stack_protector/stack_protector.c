#include <stdlib.h>
#include <stdio.h>
#include <stack_protector.h>

#if UINTPTR_MAX == UINT32_MAX
#define STACK_CHK_GUARD_VALUE 0xa5f3cc8d
#else
#define STACK_CHK_GUARD_VALUE 0xdeadbeefa55a857
#endif

uintptr_t __stack_chk_guard = STACK_CHK_GUARD_VALUE;


__attribute__((noreturn)) void __stack_chk_fail(void)
{
    printf("Stack overflow detected! Aborting program.");
    abort();
}

