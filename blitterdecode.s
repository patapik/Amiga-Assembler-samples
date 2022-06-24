;ญMFM-decode (using blitter)

wblit:	macro
	btst	#14,2(a6)
	dc.w	$66f8
	endm
color:	macro
	move.w	#\1,$180(a6)
	endm

;ญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญ
		jmp	Start
		org	$45000
		load	$45000
S:
Start:
decode_track:
	movem.l	d0-d7/a0-a5,-(a7)
	lea	$dff000,a6
	lea	s(pc),a5
	lea	trackbuff(pc),a0
	move.l	bufferpt(pc),a1
	move.l	#$55555555,d6
	move.w	#11-1,d7	;decode	11 sectors
decode_sectors:
	cmpi.w	#$4489,(a0)+	;search 1st sync
	bne.s	decode_sectors
search_syncs:
	cmpi.w	#$4489,(a0)	;search remaining syncs (if there're any)
	bne.s	syncs_skipped
	addq.w	#2,a0
	bra.s	search_syncs
syncs_skipped:
	move.l	(a0)+,d0	;infoblock (odd)
	move.l	(a0)+,d1	;infoblock (even)
	and.l	d6,d0
	and.l	d6,d1
	add.l	d0,d0
	or.l	d1,d0
	
	swap	d0
	andi.w	#$ff00,d0
	cmpi.w	#$ff00,d0	;compare format-sign
	bne.s	format_error	;error if sign <> -1
	swap	d0
	andi.w	#$ff00,d0	;mask sector-number
	add.w	d0,d0		;calc. offset
	
	move.l	a1,a2		;save a1
	adda.w	d0,a1		;a1=destination
	
;ญ blitter-decode ญ
	lea	48(a0),a0	;skip rest of header

	lea	510(a0),a0	;a0=last word of odd bits (source a)

	lea	512(a0),a3	;a3=last word of even bits (source b)
	lea	510(a1),a1	;a1=destination (dest d)

	wblit				;waitblit
	move.l	#$1dd80002,$40(a6)	;con0/con1
	moveq	#-1,d0
	move.l	d0,$44(a6)		;afwm/alwm
	moveq	#0,d0
	move.l	d0,$64(a6)		;amod/dmod
	move.l	d0,$60(a6)		;cmod/bmod
	move.w	#$5555,$70(a6)		;cdat
	move.l	a0,$50(a6)		;apt
	move.l	a3,$4c(a6)		;bpt
	move.l	a1,$54(a6)		;dpt
	move.w	#[256*64]+1,$58(a6)	;bltsize
	move.l	a3,a0
	move.l	a2,a1
	dbf	d7,decode_sectors
	addi.l	#$1600,bufferpt-s(a5)
	movem.l	(a7)+,d0-d7/a0-a5
	Rts

format_error:
	color	$f00
	Rts
bufferpt:
	dc.l	buffer
trackbuff:
	blk.b	12000,0			;store mfm-data here
buffer:
