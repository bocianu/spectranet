;The MIT License
;
;Copyright (c) 2008 Dylan Smith
;
;Permission is hereby granted, free of charge, to any person obtaining a copy
;of this software and associated documentation files (the "Software"), to deal
;in the Software without restriction, including without limitation the rights
;to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
;copies of the Software, and to permit persons to whom the Software is
;furnished to do so, subject to the following conditions:
;
;The above copyright notice and this permission notice shall be included in
;all copies or substantial portions of the Software.
;
;THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
;IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
;FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
;AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
;LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
;OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
;THE SOFTWARE.

; Simple menu system routines.

;--------------------------------------------------------------------------
; F_genmenu
; Generates a menu screen.
; Parameters: HL = pointer to menu structure, that should be a null terminated
; list of pointers to strings that define the choices.
F_genmenu
	ld b, 'A'	; first option is 'A'
.loop
	ld e, (hl)	; get pointer into DE
	inc hl
	ld d, (hl)
	inc hl
	inc hl		; go past the call address
	inc hl
	ld a, d
	or e		; check to see whether we've just got the last one
	ret z
	ld a, '['
	call PUTCHAR42	; print [
	ld a, b
	call PUTCHAR42	; print the option
	ld a, ']'
	call PUTCHAR42	; print ]
	ld a, ' '
	call PUTCHAR42	; and one space separator
	ex de, hl		; get string pointer into hl
	call PRINT42		; print the menu option
	ex de, hl		; move the menu pointer back
	ld a, '\n'		; print a CR
	call PUTCHAR42
	inc b			; update option character
	jr .loop

;-------------------------------------------------------------------------
; F_getmenuopt:
; Wait for the user to press a key, then call the appropriate routine.
F_getmenuopt
	push hl
	call GETKEY		; wait for key to be pressed
	pop hl
	sub 'a'			; ASCII a = 0
	jr c, F_getmenuopt	; key pressed was < 'a'
.loop
	push af
	ld a, (hl)
	inc hl
	or (hl)			; Null terminator?
	jr z, .outofrange
	inc hl			; hl points at call entry
	pop af
	and a			; A=0?
	jr z, .callopt
	dec a
	inc hl			; advance past string pointer
	inc hl
	jr .loop
.outofrange
	pop af			; fix stack
	jr F_getmenuopt		; try again
.callopt
	ld e, (hl)		; get call address into DE
	inc hl
	ld d, (hl)
	ex de, hl
	jp (hl)			; jump to the routine

