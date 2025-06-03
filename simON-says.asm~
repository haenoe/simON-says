MODE	EQU	28H

	SETB	MODE.0

ROW_0	EQU	18H
ROW_1	EQU	19H
ROW_2	EQU	1AH
ROW_3	EQU	1BH

; Memory addresses which store the input of the matrix keypad
ROW_INPUT0	EQU	20H
ROW_INPUT1	EQU	21H
ROW_INPUT2	EQU	22H
ROW_INPUT3	EQU	23H

	MOV	ROW_INPUT0, #01111111B
	MOV	ROW_INPUT1, #10111111B
	MOV	ROW_INPUT2, #11011111B
	MOV	ROW_INPUT3, #11101111B

; Clear all input at the start of each loop. We use negative logic here, where a bit of zero means a pressed key.
; The data already encodes the column (4 most significant bits). This _is_ a waste of 16 bits here, but it allows us to easily just copy the data for output on/comparison with the LED Matrix.

;;;  Zufallszahlengenerator + CASE-Anweisung + SATISTIK ----
;;;  Zufallszahl in R2 E {0,...,7}
;;;  Statistik in 030h - 038h 
;;;
ZUF8R	EQU	0x40		;ein byte
	jmp	init


ANF:
;-----------GENERIER EINE ZUFALLSZAHL----------
	call	ZUFALL		;Zufallszahl A bestimmen zwischen 00h und ffh
;----------- CASE-ANWEISUNG-------------------------
	mov	R2, #00h	;Zähler initialisieren mit 0 
neu:	add	A, #020h	;die Zufallszahl plus 32 
	inc	R2		;Zähler um 1 erhöhen
	jnc	neu		;falls schon Überlauf, dann weiter - sonst  addiere 32

	mov	A, R2		;schreib Zahl in A
	ret
;--------------------------------------------------

; ------ Zufallszahlengenerator-----------------
ZUFALL:	mov	A, ZUF8R	; initialisiere A mit ZUF8R
	jnz	ZUB
	cpl	A
	mov	ZUF8R, A
ZUB:	anl	a, #10111000b
	mov	C, P
	mov	A, ZUF8R
	rlc	A
	mov	ZUF8R, A
	ret

;-----------MAIN-----------------------------------
init:
	MOV	R0, #2fh	;Speichere die Zahlenreihe oberhalb 30h

LOOP:
	JNB	MODE.0, CHECK_ROW_INPUT0
; Clear
	CALL	ANF
	ORL	A, #11110000B
	ANL	A, #01111111B
	MOV	ROW_0, A

	CALL	ANF
	ORL	A, #11110000B
	ANL	A, #10111111B
	MOV	ROW_1, A

	CALL	ANF
	ORL	A, #11110000B
	ANL	A, #11011111B
	MOV	ROW_2, A

	CALL	ANF
	ORL	A, #11110000B
	ANL	A, #11101111B
	MOV	ROW_3, A

	; CLR 	MODE.0

	; Display

	MOV	P1, ROW_0
	MOV	P1, ROW_1
	MOV	P1, ROW_2
	MOV	P1, ROW_3

	MOV	A, #01000000B
	JNB	P2.0, SHOW_PATTERN_LAST_TIME
	JMP	LOOP

SHOW_PATTERN_LAST_TIME:
	MOV	P1, #11111111B
	JZ	WAIT_FOR_INPUT_FINISH

	MOV	P1, ROW_0
	MOV	P1, ROW_1
	MOV	P1, ROW_2
	MOV	P1, ROW_3

	SUBB	A, #1
	JMP	SHOW_PATTERN_LAST_TIME

WAIT_FOR_INPUT_FINISH:
	MOV	P1, #11111111B

	MOV	P1, ROW_INPUT0
	MOV	P1, ROW_INPUT1
	MOV	P1, ROW_INPUT2
	MOV	P1, ROW_INPUT3

CHECK_ROW_INPUT0:
	CLR	P0.0

CHECK_1:
	JB	P0.4, CHECK_2
	CLR	ROW_INPUT0.3

CHECK_2:
	JB	P0.5, CHECK_3
	CLR	ROW_INPUT0.2

CHECK_3:
	JB	P0.6, CHECK_A
	CLR	ROW_INPUT0.1

CHECK_A:
	JB	P0.7, CHECK_ROW_INPUT1
	CLR	ROW_INPUT0.0

CHECK_ROW_INPUT1:
	SETB	P0.0
	CLR	P0.1

CHECK_4:
	JB	P0.4, CHECK_5
	CLR	ROW_INPUT1.3

CHECK_5:
	JB	P0.5, CHECK_6
	CLR	ROW_INPUT1.2

CHECK_6:
	JB	P0.6, CHECK_B
	CLR	ROW_INPUT1.1

CHECK_B:
	JB	P0.7, CHECK_ROW_INPUT2
	CLR	ROW_INPUT1.0

CHECK_ROW_INPUT2:
	SETB	P0.1
	CLR	P0.2

CHECK_7:
	JB	P0.4, CHECK_8
	CLR	ROW_INPUT2.3

CHECK_8:
	JB	P0.5, CHECK_9
	CLR	ROW_INPUT2.2

CHECK_9:
	JB	P0.6, CHECK_C
	CLR	ROW_INPUT2.1

CHECK_C:
	JB	P0.7, CHECK_ROW_INPUT3
	CLR	ROW_INPUT2.0

CHECK_ROW_INPUT3:
	SETB	P0.2
	CLR	P0.3

CHECK_STAR:
	JB	P0.4, CHECK_0
	CLR	ROW_INPUT3.3

CHECK_0:
	JB	P0.5, CHECK_HASH
	CLR	ROW_INPUT3.2

CHECK_HASH:
	JB	P0.6, CHECK_D
	CLR	ROW_INPUT3.1

CHECK_D:
	JB	P0.7, CHECK_FINISHED
	CLR	ROW_INPUT3.0

CHECK_FINISHED:
	SETB	P0.3
	JNB	P2.1, CHECK
	JMP	WAIT_FOR_INPUT_FINISH

CHECK:
	MOV	A, ROW_0
	MOV	B, ROW_INPUT0
	CJNE	A, B, WRONG_INPUT

	MOV	A, ROW_1
	MOV	B, ROW_INPUT1
	CJNE	A, B, WRONG_INPUT

	MOV	A, ROW_2
	MOV	B, ROW_INPUT2
	CJNE	A, B, WRONG_INPUT

	MOV	A, ROW_3
	MOV	B, ROW_INPUT3
	CJNE	A, B, WRONG_INPUT

	JMP	RIGHT_INPUT

WRONG_INPUT:
	MOV	P1, #11111111B
	MOV	P1, #01110110B
	MOV	P1, #10111111B
	MOV	P1, #11011001B
	MOV	P1, #11100110B
	JMP	WRONG_INPUT

RIGHT_INPUT:
	MOV	P1, #11111111B
	MOV	P1, #01110110B
	MOV	P1, #10111111B
	MOV	P1, #11010110B
	MOV	P1, #11101001B
	JMP	RIGHT_INPUT

END