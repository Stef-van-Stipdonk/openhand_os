#include <stdint.h>
#include <stdio.h>

#include "gdt.h"


#define GDT_ENTRY_COUNT 5
#define GDT_MAX_SEGMENTS 65535

extern void flush_gdt(uintptr_t);

struct gdt_entry_t{
	uint16_t limit;
	uint16_t base_low;
	uint8_t base_middle;
	uint8_t access;
	uint8_t flags;
	uint8_t base_high;
}__attribute__((packed));

struct gdt_ptr_t {
	uint16_t limit;
	unsigned int base;
}__attribute__((packed));

struct gdt_entry_t gdt_entries[GDT_ENTRY_COUNT];
struct gdt_ptr_t gdt_ptr;

void init_gdt() {
	gdt_ptr.limit = (sizeof(struct gdt_entry_t) * GDT_ENTRY_COUNT) - 1;
	gdt_ptr.base = (unsigned int)&gdt_entries;

	set_gdt_gate(0, 0, 0, 0, 0); // Null segment
	// TODO: Set macros instead of the current hardcoded values for all the flags
	set_gdt_gate(1, 0, 0xFFFFFFFF, 0b10011010, 0b11001111); // Kernel code segment
	// TODO: Set macros instead of the current hardcoded values for all the flags
	set_gdt_gate(2, 0, 0xFFFFFFFF, 0b10010010, 0b11001111); // Kernel data segment
	// TODO: Set macros instead of the current hardcoded values for all the flags
	set_gdt_gate(3, 0, 0xFFFFFFFF, 0b11111010, 0b11001111); // User code segment
	// TODO: Set macros instead of the current hardcoded values for all the flags
	set_gdt_gate(4, 0, 0xFFFFFFFF, 0b11111010, 0b11001111); // User data segment
	
	flush_gdt((uintptr_t)&gdt_ptr);

	printf("[ Done ] Initialize Global Descriptor Table\n");
}

void set_gdt_gate(uint32_t num_p, uint32_t base_p, uint32_t limit_p, uint8_t access_p, uint8_t granularity_p) {
	if (num_p > GDT_ENTRY_COUNT - 1) {
		printf("[ ERROR ] Tried accessing outside the bounds of GDT table");
		return;
	}

	gdt_entries[num_p].base_low = (base_p & 0xFFFF);
	gdt_entries[num_p].base_middle = (base_p >> 16) & 0xFF;
	gdt_entries[num_p].base_high = (base_p >> 24) & 0xFF;

	gdt_entries[num_p].limit = (limit_p & 0xFFFF);
	gdt_entries[num_p].flags = (limit_p >> 16) & 0x0F;
	gdt_entries[num_p].flags |= (granularity_p & 0xF0);

	gdt_entries[num_p].access = access_p;
}
