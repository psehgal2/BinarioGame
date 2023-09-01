;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                            ;
;                           SwitchFunctions.asm                              ;
;                            Switch Functions                                ;
;    Initializations and Debouncing for Up/Down, Left/Right Switches         ;
;                                                                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; This file contains the functions for initializing and debouncing the switches
; The public functions included are:
;    InitSwitch            - initialize the switches
;    UDSwitch:             - initialize U/D switch function
;    LRSwitch              - initialize L/R switch function
;    SwitchLRDebounce:     - debounces the L/R switch 
;    SwitchUDDebounce:     - debounces the U/D switch 

;
; Revision History:
;    04/27/22  Purvi Sehgal             wrote initialization function
;    04/28/22  Purvi Sehgal             wrote UDSwitch and LRSwitch function
;    04/29/22  Purvi Sehgal             wrote LR/UD debounce functions
;    04/30/22  Purvi Sehgal             debugged code - didn't correctly define
;                                       constant for when switch is up
;    05/01/22  Purvi Sehgal             demo'd                                                                                                                                                                             




.cseg


;Description: This method initializes all the variables needed for the U/D and 
;             L/R switches.
;Operational Description: This method sets all the flags to zero and sets 
;                         the debounce control variables (one for the left/right 
;                         switch and one for the up/down switch) used in the 
;                         switch debounce method equal to a constant, the 
;                         debounce time. 
;Arguments: None
;Return Values: None
;Global Variables: None
;Shared Variables: All the following variables are set: UD_switchFlag, 
;                  LR_switchFlag, debounce_cntrUD, and debounce_cntrLR. 
;Local Variables: None
;Inputs: None
;Outputs: None
;User Interface: None
;Error Handling: None
;Algorithms: None
;Data Structures: None
;Limitations: None
;Known Bugs: None


InitSwitch:            ;start initialize switch function
         LDI    R16, FALSE   ;loads false into the R16 register
		 STS    LRSwitchFlag, R16  ;sets the L/R switch flag variable equal 
                                   ;to the register with FALSE in it
		 STS    UDSwitchFlag, R16  ;sets the U/D switch flag variable equal 
                                   ;to the register with FALSE in it
		 LDI    R17, DEBOUNCE_TIME  ;sets the register equal to the debounce 
                                    ;time constant
		 STS    debounceCntrUD, R17 ;stores the register value with debounce 
                                    ;time into the debounceCntrUD variable 
		 STS    debounceCntrLR, R17 ;stores the register value with debounce 
                                    ;time into the debounceCntrLR variable
		 RET           ;returns from this function back to the function that 
                       ;called it


;Description: This method returns TRUE with the zero flag set if the left/right 
;             switch is pressed since it was last called. 
;             Otherwise, it returns FALSE with the zero flag reset. The function
;             exits when something is returned/the zero flags are set, 
;             and, while we can’t interrupt the program while this function is 
;             running, we do nothing to handle this error.
;Operational Description: This method first turns off the interrupt since it 
;                         changes variables that are in the interrupt handler. 
                          ;If the UD_switchFlag is on, it turns the flag off, 
                          ;returns true, and sets the zero flag. 
                          ;Otherwise, it returns false and resets the zero flag. 
                          ;Then, the interrupt flag is restored. 
;Arguments: None
;Return Values: Returns true or false depending on the 
;               UD_switchFlag value
;Global Variables: None
;Shared Variables: the UD_switchFlag is first accessed and set to zero if the 
;                  flag is initially equal to 1.
;Local Variables: None
;Inputs: None
;Outputs: None
;User Interface: None
;Error Handling: None
;Algorithms: None
;Data Structures: None
;Limitations: If we want to interrupt the program while this method is running…
;             (for example if the user wants to exit the game), then that is 
;             delayed since the interrupt is turned off.
;Known Bugs: None

UDSwitch:            ;start initialize U/D switch function
         IN R0, SREG ;Takes all the flags in SREG and stores them in the R17 
                     ;register
		 CLI          ;Clears the interrupt flag
         LDS R18, UDSwitchFlag ;loads the flag into the register
         LDI R16, FALSE   ;loads false into the R16 register
		 STS UDSwitchFlag, R16  ;sets the U/D switch flag variable equal to 
                                ;the register with FALSE in it
		 OUT SREG, R0 ;resets the flags in the S register to the original 
                      ;values stored in R17
         CPI R18, TRUE ;Sets the zero flag if the UDSwitchFlag equals 1
		 RET           ;returns from this function back to the function 
                       ;that called i


