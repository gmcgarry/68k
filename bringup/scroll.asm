; scroll LEDs attached to the address bus
; ROM at $00000000
; RAMless

STACK	EQU	$00007FFF

	ORG	$00000000
VTABLE:
	DC.L	STACK		; stack
	DC.L	START		; reset
START:
	MOVE.L	#1,d1
1:	MOVE.L	d1,a0
	MOVE.W	#$FFFF,d0
2:	MOVE.B	(a0),d2
	DBF	d0,2b		; 10 cycles per loop + 14 cycles for last (branch not taken) 
	ROL.L	#1,d1
	BRA	1b

	END
