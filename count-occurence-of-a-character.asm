DATA SEGMENT
    STR DB 20 DUP('$')
    CHAR DB 4 DUP('$')
    NEWLINE DB 10,13,'$'
    ANS DB 4 DUP('$')
DATA ENDS                  

CODE SEGMENT
    START:
    ASSUME CS:CODE, DS:DATA
    MOV AX,DATA
    MOV DS,AX
    
    XOR AX,AX
    
    MOV AH,0AH
    LEA DX,STR
    INT 21H
          
    MOV AH,09H
    LEA DX,NEWLINE
    INT 21H
          
    MOV AH,0AH
    LEA DX,CHAR
    INT 21H  
    
    MOV AH,09H
    LEA DX,NEWLINE
    INT 21H
    
    MOV CX,0      
    MOV CL,[STR+1]
    MOV BX,0
    MOV DX,0
    LEA BP,[STR+2]
               
COUNT:
    MOV DL,[BP]
    CMP [CHAR+2],DL
    JNE SKIP
    INC BX
    SKIP:
    INC BP
    LOOP COUNT
    
    XOR AX,AX
    MOV AX,BX
    ADD AX,0H
    DAA
    
    MOV BX,AX
    AND BX,0FH
    ADD BX,30H
    MOV [ANS+1],BL
    
    MOV BX,AX
    AND BX,0F0H
    SHR BX,4
    ADD BX,30H
    MOV [ANS],BL
    
    MOV AH,09H
    LEA DX,ANS
    INT 21H
                    
CODE ENDS
END START