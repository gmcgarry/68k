MONITR	EQU	$000804A8

S1	EQU	0
S10	EQU	1
MI1	EQU	2
MI10	EQU	3
H1	EQU	4
H10	EQU	5
DA1	EQU	6
DA10	EQU	7
MO1	EQU	8
MO10	EQU	9
Y1	EQU	10
Y10	EQU	11
W	EQU	12
CD	EQU	13		; 30-sec adjust, IRQ, BUSY, HOLD
CE	EQU	14		; t1, t0, ITRPT/STND, MASK
CF	EQU	15		; TEST, 24/12, STOP, REST

; BOLD=1 inhibits the clock during read/write (much be set for less than 1 second)
; IRQ indicates the (inverted) level of the STD.P pin
; MASK=0 enables timing on STD.P; MASK=1 disables STD.P
; timing of STD.P is controlled by t0/t1 divisor: 00 = 1/64 second, 01=1second, 10=1minute, 11=1hour
; ITRPT/STND=1 (interrupt mode), then STD.P remains low until IRQ is reset to 0
; ITRPT/STND=0 (standard-pulse mode), then STD.P remains low until IRQ is reset to 0 (or the t0/t1 timer expires)

REGS	EQU	$000FD000
ACIA	EQU	$000FD800
ACIACS	EQU	ACIA+0
ACIADA	EQU	ACIA+1

STACK	EQU	$00020000

	ORG $00000400
start:
;	MOVE.L	#STACK,SP
	LEA	crlfs,A0
	BSR	PUTS
	LEA	intros,A0
	BSR	PUTS

	BSR	init

loop:
	MOVE.B	#'#',D0
	BSR	PUTC
	MOVE.B	#' ',D0
	BSR	PUTC
	BSR	GETC
	MOVE.B	D0,D1
	LEA	crlfs,A0
	BSR	PUTS
	MOVE.B	D1,D0
1:
	CMP.B	#'D',D0		; dump
	BNE	1f
	BSR	dump
	BRA	loop
1:
	CMP.B	#'R',D0		; init
	BNE	1f
	BSR	init
	BRA	loop
1:
	CMP.B	#'T',D0		; time
	BNE	1f
	BSR	time
	BRA	loop
1:
	CMP.B	#'I',D0		; interrupt
	BNE	1f
	BSR	interrupt
	BRA	loop
1:
	CMP.B	#'2',D0		; 24-hour time
	BNE	1f
	BSR	hour24
	BRA	loop
1:
	CMP.B	#'*',D0		; test mode
	BNE	1f
	BSR	testmode
	BRA	loop
1:
	CMP.B	#'X',D0		; exit
	BNE	1f
	JMP	MONITR
1:
	LEA	badcmds,A0
	BSR	PUTS
	JMP	loop

interrupt:
	move.w	#$2700,SR	; disable processor interrupts
	
	LEA	isr,A0		; setup interrupt handler
	MOVE.L	A0,$7FF00

	MOVE.L	#REGS,A1

	MOVE.B	#$6,D0		; enable one-second clock interrupts
	MOVE.B	D0,CE(A1)

	CLR.B	CD(A1)		; clear clock interrupt

	AND.W	#$f8ff,sr	; enable processor interrupts
	RTS

isr:
	MOVE.L	#REGS,A1
	MOVE.B	CD(A1),D0
	AND.B	#$04,D0
	BEQ	1f	; not for us

	CLR.B	CD(A1)	; clear interrupt

	MOVE.B	#'.',D0
	BSR	PUTC
1:
	RTE

testmode:
	MOVE.L	#REGS,A1
	MOVE.B	CF(A1),D0
;	AND.B	#$08,D0
	BTST.B	#3,D0
	BNE	1f

	OR.B	#$08,D0	; TEST=1
	MOVE.B	D0,CF(A1)
	LEA	testmodeon,A0
	JMP	PUTS
1:
	AND.B	#$07,D0	; TEST=0
	MOVE.B	D0,CF(A1)
	LEA	testmodeoff,A0
	JMP	PUTS

init:
	MOVE.L	#REGS,A1
	CLR.B	CD(A1)	; ADJ=0, IRQ=xxx, BUSY=xxx, HOLD=0
	MOVE.B	#$01,D0	; TIMER=1/64, WAVE OUTPUT, MASK=1
	MOVE.B	D0,CE(A1)
	MOVE.B	#$05,D0	; TEST=0, 24HOUR=1, STOP=0, REST=1
	MOVE.B	D0,CF(A1)
	MOVE.B	#$04,D0	; TEST=0, 24HOUR=1, STOP=0, REST=0
	MOVE.B	D0,CF(A1)
	RTS

hour24:
	MOVE.L	#REGS,A1
	MOVE.B	CF(A1),D0
;	AND.B	#$04,D0
	BTST.B	#2,D0
	BEQ	1f

	OR.B	#$01,D0	; REST=1
	MOVE.B	D0,CF(A1)
	AND.B	#$0B,D0	; CLEAR 12/24
	MOVE.B	D0,CF(A1)
	AND.B	#$0E,D0	; REST=0
	MOVE.B	D0,CF(A1)
	LEA	hour24off,A0
	JMP	PUTS

