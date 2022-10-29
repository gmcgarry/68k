; 256B ROM @ $00000000

STACK	EQU	$00000000

	.org	$00000000
vtable:
	.long	STACK		; stack
	.long	START		; reset

	.org	$0040
START:
	BRA	.
