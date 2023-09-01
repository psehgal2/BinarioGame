;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                            ;
;                           RotaryFunctions.asm                              ;
;                        Rotary Encoder Functions                            ;
;    Initializations and Rotations Handlers for Up/Down, Left/Right Encoders ;
;                                                                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; This file contains the functions for initializing the rotary encoders and 
; handling the rotations
; The public functions included are:
;    InitRotary     - initialize rotary encoders
;    UpRot:         - initialize U/D Rotary counterclockwise function
;    DownRot        - initialize U/D Rotary clockwise function
;    LeftRot        - initialize L/R Rotary counterclockwise function
;    RightRot       - initialize L/R Rotary clockwise function
;    LREncoder:     - initialize L/R Rotary encoder function to handle rotations 
;    UDEncoder:     - initialize U/D Rotary encoder function to handle rotations 

;
; Revision History:
;    04/27/22  Purvi Sehgal             wrote initialization functions
;    04/28/22  Purvi Sehgal             wrote Up/Down/Left/Right rotate function
;    04/29/22  Purvi Sehgal             wrote LR/UD encoder functions
;    04/30/22  Purvi Sehgal             debugged code - didn't correctly restore
;                                       interrupt flag
;    05/01/22  Purvi Sehgal             demo'd                                                                                                                                                                             



.cseg


;Description: This method initializes all the variables needed for the U/D, L/R 
;             rotary encoders. 
              ;This method is exited out of when the six variables are set. 
;Operational Description: This method sets all the flags to zero and sets both 
;                         the bytes for left/right and up/down rotary encoders 
;                         equal to 8, 0-value bits. These bits are referred to 
;                         as bit0, bit1, bit2,…bit7. Like two arrays, these two 
;                         bytes are used for the rotary encoder debouncer 
;                         methods.  
;Arguments: None
;Return Values: None
;Global Variables: None
;Shared Variables: All the following variables are set: LRbyte, UDbyte, 
;                  LR_rotaryCCWFlag, LR_rotaryCWFlag, UD_rotaryCCWFlag, 
;                  UD_rotaryCWFlag
;Local Variables: None
;Inputs: None
;Outputs: None
;User Interface: None
;Error Handling: None
;Algorithms: None
;Data Structures: 2 array-like data structures (2, 8 bit Bytes)
;Limitations: None
;Known Bugs: None


InitRotary:            ;start initialize rotary function
         LDI    R16, ZERO_BYTE   ;loads the zero byte constant (8, zero bits) 
                                 ;into the R16 register
		 STS    LRByte, R16  ;sets the LRByte variable equal to the register 
                             ;with a zero byte in it
		 STS    UDByte, R16  ;sets the LRByte variable equal to the register 
                             ;with a zero byte in it
		 LDI    R16, FALSE   ;loads false into the R16 register
		 STS    LRRotaryCCWFlag, R16  ;sets the L/R rotary encoder counter 
         ;                             clockwise flag variable equal to the 
                                       ;register with FALSE in it
         STS    LRRotaryCWFlag, R16  ;sets the L/R rotary encoder clockwise 
                                     ;flag variable equal to the register with 
                                     ;FALSE in it
		 STS    UDRotaryCCWFlag, R16  ;sets the U/D rotary encoder counter 
                                      ;clockwise flag variable equal to the 
                                      ;register with FALSE in it
         STS    UDRotaryCWFlag, R16  ;sets the U/D rotary encoder clockwise flag 
                                     ;variable equal to the register with FALSE 
                                     ;in it
		 RET           ;returns from this function back to the function that 
                       ;called it




