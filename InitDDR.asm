;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                            ;
;                                 InitDDR.asm                                ;
;                     Initialize GPIO Port A, B, C, D, E                     ;
;                           Initialize DDR Functions                         ;
;                                                                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; This file contains the function for initializing the GPIO Ports A, B, C, D
; The public functions included are:
;    InitDDRB   - sets up DDR for port B
;    InitLEDPortACD - sets DDR for ports A, C, and D
;    InitDDRE  - sets up DDR for port E
;    
; Revision History:
;    04/27/22  Purvi Sehgal             wrote DDR init for port E
;    05/10/22  Purvi Sehgal             wrote pin init for ports A, C, D
;    06/04/22  Purvi Sehgal             wrote DDR init for port B
;    06/05/22  Purvi Sehgal             demo'd 


.cseg


;Description:             This method initializes GPIO port B. The method 
;                         terminates after the direction of the port is set. 
;Operational Description: This sets the data direction register for port B
;                         so that SS, SCK, MOSI, and OC1A are outputs (sets 
;                         these bits equal to 1). 
;Global Variables:        None
;Shared Variables:        None
;Local Variables:         None
;Inputs:                  None
;Outputs:                 None
;User Interface:          None
;Error Handling:          None 
;Algorithms:              None
;Data Structures:         None
;Limitations:             None
;Known Bugs:              None 
;Registers changed:       DDRB, R16

InitDDRB:
  LDI R16, SET_DDRB_INPUT_OUTPUT ;loads into a register the constant that sets 
                                 ;SS, SCK, MOSI, and OC1A as outputs
  OUT DDRB, R16                  ;sets SS, SCK, MOSI, and OC1A as outputs
  RET                           


;Description:             This method initializes GPIO ports A, C, D. It 
;                         terminates after the direction of the port is set. 
;Operational Description: This sets the data direction register for port A,
;                         C, D so they are outputs (sets 
;                         these bits equal to 1). 
;Global Variables:        None
;Shared Variables:        None
;Local Variables:         None
;Inputs:                  None
;Outputs:                 None
;User Interface:          None
;Error Handling:          None 
;Algorithms:              None
;Data Structures:         None
;Limitations:             None
;Known Bugs:              None 
;Registers changed:       DDRA, DDRC, DDRD, R16


InitDDRACD:                   ;initializes GPIO ports A, C, and D
       LDI R16, OUTPUT_PORT   ;makes a port an output port
	   OUT DDRA, R16          ;establishes Port A as an output port
	   OUT DDRC, R16          ;establishes Port C as an output port
	   OUT DDRD, R16          ;establishes Port D as an output port
	   RET                    ;terminates function


;Description:             This method initializes GPIO port E. The method 
;                         terminates after the variable is set. 
;Operational Description: This sets data direction register for port E to 
;                         equal to zero, which means the switches and rotary 
;                         encoders are all inputs as opposed to outputs.
;Arguments:               None 
;Return Values:           None
;Global Variables:        None
;Shared Variables:        None
;Local Variables:         None
;Inputs:                  None
;Outputs:                 None
;User Interface:          None
;Error Handling:          None 
;Algorithms:              None
;Data Structures:         None
;Limitations:             None
;Known Bugs:              None 
;Registers changed:       R16, DDRE     



InitDDRE:                   ;initializes the GPIO pin - the DDRE port 
       LDI R16, ZERO_BYTE   ;loads the zero byte constant (8, zero bits) into 
                            ;the R16 register
	   OUT DDRE, R16        ;sets the DDRE port equal to the register 
                            ;value (which is 00 in hex), 
	                        ;establishing the DDRE port as an input port
       RET                  ;jumps back to the function that called it

.dseg

