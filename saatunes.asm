; void tune_playnote(byte chan, byte note, byte volume);
; void tune_stopnote(byte chan);
; void tune_stepscore(void);

.include "monitor.inc"

SAAREGS	EQU	$FFFFDC00
SAACTRL	EQU	SAAREGS+0
SAAADDR	EQU	SAAREGS+1

	ORG $00000400
start:	JMP	main

NOTE	DS.B	3

	.p2align 2
main:
	LEA	intro,A0
	JSR	PUTS
	BSR	saa_init

1:	MOVE.B	#'\\',D0
	JSR	PUTC
	BSR	playtune

	MOVE.B	#$FF,D0
	BSR	delay

	JMP	MONITR

	MOVE.B	#'/',D0
	JSR	PUTC

	BSR	playscale

	MOVE.B	#$FF,D0
	BSR	delay

	JMP	MONITR

intro	DC.B	"\r\nTune on SAA1099\r\n",0

	.p2align 4
saa_init:
	; Reset all the sound channels
	MOVE.B	#$1C,SAAADDR
	NOP
	NOP
	NOP
	MOVE.B	#$02,SAACTRL
	NOP
	MOVE.B	#$00,SAACTRL

	; Sound Enable
	MOVE.B	#$01,SAACTRL

	; Disable frequencies
	MOVE.B	#$14,SAAADDR
	MOVE.B	#$00,SAACTRL
	
	; Disable noise channels
	MOVE.B	#$15,SAAADDR
	MOVE.B	#$00,SAACTRL
	
	; Disable envelopes
	MOVE.B	#$18,SAAADDR
	MOVE.B	#$00,SAACTRL

	MOVE.B	#$19,SAAADDR
	MOVE.B	#$00,SAACTRL

	RTS

	; apparently, these are midi notes, but should -1 first
	;  byte octave = (note / 12) - 1;
	;  byte noteVal = note - ((octave + 1) * 12);
Notes:
	;	octave, note, volume, delay
	DC.B	(24/12)-1, 24-(24/12)*12, $0F, 32
	DC.B	(48/12)-1, 48-(48/12)*12, $2D, 32
	DC.B	(52/12)-1, 52-(52/12)*12, $4B, 32
	DC.B	(55/12)-1, 55-(55/12)*12, $69, 32
	DC.B	(60/12)-1, 60-(60/12)*12, $A6, 32
	DC.B	(64/12)-1, 64-(64/12)*12, $C3, 32
	DC.B	(64/12)-1, 64-(64/12)*12, $F0, 32
EndNotes:

	.p2align 4
playtune:
	LEA	Notes,A0
	LEA	EndNotes,A1
2:	BSR	playnote
	MOVE.B	3(A0),D0
	BSR	delay
	LEA	4(A0),A0
	CMP.L	A1,A0
	BLO	2b
	BSR	stopnote
	RTS

	.p2align 4
playscale:
	LEA	NOTE,A0
	MOVE.B	#$FF,2(A0)	; volume

	; enable channel0
	MOVE.B	#$14,SAAADDR
	MOVE.B	#$01,SAACTRL
	
	CLR	D1
1:	MOVE.W	D1,0(A0)	; octave/tone
	JSR	playtone
	MOVE.B	#$05,D0
	BSR	delay
	ADD.W	#1,D1
	CMP.W	#$800,D1
	BLO	1b
	BSR	stopnote
	RTS

; D0: milliseconds
; 10MHz: 10000000 / 1000 / 84 = 119
	.p2align 4
delay:
	MOVE.L	D1,-(SP)
	AND.W	#$FF,D0
	BRA	2f
4:	MOVE.W	#118,D1
1:	BSR	3f	; 34 + 32 cycles
	DBRA	D1,1b	; 18 cycles
2:	DBRA	D0,4b	; 18 cycles
	MOVE.L	(SP)+,D1
3:	RTS

; The 12 note-within-an-octave values for the SAA1099, starting at B
NoteAddr	DC.B	5, 32, 60, 85, 110, 132, 153, 173, 192, 210, 227, 243

; Start playing a note on channel 0
; A0 = [ octave, note, volume ]
	.p2align 4
playnote:
	MOVE.L	A0,-(SP)

	; set volume
	MOVE.B	#00,SAAADDR
	MOVE.B	2(A0),SAACTRL

	; set octave
	MOVE.B	#$10,SAAADDR
	MOVE.B	0(A0),SAACTRL

	; set note (frequency)
	MOVE.B	1(A0),D0
	AND.B	#$07,D0
	LEA	NoteAddr,A0
	MOVE.B	#$08,SAAADDR
	MOVE.B	0(A0,D0),SAACTRL

	; enable channel0
	MOVE.B	#$14,SAAADDR
	MOVE.B	#$01,SAACTRL

	MOVE.L	(SP)+,A0
	RTS

; A0 = [ octave, tone, volume ]
	.p2align 4
playtone:
	; set volume
	MOVE.B	#$00,SAAADDR
	MOVE.B	2(A0),SAACTRL

	; set octave
	MOVE.B	#$10,SAAADDR
	MOVE.B	0(A0),SAACTRL

	; set note (frequency)
	MOVE.B	#$08,SAAADDR
	MOVE.B	1(A0),SAACTRL

	; enable channel0
;	MOVE.B	#$14,SAAADDSR
;	MOVE.B	#$01,SAACTRL
	
	RTS

	.p2align 4
stopnote:
	MOVE.B	#$14,SAAADDR
	MOVE.B	#$00,SAACTRL
	RTS

	END