;Description: This method returns TRUE with the zero flag set if the up/down 
;             rotary encoder is rotated counterclockwise since it was last 
;             called. Otherwise, it returns FALSE with the zero flag reset. 
;             The function exits when something is returned/the zero flags 
;             are set, and, while we can’t interrupt the program while this 
;             function is running, we do nothing to handle this error. 
;Operational Description: This method first turns off the interrupt since it 
;                         changes variables that are in the interrupt handler.  
;                         If the UD_rotaryCCWFlag is on, it turns the flag off, 
;                         returns true, and sets the zero flag. Otherwise, it 
;                         returns false and resets the zero flag. Then, the 
;                         interrupt flag is restored. 
;Arguments: None
;Return Values: Returns true or false depending on the UD_rotaryCCWFlag value
;Global Variables: None
;Shared Variables: the UD_rotaryCCWFlag is first accessed and set to zero if 
;                  the flag is initially equal to 1.
;Local Variables: None
;Inputs: None
;Outputs: None
;User Interface: None
;Error Handling: None
;Algorithms: None
;Data Structures: None
;Limitations: If we want to interrupt the program while this method is 
;             running…(for example if the user wants to exit the game), 
;             then that is delayed since the interrupt is turned off.
;Known Bugs: None

UpRot:            ;start initialize U/D Rotary counterclockwise function
         IN R17, SREG ;Takes all the flags in SREG and stores them in 
                      ;the R17 register
		 CLI          ;Clears the interrupt flag
         LDS R18, UDRotaryCCWFlag ;loads the flag into the register
         LDI R16, FALSE   ;loads false into the R16 register
		 STS UDRotaryCCWFlag, R16  ;sets the U/D rotary counterclockwise 
                                   ;flag variable equal to the register 
                                   ;with FALSE in it
		 OUT SREG, R17 ;resets the flags in the S register to the 
                       ;original values stored in R17
         CPI R18, TRUE ;Sets the zero flag if the UDRotaryCCWFlag equals 1
		 RET           ;returns from this function back to the function 
                       ;that called it




;Description: This method returns TRUE with the zero flag set if the 
;             up/down rotary encoder is rotated clockwise since it was 
;             last called. Otherwise, it returns FALSE with the zero 
;             flag reset. The function exits when something is returned
;             the zero flags are set, and, while we can’t interrupt 
;             the program while this function is running, we do nothing 
;             to handle this error. 
;Operational Description: This method first turns off the interrupt 
;                         since it changes variables that are in the 
;                         interrupt handler.  If the UD_rotaryCWFlag is 
;                         on, it turns the flag off, returns true, and 
;                         sets the zero flag. Otherwise, it returns false 
;                         and resets the zero flag. Then, the interrupt 
;                         flag is restored. 
;Arguments: None
;Return Values: Returns true or false depending on the UD_rotaryCWFlag 
;               value
;Global Variables: None
;Shared Variables: the UD_rotaryCWFlag is first accessed and set to zero 
;                  if the flag is initially equal to 1.
;Local Variables: None
;Inputs: None
;Outputs: None
;User Interface: None
;Error Handling: None
;Algorithms: None
;Data Structures: None
;Limitations: If we want to interrupt the program while this method is 
;             running…(for example if the user wants to exit the game), 
;             then that is delayed since the interrupt is turned off.
;Known Bugs: None

DownRot:            ;start initialize U/D Rotary clockwise function
         IN R17, SREG ;Takes all the flags in SREG and stores them in 
                      ;the R17 register
		 CLI          ;Clears the interrupt flag
         LDS R18, UDRotaryCWFlag ;loads the flag into the register
         LDI R16, FALSE   ;loads false into the R16 register
		 STS UDRotaryCWFlag, R16  ;sets the U/D rotary clockwise flag 
                                  ;variable equal to the register with 
                                  ;FALSE in it
		 OUT SREG, R17 ;resets the flags in the S register to the 
                       ;original values stored in R17
         CPI R18, TRUE ;Sets the zero flag if the UDRotaryCWFlag 
                       ;equals 1
		 RET           ;returns from this function back to the 
                       ;function that called it



