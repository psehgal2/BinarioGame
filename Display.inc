;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                            ;
;                                   Display.inc                              ;
;                            Display Functions Constants                     ;
;                                 Include File                               ;
;                                                                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; This file contains the constants for the Display functions file
; for the timer
;
; Revision History:
;     05/30  Purvi Sehgal        Added constants and values 



.EQU INIT_RED_INDEX = 0b00000001       ;byte which turns on column one for the 
                                       ;red LED on the display board
.EQU INIT_GREEN_INDEX = 0b00000000     ;byte which doesn't turn on any column 
                                       ;for the green LED on the display board
.EQU LED_OFF = 0b00000000              ;turns all the LEDs off in both the red 
                                       ;and green buffers
.EQU INIT_ROW_MASK = 0b10000000        ;selects the 0th row value in a column 
                                       ;for the cursor location
.EQU MAX_COLUMNS = 0b00001000          ;constant to determine if the code has 
                                       ;looped through 8 times
.EQU RED_COLOR_VALUE = 0b00000001      ;constant so that code can check if the 
                                       ;color inputted is green
.EQU GREEN_COLOR_VALUE = 0b00000010    ;constant so that code can check if the 
                                       ;color inputted is red
.EQU YELLOW_COLOR_VALUE = 0b00000011   ;constant so that code can check if the 
                                       ;color inputted is yellow
.EQU C1_TIME = 100                     ;so that it stays on a color for longer 
                                       ;(gives the appearance of blinking when 
									   ;switch)
.EQU C2_TIME = 200                     ;so that it stays on the second color 
                                       ;for longer (gives the appearance of 
									   ;blinking when switch)
.EQU LAST_GREEN_COLUMN = 0b00000001    ;constant which checks whether last 
                                       ;green column has been enabled 
.EQU FIRST_RED_COLUMN = 0b00000001     ;constant which enables the first 
                                       ;red column, therefore resetting column
									   ;enable 
.EQU GREEN_COLUMN_DISABLE = 0b00000000 ;turns off all the green LED column 
                                       ;enables so that no green LED can be 
									   ;set 
.EQU TOTAL_COLUMNS = 8                 ;max number of columns
.EQU SELECT_LEFT_COLUMN = 0            ;selects the left-most column
.EQU INVALID_ROW = 9                   ;selects an invalid row so that the 
                                       ;cursor doesn't blink initially
.EQU INVALID_COLUMN = 9                ;selects an invalid column so the cursor 
                                       ;doesn't blink initially
