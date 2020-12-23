DATA SEGMENT
    STR DB 5 DUP('$')
    NEWLINE DB 10,13,'$'
    DISP DB 3 DUP('$')
    FIBLOC DD ?
DATA ENDS

CODE SEGMENT
    START:
    ASSUME CS:CODE, DS:DATA, SS:STACKSEGMENT
    MOV AX,DATA
    MOV DS,AX
        
    MOV AX,0H

    MOV AH,0AH
    LEA DX,STR
    INT 21H
    
    MOV AH,09H
    LEA DX,NEWLINE
    INT 21H
    
    MOV AH,09H
    LEA DX,NEWLINE
    INT 21H
    
    MOV FIBLOC,FIBONACCI
    MOV FIBLOC+2,PROCEDURES
    
    CALL FAR FIBLOC
    
    HLT                    
CODE ENDS
            
            
PROCEDURES SEGMENT
 
    FIBONACCI PROC FAR
        ASSUME CS:PROCEDURES
        XOR CX,CX
        MOV CL,[STR+2]
        SUB CL,30H
        CMP [STR+1],1
        JE FIB
        
        MOV AL,0AH
        MUL CL
        MOV CX,AX
        MOV AL,[STR+3]      
        SUB AL,30H
        ADD CL,AL
        
        FIB:
        CMP CX,0H
        JE DONE
        
        MOV AX,0H
        CALL PRINT
        DEC CX
        JZ DONE
        
        MOV AX,1H
        CALL PRINT
        DEC CX
        JZ DONE
        
        MOV BL,0H
        MOV BH,1H
        
        LP:
        MOV AL,BL
        ADD AL,BH
        CALL PRINT
        MOV AL,BL
        ADD AL,BH
        MOV BL,BH
        MOV BH,AL
        LOOP LP        
           
        DONE:
        RETF
    FIBONACCI ENDP
    
    PRINT PROC NEAR
        ADD AL,0H
        DAA
        MOV DL,AL
        
        AND DL,0FH
        ADD DL,30H
        MOV [DISP+1],DL
        
        MOV DL,AL
        AND DL,0F0H
        SHR DL,4H
        ADD DL,30H
        MOV [DISP],DL
        
        MOV AH,09H
        LEA DX,DISP
        INT 21H
        
        MOV AH,09H
        LEA DX,NEWLINE
        INT 21H
        
        RET
    PRINT ENDP
    
PROCEDURES ENDS

END START