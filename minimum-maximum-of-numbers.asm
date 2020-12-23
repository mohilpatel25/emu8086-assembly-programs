DATA SEGMENT
    ARRAY DB 1H,12H,25H,0H,2H
    COUNT DB $-ARRAY
    MIN DB ?
    MAX DB ?
DATA ENDS

CODE SEGMENT
    START:
    ASSUME CS:CODE,DS:DATA
    MOV AX,DATA
    MOV DS,AX
    
    MOV AX,0H
    MOV CL,COUNT
    MOV SI,OFFSET ARRAY
               
    MOV AL,[SI]
    MOV MAX,AL
    MOV MIN,AL
    
LOOP_L:
    MOV AL,[SI]
    CMP AL,MAX
    JG GREAT
    JMP NXT

GREAT:
    MOV MAX,AL
    
NXT:
    CMP MIN,AL
    JG SMALL
    JMP NXT2

SMALL:
    MOV MIN,AL

NXT2:
    INC SI
    LOOP LOOP_L
            
CODE ENDS
END START