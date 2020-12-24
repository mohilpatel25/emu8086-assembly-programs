DATA SEGMENT
    DISPIN DB "ENTER INFIX EXPRESSION: $"
    DISPPOST DB "POSTFIX EXPRESSION: $"
    NEWLINE DB 10,13,'$'
    INFIX DB 50 DUP('$')
    LEN DB ?
    POSTFIX DB LEN DUP(0)
    CUR DB 0    
DATA ENDS

STACK_SEG SEGMENT
    DW 100 DUP(0)
    TOS LABEL WORD
STACK_SEG ENDS

CODE SEGMENT
    ASSUME CS:CODE,DS:DATA,SS:STACK_SEG
START:
    MOV AX,DATA
    MOV DS,AX
    MOV AX,STACK_SEG
    MOV SS,AX
    LEA SP,TOS
   
    MOV AH,09H
    LEA DX,DISPIN
    INT 21H
    
    MOV AH,0AH
    LEA DX,INFIX
    INT 21H
    
    MOV AH,09H
    LEA DX,NEWLINE
    INT 21H
    
    MOV CL,[INFIX+1]
    MOV LEN,CL
    
    LEA SI,INFIX
    INC SI
    INC SI
    LEA DI,POSTFIX
    
    
    
    MOV AX,"&"
    PUSH AX
    
    LOOP1:
        MOV AL,[SI]
        MOV CUR,AL  
        
        CMP AL,"/"
        JE OPERATOR
        CMP AL,"*"
        JE OPERATOR
        CMP AL,"+"
        JE OPERATOR
        CMP AL,"-"
        JE OPERATOR
        CMP AL,"^"
        JE OPERATOR
        CMP AL,"("
        JE OPERATOR
        CMP AL,")"
        JE OPERATOR
        
        MOV [DI],AL
        INC DI
        JMP SKIPELSE      
                    
        OPERATOR:
        CMP CUR,"("
        JNE CONT
        MOV AX,"("
        PUSH AX
        JMP SKIPELSE         
        
        CONT:
        CMP CUR,")"
        JNE CONT2
        
        LOOP2:
            POP BX
            MOV [DI],BL
            INC DI
            MOV BP,SP
            CMP [BP],"("
            JE OUTER
            CMP [BP],"&"
            JE OUTER
            LOOP LOOP2
        
        OUTER:
            MOV AL,"(" 
            MOV BP,SP
            MOV AH,[BP]    
            CMP AH,AL
            JNE OUTER2
            POP BX
        
        OUTER2:
            JMP SKIPELSE
               
        CONT2:
        LOOP3:
            MOV AX,"&"
            CMP [SI],AL
            JE OUTER3    
            XOR DX,DX
            MOV AL,CUR
            CALL PREC
            MOV DH,DL
            MOV BP,SP
            MOV AL,[BP]
            CALL PREC
            
            CMP DL,DH
            JL OUTER3
            POP BX
            MOV [DI],BL
            INC DI
            LOOP LOOP3
            
            OUTER3:
                XOR AX,AX
                MOV AL,CUR
                PUSH AX
            
        SKIPELSE:        
        DEC LEN
        INC SI
        CMP LEN,0
        LOOPNE LOOP1
    
    
    MOV AL,"&"
    MOV BP,SP
    MOV AH,[BP]
    CMP AH,AL
    JE DONE
    
    LOOPFINAL:
        POP AX
        MOV [DI],AL
        INC DI
        MOV AL,"&"
        MOV BP,SP
        MOV AH,[BP]
        CMP AH,AL
        LOOPNE LOOPFINAL
        
    JMP DONE
    
    PREC PROC NEAR
        CMP AL,"^"
        JNE D
        MOV DL,3
        RET
        
        D:
        CMP AL,"/"
        JNE M
        MOV DL,2
        RET
        
        M:
        CMP AL,"*"
        JNE A
        MOV DL,2
        RET
        
        A:
        CMP AL,"+"
        JNE S
        MOV DL,1
        RET
        
        S:
        CMP AL,"-"
        JNE RTN
        MOV DL,1
        RET
        
        RTN:
        MOV DL,0
         
        RET
    PREC ENDP
        
    DONE:
    MOV [DI],'$'
    
    MOV AH,09H
    LEA DX,DISPPOST
    INT 21H
    
    MOV AH,09H
    LEA DX,POSTFIX
    INT 21H

CODE ENDS
END START
