;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                            ;
;                             RotaryFunctions.inc                            ;
;                         Rotary Functions Constants                         ;
;                                 Include File                               ;
;                                                                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; This file contains the definitions for the rotary functions file
; for the UD/LR rotary encoders
;
; Revision History:
;     04/30  Purvi Sehgal        Added constants and values 


.EQU   BIT_MASK54 = 0b00110000            ;Sets Bit 5 and Bit 4 equal to 1 & 
                                          ;the rest to 0
.EQU   BIT_MASK76 = 0b11000000            ;Sets Bit 7 and Bit 6 equal to 1 & 
                                          ;the rest to 0
.EQU   ENCODER_STATE_MASK = 0b11000000    ;Selects the two bits the rotary 
                                          ;encoder effects
.EQU   CCW_BIT = 0b11010010               ;Pattern to check if a counter 
                                          ;clockwise rotation is complete

.EQU   CW_BIT = 0b11100001                ;Pattern to check if a clockwise 
                                          ;rotation is complete
.EQU   RESET = 0b11000000                 ;Reset constant for UD/LRByte
.EQU   UD_ENCODER_STATE_MASK = 0b00011000 ;Retrieves the encoder state for UD
                                          ;Encoder
