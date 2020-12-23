DATA SEGMENT
    EVEN DB "THE NUMBER IS EVEN$"
    ODD DB "THE NUMBER IS ODD$"
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
    
    MOV BX,24   ;INPUT NUMBER
    
    PUSH BX
        
    MOV PROCLOC,ODDEVEN
    MOV PROCLOC+2,PROCEDURES
    
    CALL FAR PROCLOC
    
    HLT                    
CODE ENDS
            
            
PROCEDURES SEGMENT
    ODDEVEN PROC FAR
        ASSUME CS:PROCEDURES
        MOV BP,SP
        MOV AX,[BP+4]
        AND AX,1H
        JZ E
        
        MOV AH,09H
        LEA DX,ODD
        INT 21H
        JMP DONE
        
        E:
        MOV AH,09H
        LEA DX,EVEN
        INT 21H 
       
        DONE:
        MOV AH,09H
        LEA DX,NEWLINE
        INT 21H
           
        RETF
    ODDEVEN ENDP
PROCEDURES ENDS

END START