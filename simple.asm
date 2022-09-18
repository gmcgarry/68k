PUTS	EQU	$000800C4
PUTC	EQU	$000803EC
MONITR	EQU	$00080362

	ORG	$0000400
main:
	lea	str,a0
	jsr	PUTS
;	rts
	jmp	MONITR

str:	.asciz	"This is the message\r\n"

	END
