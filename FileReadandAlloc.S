;ASM-ONE SAMPLE FILE READ+ALLOCATE by Patapik 2021

OpenLib		=-408
Closelib 	=-414
Close    	=-36
Open		=-30
Read 		=-42


ExecBase        = 4
AllocMem	= -198


Flength = 200

Start:
	move.l ExecBase,a6
	move.l #2,d1
	move.l #Flength,d0
	jsr AllocMem(a6)
	cmp.l #Flength,d0
	bgt.s OkAlloc
	rts ;no free memory

OkAlloc:	
	move.l d0,MemoryBuffer

	lea dosname(pc),a1
	moveq #0,d0
	jsr OpenLib(a6)
	move.l d0,dosbase
	beq error2

	move.l #filename,d1
	move.l #1005,d2  ;old mode
	move.l dosbase,a6
	jsr Open(a6) ;open
	beq error
	move.l d0,filehandle
;Alloc mem
	move.l filehandle,d1
	move.l MemoryBuffer,d2
	move.l #Flength,d3
	jsr Read(a6)  ;DOS Read

;close file

	move.l filehandle,d1
	jsr Close(a6)

;close dos lib

error:	move.l dosbase,a1
	move.l execbase,a6
	jsr CloseLib(a6)
error2:	rts
	
	even

MemoryBuffer: 
	 dc.l 0       
              
dosbase:
	dc.l 0
filehandle:
	dc.l 0 	
dosname:
	dc.b 'dos.library',0
filename:
	dc.b 'RAM:a.adf',0
		
