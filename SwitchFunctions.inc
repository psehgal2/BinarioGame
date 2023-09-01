;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                            ;
;                               SwitchFunctions.inc                          ;
;                   Switch Initialization and Debouncing Constants           ;
;                                 Include File                               ;
;                                                                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; This file contains the constants for the SwitchFunctions file
; Revision History:
; 04/27/22  Purvi Sehgal        Added constants and values 

.EQU DEBOUNCE_TIME = 20                 ;Sets debounce time equal to 20
.EQU SWITCH_STATE_MASK = 0b00000100     ;Mask
.EQU SWITCH_IS_DOWN = 0b00000000        ;Constant for when switch is down
.EQU LR_SWITCH_STATE_MASK = 0b00100000  ;LR mask for switch state
