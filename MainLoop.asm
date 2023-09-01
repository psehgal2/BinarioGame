;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                            ;
;                                   MainLoop                                 ;
;                              Final Binario Game                            ;
;                                  EE/CS 10b                                 ;
;                                                                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;
;Binario Game Functional Specification
;Description:     The system is a Binario game with an 8 x 8 grid. The grid 
;                 already has some squares filled with either red or green. 
;                 These squares cannot be changed. The rest squares are empty, 
;				  and the user gets to choose what color (Red or Green) will 
;				  occupy the blank space. By the end of the game, every 
;                 square in the grid should either be red or green. However, 
;                 the rules to filling up the grid are: a color cannot occupy 
; 				  more than two consecutive spaces column-wise and row-wise, 
; 				  every row and column should have exactly four red squares 
;				  and four green squares, and no columns and rows should look 
;                 the same. There are also multiple tableaus on the system, so 
;                 the user can play more than one game. The program can be 
;                 exitted. If illegal moves are made (trying to change 
;                 a fixed position) a low-frequency single tone error sound 
;                 is produced            
;Input:           These are the following inputs:
;                    Switch Name:      Switch Type:           Description:
;                    Column Select     U/D Rotary encoder     Rotating this 
;															  switch, allows 
;                                                             user to select 
;                                                             different 
;                                                             squares 
;                                                             in a single 
;                                                             column    
;                    Row Select        L/R Rotary encoder     Rotating this 
;															  switch, allows 
; 															  the user to 
;															  select different 
;															  squares in a 
;															  single row
;                    Choose color      L/R Pushbutton switch  Pushing this 
;															  switch changes 
;															  the color of 
;                                						 	  the square 
;															  selected by 
;                                                             the rotary 
;															  encoders, 
;															  blinking 
;                                                             between red, 
;															  green, or 
;															  yellow and 
;															  no color
;                                                             with every 
;															  push. Pushing 
;															  the Row Select 
;															  rotary encoder 
;                                                             activates this 
;															  switch.
;                    Reset             U/D Pushbutton switch  Pushing this 
;															  switch changes 
;															  the tableau. 
;															  To reset, cycle 
;															  through 
;                                                             all the 8 
;															  tableaus 
;                                                             Pushing the 
;															  column select 
;                                                             rotary encoder 
;															  activates this 
;															  switch.
;Output:          A 8 x 8 LED display grid with squares of red, green, or no 
;				  color. 
;                 A speaker that plays different audios when the game is won, 
;				  lost, or an illegal move is made. 
;
;User Interface:  The game is shown on the 8 x 8 LED grid. Using the Row 
;				  Select rotary encoder, the user can select an LED 
;				  anywhere in a single row, and using the Column Select rotary 
;				  encoder, the user can select an LED anywhere in a column. 
;				  Thus, all the LEDs in the grid can be accessed using the 
;				  encoders. When the cursor reaches the end of a row or column
;                 it wraps around. When a LED is selected, it starts blinking 
;				  a default yellow. To change the color of the LEDs in the 
;				  square in the grid, the following should be done: First, 
;				  the Row Select rotary encoder should be pressed to stop the 
;				  blinking yellow. At this point, the square should start 
;				  blinking between red, green, or yellow and no color. 
;                 Every subsequent time the switch is pressed, the color 
;				  should cycle between green, red, or yellow and no color. 
;				  Moving to another square would "lock in" the color 
; 				  blinking at the previous square. However, if the color is 
;                 blinking yellow moving the cursor sets the LED to no color. 
;				  Any pixel that was not fixed at the beginning of the game
;                 can be changed. However, if the color was preset from the 
;                 beginning of the game, pressing the switch does not change 
;				  the color. Pressing the Column Select rotary encoder allows 
;				  the user to cycle through the game. To reset the game
;                 the user should cycle through all the game boards. The user 
;				  gets audio feedback via the speaker system when an illegal 
;				  move is made. If the game is won, a high frequency 
;                 tone is produced and the last column the user selected a 
;  				  color for flashes. Once the board is filled, the user 
; 				  has either won or lost. In that case, no LEDs can be changed. 
;				  The user must reset the tableau. If the game is lost, a 
;				  lower frequency frequency tone is produced
;Error Handling:  If the user tries to change a preset square, it doesn't 
;				  change it and should produce a low tone error noise 
;				  using the speaker system. If the user tries to move
;                 the cursor beyond the limits of the board, then the 
;				  cursor loops around to the exact same
;                 position on the other side. Long presses vs short 
;				  presses are not handled
;Algorithms:      None
;Data Structures: There are two 8 x 8 arrays. The first array represents the 
;				  array for a green LED and the second is for the red LED. 
;				  Each position in the array is analogous to each position 
;                 in the grid. A 1 means the color is on and a 0 means the 
;				  color LED is off. Moreover, if both of the colors are off 
;				  or both of them are on (AKA both have 0s or both have 1s, 
;				  no color should appear on the square). For example, for 
;				  the first element of the green LED array, if there is 1, 
;                 then the green LED is on at that position in the grid 
;				  (assuming the red LED array has a 0 at that spot). 
;                 If both green and red LED arrays have 0s at a point in the 
;				  array, then the grid will have no color at that position. 
;				  If both LEDs have 1s at a bit, then yellow color will appear. 
;Limitations:     There are only a certain number of games that can be played. 
;				  Moreover, the user can't randomly generate different games. 
;				  The second to last color set in the board has to be 
;                 red and the last color set has to be green otherwise the 
;				  player will always lose the game. Also, if the switches 
;			      are pressed too fast, the press will not be registered.
;Global Variables:None
;Known Bugs:      None  
;Special Notes:   Fun game!

