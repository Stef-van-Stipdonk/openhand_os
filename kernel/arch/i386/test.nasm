section .multiboot.data align=4
	; Multiboot Header
    dd 0x1BADB002                   ; MULTIBOOT_HEADER_MAGIC
    dd 0x00000003                   ; MULTIBOOT_HEADER_FLAGS (ALIGN | MEMINFO)
    dd -(0x1BADB002 + 0x00000003)   ; CHECKSUM

section .bss
    align 16
stack_bottom:
    resb 16384  ; 16 KiB stack
stack_top:

section .text
    global _start
    extern cmain   ; C Kernel Entry
    extern printf  ; Print function for debugging

_start:
    ; Jump to the multiboot entry point
    jmp multiboot_entry

multiboot_entry:
    ; Set up stack
    mov esp, stack_top

    ; Reset EFLAGS
    push dword 0
    popf

    ; Push Multiboot parameters
    push ebx  ; Multiboot info structure pointer
    push eax  ; Multiboot magic number

    ; Call kernel main
    call cmain

    ; If we return from kernel_main, halt
    push halt_message
    call printf

.hang:
    hlt
    jmp .hang

section .rodata
halt_message:
    db "Halted.", 0

