; RAMless, ROM @ 0x00000000

ACIACS	EQU	$FFFFD800	; [0-F][0-F][0-F][8-F]3800 maps to D800
ACIADA	EQU	$FFFFD801

RAM_START	EQU	$00000
RAM_END		EQU	$80000

	.BASE	$00080000
	ORG	$00080000

	DC.L	$00000000
	DC.L	START

MSG:	.asciz	"Testing memory... "
FAIL:	.asciz	"X\r\n"
OK:	.asciz	"/\r\n"

	.align	1
START:
	MOVE.B	#$03, ACIACS	; reset ACIA
	NOP
	NOP
	MOVE.B	#$15, ACIACS	; initialise ACIA (/16) = 115200bps

	LEA	MSG, A0
	BRA	2f
1:	MOVE.B	ACIACS, D1
	AND.B	#$02, D1
	BEQ	1b
	MOVE.B	D0, ACIADA
2:	MOVE.B	(A0)+, D0
	BNE	1b

	MOVE.L	#0,A0
	MOVE.W	#$FFFF,D0	; DELAY TO LET FLIP-FLOP ON A19 STABILIZE
1:	MOVE.B	(A0)+,D1
	ADD.W	#-1,D0
	BNE	1b

	LEA	RAM_START.L, A1
LOOP:
	MOVE.L	A1,D2
        ROL.L   #8,D2           ; 4321 -> 3214

	; --- PUTHEX ---
        MOVE.B  d2,d0
        LSR.B   #$4,d0
        ADD.B   #'0',d0
        CMP.B   #'9',d0         ; Check if the hex number was from 0-9
        BLE     1f
        ADD.B   #7,d0           ; Shift 0xA-0xF from ':' to 'A'

	; --- PUTCHAR ---
1:	MOVE.B	ACIACS, D3	; Print one character
	AND.B	#$02, D3
	BEQ	1b
	MOVE.B	D0,ACIADA
	; ---------------

        ANDI.B  #$0F,d2         ; Now we want the lower digit Mask only the lower digit
        ADD.B   #'0',d2
        CMP.B   #'9',d2         ; Same as before    
        BLE     1f
        ADD.B   #7,d2
1:      MOVE.B  d2,d0

	; --- PUTCHAR ---
1:	MOVE.B	ACIACS, D3	; Print one character
	AND.B	#$02, D3
	BEQ	1b
	MOVE.B	D0,ACIADA
	; ---------------
	; ---------------

	MOVE.L	A1,D2
        ROL.L   #8,D2           ; 4321 -> 3214
        ROL.L   #8,d2           ; 3214 -> 2143 

	; --- PUTHEX ---
        MOVE.B  d2,d0
        LSR.B   #$4,d0
        ADD.B   #'0',d0
        CMP.B   #'9',d0         ; Check if the hex number was from 0-9
        BLE     1f
        ADD.B   #7,d0           ; Shift 0xA-0xF from ':' to 'A'

	; --- PUTCHAR ---
1:	MOVE.B	ACIACS, D3	; Print one character
	AND.B	#$02, D3
	BEQ	1b
	MOVE.B	D0,ACIADA
	; ---------------

        ANDI.B  #$0F,d2         ; Now we want the lower digit Mask only the lower digit
        ADD.B   #'0',d2
        CMP.B   #'9',d2         ; Same as before    
        BLE     1f
        ADD.B   #7,d2
1:      MOVE.B  d2,d0

	; --- PUTCHAR ---
1:	MOVE.B	ACIACS, D3	; Print one character
	AND.B	#$02, D3
	BEQ	1b
	MOVE.B	D0,ACIADA
	; ---------------
	; ---------------

	MOVE.L	A1,D2
        ROL.L   #8,D2           ; 4321 -> 3214
        ROL.L   #8,d2           ; 3214 -> 2143 
	ROL.L   #8,d2           ; 2143 -> 1432 Middle byte in low

	; --- PUTHEX ---
        MOVE.B  d2,d0
        LSR.B   #$4,d0
        ADD.B   #'0',d0
        CMP.B   #'9',d0         ; Check if the hex number was from 0-9
        BLE     1f
        ADD.B   #7,d0           ; Shift 0xA-0xF from ':' to 'A'

	; --- PUTCHAR ---
