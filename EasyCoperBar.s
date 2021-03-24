;The simples copper bar by Patapik 2021

OpenLib		=-408
CloseLib 	=-414

DMASET=	%1000000111000000   ($dff096)
;	 -----a-bcdefghij

;	a: Blitter Nasty
;	b: Bitplane DMA (if this isn't set, sprites disappear!)
;	c: Copper DMA
;	d: Blitter DMA
;	e: Sprite DMA
;	f: Disk DMA
;	g-j: Audio 3-0 DMA 


	move.l	$4.w,a6      
	move.l	#libname,a1
	jsr	OpenLib(a6)
	move.l	d0,GBase
	

	move.w	#%0000001110100000,$dff096
	move.l	#cop1,$dff080                 ;set copperlist
	clr.w	$dff088
	move.w	#%1000001010000000,$dff096

l1:	cmp.b	#$0,$dff006
	bne.s	l1

	add.b #1,Wait       ;vertical position
	add.b #1,Wait2      
	
	btst	#6,$bfe001   ;Mouse button test
	bne.s	l1

	move.l	GBase,a6		;restore old copperlist
	move.l	38(a6),$dff080    		
	clr.w	$dff088			
	move.w	#%1000001111100000,$dff096

	move.l	$4.w,a6
	move.l	GBase,a1
	jsr	CloseLib(a6)
	rts

		
libname:	dc.b	"graphics.library",0
		even
GBase:	dc.l    0

cop1:
		dc.l	$01800000  ; $dff180 set color
Wait:		dc.l	$2c0ffffe  ; $1c the first visable screen line 
		dc.l	$018008A0  ; $dff180 set color
Wait2:		dc.l    $3f0ffffe
		dc.l    $01800000
		dc.l	$fffffffe  ;Copper END
		