1:	OR.B	#$01,D0	; REST=1
	MOVE.B	D0,CF(A1)
	OR.B	#$4,D0	; SET 12/24
	MOVE.B	D0,CF(A1)
	AND.B	#$0E,D0	; REST=0
	MOVE.B	D0,CF(A1)
	LEA	hour24on,A0
	JMP	PUTS

time:
	MOVE.L	#REGS,A1
	MOVE.B	H10(A1),D0
	AND.B	#$3,D0
	BSR	PUTDEC
	MOVE.B	H1(A1),D0
	BSR	PUTDEC
	MOVE.B	#':',D0
	BSR	PUTC
	MOVE.B	MI10(A1),D0
;	AND.B	#$7,D0
	BSR	PUTDEC
	MOVE.B	MI1(A1),D0
	BSR	PUTDEC
	MOVE.B	#':',D0
	BSR	PUTC
	MOVE.B	S10(A1),D0
;	AND.B	#$7,D0
	BSR	PUTDEC
	MOVE.B	S1(A1),D0
	BSR	PUTDEC

	MOVE.B	#' ',D0
	BSR	PUTC

	MOVE.B	DA10(A1),D0
;	AND.B	#$3,D0
	BSR	PUTDEC
	MOVE.B	DA1(A1),D0
	BSR	PUTDEC
	MOVE.B	#'/',D0
	BSR	PUTC
	MOVE.B	MO10(A1),D0
;	AND.B	#$01,D0
	BSR	PUTDEC
	MOVE.B	MO1(A1),D0
	BSR	PUTDEC
	MOVE.B	#'/',D0
	BSR	PUTC
	MOVE.B	Y10(A1),D0
	BSR	PUTDEC
	MOVE.B	Y1(A1),D0
	BSR	PUTDEC

	MOVE.B	#' ',D0
	BSR	PUTC

	LEA	WEEKDAY,A0
	MOVE.B	W(A1),D0
	AND.L	#$07,D0
	LSL.L	#2,D0
;	ADD.L	#WEEKDAY,D0
	LEA	0(A0,D0.W),A0
	BSR	PUTS

	LEA	crlfs,A0
	JMP	PUTS

dump:
	CLR.B	D2
	MOVE.L	#REGS,A1
1:
	MOVE.B	D2,D0
	BSR	PUTHEX
	MOVE.B	#':',D0
	BSR	PUTC
	MOVE.B	#' ',D0
	BSR	PUTC
	MOVE.B	(A1)+,D0
	BSR	PUTHEX
	MOVE.B	#'\r',D0
	BSR	PUTC
	MOVE.B	#'\n',D0
	BSR	PUTC
	ADD.B	#1,D2
	CMP.B	#$10,D2
	BNE	1b
	RTS

GETC:	MOVE.B  ACIACS,D0
	AND.B   #$01,D0
	BEQ     GETC
	MOVE.B  ACIADA,D0
	AND.B   #0x7F,D0           ;  Strip msb of input
	BRA     PUTC

1:      BSR     PUTC
PUTS:   MOVE.B  (A0)+,D0
	BNE     1b
	RTS

PUTDEC:
	AND.B	#$0F,D0
	ADD.B	#$30,D0
	BRA	PUTC

OUTHL:  LSR.B	#4,D0           ; OUT HEX LEFT BCD DIGIT
OUTHR:  AND.B	#$0F,D0         ; OUT HEX RIGHT BCD DIGIT
	ADD.B	#'0',D0
	CMP.B	#'9',D0
	BLS	PUTC
	ADD.B	#$7,D0
PUTC:	MOVEM.L	D0,-(SP)        ; OUTPUT ONE CHAR
1:	MOVE.B	ACIACS,D0       ; Print one character
	AND.B	#$02,D0
	BEQ	1b
	MOVEM.L	(SP)+,D0
	MOVE.B	D0,ACIADA
	RTS

PUTHEX:
OUT2H:	MOVE.B	D0,D1
	BSR	OUTHL	; OUT LEFT HEX CHAR
	MOVE.B	D1,D0
	BRA	OUTHR	; OUTPUT RIGHT HEX CHAR AND R
 	ADD.B	#$7,D0
	JMP	PUTC

intros:		FCC	"MSM6242B tester\r\n",0
badcmds:	FCC	"unrecognised command\r\n",0
crlfs:		FCC	"\r\n",0

testmodeon:	FCC	"Test-mode on\r\n",0
testmodeoff:	FCC	"Test-mode off\r\n",0

hour24on:	FCC	"Setting 24-hour time\r\n",0
hour24off:	FCC	"Setting 12-hour time\r\n",0

WEEKDAY		DC.L	SUNS, MONS, TUES, WEDS, THURS, FRIS, SATS, ERRORS
SUNS:		FCC	"Sunday",0
MONS:		FCC	"Monday",0
TUES:		FCC	"Tuesday",0
WEDS:		FCC	"Wednesday",0
THURS:		FCC	"Thursday",0
FRIS:		FCC	"Friday",0
SATS:		FCC	"Saturday",0
ERRORS:		FCC	"Badday",0

	END
