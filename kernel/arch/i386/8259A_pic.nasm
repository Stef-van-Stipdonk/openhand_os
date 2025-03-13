global init_pic

init_pic:
	mov 0x11, al	; ICW1
	out al, 0x20	; Setup master PIC

	out al, 0xA0	; Setup slave PIC

	mov 0x20, al	; ICW2
	out al, 0x21	; Setup master PIC

	mov 0x28, al	; ICW3
	out al, 0xA1	; Setup slave PIC

	mov 0x4, al	; ICW3
	out al, 0x21	; Setup master PIC

	mov 0x2, al	; ICW3
	out al, 0xA1	; Setup slave PIC

	mov 1, al	; enables 80x86 mode
	out al, 0x21
	out al, 0xA1


