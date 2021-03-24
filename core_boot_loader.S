;Floppy boot loader, shortest version by Patapik 2021

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

;This is the BOOT loader not Loader ,A1 is already auto initialized, trackdisk.device read boot sector, system start to execute program from start + $c 
;USAGE: ASM-ONE

;ws
;RAM PTR> start
;DISK PTR> 0
;LENGTH> 2
;CC

;right side are params after >
;WS this is internal ASM-One command WriteSector.
;CC this is internal ASM-One command calculate boot sector checksum. 