1:	MOVE.B	ACIACS, D3	; Print one character
	AND.B	#$02, D3
	BEQ	1b
	MOVE.B	D0,ACIADA
	; ---------------

        ANDI.B  #$0F,d2         ; Now we want the lower digit Mask only the lower digit
        ADD.B   #'0',d2
        CMP.B   #'9',d2         ; Same as before    
        BLE     1f
        ADD.B   #7,d2
1:      MOVE.B  d2,d0

	; --- PUTCHAR ---
1:	MOVE.B	ACIACS, D3	; Print one character
	AND.B	#$02, D3
	BEQ	1b
	MOVE.B	D0,ACIADA
	; ---------------
	; ---------------

	MOVE.L	A1,D2

	; --- PUTHEX ---
        MOVE.B  d2,d0
        LSR.B   #$4,d0
        ADD.B   #'0',d0
        CMP.B   #'9',d0         ; Check if the hex number was from 0-9
        BLE     1f
        ADD.B   #7,d0           ; Shift 0xA-0xF from ':' to 'A'

	; --- PUTCHAR ---
1:	MOVE.B	ACIACS, D3	; Print one character
	AND.B	#$02, D3
	BEQ	1b
	MOVE.B	D0,ACIADA
	; ---------------

        ANDI.B  #$0F,d2         ; Now we want the lower digit Mask only the lower digit
        ADD.B   #'0',d2
        CMP.B   #'9',d2         ; Same as before    
        BLE     1f
        ADD.B   #7,d2
1:      MOVE.B  d2,d0

	; --- PUTCHAR ---
1:	MOVE.B	ACIACS, D3	; Print one character
	AND.B	#$02, D3
	BEQ	1b
	MOVE.B	D0,ACIADA
	; ---------------
	; ---------------

	MOVE.B	#' ', D0
	; --- PUTCHAR ---
1:	MOVE.B	ACIACS, D3	; Print one character
	AND.B	#$02, D3
	BEQ	1b
	MOVE.B	D0,ACIADA
	; ---------------
	; ---------------

        move.b  #$AA, (A1)   ; First test with 10101010
        cmp.b   #$AA, (A1)
        bne   fail
        move.b  #$55, (A1)   ; Then with 01010101
        cmp.b   #$55, (A1)
        bne   fail
        move.b  #$00, (A1)   ; And finally clear the memory
        cmp.b   #$00, (A1)
        bne   fail 
	LEA	OK, A0
        bra	print
fail:                     ; One of the bytes of RAM failed to readback test

	MOVE.B	#':',D0

	; --- PUTCHAR ---
1:	MOVE.B	ACIACS, D3	; Print one character
	AND.B	#$02, D3
	BEQ	1b
	MOVE.B	D0,ACIADA
	; ---------------

	MOVE.B	(A1),D2
        ROL.L   #8,D2           ; 4321 -> 3214

	; --- PUTHEX ---
        MOVE.B  d2,d0
        LSR.B   #$4,d0
        ADD.B   #'0',d0
        CMP.B   #'9',d0         ; Check if the hex number was from 0-9
        BLE     1f
        ADD.B   #7,d0           ; Shift 0xA-0xF from ':' to 'A'

	; --- PUTCHAR ---
1:	MOVE.B	ACIACS, D3	; Print one character
	AND.B	#$02, D3
	BEQ	1b
	MOVE.B	D0,ACIADA
	; ---------------

        ANDI.B  #$0F,d2         ; Now we want the lower digit Mask only the lower digit
        ADD.B   #'0',d2
        CMP.B   #'9',d2         ; Same as before    
        BLE     1f
        ADD.B   #7,d2
1:      MOVE.B  d2,d0

	; --- PUTCHAR ---
1:	MOVE.B	ACIACS, D3	; Print one character
	AND.B	#$02, D3
	BEQ	1b
	MOVE.B	D0,ACIADA
	; ---------------
	; ---------------

	LEA	FAIL,A0
print:
	BRA	2f
1:	MOVE.B	ACIACS, D1
	AND.B	#$02, D1
	BEQ	1b
	MOVE.B	D0, ACIADA
2:	MOVE.B	(A0)+, D0
	BNE	1b

	add.l	#1,A1
	cmp.l   #RAM_END, A1  
        blt	LOOP        ; While we're still below the end of ram to check
	JMP	START

	END
