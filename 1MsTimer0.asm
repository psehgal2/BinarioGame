;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                            ;
;                              1MsTimer0.asm                                 ;
;                            Timer Functions                                 ;
;             Event Handler and Timer Initialization Functions               ;
;                                                                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; This file contains the functions for initializing the timer and setting up 
; the event handler 
; The public functions included are:
;    Timer0InterruptHandler1Ms   - sets up the event handler
;    OneMsTimer0Init   - initializes the 1Ms timer
;
; Revision History:
;    04/29/22  Purvi Sehgal             wrote the timer initialization function
;    04/29/22  Purvi Sehgal             wrote the event handler function
;    04/30/22  Purvi Sehgal             debugged code - didn't correctly 
;                                       push and pop SREG
;    05/01/22  Purvi Sehgal             demo'd       


.cseg


;Description:             This method debounces the switches and handles the 
;                         rotations of the encoders. It also multiplexes for 
;                         and updates the 64 LEDs based on the RedBuffer and 
;                         GreenBuffer values. The function is exited once all 
;                         methods are called. Also, if switches are pressed 
;                         extremely quickly, the presses won’t all be counted, 
;                         but the program does not handle this error. 
;Operational Description: This method works by calling five other methods. 
;                         The first method handles the rotations of up/down 
;                         rotary encoder, the second handles the rotations of 
;                         the left/right encoder, the third debounces the left
;                         /right switch, the fourth debounces the up/down switch
;                         ,and the fifth multiplexes the 64 pixels on the LED 
;                         component. 
;Arguments:               None
;Return Values:           None
;Global Variables:        None
;Shared Variables:        None
;Local Variables:         None
;Inputs:                  None
;Outputs:                 None
;User Interface:          The user rotates the LR, UD encoders and/or presses 
;                         the LR, UD switches. 
;Error Handling:          If the user pushes the switch at a rate of more 
;                         than 1/20 milliseconds, the clicks will not be 
;                         counted. This error is ignored. 
;Algorithms:              None
;Data Structures:         None
;Limitations:             Not all clicks may be counted if they are done 
;                         fast enough. Also, the frequent interrupts may 
;                         slow the program down overall (yet provide a 
;                         faster response) 
;Known Bugs:              None                     


Timer0InterruptHandler1Ms:       ;start initialize event handler
         PUSH  R1
		 IN    R1, SREG         ;Puts the flags into R1
         PUSH  R1               ;pushes the register to the stack
		 PUSH  YL
		 PUSH  YH
		 PUSH  ZL
		 PUSH  ZH
		 PUSH  R16
		 PUSH  R17       
		 PUSH  R18
		 PUSH  R19
		 PUSH  R20              ;push all used registers to save them
		 PUSH  R21
		 PUSH  R22
		 PUSH  R23
         RCALL LREncoder        ;calls the LR encoder
		 RCALL UDEncoder        ;calls the UD encoder
		 RCALL SwitchUDDebounce ;calls the UD switch debouncer
		 RCALL SwitchLRDebounce ;calls the LR switch debouncer
         RCALL Multiplexer      ;calls the Multiplexer function
         POP   R23
		 POP   R22
		 POP   R21
		 POP   R20
		 POP   R19
		 POP   R18
		 POP   R17
		 POP   R16
		 POP   ZH
		 POP   ZL
		 POP   YH
		 POP   YL
		 POP   R1
         OUT   SREG, R1
		 POP   R1
         RETI                  ;returns from this function back to the 
                               ;function that called it and sets the 
							   ;interrupt flag




;Description:             This method initializes the timer. Also, if the 
;                         switches are pressed extremely quickly, the 
;                         presses won’t all be counted, but the program 
;                         does not handle this error. 
;Operational Description: This sets the timer to generate an interrupt 
;                         every millisecond. 
;Arguments:               None
;Return Values:           None
;Global Variables:        None
;Shared Variables:        None
;Local Variables:         None
;Inputs:                  None
;Outputs:                 None
;User Interface:          None
;Error Handling:          If the user pushes the switch at a rate of more 
;                         than 1/20 milliseconds, the clicks will not 
;                         be counted. This error is ignored. 
;Algorithms:              None
;Data Structures:         None
;Limitations:             Not all clicks may be counted if they are done 
;                         fast enough. Also, the frequent interrupts 
;                         may slow the program down overall (yet 
;                         provide a faster response) 
;Known Bugs:              None                     


OneMsTimer0Init:                  ;start initialize 1 ms timer function
         LDI    R16, TCCR0_BYTE   
         OUT    TCCR0, R16        ;sets prescaler to 64
         LDI    R17, TIMSK_BYTE  
         OUT    TIMSK, R17        ;timer overflow interrupt enable
         LDI    R18, OCR0_BYTE   
         OUT    OCR0, R18         ;sets compare register value to 250
         RET                      ;terminates function

.dseg
