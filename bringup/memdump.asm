; RAMless, ROM @ 0x00000000

ACIACS	EQU	$000FD800	; [0-F][0-F][0-F][8-F]5800 maps to D800
ACIADA	EQU	$000FD801

	ORG	$00000000
	DC.L	$00000000
	DC.L	START

	.align	1
START:	MOVE.B	#$03, ACIACS	; reset ACIA
	NOP
	NOP
	MOVE.B	#$15, ACIACS	; initialise ACIA (/16) = 34800kpbs

	LEA	MSG, A0
	BRA	2f
1:	MOVE.B	ACIACS, D1
	AND.B	#$02, D1
	BEQ	1b
	MOVE.B	D0, ACIADA
2:	MOVE.B	(A0)+, D0
	BNE	1b

	MOVE.L	#$00,A0
LOOP:
	MOVE.L	A0,D2
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

	MOVE.L	A0,D2
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

	MOVE.L	A0,D2
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

	MOVE.L	A0,D2

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

	MOVE.B	#':',D0
	; --- PUTCHAR ---
1:	MOVE.B	ACIACS, D3	; Print one character
	AND.B	#$02, D3
	BEQ	1b
	MOVE.B	D0,ACIADA
	; ---------------

	MOVE.B	#' ',D0
	; --- PUTCHAR ---
1:	MOVE.B	ACIACS, D3	; Print one character
	AND.B	#$02, D3
	BEQ	1b
	MOVE.B	D0,ACIADA
	; ---------------

DLOOP:
	MOVE.B	(A0)+,D2

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

	MOVE.B	#' ',D0
	; --- PUTCHAR ---
1:	MOVE.B	ACIACS, D3	; Print one character
	AND.B	#$02, D3
	BEQ	1b
	MOVE.B	D0,ACIADA
	; ---------------

	MOVE.L	A0,D2
	AND.B	#$0F,D2
	BNE	DLOOP

	MOVE.B	#'\r',D0
	; --- PUTCHAR ---
1:	MOVE.B	ACIACS, D3	; Print one character
	AND.B	#$02, D3
	BEQ	1b
	MOVE.B	D0,ACIADA
	; ---------------

	MOVE.B	#'\n',D0
	; --- PUTCHAR ---
1:	MOVE.B	ACIACS, D3	; Print one character
	AND.B	#$02, D3
	BEQ	1b
	MOVE.B	D0,ACIADA
	; ---------------

	BRA	LOOP

MSG:	.asciz	"Dumping Memory\r\n"


	END
