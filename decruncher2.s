
;---------------  DECRUNCH DATA PACKED WITH POWER PACKER  --------------

;a3-destination address, a0-packed data end, a5-start without header 
k:
	lea	$50000	,a3
	lea	datacrunch+2448	,a0
	lea	datacrunch+4	,a5	
	bsr	decrunch
	rts

Decrunch:
	movem.l	d0-d7/a0-a6,-(sp)
	lea	$dff180,a6		;color
	bsr.s	DecrIt
	movem.l	(sp)+,d0-d7/a0-a6
	rts
DecrIt:
	moveq #3,d6
	moveq #7,d7
	moveq #1,d5
	move.l a3,a2				; remember start of file
	move.l -(a0),d1			; get file length and empty bits
	tst.b d1
	beq.s NoEmptyBits
	bsr.s ReadBit				; this will always get the next long (D5 = 1)
	subq.b #1,d1
	lsr.l d1,d5					; get rid of empty bits
NoEmptyBits:
	lsr.l #8,d1
	add.l d1,a3					; a3 = endfile
LoopCheckCrunch:
	bsr.s ReadBit				; check if crunch or normal
	bcs.s CrunchedBytes
NormalBytes:
	moveq #0,d2
Read2BitsRow:
	moveq #1,d0
	bsr.s ReadD1
	add.w d1,d2
	cmp.w d6,d1
	beq.s Read2BitsRow
ReadNormalByte:
	moveq #7,d0
	bsr.s ReadD1
	move.b d1,-(a3)
	dbf d2,ReadNormalByte
	cmp.l a3,a2
	bcs.s CrunchedBytes
	rts
ReadBit:
	lsr.l #1,d5					; this will also set X if d5 becomes zero
	beq.s GetNextLong
	rts
GetNextLong:
	move.l -(a0),d5
	roxr.l #1,d5				; X-bit set by lsr above
	rts
ReadD1sub:
	subq.w #1,d0
ReadD1:
	moveq #0,d1
ReadBits:
	lsr.l #1,d5					; this will also set X if d5 becomes zero
	beq.s GetNext
RotX:
	roxl.l #1,d1
	dbf d0,ReadBits
	rts
GetNext:
	move.l -(a0),d5
	roxr.l #1,d5				; X-bit set by lsr above
	bra.s RotX
CrunchedBytes:
	moveq #1,d0
	bsr.s ReadD1				; read code
	moveq #0,d0
	move.b 0(a5,d1.w),d0		; get number of bits of offset
	move.w d1,d2				; d2 = code = length-2
	cmp.w d6,d2					; if d2 = 3 check offset bit and read length
	bne.s ReadOffset
	bsr.s ReadBit				; read offset bit (long/short)
	bcs.s LongBlockOffset
	moveq #7,d0
LongBlockOffset:
	bsr.s ReadD1sub
	move.w d1,d3				; d3 = offset
Read3BitsRow:
	moveq #2,d0
	bsr.s ReadD1
	add.w d1,d2					; d2 = length-1
	cmp.w d7,d1					; cmp with #7
	beq.s Read3BitsRow
	bra.s DecrunchBlock
ReadOffset:
	bsr.s ReadD1sub			; read offset
	move.w d1,d3				; d3 = offset
DecrunchBlock:
	addq.w #1,d2
DecrunchBlockLoop:
	move.b 0(a3,d3.w),-(a3)
	dbf d2,DecrunchBlockLoop
EndOfLoop:
	move.w a3,(a6)
	cmp.l a3,a2
	bcs LoopCheckCrunch
	rts


datacrunch:
	incbin	"df0:reset.crunch"


