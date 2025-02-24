extern _kernel_start
extern _kernel_end
extern _init
extern kernel_main
extern printf

; Multiboot constants
AFLAG 		equ 1 << 0
MEMINFO		equ 1 << 1
FLAGS		equ AFLAG | MEMINFO
MAGIC		equ 0x1BADB002
CHECKSUM	equ -(MAGIC + FLAGS)

; Paging constants
PAGE_PRESENT	equ 0x001 ; Page is present in memory
PAGE_WRITEABLE	equ 0x002 ; Page is writable
PAGE_FLAGS	equ PAGE_PRESENT | PAGE_WRITEABLE
CR0_PAGING	equ 0x80000000 ; CR0 bit to enable paging
CR0_WRITE_PROT	equ 0x00010000 ; CR0 bit for write protection
CR0_FLAGS	equ CR0_PAGING | CR0_WRITE_PROT

; Stack constants
STACK_SIZE	equ 16384 ; 16 KiB

; Multiboot header
section .multiboot_header align=4
    dd MAGIC
    dd FLAGS
    dd CHECKSUM

; Data section
section .data align=4
	fatal_fault_message: db 'Please reboot, a fatal fault occured.', 0


; Stack canary
section .rodata
    global __stack_chk_guard
__stack_chk_guard:
    dd 0xDEADBEEF

; Bootstrap stack
section .bootstrap_stack align=16
stack_bottom:
    resb STACK_SIZE
stack_top:

; Page tables
section .bss align=4096
boot_page_directory:
    resb 4096
boot_page_table1:
    resb 4096

; Kernel entry point
section .multiboot.text
    global _start
    _start:
	; Map page tables
        mov edi, boot_page_table1 - 0xC0000000
        xor esi, esi
        mov ecx, 1023

page_table_map_loop:
	mov edx, esi
	or edx, PAGE_FLAGS
	mov [edi], edx

	add esi, 4096
	add edi, 4

	cmp esi, _kernel_end - 0xC0000000
	jl page_table_map_loop

	; Set up base page directory entries
	mov dword [boot_page_table1 - 0xC0000000 + 1023 * 4], 0x000B8000 | PAGE_FLAGS ; Map last entry to VGA text buffer

	mov eax, boot_page_table1 - 0xC0000000
	or eax, PAGE_FLAGS
	mov dword [boot_page_directory - 0xC0000000 + 0], eax
	mov dword [boot_page_directory - 0xC0000000 + 768 * 4], eax

	; Enable paging
	mov ecx, boot_page_directory - 0xC0000000
	mov cr3, ecx
	mov ecx, cr0
	or ecx, CR0_FLAGS
	mov cr0, ecx
	
	; Transfer control to higher-half kernel
	lea ecx, [transfer_control_to_kernel]
	jmp ecx

section .text
transfer_control_to_kernel:
	; Clear identity mapping
	mov dword [boot_page_directory + 0], 0
	mov ecx, cr3
	mov cr3, ecx

	; Set up stack
	mov esp, stack_top

	; Call global constructors
	call _init

	; Enter kernel main
	call kernel_main
	
	cli
	push fatal_fault_message
	call printf
	add esp, 4

.hang:
	hlt
	jmp .hang
