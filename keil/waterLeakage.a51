org 00h
//PIN3.4 =COUNTER1   PIN3.5=COUNTER2(REDUCTION IN COUNT REPRESNT LEAK)
//PORT1 FOR LCD DATA LINE & P2.1=RS  P2.2=Enable VDD=5V  VSS,VEE(CONTRAST),RW ARE GROUNDED
//CURRENTLY IT WILL CHECK FOR 10COUNTS PER CYCLE FOR COUNTER1
//IF COUNT ON COUNTER2 IS =<5 REPRESENT LEAK
//P2.6 IS USED FOR BUZZER OR LED TO REPRESNT LEAK

	CLR P2.6
	mov tmod,#01010110B
	
	Mov A, #38H     // use 2 lines and 5*7 
	ACALL com    
	MOV A, #0EH   //cursor blinking off 
	ACALL com    
	MOV A, #80H   // force cursor to first line 
	ACALL com  
	MOV A, #01H     //clr screen
	ACALL com   

	MOV DPTR ,#welSTR
	wel : MOV A,#00H   
	MOVC A,@A+DPTR    
	JZ FINS      
	ACALL L_D    
	INC DPTR    
	SJMP wel    
	FINS: acall DEL_ROUTINE 
	lJMP again
	welSTR: DB'CHECKING STATUS',0
		
		
again:mov tl0,#00h //intailaising value
	mov tl1,#00h
	mov b,#00h
back:setb tr0 //start counter0
	setb tr1 //start counder1
	mov a,tl0
	mov b,tl1
	cjne a, #10, back // count for 30 pulse
	mov a, tl1
	cjne a, 5, not_equal
	sjmp leak_found
not_equal: jnc next // jump if a>5
	sjmp leak_found
next: sjmp no_leak //a<5

leak_found:setb P2.6 
	sjmp disp_leak

no_leak:CLR P2.6
	sjmp disp_noleak


disp_leak:Mov A, #38H     // use 2 lines and 5*7 
	ACALL com    
	MOV A, #0EH   //cursor blinking off 
	ACALL com    
	MOV A, #80H   // force cursor to first line 
	ACALL com  
	MOV A, #01H     //clr screen
	ACALL com   

	MOV DPTR ,#STR
	REV : MOV A,#00H   
	MOVC A,@A+DPTR    
	JZ FINISH      
	ACALL L_D    
	INC DPTR    
	SJMP REV    
	FINISH:acall DEL_ROUTINE 
	SJMP again    

	com: ACALL DEL_ROUTINE  
	MOV P1, A   
	CLR P2.1   //rs=0
	SETB P2.2
	CLR P2.2   
	RET    

	L_D: ACALL DEL_ROUTINE  
	MOV P1, A      
	SETB P2.1     
	SETB P2.2     
	CLR P2.2     
	RET       

	DEL_ROUTINE: MOV R0, #0FFH  
	L1: MOV R1, #0FFH   
	L2: DJNZ R1, L2    
	DJNZ R0, L1
	RET       
	STR: DB'!!LEAKAGE FOUND!!',0
		
disp_noleak:Mov A, #38H     // use 2 lines and 5*7 
	ACALL com    
	MOV A, #0EH   //cursor blinking off 
	ACALL com    
	MOV A, #80H   // force cursor to first line 
	ACALL com  
	MOV A, #01H     //clr screen
	ACALL com   

	MOV DPTR ,#noSTR
	Rit : MOV A,#00H   
	MOVC A,@A+DPTR    
	JZ FIN      
	ACALL L_D    
	INC DPTR    
	SJMP Rit    
	FIN: acall DEL_ROUTINE 
	lJMP again
	noSTR: DB'NO LEAKAGE FOUND',0
		

end