;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                            ;
;                                  1MsTimer0.inc                             ;
;                          Timer Functions Constants                         ;
;                                 Include File                               ;
;                                                                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; This file contains the constants for the 1MsTimer0 functions file
; for the timer
;
; Revision History:
;     04/30  Purvi Sehgal        Added constants and values 


.EQU TCCR0_BYTE = 0b00001011    ;sets prescaler to 64
.EQU TIMSK_BYTE = 0b00000010    ;timer overflow interrupt enable
.EQU OCR0_BYTE = 0b11111010     ;sets compare register value to 250
