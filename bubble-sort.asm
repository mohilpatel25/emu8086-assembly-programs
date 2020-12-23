DATA SEGMENT
    ORIGINAL DB 12H,25H,1H,12H,10H,35H,9H
    COUNT DB $-A
    SORTED DB ?
DATA ENDS                  

CODE SEGMENT
    START:
    ASSUME CS:CODE, DS:DATA
    MOV AX,DATA
    MOV DS,AX

    MOV CL,COUNT
    MOV AX,0H
    MOV BX,OFFSET ORIGINAL
    MOV SI,OFFSET SORTED
    
    COPY:
        MOV AL,[BX]
        MOV [SI],AL
        INC BX
        INC SI
        LOOP COPY
    
    MOV AX,0H
    MOV CX,0H
    DEC COUNT
    
    OUTER:
        MOV CX,0H
        MOV CL,COUNT
        MOV BX,OFFSET SORTED
        INNER:
            MOV AH,[BX]
            MOV AL,[BX+1]
            CMP AH,AL
            JG SWAP
            JMP NEXT
            SWAP:
                MOV [BX],AL
                MOV [BX+1],AH
            
            NEXT:
                INC BX
                LOOP INNER    
        
        DEC COUNT
        CMP COUNT,0H
        LOOPNZ OUTER
                
CODE ENDS
END START