;Description: This method returns TRUE with the zero flag set if the 
;             left/right rotary encoder is rotated counterclockwise 
;             since it was last called. Otherwise, it returns FALSE 
;             with the zero flag reset. The function exits when something 
;             is returned/the zero flags are set, and, while we can’t 
;             interrupt the program while this function is running, we do 
;             nothing to handle this error. 
;Operational Description: This method first turns off the interrupt since 
;                         it changes variables that are in the interrupt 
;                         handler.  If the LR_rotaryCCWFlag is on, it 
;                         turns the flag off, returns true, and sets the 
;                         zero flag. Otherwise, it returns false  and 
;                         resets the zero flag. Then, the interrupt flag 
;                         is restored. 
;Arguments: None
;Return Values: Returns true or false depending on the LR_rotaryCCWFlag 
;               value
;Global Variables: None
;Shared Variables: the LR_rotaryCCWFlag is first accessed and set to zero 
;                  if the flag is initially equal to 1.
;Local Variables: None
;Inputs: None
;Outputs: None
;User Interface: None
;Error Handling: None
;Algorithms: None
;Data Structures: None
;Limitations: If we want to interrupt the program while this method is 
;             running…(for example if the user wants to exit the game), 
;             then that is delayed since the interrupt is turned off.
;Known Bugs: None


LeftRot:            ;start initialize L/R Rotary counterclockwise function
         IN R17, SREG ;Takes all the flags in SREG and stores them in the  
                      ;R17 register
		 CLI          ;Clears the interrupt flag
         LDS R18, LRRotaryCCWFlag ;loads the flag into the register
         LDI R16, FALSE   ;loads false into the R16 register
		 STS LRRotaryCCWFlag, R16  ;sets the L/R rotary counterclockwise 
                                   ;flag variable equal to the register
                                   ;with FALSE in it
		 OUT SREG, R17 ;resets the flags in the S register to the original 
                       ;values stored in R17
         CPI R18, TRUE ;Sets the zero flag if the LRRotaryCCWFlag equals
		 RET           ;1 returns from this function back to the function 
                       ;that called it




;Description: This method returns TRUE with the zero flag set if the left/right 
;;            rotary encoder is rotated clockwise since it was last called. 
;             Otherwise, it returns FALSE with the zero flag reset. The 
;             function exits when something is returned/the zero flags are set, 
;             and, while we can’t interrupt the program while this function 
;             is running, we do nothing to handle this error. 
;Operational Description: This method first turns off the interrupt since it 
;                         changes variables that are in the interrupt handler.  
;                         If the LR_rotaryCWFlag is on, it turns the flag off, 
;                         returns true, and sets the zero flag. Otherwise, it 
;                         returns false and resets the zero flag. Then, 
;                         the interrupt is restored. 
;Arguments: None
;Return Values: Returns true or false depending on the LR_rotaryCWFlag value
;Global Variables: None
;Shared Variables: the LR_rotaryCWFlag is first accessed and set to zero if 
;                  the flag is initially equal to 1.
;Local Variables: None
;Inputs: None
;Outputs: None
;User Interface: None
;Error Handling: None
;Algorithms: None
;Data Structures: None
;Limitations: If we want to interrupt the program while this method is 
;             running…(for example if the user wants to exit the game), 
;             then that is delayed since the interrupt is turned off.
;Known Bugs: None

RightRot:            ;start initialize L/R Rotary clockwise function
         IN R17, SREG ;Takes all the flags in SREG and stores them in the 
                      ;R17 register
		 CLI          ;Clears the interrupt flag
         LDS R18, LRRotaryCWFlag ;loads the flag into the register
         LDI R16, FALSE   ;loads false into the R16 register
		 STS LRRotaryCWFlag, R16  ;sets the L/R rotary clockwise flag variable 
                                  ;equal to the register with FALSE in it
		 OUT SREG, R17 ;resets the flags in the S register to the original 
                       ;values stored in R17
         CPI R18, TRUE ;Sets the zero flag if the LRRotaryCWFlag equals 1
		 RET           ;returns from this function back to the function 
                       ;that called it


