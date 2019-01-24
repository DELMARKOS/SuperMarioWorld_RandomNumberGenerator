TITLE PROGRAM
DATA SEGMENT
 seed1 DB 066h;$148B
 seed2 DB 08FH;$148C
 output1 DB 0E9H;$148D
 output2 DB 0A6H;$148E
 DIG db 0;temp
DATA ENDS
COMMAND SEGMENT
MAINBODY: 
 MOV AX,DATA
 MOV DS,AX
 ;accumulator->al
 ;index register->bl
 START:;routine
 
 call get_rand
 
 MOV AL,output1
 call print_two_hex_digits

 MOV AL,output2
 call print_two_hex_digits
 call print_cr_lf
 
 JMP START
 
 MOV AH,4CH
 INT 21H

get_rand proc
    push AX
    push BX
    
    MOV BL,01h
    
    call TickRNG;to produce output1
    
    DEC BL
    
    call TickRNG;to produce outout2

    pop BX
    pop AX
ret
get_rand endp

tickrng proc
    PUSH AX
    PUSH BX
    
    MOV AL,seed1
    SHL AL,2
    
    STC;SET CARRY FLAG == CF <- 1
    
    ADC AL,seed1
    MOV seed1,AL
    
    SHL seed2,1    
    
    MOV AL,20H 
    
    ;SAVE CARRY
    ;MOV CL,AL
    
    RCL CH,1    
    
    AND AL,seed2;will change the zero flag
    ;CMP AL,seed2;wont change the zero flag
    
    RCR CH,1
    
    JNC Label1
    JZ Label3
    JNE Label2;JNZ Label2
    
    
    Label1:JNE Label3
    Label2:INC seed2
    Label3:MOV AL,seed2
    
    XOR AL,seed1
    
    CMP BL,1
    JZ MOVTOUTPUT2
    MOV output1,AL
    JMP RETURN
    
    MOVTOUTPUT2:
    MOV output2,AL
    
    RETURN:
    POP AX
    POP BX
ret
tickrng endp

print_two_hex_digits proc
 PUSH AX
 PUSH BX 
  
  MOV AH,0
  
  MOV BL,16
  DIV BL
  
  MOV DIG,AL
  
  call print_one_hex_digit
  
  MOV DIG,AH
  
  call print_one_hex_digit
 
 POP BX
 POP AX
ret
print_two_hex_digits endp

print_one_hex_digit proc
    push AX
    push DX
    
    CMP DIG,09H
    JBE lessthan9
 
    ;ABOVE 9
    MOV DL,DIG
    ADD DL,37H
    MOV AH,02
    INT 21H
    JMP OVER
 
    lessthan9:
    MOV DL,DIG
    ADD DL,30H
    MOV AH,02
    INT 21H    
    
    OVER:
    pop DX
    pop AX
    ret
print_one_hex_digit endp

print_cr_lf proc
push AX
push DX

;CR - LF
MOV DL,10
MOV AH,02H
INT 21h
    
MOV DL,13
MOV AH,02H
INT 21h

pop DX
pop AX
ret
print_cr_lf endp

COMMAND ENDS
SOROS SEGMENT STACK
db 256 dup(0)
SOROS ENDS
END MAINBODY