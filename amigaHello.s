
	section "main", code

main:
	move.l	$4.w, a6    ;execBase

	lea	library(pc), a1
;	moveq	#0, d0
	jsr	-552(a6)    ;OpenLibrary
	move.l	d0,a6 

	move.l	#message,d1
	jsr -948(a6)       ;PutStr

	move.l	a6,a1
	move.l	$4.w,a6
	jsr  -414(a6)      ;CloseLibrary
;	moveq	#0, d0
	rts

library	dc.b	"dos.library", 0
message	dc.b	"Hello World!", 0
end:

