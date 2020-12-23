DATA SEGMENT
    PRIME DB "THE NUMBER IS PRIME$"
    NOTPRIME DB "THE NUMBER IS NOT PRIME$"
    ONE DB "1 IS NEITHER PRIME NOR COMPOSITE$"
    NEWLINE DB 10,13,'$'
    PROCLOC DD ?
DATA ENDS

STACKSEGMENT SEGMENT STACK
    DW 40 DUP(0)
    STACKTOP LABEL WORD
STACKSEGMENT ENDS

CODE SEGMENT
    START:
    ASSUME CS:CODE, DS:DATA, SS:STACKSEGMENT
    MOV AX,DATA
    MOV DS,AX
    
    MOV AX,STACKSEGMENT
    MOV SS,AX
    LEA SP,STACKTOP
        
    MOV AX,0H
    
    MOV BX,17   ;INPUT NUMBER
    
    PUSH BX
        
    MOV PROCLOC,PRIMECHECK
    MOV PROCLOC+2,PROCEDURES
    
    CALL FAR PROCLOC
    
    HLT                    
CODE ENDS
            
            
PROCEDURES SEGMENT
    PRIMECHECK PROC FAR
        ASSUME CS:PROCEDURES
        MOV BP,SP
        MOV DX,[BP+4]
        MOV AX,DX
        MOV CX,DX
        DEC CL
        
        CMP AX,1
        JE ONELABEL
        
        LP:
        DIV CL
        CMP AH,0H
        JE NPRIME
        MOV AX,DX
        CMP CL,2H
        LOOPNE LP
        
        MOV AH,09H
        LEA DX,PRIME
        INT 21H
        JMP DISP
        
        NPRIME:
        MOV AH,09H
        LEA DX,NOTPRIME
        INT 21H
        JMP DISP
        
        ONELABEL:
        MOV AH,09H
        LEA DX,ONE
        INT 21H
        JMP DISP
        
        DISP:
        MOV AH,09H
        LEA DX,NEWLINE
        INT 21H
        JMP RETURN
        
        RETURN:        
        RETF
    PRIMECHECK ENDP
PROCEDURES ENDS

END START