;Description: This method returns TRUE with the zero flag set if the 
;             left/right switch is pressed since it was last called. 
;             Otherwise, it returns FALSE with the zero flag reset. The function 
;             exits when something is returned/the zero flags are set, and, 
;             while we can’t interrupt the program while this function is running, 
;             we do nothing to handle this error.
;Operational Description: This method first turns off the interrupt since 
;                         it changes variables that are in the interrupt 
;                         handler. If the LR_switchFlag is on, it turns the flag 
;                         off, returns true, and sets the zero flag. Otherwise, 
;                         it returns false  and resets the zero flag. Then, the 
;                         interrupt flag is restored. 
;Arguments: None
;Return Values: Returns true or false depending on the LR_switchFlag value
;Global Variables: None
;Shared Variables: the LR_switchFlag is first accessed and set to zero if the flag 
;                  is initially equal to 1.
;Local Variables: None
;Inputs: None
;Outputs: None
;User Interface: None
;Error Handling: None
;Algorithms: None
;Data Structures: None
;Limitations: If we want to interrupt the program while this method is running…
;             (for example if the user wants to exit the game), then that is 
;             delayed 
;             since the interrupt is turned off.
;Known Bugs: None

LRSwitch:            ;start initialize L/R switch function
         IN R0, SREG ;Takes all the flags in SREG and stores them in the R17 
                     ;register
		 CLI          ;Clears the interrupt flag
         LDS R18, LRSwitchFlag ;loads the flag into the register
         LDI R16, FALSE   ;loads false into the R16 register
		 STS LRSwitchFlag, R16  ;sets the L/R switch flag variable equal to the 
                                ;register with FALSE in it
		 OUT SREG, R0 ;resets the flags in the S register to the original 
                      ;values stored in R17
         CPI R18, TRUE ;Sets the zero flag if the LRSwitchFlag equals 1
		 RET           ;returns from this function back to the function 
                       ;that called it



;Description: This method debounces for the up/down switch. It updates the 
;             UD_switchFlag once the debounce_cntrUD decrements to zero. 
;             This code is called every interrupt. 
;Operational Description: This method sets the variable, debounce_cntrUD, 
;                         equal to a debounce time constant and then 
;                         decrements it until it hits zero. When it hits zero, 
;                         the method sets the switch flag. Every time 
;                         debounce_cntrUD becomes less than zero, the method 
;                         sets it equal to zero. 
;Arguments: None 
;Return Values: None
;Global Variables: None
;Shared Variables: The following variables are modified: debounce_cntrUD 
;                  and UD_switchFlag 
;Local Variables: None
;Inputs: The up and down pressing switch
;Outputs: None
;User Interface: The user presses the up/down switch 
;Error Handling: If the user presses the switch too fast, the presses 
;                will not be counted. This error is ignored. 
;Algorithms: None
;Data Structures: None 
;Limitations:  Not all clicks may be counted if they are done fast enough. 
;              Also, the frequent interrupts may slow the program down 
;              overall.
;Known Bugs: None


SwitchUDDebounce:         ;start initialize U/D switch debouncer function 
UDInputLoop:
		 IN   R21, PINE  ;Loads pinE into register
         ANDI R21, SWITCH_STATE_MASK   ;Gets the 1 bit that the 
                                       ;switch effects
		 CPI  R21, SWITCH_IS_DOWN ;Sets zero flag if the switch is down
		 BREQ UDSwitchIsDown   ;Jumps to the switch is down section 
                               ;if the zero flag is not set (if 
                               ;switch is down) 
         RJMP UDSwitchIsUp     ;Jumps to the switch is up section if 
                               ;the zero flag is set (if switch is up)
UDSwitchIsUp:
		 LDI    R22, DEBOUNCE_TIME  ;sets the register equal to the 
                                    ;debounce time constant
		 STS    debounceCntrUD, R22 ;stores the register value with 
                                    ;debounce time into the 
                                    ;debounceCntrUD variable 
		 RJMP   UDEndLoop ;Jumps to the EndLoop section
UDSwitchIsDown:
         LDS R23, debounceCntrUD
         DEC R23 ;decrements the R25 register, which represents the 
                 ;debounceCntrUD
		 STS debounceCntrUD, R23 ;stores the decremented value back in 
                                 ;the counter
		 CPI R23, 0 ;sets the zero flag if debounceCntrUD equals zero
		 BREQ SetUDSwitchFlag ;jumps to the SetUDSwitchFlag section
		 BRLT UDSetDebounceCounter ;jumps to the SetDebounceCounter section
		 RJMP UDInputLoop
