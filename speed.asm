;
; Calculate CPU clock using MSM4262B clock
;
; Cycles times are for 8-bit mode (MC68008).
;

.include "monitor.inc"

REGS	EQU	$FFFFD000

CD	EQU	13		; 30-sec adjust, IRQ, BUSY, HOLD
CE	EQU	14		; t1, t0, ITRPT/STND, MASK
CF	EQU	15		; TEST, 24/12, STOP, REST

	ORG $00000400
main:
	LEA	crlfs,A0
	JSR	PUTS
	LEA	intros,A0
	JSR	PUTS

	MOVE.W	SR,-(SP)
	MOVE.W	#$2700,SR	; disable interrupts

	LEA	REGS,A1
	CLR.B	CD(A1)		; ADJ=0, IRQ=xxx, BUSY=xxx, HOLD=0
	CLR.B	CE(A1)		; TIMER=1/64 (33% duty cycle), ITRPT/STD=0 (wave output), MASK=0
        MOVE.B  #$05,CF(A1)	; TEST=0, 24HOUR=1, STOP=0, REST=1
        MOVE.B  #$04,CF(A1)	; TEST=0, 24HOUR=1, STOP=0, REST=0

	CLR.L	D1
	MOVE.L	#4,D2
	LEA	CD(A1),A2
1:				; wait for wave to go high
	MOVE.B	(A2),D0
	AND.B	D2,D0
	BEQ	1b
1:				; wait for wave to go low
	MOVE.B	(A2),D0
	AND.B	D2,D0
	BNE	1b
1:
	ADD.W	#1,D1		; 8T 
	MOVE.B	(A2),D0		; 12T
	AND.B	D2,D0		; 8T
	BEQ	1b		; 8T + 10T (taken) 20T
1:
	ADD.W	#1,D1		; 8T
	MOVE.B	(A2),D0		; 12T
	AND.B	D2,D0		; 8T
	BNE	1b		; 18T (taken)	20T

	; at this point, D1 is the number of times round the loop

	; timer is 1/64 of a second
	; 46 T cycles around the loop

	; MHz = D1 * 64 * 46
	MULU.W	#(64 * 46),D1

	LEA	msgs,A0
	JSR	PUTS

	MOVE.L	D1,D0
	BSR	PUTDEC32

	MOVE	D1,D0
	LEA	hzs,A0

	JSR	PUTS

	MOVE.B	#$01,D0
	MOVE.B	D0,CE(A1)	; mask interrupt
	CLR.B	CD(A1)		; clear interrupt

	MOVE.W	(SP)+,SR	; restore interrupts

	JMP	MONITR

PUTDEC32:
	MOVE.L	D0,-(SP)
	DIVU	#1000,D0
	BEQ	1f
	MOVE.L	D0,-(SP)
	EXT.L	D0
	BSR	PUTDEC16
	MOVE.L	(SP)+,D0
1:	CLR.W	D0
	SWAP	D0
	BSR	PUTDEC16
	MOVE.L	(SP)+,D0
	RTS

; print 16-bit number in D0
PUTDEC16:
	CLR.B	D3		; COUNTER FOR NUMBER OF DIGITS
1:	DIVU	#10,D0		; D0 = D0/10 (REMAINDER IN MSW, QUOTIENT IN LSW)
	SWAP	D0		; GET THE REMAINDER IN LSW
	OR.B	#$30,D0		; CONVERT TO ASCII
	MOVE.B	D0,-(SP)	; ACCUMULATE ASCII ON STACK
	ADD	#1,D3		; INCREMENT COUNTER
	CLR.W	D0		; CLEAR REMAINDER
	SWAP	D0		; LSW IS NEXT VALUE, MSW IS 0
	BNE	1b		; GO AGAIN
2:	MOVE.B	(SP)+,D0	; POP NEXT ASCII CHARACTER
	JSR	PUTC
	SUB.B	#1,D3		; DECREMENTER COUNTER
	BNE	2b
	RTS

intros:	FCC	"Speed Checker"
crlfs:	FCC	"\r\n",0
msgs:	FCC	"CPU Speed is ",0
hzs:	FCC	" Hz\r\n",0

	END
