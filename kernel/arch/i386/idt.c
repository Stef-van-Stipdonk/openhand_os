#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#include "idt.h"


struct idt_entry_t {
	uint16_t isr_low;
	uint16_t kernel_cs;
	uint8_t reserved;
	uint8_t attributes;
	uint16_t isr_high;
}__attribute__((packed));

struct idtr_t {
	uint16_t limit;
	uint32_t base;
} __attribute__((packed));

__attribute__((aligned(0x10)))
static struct idt_entry_t idt[IDT_MAX_SEGMENTS];

static struct idtr_t idtr;

static bool vectors[IDT_MAX_SEGMENTS];

extern void* isr_stub_table[];

void init_idt() {
	idtr.base = (uintptr_t)&idt[0];
	idtr.limit = (uint16_t)sizeof(struct idt_entry_t) * IDT_MAX_SEGMENTS - 1;

	for (uint8_t i = 0; i < IDT_CPU_EXCEPTION_COUNT; i++) {
		idt_set_descriptor(i, isr_stub_table[i], 0x8E);
		vectors[i] = true;
	}

	__asm__ volatile ("lidt %0" : : "m"(idtr));
	__asm__ volatile ("sti");

	printf("[ Done ] Initialize Interrupt Descriptor Table\n");
}

void idt_set_descriptor(uint8_t vector, void* isr, uint8_t flags) {
    struct idt_entry_t* descriptor = &idt[vector];

    descriptor->isr_low        = (uint32_t)isr & 0xFFFF;
    descriptor->kernel_cs      = 0x08;
    descriptor->attributes     = flags;
    descriptor->isr_high       = (uint32_t)isr >> 16;
    descriptor->reserved       = 0;
}