;Description: This method handles rotations for the left/right rotary encoder. 
;             It either updates the rotaryCCWFlag or rotaryCWFlag for the 
;             left/right encoder to 1 if a full counterclockwise or 
;             clockwise rotation is made. Otherwise, it does nothing. This 
;             code is called every interrupt. 
;Operational Description: This method stores an 8 bit byte called LRbyte. 
;                         Like an array, stuff is added to or removed 
;                         from it. Pairs of two representing the 
;                         position along the rotation (i.e. 11, 00, 01, 
;                         etc) are added to the byte, and once it matches a 
;                         specific 8 bit pattern, then the respective flag 
;                         is set. If a pair to be added matches the second pair 
;                         in the byte, then the byte is shifted to the left. 
;                         Also, if the pair to be added is the same as the 
;                         first pair in LRbyte, nothing happens. 
;Arguments: None 
;Return Values: None
;Global Variables: None
;Shared Variables: The following variables are modified: LRbyte, bits0-7, 
;                  LR_rotaryCCWFlag, and LR_rotaryCWFlag. 
;Local Variables: currentEncoderState
;Inputs: The left and right rotary encoder (and state)
;Outputs: None
;User Interface: The user rotates the left/right encoder in a clockwise 
;                or counterclockwise direction
;Error Handling: If the user rotates the rotary encoder too fast, the 
;                clicks/2 bit pairs will not be counted. This 
;                error is ignored. 
;Algorithms: None
;Data Structures: Array-like structure (byte)
;Limitations:  Not all clicks may be counted if they are done fast enough. 
;              Also, the frequent interrupts may slow the program down 
;              overall.
;Known Bugs: None  

LREncoder:         ;start initialize L/R Rotary encoder function to handle 
                   ;rotations 
LRInputLoopRot:
         IN   R21, PINE  ;Loads pinE into register
         LDS  R18, LRByte   ;loads LRByte into the register for storage
		 ANDI  R21, ENCODER_STATE_MASK   ;Gets the 2 bits that the rotary 
                                         ;encoder effects
         ;Handling Previous Previous State
		 LDS  R19, LRByte   ;loads LRByte into the register so that it can 
                            ;be changed
		 ANDI R19, BIT_MASK54 ;zeros out everything besides the 5th and 4th 
                              ;bit of the LRByte stored in the register
         LSL R19 ;shifts left
         LSL R19 ;shifts left
		 CP R21, R19 ;Sets the zero flag if CurrentEncoderState equals 
                     ;the 5th and 4th bit of LRByte
		 BREQ LRSameAsPreviousPreviousStateRot   ;If the zero flag is set 
                                                 ;(if CurrentEncoderState 
                                                 ;equals the two bits),
                                                 ;jumps to 
                                                 ;SameAsPreviousPreviousState 
                                                 ;section in the code
         ;Handling Previous State
         LDS  R20, LRByte   ;loads LRByte into the register so that it 
                            ;can be changed
		 ANDI R20, BIT_MASK76 ;zeros out everything besides the 7th and 
                              ;6th bit of the LRByte stored in the register
		 CP R21, R20 ;Sets the zero flag if CurrentEncoderState equals the 7th 
                     ;and 6th bit of LRByte
		 BREQ LRSameAsPreviousStateRot      ;If the zero flag is set 
                                            ;(if CurrentEncoderState equals the 
                                            ;two bits),jumps to 
                                            ;SameAsPreviousPreviousState section 
                                            ;in the code
         
         ;Handling Everything Else
		 RJMP LRELSERot           ;If it hasn't jumped to anything yet, it will 
                                  ;jump to the Else section in the code
LRSameAsPreviousStateRot:
         RJMP LREndLoopRot ;Jumps to the EndLoop section

LRSameAsPreviousPreviousStateRot:
         LSL R18  ;Logical Shift Left -> shifts all the bits once to the left 
                  ;and adds a 0 to bit0
		 LSL R18  ;Logical Shift Left -> shifts all the bits once to the left 
                  ;and adds a 0 to bit0
         STS LRByte, R18 
         RJMP LREndLoopRot ;Jumps to the EndLoop section

LRELSERot:
         LSR R18  ;Logical Shift Right -> shifts all the bits once to the right 
                  ;and adds a 0 to bit7
		 LSR R18  ;Logical Shift Right -> shifts all the bits once to the right 
                  ;and adds a 0 to bit7
         OR   R18, R21;Adds the CurrentEncoderState to bit 7 and bit 6
         STS LRByte, R18 
		 CPI  R18, CCW_BIT ;Checks if counterclockwise rotation has been 
        ;                   completed (sets zero flag if they are the same)
		 BREQ LRCompleteCCWRotation ;Jump to the Complete CCWRotation section 
                                    ;if the zero flag is set
		 CPI  R18, CW_BIT ;Checks if clockwise rotation has been completed 
                          ;(sets zero flag if they are the same)
		 BREQ LRCompleteCWRotation ;Jump to the CompleteCWRotation section 
                                   ;if the zero flag is set
		 RJMP LREndLoopRot ;Jumps to the EndLoop section

