DATA SEGMENT
    STR DB 20 DUP('$')
    NEWLINE DB 10,13,'$'
    REVERSELOC DD ?
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

    MOV AH,0AH
    LEA DX,STR
    INT 21H
    
    MOV AH,09H
    LEA DX,NEWLINE
    INT 21H
    
    LEA SI,STR
    MOV BP,SP
    
    PUSH SI
    
    MOV REVERSELOC,REVERSE
    MOV REVERSELOC+2,PROCEDURES
    
    CALL FAR REVERSELOC
    
    POP SI
    
    ADD SI,2
    
    MOV AH,09H
    LEA DX,SI
    INT 21H
    
    HLT
                        
CODE ENDS
            
            
PROCEDURES SEGMENT
 
    REVERSE PROC FAR
        ASSUME CS:PROCEDURES
        
        MOV SI,[BP-2]
        
        MOV AX,0H
        MOV AL,[SI+1]
        MOV BL,2H
        DIV BL
        
        MOV CL,AL
              
        LEA DI,[SI+2]
        LEA BX,[SI+1]
        ADD BL,[SI+1]
        
        REV:
            MOV DL,[BX]
            MOV DH,[DI]
            MOV [DI],DL
            MOV [BX],DH
            INC DI
            DEC BX
        LOOP REV
        
        RETF
    REVERSE ENDP

PROCEDURES ENDS

END START