;
; Revision History:
;    06/09/22 Purvi Sehgal              added initialization functions, 
;										include files, and asm files
;    06/10/22 Purvi Sehgal              added main loop and start game 
;                                       
;    06/12/22 Purvi Sehgal              demo'd




;set the device
.device ATMEGA64




;get the definitions for the device
.include  "m64def.inc"

;include files
.include "SwitchFunctions.inc"
.include "RotaryFunctions.inc"
.include "Display.inc"
.include "ReadEEROM.inc"
.include "PlayNote.inc"
.include "InitDDR.inc"
.include "Constants.inc"
.include "UserInterface.inc"
.include "1MsTimer0.inc"



.cseg


;setup the vector area

.org    $0000



        JMP     Start                   ;reset vector
        JMP     PC                      ;external interrupt 0
        JMP     PC                      ;external interrupt 1
        JMP     PC                      ;external interrupt 2
        JMP     PC                      ;external interrupt 3
        JMP     PC                      ;external interrupt 4
        JMP     PC                      ;external interrupt 5
        JMP     PC                      ;external interrupt 6
        JMP     PC                      ;external interrupt 7
        JMP     PC                      ;timer 2 compare match
        JMP     PC                      ;timer 2 overflow
        JMP     PC                      ;timer 1 capture
        JMP     PC                      ;timer 1 compare match A
        JMP     PC                      ;timer 1 compare match B
        JMP     PC                      ;timer 1 overflow
        JMP     Timer0InterruptHandler1Ms ;timer 0 compare match
        JMP     PC                      ;timer 0 overflow
        JMP     PC                      ;SPI transfer complete
        JMP     PC                      ;UART 0 Rx complete
        JMP     PC                      ;UART 0 Tx empty
        JMP     PC                      ;UART 0 Tx complete
        JMP     PC                      ;ADC conversion complete
        JMP     PC                      ;EEPROM ready
        JMP     PC                      ;analog comparator
        JMP     PC                      ;timer 1 compare match C
        JMP     PC                      ;timer 3 capture
        JMP     PC                      ;timer 3 compare match A
        JMP     PC                      ;timer 3 compare match B
        JMP     PC                      ;timer 3 compare match C
        JMP     PC                      ;timer 3 overflow
        JMP     PC                      ;UART 1 Rx complete
        JMP     PC                      ;UART 1 Tx empty
        JMP     PC                      ;UART 1 Tx complete
        JMP     PC                      ;Two-wire serial interface
        JMP     PC                      ;store program memory ready




; start of the actual program

Start:                                  ;start the CPU after a reset
        LDI     R16, LOW(TopOfStack)    ;initialize the stack pointer
        OUT     SPL, R16
        LDI     R16, HIGH(TopOfStack)
        OUT     SPH, R16


        ;call any initialization functions
        RCALL   OneMsTimer0Init
        RCALL   InitRotary
        RCALL   InitSwitch
        RCALL   InitDDRE
        RCALL   InitDDRB
		RCALL   InitSPI
        RCALL   InitSquareWaveTimer1
		RCALL   OneMsTimer0Init
        RCALL   InitDDRACD
        RCALL   InitLEDVariables
        SEI


        RCALL   StartGame                 ;start the game
        JMP     PC                  ;shouldn't return, but if it does, restart




;Description:             This function starts the game and helps set up the 
;                         initial tableau. It sets the cursor as well
;                         
;Operational Description: This function calls the set initial game state 
;                         function and the init cursor function, which sets
;                         a yellow-no color blinking cursor to the top 
;                         left corner of the board. It then starts the game
;						  main loop, which never terminates, so nothing 
;						  is returned 
;Arguments:         	  None
;Return Values:     	  None
;Global Variables:  	  None
;Shared Variables:  	  None
;Local Variables:   	  None
;Inputs:            	  None
;Outputs:                 None
;User Interface:          None
;Error Handling:          None
;Algorithms:              None
;Data Structures:         None
;Limitations:             None
;Known Bugs:              None
;Registers changed:       None



