;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;boot.na
; FILE:		boot.nasm
; PURPOSE:	Setting up multiboot, the stack, paging and canaries.

extern _kernel_start
extern _kernel_end
extern _init
extern kernel_main
extern printf

%define VIRTUAL_OFFSET 0xC0000000
%define PHYSICAL_VGA_ADDR 0x000B8000

;
; MULTIBOOT SETUP
;
MB_MAGIC		equ 0x1BADB002
MB_ALIGN_FLAG     	equ 1 << 0
MB_MEMINFO        	equ 1 << 1
MB_FLAGS          	equ MB_ALIGN_FLAG | MB_MEMINFO
MB_CHECKSUM       	equ -(MB_MAGIC + MB_FLAGS)

; Multiboot Header
section .multiboot align=4
    dd MB_MAGIC 
    dd MB_FLAGS 
    dd MB_CHECKSUM 

;
; STACK SETUP
;
section .bss
	align 16
stack_bottom:
	resb 16384 * 8 ; 16 KiB
stack_top:
	align 16

;
; PAGING SETUP
;
section .bss 
	align 4096
boot_page_directory:
    resb 4096
boot_page_table1:
    resb 4096

;
; KERNEL ENTRY
;
section .boot
global _start
_start:
    mov edi, boot_page_table1 - VIRTUAL_OFFSET ; Physical address of boot_page_table1
    xor esi, esi ; First map address is 0
    mov ecx, 1023 ; Number of page tables

map_loop:
    cmp esi, _kernel_start
    jl map_page_table
    cmp esi, _kernel_end - VIRTUAL_OFFSET
    jge base_setup

    mov edx, esi
    or edx, 0x003
    mov [edi], edx

map_page_table:
    add esi, 4096
    add edi, 4
    loop map_loop

base_setup:
    mov dword [boot_page_table1 - VIRTUAL_OFFSET + 1023 * 4], PHYSICAL_VGA_ADDR | 0x003 ; Map VGA addr
    mov dword [boot_page_directory - VIRTUAL_OFFSET], boot_page_table1 - VIRTUAL_OFFSET + 0x003
    mov dword [boot_page_directory - VIRTUAL_OFFSET + 768 * 4], boot_page_table1 - VIRTUAL_OFFSET + 0x003

    mov ecx, boot_page_directory - VIRTUAL_OFFSET
    mov cr3, ecx

    mov ecx, cr4
    OR ecx, 0x10
    mov cr4, ecx

    mov ecx, cr0
    or ecx, 0x80000000
    mov cr0, ecx

    jmp jump_to_higher_half 

section .text

jump_to_higher_half:
	; Setup stack
	mov esp, stack_top

	; Reset flag register
	push dword 0
	popf

	xor ebp, ebp

	push ebx	; Multiboot info structure pointer
	push eax	; Multiboot magic number

	; Transfer control to kernel_main
	call kernel_main

	; Hang if kernel_main unexpectedly returns
	push halt_message
	call printf
.hang:
	hlt
	jmp .hang

section .rodata
halt_message:
	db "Halted.", 0
