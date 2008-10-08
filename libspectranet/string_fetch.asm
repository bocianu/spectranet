; caller linkage for string_fetch
; unsigned int string_fetch(char *buf, int bufsz);
XLIB string_fetch
LIB libspectranet
XREF ASMDISP_STRING_FETCH_CALLEE
	
.string_fetch
	pop de		; return address
	pop bc		; bufsz
	pop hl		; buf
	push hl
	push bc
	push de
	jp string_fetch_callee + ASMDISP_STRING_FETCH_CALLEE

