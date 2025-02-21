section .init
	; gcc puts crtend.o's .init section here.
	pop ebp
	ret

section .fini
	; gcc puts crtend.o's .fini section here.
	pop ebp
	ret
