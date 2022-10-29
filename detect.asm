.include "monitor.inc"

	ORG	$00000400

START:
	LEA	INTRO,A0
	JSR	PUTS

	MOVE.L	$10,IISAVED.L		; Save illegal instruction handler
	MOVE.L	$2C,FLSAVED.L		; Save F-line too (for move16 test)

	MOVE.L	#IIHANDLER,$10		; and install our temporary one...
	MOVE.L	#IIHANDLER,$2C		; ... to both vectors

	MOVE.L	#.CONT0,CONTADDR.L	; Set up continue address
	CLR.B	IIFLAG.L		; Reset illegal flag

	.68010
	MOVEC	D0,VBR			; Try to set VBR
	.68000

.CONT0:
	TST.B	IIFLAG.L		; Was it illegal?
	BEQ	.TRY010			; Go on for 010 and up if not...

	CLR.B	CPUTYPE.L		; Else it's an 000
	BRA	.DONE

.TRY010:
	CLR.B	IIFLAG.L		; Reset illegal flag
	MOVE.L	#.CONT1,CONTADDR.L	; Set up continue address
	.68020
	EXTB.L	D0			; Try EXTB
	.68000
.CONT1:
	tst.b	IIFLAG.L		; Was it illegal?
	beq	.TRY020			; Go on for 020 and up if not...

	move.b	#1,CPUTYPE.L		; Else it's an 010
	bra	.DONE

.TRY020:
	clr.b	IIFLAG.L		; Reset illegal flag
	move.l	#.CONT2,CONTADDR.L	; Set up continue address
	.68020
	CALLM	#0,CMODULE.L		; Do module call
	.68000
.CONT2:
	tst.b	IIFLAG.L		; Was it illegal?
	bne	.TRY030			; Go on for 030 and up if so...

	move.b	#2,CPUTYPE.L		; Else it's an 020
	bra	.DONE		 

.TRY030:
	clr.b	IIFLAG.L		; Reset illegal flag
	move.l	#.CONT3,CONTADDR.L	; Set up continue address
	lea	M16BUF.L,A0

	; TODO Once F-Line is properly supported in HW on Pro, this can 
	; switch to using MOVE16 (and no longer need supervisor mode):
	;
	; .68040
	; move16 (A0)+,(A0)+		; Try MOVE16
	; .6800
	;
	; Will need to invert the branch (to beq) to .TRY040 at that
	; point!

	.68030
	PMOVE	MMUSR,M16BUF.L		; Try PMOVE
	.68000
.CONT3:
	tst.b	IIFLAG.L		; Was it illegal?
	bne	.TRY040			; Go on for 040 and up if so...

	move.b	#3,CPUTYPE.L		; Else it's an 030
	bra	.DONE

.TRY040:
	clr.b	IIFLAG.L		; Reset illegal flag
	MOVE.L	#.CONT4,CONTADDR.L	; Set up continue address
	LEA	M16BUF,A0
;	movep.w D0,(0,A0)		; Try MOVEP
.CONT4:
	tst.b	 IIFLAG.L		; Was it illegal?
	beq	 .IS040			; It's 040 if not

	move.b	#6,CPUTYPE.L		; Else it's an 060
	bra	 .DONE

.IS040:
	move.b	#4,CPUTYPE.L

.DONE:
 	LEA	SZCPU,A0		; Get prefix string into A1
	JSR	PUTS
	MOVE.B	CPUTYPE.L,D0
	ADD.B	#$30,D0
	JSR	PUTC
	MOVE.B	#'0',D0
	JSR	PUTC

	MOVE.L	IISAVED.L,$10		; Restore original handler
	MOVE.L	FLSAVED.L,$2C		; for both II and FL

	JMP	MONITR

MODENTRY:
	dc.w	$7000			; Save SP (essentially no-op)
	.68020
	RTM	SP			; Just return	
	.68000

IIHANDLER:
	MOVE.B	#1,IIFLAG.L		; Set the flag
	MOVE.L	CONTADDR.L,2(SP)	; Update continue PC
	RTE

		DC.W	0
CONTADDR	DC.L	0
M16BUF		DC.L	0,0,0,0
IISAVED		DC.L	0
FLSAVED		DC.L	0
CMODULE		DC.L	$0		; Option 0, Type 0, Rest ignored
		DC.L	MODENTRY	; Entry word at MODENTRY
SZCPU		DC.B	"MC680", 0
CPUTYPE		DC.B	0
IIFLAG		DC.B	0 

INTRO		DC.B	"Detecting CPU...\r\n",0

	END
