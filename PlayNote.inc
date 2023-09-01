;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                            ;
;                                  PlayNote.inc                              ;
;                   PlayNote, Timer1, and Division Function Constants        ;
;                                 Include File                               ;
;                                                                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; This file contains the constants for the PlayNote functions file
; to play a sound at a certain frequency
;
; Revision History:
;     06/01  Purvi Sehgal        Added constants and values 





.EQU   INIT_TCCR1A = 0b01000000      ;enables toggling on compare match for 
                                     ;Channel A
.EQU   INIT_TCCR1B = 0b00001011      ;sets the prescaler to 64 
.EQU   TURN_OFF_SPEAKER = 0b11011111 ;this stops outputting square waves to the 
                                     ;speaker, so it turns it off 
.EQU   TURN_ON_SPEAKER = 0b00100000  ;this stops outputting square waves to the 
                                     ;speaker, so it turns it off 
.EQU   DETERMINE_COUNTER = 62500     ;assists in determining the counter value 
                                     ;(8 million HZ/(2*64[prescaler]))