LRCompleteCCWRotation:
         LDI R21, TRUE   ;loads true into the R21 register
		 STS LRRotaryCCWFlag, R21  ;sets the L/R rotary counterclockwise flag 
                                   ;variable equal to the register with TRUE 
                                   ;in it
         LDI R18, RESET ;clears LRByte and adds 11 in the beginning
         STS LRByte, R18 
         RJMP LREndLoopRot ;Jumps to the EndLoop section
    

LRCompleteCWRotation:
         LDI R22, TRUE   ;loads true into the R22 register
		 STS LRRotaryCWFlag, R22  ;sets the L/R rotary clockwise flag variable 
                                  ;equal to the register with TRUE in it
         LDI R18, RESET;clears LRByte and adds 11 in the beginning
         STS LRByte, R18
         RJMP LREndLoopRot ;Jumps to the EndLoop section

LREndLoopRot:
		 RET       ;Does nothing and returns back to the function that called 
                   ;this function



;Description: This method handles rotations for the up/down rotary encoder. 
;             It either updates the rotaryCCWFlag or rotaryCWFlag for the 
;             up/down encoder to 1 if a full counterclockwise or clockwise 
;             rotation is made. Otherwise, it does nothing. This code is 
;             called every interrupt. 
;Operational Description: This method stores an 8 bit byte called UDbyte. 
;                         Like an array, stuff is added to or removed from 
;                         it. Pairs of two representing the position along 
;                         the rotation (i.e. 11, 00, 01, etc) are added to 
;                         the byte, and once it matches a specific 8 bit 
;                         pattern, then the respective flag is set. If a 
;                         pair to be added matches the second pair in the 
;                         byte, then the byte is shifted to the left. 
;                         Also, if the pair to be added is the same as 
;                         the first pair in UDbyte, nothing happens. 
;Arguments: None 
;Return Values: None
;Global Variables: None
;Shared Variables: The following variables are modified: UDbyte, bits0-7, 
;                  UD_rotaryCCWFlag, and UD_rotaryCWFlag. 
;Local Variables: currentEncoderState
;Inputs: The up and down rotary encoder (and state)
;Outputs: None
;User Interface: The user rotates the up/down encoder in a clockwise or 
;                counterclockwise direction
;Error Handling: If the user rotates the rotary encoder too fast, the 
;                clicks/2 bit pairs will not be counted. This error 
;                is ignored. 
;Algorithms: None
;Data Structures: Array-like structure (byte)
;Limitations:  Not all clicks may be counted if they are done fast 
;              enough. Also, the frequent interrupts may slow the 
;              program down overall (yet provide a faster response).
;Known Bugs: None 

UDEncoder:         ;start initialize U/D Rotary encoder function to 
;                   handle rotations 
UDInputLoopRot:
         IN   R21, PINE  ;Loads pinE into register
         LDS  R18, UDByte   ;loads UDByte into the register for storage
		 ANDI  R21, UD_ENCODER_STATE_MASK   ;Gets the 2 bits that the 
                                            ;rotary encoder effects
         LSL  R21   ;Shifts the current state bits to the left
         LSL R21    ;shifts the current state bits to the left
         LSL R21    ;shifts the current state bits to the left

         ;Handling Previous Previous State
		 LDS  R19, UDByte   ;loads UDByte into the register so 
                            ;that it can be changed
		 ANDI R19, BIT_MASK54 ;zeros out everything besides the 
                              ;5th and 4th bit of the UDByte 
                              ;stored in the register
         LSL R19 ;shifts left
         LSL R19 ;shifts left
		 CP R21, R19 ;Sets the zero flag if CurrentEncoderState equals 
                     ;the 5th and 4th bit of UDByte
		 BREQ UDSameAsPreviousPreviousStateRot ;If the zero 
                                              ;flag is set 
                                              ;if Current
                                              ;EncoderState 
                                              ;equals the 
                                              ;two bits),
		                                      ;jumps to 
                                              ;SameAsPrevious
                                              ;PreviousState 
                                              ;section in the code
         ;Handling Previous State
         LDS  R20, UDByte   ;loads UDByte into the register so 
                            ;that it can be changed
		 ANDI R20, BIT_MASK76 ;zeros out everything besides the 
                              ;7th and 6th bit of the UDByte 
                              ;stored in the register
		 CP R21, R20 ;Sets the zero flag if CurrentEncoderState 
                     ;equals the 7th and 6th bit of UDByte
		 BREQ UDSameAsPreviousStateRot      ;If the zero flag is 
                                            ;set (if 
                                            ;CurrentEncoderState equals 
                                            ;the two bits),
		                                    ;jumps to SameAsPrevious
                                            ;PreviousState section in the 
                                            ;code
         ;Handling Everything Else
		 RJMP UDELSERot           ;If it hasn't jumped to anything yet, 
                                  ;it will jump to the Else section in 
                                  ;the code
