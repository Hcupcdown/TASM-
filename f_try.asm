.486
DATA    SEGMENT USE16
MESG    DB  'B16040530',0DH,0AH,'$'
OLD1C   DD  ?
ICOUNT  DB  18
COUNT   DB  10
DATA    ENDS
CODE    SEGMENT USE16
        ASSUME  CS:CODE, DS:DATA
BEG:    MOV AX, DATA
        MOV DS, AX
        CLI
        CALL    READ1C
        CALL    WRITE1C
        STI
		MOV		COUNT,	0
SCAN:	MOV		AX, 07H
		INT		21H
		MOV		COUNT,	AL
		CMP     COUNT,	0
        JZ	    SCAN
        CALL    RESET
        MOV     AH,4CH
        INT     21H
;------------------------------
SERVICE PROC
        PUSHA
        PUSH    DS
        MOV     AX, DATA
        MOV     DS, AX
        DEC     ICOUNT
        JNZ     EXIT
        MOV     ICOUNT, 18
        MOV     AH, 9
        LEA     DX, MESG
        INT     21H
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
RESET   PROC
        MOV     DX,WORD PTR OLD1C
        MOV     DX,WORD PTR OLD1C+2
        MOV     AX,251CH
        INT     21H
        RET
RESET   ENDP
CODE    ENDS
        END     BEG