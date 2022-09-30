PUTS	EQU	$FFFF80C4
PUTC	EQU	$FFFF83EC
MONITR	EQU	$FFFF8362

ACIA	EQU	$FFFFD800

	ORG	$0000400
main:
	lea	str,a0
	jsr	PUTS
;	rts
	jmp	MONITR

str	DC.B	"This is the message\r\n",0

	END