StartGame:
        RCALL   SetInitialGameState ;sets up the initial tableau
		RCALL   InitCursor         
		RCALL   GameMainLoop        


;Description:             This is the mainloop which controls the entire game. 
;						  When the switches are pressed or the rotary encoder 
;						  is rotated, it executes certain commands that 
;						  control the sound and LEDs. 
;Operational Description: If the rotary encoder functions return True, 
;						  indicating that a rotation has been made, 
;						  this main loop calls a function that changes the 
;						  cursor position. If the LRSwitch is pressed (we 
;						  know based on whether LRSwitch() == True),we call a 
;						  function that changes the color the LED is 
;						  blinking on. Lastly, if UDSwitch has been clicked 
;						  we select another tableau. We check if all the 
;						  LEDs are filled with red, green, or yellow LED. 
;						  If they have, then check if the user lost the game. 
;						  If the user lost, it outputs losing, low frequency 
; 						  sound. Otherwise, we output winning, high frequency 
;						  sound. Then code loops to the beginning of the loop
;						  this happens infinitely
;Arguments:         	  None
;Return Values:     	  None
;Global Variables:  	  None
;Shared Variables:  	  None
;Local Variables:   	  None
;Inputs:            	  Calls functions that handle rotary encoders and 
;						  switches
;Outputs:                 Calls functions to output sound and turn on LEDs
;User Interface:          None
;Error Handling:          None
;Algorithms:              None
;Data Structures:         None
;Limitations:             None
;Known Bugs:              None
;Registers changed:       None


GameMainLoop:
UpRotMain:
		RCALL   UpRot   			;checks if the U/D rotary encoder has 
									;been rotated counter clockwise
		BRNE    DownRotMain 
		CALL    UpdateCursorUpRot   ;if the U/D rotary encoder has been 
								    ;rotated counter 
                                    ;clockwise update cursor accordingly
DownRotMain:  
		RCALL   DownRot   			;checks if the U/D rotary encoder has 
									;been rotated clockwise
		BRNE    RightRotMain  
		CALL    UpdateCursorDownRot ;if the U/D rotary encoder has been 
									;rotated clockwise update cursor 
									;accordingly
RightRotMain:
		RCALL   RightRot   			;checks if the L/R rotary encoder has 
		                            ;been rotated clockwise
		BRNE    LeftRotMain
		CALL    UpdateCursorRightRot;if the L/R rotary encoder has been 
									;rotated clockwise update cursor 
									;accordingly
LeftRotMain:
		RCALL   LeftRot   			;checks if the L/R rotary encoder has 
									;been rotated counter clockwise
		BRNE    LRSwitchMain
		CALL    UpdateCursorLeftRot ;if the L/R rotary encoder has been 
									;rotated counter clockwise update 
									;cursor accordingly
LRSwitchMain:
		RCALL   LRSwitch  			;checks if the L/R switch has been 
									;pressed
		BRNE    UDSwitchMain
		CALL    UpdateCursorLRSwitch;if the L/R switch has been pressed, 
									;update the cursor accordingly
UDSwitchMain:
		RCALL   UDSwitch 			;checks if the U/D switch has been 
									;pressed
		BRNE    CheckWinLose 
		CALL    ResetGame			;if the U/D switch has been pressed
									;, reset the game
CheckWinLose:
		RCALL   AllSpacesAreFilled  ;check if all spaces are filled
		BREQ    CheckGameStatus 
RepeatGameMainLoop:
		RJMP    GameMainLoop  		;starts from the beginning of the 
									;loop
CheckGameStatus:
		RCALL   CheckWinGame 	    ;checks if game is won
		BREQ    WinGameMusic        ;if game is won, play win game 
									;music
		RCALL   PlayLoseSound       ;otherwise play lose sound 
		BREQ    RepeatGameMainLoop  ;reset game loop
WinGameMusic: 
		RCALL   PlayWinSound        ;play win sound if game has won
		BREQ    RepeatGameMainLoop  ;reset the game loop


.dseg 

; the stack - 128 bytes
                .BYTE   127
TopOfStack:     .BYTE   1           ;top of the stack


; buffer for data read from the EEROM
ReadBuffer:     .BYTE   128         ;EEROM is 1024 bits

; buffer containing the expected data from the EEROM
CompareBuffer:  .BYTE   128         ;EEROM is 1024 bits

;mainloop shared variables

;all the asm files
.include "RotaryFunctions.asm"
.include "SwitchFunctions.asm"
.include "1MsTimer0.asm"
.include "InitDDR.asm"
.include "ReadEEROM.asm"
.include "PlayNote.asm"
.include "Display.asm"
.include "UserInterface.asm"

