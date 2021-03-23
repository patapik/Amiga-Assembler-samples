;Boot loader from the floppy, shortest version by Patapik 2021

start:
	dc.b "DOS",0
	dc.l 0
	dc.l $370

	clr.l $dff180  ;Color00 
	move.l $4.w,a6
	move.l #$30000,$28(a1) ;buffer
	move.l #1024,$2c(a1) ;offset
	move.l #100*512,$24(a1)  ;length 
	move.w #2,$1c(a1)  ;read 
	jsr -$1c8(a6)  ;DoIO -456(exec)
	rts	
end:


