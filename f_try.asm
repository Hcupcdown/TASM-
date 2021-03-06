.486
DATA    SEGMENT USE16
MESG    DB  'B16040530',0DH,0AH,'$'
OLD1C   DD  ?
OLD09	DD	?
COUNT   DB  10
ICOUNT  DB  18
DATA    ENDS
CODE    SEGMENT USE16
        ASSUME  CS:CODE, DS:DATA
BEG:    MOV AX, DATA
        MOV DS, AX
        CLI
        CALL    READ1C
        CALL    WRITE1C
        STI
SCAN:   CMP     COUNT,	0
        JNZ     SCAN
        CLI
        CALL    RESET1C
        STI
        MOV     AH,4CH
        INT     21H
;------------------------------
SERVICE PROC
        PUSHA
        PUSH    DS
        MOV     AX, DATA
        MOV     DS, AX
		MOV		AH,	01H
		INT		16H
		JZ		ENDCOUNT
		MOV		COUNT,	0
ENDCOUNT:
        DEC     ICOUNT
        JNZ     EXIT
		LEA		DX,	MESG
		MOV		AH,	09H
		INT		21H
        MOV     ICOUNT, 18
EXIT:   POP     DS
        POPA
        IRET
SERVICE ENDP
;---------------------------
READ1C  PROC
        MOV     AX, 351CH
        INT     21H
        MOV     WORD PTR OLD1C, BX
        MOV     WORD PTR OLD1C+2,ES
        RET
READ1C  ENDP
;----------------------------
WRITE1C PROC
        PUSH    DS
        MOV     AX, CODE
        MOV     DS, AX
        MOV     DX, OFFSET  SERVICE
        MOV     AX, 251CH
        INT     21H
        POP     DS
        RET
WRITE1C ENDP
;-----------------------------
RESET1C PROC
        MOV     DX,WORD PTR OLD1C
        MOV     DX,WORD PTR OLD1C+2
        MOV     AX,251CH
        INT     21H
        RET
RESET1C ENDP

CODE    ENDS
        END     BEG