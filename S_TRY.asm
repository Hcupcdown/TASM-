.486
DATA    SEGMENT USE16
MESG    DB  '23:59:50',0DH,'$'
OLD1C   DD  ?
ICOUNT  DB  18
COUNT0  DB  1
DATA    ENDS
CODE    SEGMENT USE16
        ASSUME  CS:CODE, DS:DATA
BEG:    MOV AX, DATA
        MOV DS, AX
        CLI
        CALL    READ1C
        CALL    WRITE1C
        STI
SCAN:   CMP     COUNT0,	0
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
        DEC     ICOUNT
        JNZ     EXIT
        MOV     BX, OFFSET  MESG
        INC     BYTE PTR [BX+7]
        CMP     BYTE PTR [BX+7], 3AH
        JNZ     NEXT0
        MOV     BYTE PTR [BX+7], 30H
        INC     BYTE PTR [BX+6]
        CMP     BYTE PTR [BX+6], 36H
        JNZ     NEXT0
        MOV     BYTE PTR [BX+6], 30H
        INC     BYTE PTR [BX+4]
        CMP     BYTE PTR [BX+4], 3AH
        JNZ     NEXT0
        MOV     BYTE PTR [BX+4], 30H
        INC     BYTE PTR [BX+3]
        CMP     BYTE PTR [BX+3], 36H
        JNZ     NEXT0
        MOV     BYTE PTR [BX+3], 30H
        INC     BYTE PTR [BX+1]
        CMP     BYTE PTR [BX],  32H
        JZ      JUDGE
JUDGE:  CMP     BYTE PTR [BX+1], 34H
        JNZ     NEXT1
        MOV     BYTE PTR [BX+1],30H
        MOV     BYTE PTR [BX],  30H
NEXT1:  CMP     BYTE PTR [BX+1], 3AH
        JNZ     NEXT0
        INC     BYTE PTR [BX]
        MOV     BYTE PTR [BX+1],30H

NEXT0:  MOV     AH, 9
        LEA     DX, MESG
        INT     21H
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