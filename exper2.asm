.486
DATA	SEGMENT	USE16
	USER	DB  'root'
	PASSWD	DB	'123456'							
	PRINT0	DB	'please enter you username and password',0AH,'username:','$'
	PRINT1	DB	0AH,'password:$'
	PRINT2	DB	0AH,'usernmae or password error',0AH,'$'
	WELCOME DB  0AH,'WELCOME!$'
	INUSER	DB	15
			DB	?
			DB	15	DUP(?)
	INPASSWD	DB	15	DUP(?)
DATA	ENDS
CODE	SEGMENT	USE16
	ASSUME	CS:CODE,DS:DATA
BEG:
	MOV	AX,	DATA
	MOV	DS,	AX
	MOV DX,	OFFSET	PRINT0      ;�����ʾ��Ϣ
	MOV AH,	9H
	INT	21H
	MOV	DX,	OFFSET	INUSER      ;���մӼ���������ַ���
	MOV	AH,	0AH
	INT	21H
	MOV DX,	OFFSET	PRINT1      ;�����ʾ��Ϣ
	MOV AH,	9H
	INT	21H
	MOV	BX,	OFFSET	INPASSWD
	MOV	CX,	6
SPASSWD:                        ;ѭ�����մӼ�����������룬������
	MOV	AH,	7H
	INT 21H
	MOV [BX],	AL
	INC	BX
LOOP	SPASSWD
	MOV	CX,	4
	MOV	BX,	OFFSET INUSER
	INC	BX
	INC	BX
	MOV	SI,	OFFSET USER
CMPUSER:                        ;�Ƚ������û�����Ԥ���Ƿ���ͬ
    MOV AL,[SI]
	CMP	[BX],	AL
	JNZ NO
	INC BX
	INC SI
LOOP	CMPUSER
	MOV	CX,	6
	MOV	BX,	OFFSET INPASSWD
	MOV	SI,	OFFSET PASSWD
CMPPASSWD:                       ;�Ƚ�������Ԥ���Ƿ���ͬ
	MOV AL,[SI]
	CMP	BYTE PTR [BX],	AL
	JNZ	NO
	INC BX
	INC SI
LOOP	CMPPASSWD
	MOV DX,	OFFSET	WELCOME
	MOV AH,	9H
	INT	21H
	MOV	AH,	4CH
	INT	21H
NO:
    MOV DX,	OFFSET	PRINT2
	MOV AH,	9H
	INT	21H
    LOOP BEG                     ;���������󣬼����ص��������
CODE	ENDS
	END	BEG