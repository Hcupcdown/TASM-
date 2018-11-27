.486
DATA  SEGMENT    USE16              ;关键字中间多了空格
SUM   DB    ?,?                     ;末尾多了逗号
MESG  DB    '25+9='
	  DB    0,0,'$'					;字符串结尾应该加上'$'表示结束
N1    DB    9,0F0H                  ;十六进制以字母开头要加0
N2    DB    25	                    ;DW导致后面类型不匹配,将其改为BYTE型
DATA  ENDS
CODE  SEGMENT     USE16
	ASSUME      CS:CODE,   DS:DATA
BEG:  
	MOV   AX,   DATA
	MOV   DS,   AX
	MOV   BX,   OFFSET SUM
	MOV   AH,   N1
	MOV   AL,   N2
	ADD   AH,   AL					
	MOV   [BX], AH
	CALL  CHANG
	MOV   AH,   9
	MOV   DX,   OFFSET MESG			;关键字拼写错误
	INT   21H
	MOV   AH,   4CH
	INT   21H
CHANG     PROC						;不需要冒号
LAST: 
	CMP	  BYTE PTR [BX], 10
	JC    NEXT
	SUB   BYTE PTR [BX], 10  
	INC   BYTE PTR [BX+7]
	JMP   LAST
NEXT:
	MOV   AL,	SUM					;ADD的操作数不能同为内存操作数，需要用寄存器中转								
	ADD   [BX+8],     AL
	ADD   BYTE PTR [BX+7],     30H	        ;目标操作数为间址内存操作数，源操作数为立即数，必须用PTR声明
	ADD   BYTE PTR [BX+8],     30H
	RET
CHANG     ENDP						;不需要冒号
CODE	 ENDS
      END	BEG