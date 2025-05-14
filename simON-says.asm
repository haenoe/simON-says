; Memory addresses which store the input of the matrix keypad
ROW_0	EQU	20H
ROW_1	EQU	21H
ROW_2	EQU	22H
ROW_3	EQU	23H

; Clear all input at the start of each loop. We use negative logic here, where a bit of zero means a pressed key.
; The data already encodes the column (4 most significant bits). This _is_ a waste of 16 bits here, but it allows us to easily just copy the data for output on/comparison with the LED Matrix.

MOV	ROW_0, #01111111B
MOV	ROW_1, #10111111B
MOV	ROW_2, #11011111B
MOV	ROW_3, #11101111B

LOOP:
	MOV	P0, #11111111B

CHECK_ROW_0:
	CLR	P0.0

CHECK_1:
	JB	P0.4, CHECK_2
	CLR	ROW_0.3

CHECK_2:
	JB	P0.5, CHECK_3
	CLR	ROW_0.2

CHECK_3:
	JB	P0.6, CHECK_A
	CLR	ROW_0.1

CHECK_A:
	JB	P0.7, CHECK_ROW_1
	CLR	ROW_0.0

CHECK_ROW_1:
	SETB	P0.0
	CLR	P0.1

CHECK_4:
	JB	P0.4, CHECK_5
	CLR	ROW_1.3

CHECK_5:
	JB	P0.5, CHECK_6
	CLR	ROW_1.2

CHECK_6:
	JB	P0.6, CHECK_B
	CLR	ROW_1.1

CHECK_B:
	JB	P0.7, CHECK_ROW_2
	CLR	ROW_1.0

CHECK_ROW_2:
	SETB	P0.1
	CLR	P0.2

CHECK_7:
	JB	P0.4, CHECK_8
	CLR	ROW_2.3

CHECK_8:
	JB	P0.5, CHECK_9
	CLR	ROW_2.2

CHECK_9:
	JB	P0.6, CHECK_C
	CLR	ROW_2.1

CHECK_C:
	JB	P0.7, CHECK_ROW_3
	CLR	ROW_2.0

CHECK_ROW_3:
	SETB	P0.2
	CLR	P0.3

CHECK_STAR:
	JB	P0.4, CHECK_0
	CLR	ROW_3.3

CHECK_0:
	JB	P0.5, CHECK_HASH
	CLR	ROW_3.2

CHECK_HASH:
	JB	P0.6, CHECK_D
	CLR	ROW_3.1

CHECK_D:
	JB	P0.7, CHECK_FINISHED
	CLR	ROW_3.0

CHECK_FINISHED:
	SETB	P0.3

	MOV	A, ROW_0
	ANL	A, ROW_0
	MOV	P1, A

	MOV	A, ROW_1
	ANL	A, ROW_1
	MOV	P1, A

	MOV	A, ROW_2
	ANL	A, ROW_2
	MOV	P1, A

	MOV	A, ROW_3
	ANL	A, ROW_3
	MOV	P1, A


	JMP	LOOP