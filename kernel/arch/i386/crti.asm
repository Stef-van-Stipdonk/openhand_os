SECTION .init
GLOBAL _init

_init:
	PUSH EBP
	MOV EBP, ESP 
	; gcc will nicely put the contents of crtbegin.o's .init section here.

SECTION .fini
GLOBAL _fini
_fini:
	PUSH EBP
	MOV EBP, ESP
	; gcc will nicely put the contents of crtbegin.o's .fini section here.
