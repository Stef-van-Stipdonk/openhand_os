#ifndef _STACK_PROTECTOR_H
#define _STACK_PROTECTOR_H 1

#ifdef __cplusplus
extern "C" {
#endif

#include <stdint.h>

uintptr_t __stack_chk_guard = 0xDEADBEEF;

__attribute__((noreturn)) void __stack_chk_fail(void);

#ifdef __cplusplus
}
#endif

#endif // _STACK_PROTECTOR_H
