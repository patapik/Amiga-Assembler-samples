aros            EQU $002E000B
init:
                       
              lea.l       $f80000,A0
              move.l      16(A0),d0
              move.l      #aros,d1
              cmp.l       d1,d0
              beq         AROS_Detected
              rts
AROS_Detected:
              nop