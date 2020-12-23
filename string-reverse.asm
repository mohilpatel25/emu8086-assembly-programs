DATA SEGMENT
    STR DB 20 DUP('$')
    NEWLINE DB 10,13,'$'
DATA ENDS                  

CODE SEGMENT
    START:
    ASSUME CS:CODE, DS:DATA
    MOV AX,DATA
    MOV DS,AX

    MOV AH,0AH
    LEA DX,STR
    INT 21H
    
    MOV AH,09H
    LEA DX,NEWLINE
    INT 21H
          
    MOV AX,0H
    MOV AL,[STR+1]
    MOV BL,2H
    DIV BL
    
    MOV CL,AL
          
    LEA BP,STR+2
    LEA BX,STR+1
    ADD BL,[STR+1]
     
REVERSE:
    MOV DH,[BP]
    MOV DL,[BX]
    MOV [BP],DL
    MOV [BX],DH
    INC BP
    DEC BX
    LOOP REVERSE
    
    MOV AH,09H
    LEA DX,STR+2
    INT 21H
                    
CODE ENDS
END START