#ifndef ARCH_I386_IDT_H
#define ARCH_I386_IDT_H

#include <stdint.h>

#define IDT_MAX_SEGMENTS 256
#define IDT_CPU_EXCEPTION_COUNT 32

void init_idt();
void idt_set_descriptor(uint8_t vector, void* isr, uint8_t flags);

#endif // ARCH_I386_IDT_H
