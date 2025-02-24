
#ifndef ARCH_I386_GDT_H
#define ARCH_I386_GDT_H

#include <stdint.h>


void init_gdt();
void set_gdt_gate(uint32_t num_p, uint32_t base_p, uint32_t limit_p, uint8_t access_p, uint8_t granularity_p);

#endif // ARCH_I386_GDT_H
