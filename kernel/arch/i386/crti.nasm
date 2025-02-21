SECTION .init
GLOBAL _init

_init:
	PUSH EBP
	MOV EBP, ESP 
	; gcc puts crtbegin.o's .init section here.

SECTION .fini
GLOBAL _fini
_fini:
	PUSH EBP
	MOV EBP, ESP
	; gcc puts crtbegin.o's .fini section here.
