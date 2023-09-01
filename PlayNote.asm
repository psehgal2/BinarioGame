;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                            ;
;                              PlayNote.asm                                  ;
;                        Sound Production Functions                          ;
;    Produces a Single Tone at a Certain Frequency Passed into Registers     ;
;                                                                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; This file contains the functions for playing a sound at a specific frequency 
; passed into registers R17 and R16. A frequency of zero means no sound should 
; be produced 
;
; The functions included are:
;        PlayNote - divides the system clock to produce a square wave that, 
;        when outputted to the speaker, produces a tone at the desired frequency
; 
;        DivideFrequency - divides two numbers. Is the first step in determining
;        the counter value (divides 15625 (8*10^6/(2*256)) by the frequency 
;        value and updates R16 and R17 so the new counter value is 
;        (8*10^6/(2*256*f)))

;
; Revision History:
;    05/29/22  Purvi Sehgal             wrote the zero frequency section
;    05/29/22  Purvi Sehgal             wrote the nonzero frequency section
;    05/30/22  Purvi Sehgal             added divide frequency function\
;    05/31/22  Purvi Sehgal             wrote the init timer function
;    05/31/22  Purvi Sehgal             debugged code - didn't correctly handle
;                                       zero frequency
;    06/03/22  Purvi Sehgal             demo'd                                                                                                                                                                             



.cseg


;Description:        This method initializes the timer in order to generate 
;                    the square wave for the sound
;Operation:          This sets the timer to generate a square wave by setting 
;                    up TCCR1A which toggles on compare matach for channel A 
;                    and TCCR1B which sets the prescaler to 64
;                    and setting bit 5 of the DDRB register high. The timer 
;                    is in clear timer on compare match mode (CTC mode) 
;Registers changed:  R16, R17, TCCR1A, TCCR1B, DDRB
;Arguments:          None
;Return Values:      None
;Global Variables:   None
;Shared Variables:   None
;Local Variables:    None
;Inputs:             None
;Outputs:            None
;User Interface:     None
;Error Handling:     None
;Algorithms:         None
;Data Structures:    None
;Limitations:        None
;Known Bugs:         None

InitSquareWaveTimer1:
  LDI  R16, INIT_TCCR1A             ;loads into a register the constant that 
                                    ;enables toggling on compare match for 
                                    ;Channel A
  OUT  TCCR1A, R16                  ;enables toggling on compare match for 
                                    ;Channel A
  LDI  R17, INIT_TCCR1B              
  OUT  TCCR1B, R17                  ;sets the prescaler to INIT_TCCR1B
                                    ;so that the compare value can 
									;fit within a word
  SBI  DDRB, 5
  RET                                






;Description:        This method plays a sound at a certain frequency (f) 
;                    chosen by the user. The method terminates after either 
;                    the DDRB is modified or OCR1A is set to a value. If 
;                    the frequency argument value is 0, no sound is produced. 
;Operation:          If the frequency is zero, the DDRB for the speaker bit 
;                    is 0, meaning nothing is being outputted to the speaker. 
;                    Otherwise, the output compare register value is set to 
;                    (8*10^6/(2*256*f)) - 1, which determines a compare value 
;                    based on the frequency and prescaler value in order to 
;                    get the clock to go high every f MHz. 
;Registers changed:  R16, R17, R19, R20, R21, R22, DDRB, OCR1AH, OCR1AL, 
;                    TCNT1H, TCNT1L, and flags
;Arguments:          Frequency in MHz is put into a 16-bit value passed by 
;                    value in R17 | R16. 
;Global Variables:   None
;Shared Variables:   None
;Local Variables:    None
;Inputs:             None
;Outputs:            Generates a sound at a certain frequency f. 
;User Interface:     None
;Error Handling:     None 
;Algorithms:         None
;Data Structures:    None
;Limitations:        None
;Known Bugs:         None

PlayNote:
ZeroFrequency:
  LDI  R19, 0  
  CPSE R17, R19                     ;if the high byte of the frequency is 
                                    ;set to zero, it moves on to check the 
                                    ;low byte
  RJMP NonZeroFrequency             ;if the high byte is not zero, it skips 
                                    ;to the section that handles nonzero 
                                    ;frequencies
  CPSE R16, R19                     ;checks if the low byte of the frequency 
                                    ;is set to zero. If not, skips to the 
                                    ;section that handles nonzero frequencies
  RJMP NonZeroFrequency             ;if the the low byte of the frequency is 
                                    ;not zero, it skips to the section that 
                                    ;handles nonzero frequencies
  IN   R22, DDRB                    ;gets the current state of the DDRB
  ANDI R22, TURN_OFF_SPEAKER        ;turns off port 5 of the DDRB, so it is 
                                    ;no longer an output
  OUT  DDRB, R22                    ;this stops outputting square waves to 
                                    ;the speaker, so it turns the speaker off 
  RJMP PlayNoteEndFunction           