UDSameAsPreviousStateRot:
         RJMP UDEndLoopRot ;Jumps to the EndLoop section

UDSameAsPreviousPreviousStateRot:
         LSL R18  ;Logical Shift Left -> shifts all the bits once to the 
                  ;left and adds a 0 to bit0
		 LSL R18  ;Logical Shift Left -> shifts all the bits once to the 
                  ;left and adds a 0 to bit0
         STS UDByte, R18 
         RJMP UDEndLoopRot ;Jumps to the EndLoop section

UDELSERot:
         LSR R18  ;Logical Shift Right -> shifts all the bits once to the 
                   ;right and adds a 0 to bit7
		 LSR R18  ;Logical Shift Right -> shifts all the bits once to the 
                  ;right and adds a 0 to bit7
         OR   R18, R21;Adds the CurrentEncoderState to bit 7 and bit 6
         STS UDByte, R18 
		 CPI  R18, CCW_BIT ;Checks if counterclockwise rotation has 
                           ;been completed (sets zero flag if they 
                           ;are the same)
		 BREQ UDCompleteCCWRotation ;Jump to the Complete CCWRotation 
                                    ;section if the zero flag is set
		 CPI  R18, CW_BIT ;Checks if clockwise rotation has been 
                          ;completed (sets zero flag if they are 
                          ;the same)
		 BREQ UDCompleteCWRotation ;Jump to the CompleteCWRotation 
                                   ;section if the zero flag is set
		 RJMP UDEndLoopRot ;Jumps to the EndLoop section

UDCompleteCCWRotation:
         LDI R21, TRUE   ;loads true into the R21 register
		 STS UDRotaryCCWFlag, R21  ;sets the L/R rotary 
                                   ;counterclockwise flag variable 
                                   ;equal to the register with TRUE 
                                   ;in it
         LDI R18, RESET ;clears UDByte and adds 11 in the beginning
         STS UDByte, R18 
         RJMP UDEndLoopRot ;Jumps to the EndLoop section
    
UDCompleteCWRotation:
         LDI R22, TRUE   ;loads true into the R22 register
		 STS UDRotaryCWFlag, R22  ;sets the L/R rotary clockwise flag 
                                  ;variable equal to the register with 
                                  ;TRUE in it
         LDI R18, RESET;clears UDByte and adds 11 in the beginning
         STS UDByte, R18
         RJMP UDEndLoopRot ;Jumps to the EndLoop section

UDEndLoopRot:
		 RET       ;Does nothing and returns back to the function 
                   ;that called this function




.dseg
LRByte:        .BYTE 1   ;initializes the LRByte variable - with 8 
                         ;bits to record L/R rotary encoder states
UDByte:        .BYTE 1   ;initializes the UDByte variable - with 
                         ;8 bits to record U/D rotary encoder states
UDRotaryCCWFlag:  .BYTE 1   ;initializes the UDRotaryCCWFlag variable
UDRotaryCWFlag:  .BYTE 1   ;initializes the UDRotaryCWFlag variable
LRRotaryCCWFlag:  .BYTE 1   ;initializes the LRRotaryCCWFlag variable
LRRotaryCWFlag:  .BYTE 1   ;initializes the LRRotaryCWFlag variable


