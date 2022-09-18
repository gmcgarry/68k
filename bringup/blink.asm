; blink LED attached to latch on I2C board
; ROM at $00000000
; RAMless

STACK	EQU	$00000000
LED	EQU	$00080000

	.org	$00000000
VTABLE:
	.long	STACK		; stack
	.long	START		; reset
START:
	MOVE.B	#0,d1
1:	MOVE.W	#$FFFF,d0
2:	MOVE.B	d1,LED
	DBRA	d0,2b		; 10 cycles per loop + 14 cycles for last (branch not taken) 
	EOR.B	#$FF,d1
	BRA	1b

	END
