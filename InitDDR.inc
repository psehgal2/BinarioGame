;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                            ;
;                                  InitDDR.inc                               ;
;                       GPIO Initialization Functions Constants              ;
;                                 Include File                               ;
;                                                                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; This file contains the constants for the GPIO pins initialization functions 
; file for DDR A, B, C, D, and E
;
; Revision History:
; 06/01/22     Purvi Sehgal        Added constants and values to combine all
;                                  DDR ports 



.EQU   SET_DDRB_INPUT_OUTPUT = 0b00100111 ;sets SS, SCK, MOSI, and OC1A as 
                                          ;outputs
.EQU   ZERO_BYTE = 0x00                   ;initializes ports as inputs
.EQU   OUTPUT_PORT = 0xFF                 ;initializes ports as outputs
