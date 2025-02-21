
extern _kernel_start
extern _kernel_end
extern _init
extern kernel_main
extern printf

;
; Set multiboot constants
;
AFLAG 		equ 1 << 0
MEMINFO		equ 1 << 1
FLAGS		equ AFLAG | MEMINFO
MAGIC		equ 0x1BADB002
CHECKSUM	equ -(MAGIC + FLAGS)

;
; Declare a header as in the Multiboot Standard
;
section .multiboot.data align=4
    dd MAGIC
    dd FLAGS
    dd CHECKSUM

;
;
;
section .data
	fatal_fault_message: db 'Please reboot, a fatal fault occured.', 0

;
; Canary Setup
;
section .rodata
    global __stack_chk_guard
__stack_chk_guard:
    dd 0xDEADBEEF

;
; Reserve a stack for the initial thread
;
section .bootstrap_stack align=16 type=bss
stack_bottom:
    resb 16384 ; 16 KiB
stack_top:

section .bss align=4096
boot_page_directory:
    resb 4096
boot_page_table1:
    resb 4096
; Add further page tables if kernel grows beyond 3 MiB

;
; The kernel entry point
;
section .multiboot.text
    global _start
    _start:
        mov edi, boot_page_table1 - 0xC0000000 ; Physical address of boot_page_table1
        xor esi, esi ; First map address is 0
        mov ecx, 1023 ; Amount of page tables

map_loop:
        cmp esi, _kernel_start
        jl map_page_table
        cmp esi, _kernel_end - 0xC0000000
        jge base_setup

        mov edx, esi
        or edx, 0x003
        mov [edi], edx

map_page_table:
        add esi, 4096
        add edi, 4

        loop map_loop

base_setup:
        mov dword [boot_page_table1 - 0xC0000000 + 1023 * 4], 0x000B8000 | 0x003
        mov dword [boot_page_directory - 0xC0000000 + 0], boot_page_table1 - 0xC0000000 + 0x003
        mov dword [boot_page_directory - 0xC0000000 + 768 * 4], boot_page_table1 - 0xC0000000 + 0x003

        mov ecx, boot_page_directory - 0xC0000000
        mov cr3, ecx

        ; Enable paging and the write protection bits
        mov ecx, cr0
        or ecx, 0x80010000
        mov cr0, ecx

        lea ecx, [transfer_control_to_kernel]
        jmp ecx

section .text

transfer_control_to_kernel:
        mov dword [boot_page_directory + 0], 0
        mov ecx, cr3
        mov cr3, ecx

        mov esp, stack_top

        ; Call the global constructors
        call _init

        ; Transfer control to the main kernel
        call kernel_main

        ; Hang if kernel_main unexpectedly returns
        cli
	push fatal_fault_message
	call printf
	add esp, 4
.hang:
        hlt
        jmp .hang
