;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                            ;
;                               UserInterface.inc                            ;
;                           User Interface Constants                         ;
;                                 Include File                               ;
;                                                                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; This file contains the definitions for the user interface file
; for game integration
;
; Revision History:
;     6/12/22  Purvi Sehgal        Added constants and values 


.EQU TURN_OFF_LED  = 0b00000000      ;turns off all the LEDs in the column
.EQU SET_HIGH_ROW_BIT = 0b10000000   ;turns on the high row bit for initialize 
                                     ;row mask
.EQU BYTES_PER_GAME  = 16            ;number of bytes the fixed and solution 
                                     ;bytes take up per game -> allows user 
									 ;to skip to the bytes for the next game
.EQU TOTAL_ROWS  = 8                 ;total number of rows in the LED
.EQU MAX_COLOR_VALUE = 3             ;maximum color value before it goes back 
.EQU MAX_GAMES = 8                   ;maximum number of game boards in the 
                                     ;EEROM
.EQU ILLEGAL_MOVE_SOUND_1 = 400      ;one of sounds played when illegal 
                                     ;move is made
.EQU TURN_OFF_SOUND = 0              ;turns off sound
.EQU CHECK_ALL_BITS_SET = 0b11111111 ;checks if all bits in column are set
.EQU WIN_MOVE_SOUND_1 = 4000         ;first sound played when game is won
.EQU WIN_MOVE_SOUND_2 = 3500         ;second sound played when game is won
.EQU LOSE_MOVE_SOUND_1 = 700         ;first sound played when game is lost
.EQU LOSE_MOVE_SOUND_2 = 650         ;second sound played when game is lost
.EQU GAME_1 = 0                      ;starts the game at the very first 
                                     ;game board
.EQU MAX_COLOR = 4                   ;sets the max color to be 4