NonZeroFrequency:  
  IN   R22, DDRB                    ;gets the current state of the DDRB
  ORI  R22, TURN_ON_SPEAKER         ;turns on port 5 of the DDRB, so it is 
                                    ;an output
  OUT  DDRB, R22                    ;enables outputting square waves to the 
                                    ;speaker, so it turns the speaker on 
  MOV  R20, R16                     ;copies R16 values into R20 since we are 
                                    ;dividing by the frequency
  MOV  R21, R17                     ;copies R17 values into R21 since we are 
                                    ;dividing by the frequency
  LDI  R16, LOW(DETERMINE_COUNTER)  
                                    
  LDI  R17, HIGH(DETERMINE_COUNTER) 
                                    
  RCALL DivideFrequency             ;divides DETERMINE_COUNTER by freq
                                    ;and updates R16 and R17 
  DEC  R16                          ;finishes calculating counter value
  OUT  OCR1AH, R17                  ;sends the high byte of the counter value 
                                    ;to OCR1A (divides the clock frequency so 
                                    ;that it matches desired frequency)
  OUT  OCR1AL, R16                  ;sends the low byte of the counter value 
                                    ;to OCR1A (divides the clock frequency so 
                                    ;that it matches desired frequency)
  OUT  TCNT1H, R19                  ;sets the timer counter to zero for the 
                                    ;high byte because no double buffering 
                                    ;of the output compare register in CTC 
                                    ;mode 
  OUT  TCNT1L, R19                  ;sets the timer counter to zero for 
                                    ;the low byte 
; RJMP PlayNoteEndFunction          

PlayNoteEndFunction:  
  RET





; Description:       This function divides the 16-bit unsigned value passed in
;                    R17|R16 by the 16-bit unsigned value passed in R21|R20.
;                    The quotient is returned in R17|R16 and the remainder is
;                    returned in R3|R2.
;
; Operation:         The function divides R17|R16 by R21|R20 using a restoring
;                    division algorithm with a 16-bit temporary register R3|R2
;                    and shifting the quotient into R17|R16 as the dividend is
;                    shifted out.  Note that the carry flag is the inverted
;                    quotient bit (and this is what is shifted into the
;                    quotient) so at the end the entire quotient is inverted.
;
; Arguments:         R17|R16 - 16-bit unsigned dividend.
;                    R21|R20 - 16-bit unsigned divisor.
; Return Values:     R17|R16 - 16-bit quotient.
;                    R3|R2   - 16-bit remainder.
;
; Local Variables:   bitcnt (R22) - number of bits left in division.
; Shared Variables:  None.
; Global Variables:  None.
;
; Input:             None.
; Output:            None.
;
; Error Handling:    None.
;
; Registers Changed: flags, R2, R3, R16, R17, R22
; Stack Depth:       0 bytes
;
; Algorithms:        Restoring division.
; Data Structures:   None.
;
; Known Bugs:        None.
; Limitations:       None.

DivideFrequency:
Div16:
  LDI  R22, 16                     ;number of bits to divide into
  CLR  R3                          ;clear temporary register (remainder)
  CLR  R2

Div16Loop:                         ;loop doing the division
  ROL  R16                         ;rotate bit into temp (and quotient
  ROL  R17                         ;into R17|R16)
  ROL  R2
  ROL  R3
  CP   R2, R20                     ;check if can subtract divisor
  CPC  R3, R21
  BRCS Div16SkipSub                ;cannot subtract, don't do it
  SUB  R2, R20                     ;otherwise subtract the divisor
  SBC  R3, R21
Div16SkipSub:                      ;C = 0 if subtracted, C = 1 if not
  DEC  R22                         ;decrement loop counter
  BRNE Div16Loop                   ;if not done, keep looping
  ROL  R16                         ;otherwise shift last quotient bit in
  ROL  R17
  COM  R16                         ;and invert quotient (carry flag is
  COM  R17                         ;inverse of quotient bit)
 ;RJMP   EndDiv16                  ;and done (remainder is in R3|R2)

EndDiv16:                          ;all done, just return
  RET


.dseg