SetUDSwitchFlag:
         LDI  R16, TRUE   ;loads true into the R16 register
		 STS  UDSwitchFlag, R16  ;sets the U/D switch flag variable equal 
                                 ;to the 
                                 ;register with TRUE in it
		 RJMP UDEndLoop ;Jumps to the EndLoop section
UDSetDebounceCounter:
         LDI  R16, FALSE   ;loads false into the R16 register
		 STS  debounceCntrUD, R16  ;sets the debounce counter variable 
                                   ;equal 
                                   ;to the register with FALSE in it
		 RJMP UDEndLoop ;Jumps to the EndLoop section         
 
UDEndLoop:
		 RET       ;Does nothing and returns back to the function 
                   ;that called this function



;Description: This method debounces for the left/right switch. It 
;             updates the LR_switchFlag once the debounce_cntrLR 
;             decrements to zero. This code is called every interrupt. 
;Operational Description: This method sets the variable, 
;                         debounce_cntrLR, equal to a debounce time 
;                         constant and then decrements it until it 
;                         hits zero. When it hits zero, the method sets 
;                         the switch flag. Every time debounce_cntrLR 
;                         becomes less than zero, the method sets it 
;                         equal to zero. 
;Arguments: None 
;Return Values: None
;Global Variables: None
;Shared Variables: The following variables are modified: debounce_cntrLR 
;                  and LR_switchFlag 
;Local Variables: None
;Inputs: The left and right pressing switch
;Outputs: None
;User Interface: The user presses the left/right switch 
;Error Handling: If the user presses the switch too fast, the presses 
;                will not be counted. This error is ignored. 
;Algorithms: None
;Data Structures: None 
;Limitations:  Not all clicks may be counted if they are done 
;              fast enough. Also, the frequent interrupts may 
;              slow the program down overall.
;Known Bugs: None 

SwitchLRDebounce:         ;start initialize L/R switch debouncer 
;                          function 
LRInputLoop:
		 IN   R21, PINE  ;Loads pinE into register
         ANDI R21, LR_SWITCH_STATE_MASK   ;Gets the 1 bit that 
                                          ;the switch effects
		 CPI  R21, SWITCH_IS_DOWN ;Sets zero flag if the switch is down
		 BREQ LRSwitchIsDown   ;Jumps to the switch is down section 
                               ;if the zero flag is not set (if switch 
                               ;is down) 
         RJMP LRSwitchIsUp     ;Jumps to the switch is up section if 
                               ;the zero flag is set (if switch is up)
LRSwitchIsUp:
		 LDI    R22, DEBOUNCE_TIME  ;sets the register equal to the 
                                    ;debounce time constant
		 STS    debounceCntrLR, R22 ;stores the register value with 
                                    ;debounce time into the 
                                    ;debounceCntrLR variable 
		 RJMP   LREndLoop ;Jumps to the EndLoop section
LRSwitchIsDown:
         LDS R23, debounceCntrLR
         DEC R23 ;decrements the R25 register, which represents 
                 ;the debounceCntrLR
		 STS debounceCntrLR, R23 ;stores the decremented value 
                                 ;back in the counter
		 CPI R23, 0 ;sets the zero flag if debounceCntrUD equals zero
		 BREQ SetLRSwitchFlag ;jumps to the SetLRSwitchFlag section
		 BRLT LRSetDebounceCounter ;jumps to the SetDebounceCounter 
                                    ;section
		 RJMP LRInputLoop
SetLRSwitchFlag:
         LDI  R16, TRUE   ;loads true into the R16 register
		 STS  LRSwitchFlag, R16  ;sets the L/R switch flag variable 
                                 ;equal to the register with TRUE 
                                 ;in it
		 RJMP LREndLoop ;jumps to the EndLoop section
LRSetDebounceCounter:
         LDI  R16, FALSE   ;loads false into the R16 register
		 STS  debounceCntrLR, R16  ;sets the debounce counter 
                                   ;variable equal to the 
                                   ;register with FALSE in it
		 RJMP LREndLoop ;jumps to the EndLoop section               
LREndLoop:
		 RET       ;Does nothing and returns back to the function 
                   ;that called this function
.dseg

LRSwitchFlag:  .BYTE 1   ;initializes the LRSwitchFlag variable
UDSwitchFlag:  .BYTE 1   ;initializes the UDSwitchFlag variable
debounceCntrUD:.BYTE 1  ;initializes the debounceCntrUD variable
debounceCntrLR: .BYTE 1  ;initializes the debounceCntrLR variable
