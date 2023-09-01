;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                            ;
;                             UserInterface.asm                              ;
;                         Binario Game Integration                           ;
;    Handles/Integrates Rotary and Switch Inputs and LED and Sound Outputs   ;
;                                                                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; This file contains the functions for playing a sound at a specific frequency 
; passed into registers R17 and R16. A frequency of zero means no sound should 
; be produced 
;
;
; Revision History:
;    06/10/22  Purvi Sehgal             set game board/EEROM functions
;    06/10/22  Purvi Sehgal             wrote sound and switch functions
;    06/10/22  Purvi Sehgal             wrote encoder handler functions
;    06/10/22  Purvi Sehgal             wrote buffer functions
;    06/11/22  Purvi Sehgal             wrote endgame functions


.cseg


;Description: 			  This sets up the initial game state by calling 
;                         the first puzzle in the EEROM.
;Operational Description: This sets the game number to zero to indicate the 
;                         first game and calls the SetGameState function 
;Arguments: 			  None
;Return Values: 		  None
;Global Variables:        None
;Shared Variables:        Sets gameNumber to be equal to zero
;Local Variables:         None
;Inputs:                  None
;Outputs:                 None
;User Interface:          None
;Error Handling:          None
;Algorithms:              None
;Data Structures:         None
;Limitations:             None
;Known Bugs:              None
;Registers changed:       R16

SetInitialGameState:
   LDI    R16, GAME_1                      ;starts the game at the very first 
   										   ;game board
   STS    gameNumber, R16                  ;shared variables allows user to 
   										   ;play multiple games			
   RCALL  SetGameState                     ;adds the starting board pattern 
   										   ;to both the game state and display
   RET


;Description:             This method initializes the game state buffer (which 
;                         is similar to the plot pixel function in that it has 
;                         a red buffer and green buffer and stores the color 
;                         at all the rows and columns in the LED). 
;Operational Description: This method sets all the rows and columns in the red 
;                         and green buffers to be zero. 
;Arguments:               None
;Return Values:           None
;Global Variables:        None
;Shared Variables:        The following variables are set: gameStateRedBuffer
;                         , gameStateGreenBuffer
;Local Variables:         None
;Inputs:                  None
;Outputs:                 None
;User Interface:          None         
;Data Structures:         None
;Limitations:             None
;Known Bugs:              None
;Registers changed:       R16, YL, YH, ZL, ZH, R18


CreateGameStateBuffer:
InitializeCurrentColumnNumber:
   LDI    R16, 0                           ;sets starting column number to 
                                           ;zero
   LDI    YL, LOW(gameStateRedBuffer)      ;initializes pointer for 
    									   ;gameStateRedBuffer
   LDI    YH, HIGH(gameStateRedBuffer)     ;initializes pointer for 
   										   ;gameStateRedBuffer
   LDI    ZL, LOW(gameStateGreenBuffer)    ;initializes pointer for 
   										   ;gameStateGreenBuffer
   LDI    ZH, HIGH(gameStateGreenBuffer)   ;initializes pointer for 
   										   ;gameStateGreenBuffer
   LDI    R18, TURN_OFF_LED                ;no LEDs should be on in the 
                                           ;column initially
;  RJMP  CheckCurrentColumnNumber          ;start executing the for 
                                           ;loop details

CheckCurrentColumnNumber:
   CPI    R16, TOTAL_COLUMNS 			   ;check if has looped through all 
   										   ;columns
   BRLT   TurnOffLEDInColumn 			   ;turns off LEDs in the specific 
   										   ;column 
   										   ;for red & green game state buffers
   RJMP   CreateGameStateBufferEndLoop     ;terminates the function if has 
   										   ;looped through all the columns

TurnOffLEDInColumn:
   ST     Y+, R18 						   ;turns off all LEDs in the column 
   									       ;for the gameStateRedBuffer and
										   ;increments pointer to the next 
										   ;column 
   ST     Z+, R18 						   ;turns off all LEDs in the column 
   										   ;for the gameStateGreenBuffer and 
										   ;increments pointer to the next 
										   ;column
   INC    R16     						   ;increments current column number 
   										   ;by one to highlight one completed 
										   ;loop
   RJMP   CheckCurrentColumnNumber         ;jumps back to run more loops 

CreateGameStateBufferEndLoop:
   RET                                     ;terminates the function by 
   										   ;returning back to the function 
										   ;that called this one 
 



;Description:             This function copies everything from the red 
;                         game state buffer to the red display buffers.
;Operational Description: This iterates through all the bytes in the game 
;						  state buffers and replaces the bytes in the 
;                         display buffers with those the game state 
;                         buffer bytes for red
;Arguments:               None
;Return Values:           None
;Global Variables:        None
;Shared Variables:        Reads gameStateRedBuffer
;Local Variables:         None
;Registers changed:       R16, ZL, ZH, R20
;Registers accessed:      YL, YH
;Inputs:                  None
;Outputs:                 None
;User Interface:          None
;Error Handling:          None
;Algorithms:              None
;Data Structures:         None
;Limitations:             None
;Known Bugs:              None

MoveGameStateToRedBuffer:
   LDI    R16, 0                           ;sets starting column number to 
   										   ;zero
   LDI    YL, LOW(gameStateRedBuffer)      ;initializes pointer for 
   										   ;gameStateRedBuffer
   LDI    YH, HIGH(gameStateRedBuffer)     ;initializes pointer for 
   										   ;gameStateRedBuffer
   LDI    ZL, LOW(redBuffer)               ;initializes pointer for redBuffer
   LDI    ZH, HIGH(redBuffer)              ;initializes pointer for redBuffer

CheckGameStateColumnNumber:
   CPI    R16, TOTAL_COLUMNS               ;check if has looped through all 
                                           ;the columns
   BRLT   MoveFromGameStateToDisplay 
   RJMP   MoveGameStateEndLoop             ;terminates the function if has 
   										   ;looped through all the columns

MoveFromGameStateToDisplay:
   LD     R20, Y+                          ;stores the red buffer from the 
   										   ;game state
   ST     Z+, R20                          ;stores the game state byte into 
   										   ;the red buffer
   INC    R16                              ;increments column number
   RJMP   CheckGameStateColumnNumber       ;loops back to see if has gone 
   										   ;through all the bytes

MoveGameStateEndLoop:
   RET                                     ;terminates the function 


;Description:             This function copies everything from the green 
;                         game state buffer to the green display buffers.
;Operational Description: This iterates through all the bytes in the game state 
;                         buffers and replaces the bytes in the display buffers 
;                         with those the game state buffer bytes for green
;Arguments:               None
;Return Values:           None
;Global Variables:        None
;Shared Variables:        Reads gameStateGreenBuffer
;Local Variables:         None
;Registers changed:       R16, ZL, ZH, R20
;Registers accessed:      YL, YH
;Inputs:                  None
;Outputs:                 None
;User Interface:          None
;Error Handling:          None
;Algorithms:              None
;Data Structures:         None
;Limitations:             None
;Known Bugs:              None

MoveGameStateToGreenBuffer:
   LDI    R16, 0                           ;sets starting column number to zero
   LDI    YL, LOW(gameStateGreenBuffer)    ;initializes pointer for 
   										   ;gameStateGreenBuffer
   LDI    YH, HIGH(gameStateGreenBuffer)   ;initializes pointer for 
   										   ;gameStateGreenBuffer
   LDI    ZL, LOW(greenBuffer)             ;initializes pointer for greenBuffer
   LDI    ZH, HIGH(greenBuffer)            ;initializes pointer for greenBuffer

GreenCheckGameStateColumnNumber:
   CPI    R16, TOTAL_COLUMNS               ;check if has looped through all 
   									       ;the columns
   BRLT   GreenMoveFromGameStateToDisplay 
   RJMP   GreenMoveGameStateEndLoop        ;terminates the function if has 
   										   ;looped through all the columns

GreenMoveFromGameStateToDisplay:
   LD    R20, Y+                           ;stores the green buffer from the 
   										   ;game state
   ST    Z+, R20                           ;stores the game state byte into 
                                           ;the green buffer
   INC   R16                               ;increments column number
   RJMP  GreenCheckGameStateColumnNumber   ;loops back to see if has gone 
   										   ;through all the bytes

GreenMoveGameStateEndLoop:
   RET  ;terminates the function 



;Description:             This method sets the game state and gets the starting 
;                         board from the EEROM. It then adds this starting 
;                         board pattern to both the game state and display.  
;Operational Description: This calls a function to initialize a game state 
;                         buffer with red & green game state buffers. It then 
;                         calls the EEROM to get the board pattern. 
;                         It determines which bits to write to the buffers 
;                         by combining the EEROM solution and fixed bytes. 
;                         It then moves these values to the display buffers. 
;Arguments:               None
;Return Values:           None
;Global Variables:        None
;Shared Variables:        It accesses the gameNumber variable, allocates the 
;                         ReadBuffer section in memory, and sets 
;                         gameStateRedBuffer and gameStateGreenBuffer
;Local Variables:         None
;Registers changed:       R16, R17, YL, YH, XL, XH, ZL, ZH, R19, R20, R22, R21 
;Inputs:                  None
;Outputs:                 None
;User Interface:          None
;Error Handling:          None
;Algorithms:              None
;Data Structures:         None
;Limitations:             None
;Known Bugs:              None

SetGameState:
   RCALL CreateGameStateBuffer             ;initializes the red and green game 
   										   ;state buffers
   LDI   R16, BYTES_PER_GAME               ;number of bytes the fixed and 
   										   ;solution bytes take up per game -> 
										   ;allows user to skip to the bytes 
										   ;for the next game
   LDS   R17, gameNumber        
   MUL   R17, R16                          ;finds the starting address for 
   										   ;the EEROM game data
   MOV   R17, R0                           ;copies the multiplication result 
   										   ;into another register 
   LDI   YL, LOW(ReadBuffer)               ;loads a buffer that EEROM data 
   										   ;is passed into 
   LDI   YH, HIGH(ReadBuffer)              ;loads a buffer that EEROM data 
   										   ;is passed into 
   RCALL ReadEEROM                         ;reads n bytes from the EEROM 
   										   ;and puts the values starting at 
										   ;the Y register address
  ;RJMP InitializeEEROMColumnNumber  

InitializeEEROMColumnNumber:
   LDI   R16, 0                            ;sets starting column number to
   										   ;zero
  ;RJMP  InitializeGameStateBuffers
InitializeGameStateBuffers:
   LDI   XL, LOW(gameStateRedBuffer)       ;initializes pointer for 
   										   ;gameStateRedBuffer
   LDI   XH, HIGH(gameStateRedBuffer)      ;initializes pointer for 
   										   ;gameStateRedBuffer
   LDI   ZL, LOW(gameStateGreenBuffer)     ;initializes pointer for 
   										   ;gameStateGreenBuffer
   LDI   ZH, HIGH(gameStateGreenBuffer)    ;initializes pointer for 
   										   ;gameStateGreenBuffer
;  RJMP  CheckEEROMColumnNumber            ;start executing the for loop
										   ;details

CheckEEROMColumnNumber:
   CPI   R16, TOTAL_COLUMNS                ;check if has looped through 
   									       ;all the columns
   BRLT  AddEEROMToGameState               ;updates the game state green 
   										   ;and red buffers based on data 
										   ;from the EEROM
   RJMP  SetGameStateEndLoop               ;terminates the function if has 
   										   ;looped through all the columns

AddEEROMToGameState:
   LDI   YL, LOW(ReadBuffer)               ;accesses the first byte of the 
   										   ;EEROM data
   LDI   YH, HIGH(ReadBuffer)              ;accesses the first byte of the 
   										   ;EEROM data
   ADD   YL, R16                           ;moves the pointer to the correct 
                                           ;byte of the EEROM data
   LDI   R19, 0
   ADC   YH, R19
   LD    R20, Y                            ;stores the solution byte of a 
   										   ;certain column (R16)
   LDI   R22, TOTAL_COLUMNS
   ADD   YL, R22                           ;moves the pointer to access the 
                                           ;fixed position byte at that 
										   ;column
   LDI   R19, 0
   ADC   YH, R19
   LD    R21, Y                            ;stores the EEROM fixed position 
   										   ;byte of a certain column (R16)
   MOV   R22, R21                          ;makes a copy of the fixed 
                                           ;position byte so that we can 
										   ;change it
   AND   R22, R20 
   ST    X+, R22                           ;stores the fixed green LEDs in 
                                           ;the game state green buffer at 
										   ;a certain column
   COM   R20                               ;to adjust the solution byte for 
                                           ;the green LEDs
   AND   R21, R20 
   ST    Z+, R21                           ;stores the fixed green LEDs in 
                                           ;the game state green buffer at 
										   ;a certain column
   INC   R16                               ;increments current column 
   										   ;number by one to highlight one 
										   ;completed loop
   RJMP  CheckEEROMColumnNumber            ;jumps back to run more loops 

SetGameStateEndLoop:
   RCALL ClearDisplay
   RCALL MoveGameStateToRedBuffer          ;moves fixed LEDs to display 
                                           ;buffer so they are displayed 
										   ;on the board
   RCALL MoveGameStateToGreenBuffer        ;moves fixed LEDs to display 
                                           ;buffer so they are displayed 
										   ;on the board
   RET                                     ;terminates the function 
 

;Description:             This method initializes the cursor to blink between 
;                         yellow and no color in the left corner of the LED. 
;Operational Description: Sets the row and column to be zero and the colors 
;                         to be yellow and no color and then calls the set 
;                         cursor function. This function also sets row and 
;                         column position to be shared variables so that they 
;                         can be modified in other functions. 
;Arguments:               None
;Return Values:           None
;Global Variables:        None
;Shared Variables:        Sets blinkColorSelect which iterates through 
;                         different blinking colors when the switch is 
;                         pressed, rowPos (row number), and columnPos (column 
;                         number). 
;Local Variables:         None
;Registers changed:       R16, R17, R18, R19, R20
;Inputs:                  None
;Outputs:                 None
;User Interface:          None
;Error Handling:          None
;Algorithms:              None
;Data Structures:         None
;Limitations:             None
;Known Bugs:              None


InitCursor:
   LDI   R20, LED_OFF
   STS   blinkColorSelect, R20             ;the initial blinking LED color 
                                           ;when the LR switch is pressed 
										   ;is set to no color 
   LDI   R16, 0                            ;initial row is set to the 
   										   ;top-most row
   LDI   R17, 0                            ;initial column is set to the 
   										   ;left-most column
   STS   rowPos, R16
   STS   columnPos, R17
   LDI   R18, YELLOW_COLOR_VALUE           ;sets the first cursor color 
   										   ;to yellow
   LDI   R19, LED_OFF                      ;sets the second cursor color 
   										   ;to no color
   RCALL SetCursor                         ;sets the cursor to blink 
   										   ;between yellow and no color 
										   ;in the left, top-most corner
   RET                                     ;terminates the function


;Description:             Plays a low frequency sound when user tries to
;                         change a fixed pixel
;Operational Description: This function inputs a low frequency and calls the 
;                         play note function. It also calls Delay function
;                         It then turns off the sound
;Arguments:               None
;Return Values:           None
;Global Variables:        None
;Shared Variables:        None 
;Local Variables:         None
;Inputs:                  None
;Outputs:                 A low frequency sound is produced for a short
;                         period of time 
;Registers changed:       R16, R17
;User Interface:          None
;Error Handling:          None
;Algorithms:              None
;Data Structures:         None
;Limitations:             None
;Known Bugs:              None


PlayIllegalMoveSound:
   LDI   R16, LOW(ILLEGAL_MOVE_SOUND_1)    ;plays a low-frequency illegal 
   										   ;move sound
   LDI   R17, HIGH(ILLEGAL_MOVE_SOUND_1)   ;plays a low-frequency illegal 
                                           ;move sound
   RCALL PlayNote              
   RCALL Delay16                           ;holds the note for a short 
                                           ;period of time
   LDI   R16, TURN_OFF_SOUND               ;turns off the speaker
   LDI   R17, TURN_OFF_SOUND               ;turns off the speaker
   RCALL PlayNote              
   RET                                     ;turns off the function

;Description:             Plays a high frequency sound when user wins the 
;                         game
;Operational Description: This function inputs a high frequency and calls the 
;                         play note function. It also calls Delay function
;Arguments:               None
;Return Values:           None
;Global Variables:        None
;Shared Variables:        None 
;Local Variables:         None
;Inputs:                  None
;Outputs:                 A high frequency sound is produced 
;Registers changed:       R16, R17
;User Interface:          None
;Error Handling:          None
;Algorithms:              None
;Data Structures:         None
;Limitations:             None
;Known Bugs:              None

PlayWinSound:
   LDI   R16, LOW(WIN_MOVE_SOUND_1)        ;plays a high-frequency win 
   										   ;game sound
   LDI   R17, HIGH(WIN_MOVE_SOUND_1)       ;plays a high-frequency win 
   										   ;game sound
   RCALL PlayNote              
   RCALL Delay16                           ;holds the note for a short 
   										   ;period of time
   LDI   R16, LOW(WIN_MOVE_SOUND_2)        ;plays a high-frequency win 
   										   ;game sound
   LDI   R17, HIGH(WIN_MOVE_SOUND_2)       ;plays a high-frequency win 
   										   ;game sound
   RCALL PlayNote              
   RCALL Delay16                           ;holds the note for a short 
   										   ;period of time 

   RET                                     ;turns off the function



;Description:             Plays a low frequency sound when user loses the 
;                         game
;Operational Description: This function inputs a low frequency and calls the 
;                         play note function. It also calls Delay function
;Arguments:               None
;Return Values:           None
;Global Variables:        None
;Shared Variables:        None 
;Local Variables:         None
;Inputs:                  None
;Outputs:                 A low frequency sound is produced 
;Registers changed:       R16, R17
;User Interface:          None
;Error Handling:          None
;Algorithms:              None
;Data Structures:         None
;Limitations:             None
;Known Bugs:              None


PlayLoseSound:
   LDI   R16, LOW(LOSE_MOVE_SOUND_1)       ;plays a low-frequency lose 
   										   ;game sound
   LDI   R17, HIGH(LOSE_MOVE_SOUND_1)      ;plays a low-frequency lose 
   										   ;game sound
   RCALL PlayNote              
   RCALL Delay16                           ;holds the note for a short 
   										   ;period of time 
   LDI   R16, LOW(LOSE_MOVE_SOUND_2)       ;plays a low-frequency lose 
   										   ;game sound
   LDI   R17, HIGH(LOSE_MOVE_SOUND_2)      ;plays a low-frequency lose 
   										   ;game sound
   RCALL PlayNote              
   RCALL Delay16                           ;holds the note for a short 
   										   ;period of time     
   RET                                     ;turns off the function


;Delay16
;
;Description:             This procedure delays number of clocks in R16
;                         times 80000. Thus with a 8 MHz clock the delay 
;                         passed is in 10 millisecond units.
;Operational Description: The function just loops decrementing Y until it 
;                         is 0
;Arguments:               R16 - 1/80000 the number of CPU clocks to delay.
;Return Value:            None
;Local Variables:         None
;Shared Variables:        None
;Global Variables:        None
;Input:                   None
;Output:                  None
;Error Handling:          None
;Algorithms:              None
;Data Structures:         None
;Registers Changed:       flags, R16, Y (YH | YL)
;Stack Depth:             0 bytes
;Author:                  Glen George
;Last Modified:           May 6, 2018

Delay16:

Delay16Loop:                               ;outer loop runs R16 times
   LDI   YL, LOW(20000)                    ;inner loop is 4 clocks
   LDI   YH, HIGH(20000)                   ;so loop 20000 times to get 
                                           ;80000 clocks
Delay16InnerLoop:                          ;do the delay
   SBIW  Y, 1
   BRNE  Delay16InnerLoop

   DEC   R16                               ;count outer loop iterations
   BRNE  Delay16Loop

DoneDelay16:                               ;done with the delay loop - 
										   ;return
   RET


;Description:             When the LR switch is pressed, it starts blinking 
;                         between green, red, or yellow and no color. It 
;                         then sets the pixel color to be the blinking color
;Operational Description: If the LRSwitch is pressed (we know based on 
;                         whether LRSwitch() == True), we increment 
;                         blinkColorSelect, which changes the color the LED 
;                         is blinking on. Then, we update the cursor with 
;                         this new color value. Then, we check if it is an 
;                         illegal move by calling the function. If it is 
;                         not, we update the game state buffer and the plot 
;                         pixel function. 
;Arguments:               None
;Return Values:           None
;Global Variables:        None
;Shared Variables:        Accesses and sets blinkColorSelect which iterates 
;                         through different blinking colors when the switch 
;                         is pressed, accesses rowPos (row number) and 
;                         columnPos 
;                         (column number). 
;Local Variables:         None
;Registers changed:       R16, R17, R18, R19, R20, R21
;Inputs:                  None
;Outputs:                 Calls function that plots pixels
;User Interface:          None
;Error Handling:          None
;Algorithms:              None
;Data Structures:         None
;Limitations:             None
;Known Bugs:              None


UpdateCursorLRSwitch:
   LDS   R20, blinkColorSelect
   LDI   R21, MAX_COLOR_VALUE              ;enables switching first color 
   										   ;between red, green, and yellow
   RCALL Mod                               ;calculates blinkColorSelect % 
   										   ;MAX_COLOR_VALUE
   INC   R20 
   STS   blinkColorSelect, R20             ;updates blinkColorSelect with 
   										   ;mod value
   MOV   R18, R20                          ;sets blinkColorSelect as the 
   										   ;first color
   LDI   R19, LED_OFF                      ;sets the second blink color 
   ;									   ;to be no color
   LDS   R16, rowPos 
   LDS   R17, columnPos  
   RCALL SetCursor                         ;sets the cursor to blink 
   										   ;between red, green, or yellow 
										   ;and no color at a certain 
										   ;position
   LDS   R16, rowPos 
   LDS   R17, columnPos
   RCALL CheckIllegalMove                  ;checks if trying to change 
                                           ;fixed position
   BREQ  ChangePixelColor                  ;if not illegal, changes the 
                                           ;pixel in the game state buffer 
										   ;and on the display
   RCALL PlayIllegalMoveSound              ;if makes an illegal move, play 
                                           ;the illegal move sound  
   RJMP  UpdateCursorEndLoop
ChangePixelColor:
   CPI   R18, YELLOW_COLOR_VALUE           ;check if blink color is yellow
   BRNE  UpdateBuffers                     ;if not blinking yellow set 
                                           ;normally
TurnOffLed:
   MOV   R18, R19                          ;set the pixel color to no 
                                           ;color if blinking yellow
   RJMP  UpdateBuffers
UpdateBuffers: 
   RCALL UpdateGameStateBuffer
   RCALL MoveGameStateToRedBuffer
   RCALL MoveGameStateToGreenBuffer
   RCALL PlotPixel
UpdateCursorEndLoop:
   RET         


;Description:             When the UDSwitch is pressed, we reset
;                         the game to the next tableau. To access
;                         the current tableau, the user should
;                         cycle through all the tableaus
;Operational Description: If the UDSwitch is pressed (we know based on 
;                         whether UDSwitch() == True), turn off sound
;                         clear the display, increment the game number,
;                         and set up a new board
;Arguments:               None
;Return Values:           None
;Global Variables:        None
;Shared Variables:        Accesses and sets gameNumber 
;Local Variables:         None
;Registers changed:       R16, R17, R20, R21
;Inputs:                  None
;Outputs:                 Calls function to turn off sound
;User Interface:          None
;Error Handling:          None
;Algorithms:              None
;Data Structures:         None
;Limitations:             None
;Known Bugs:              None

ResetGame:
   LDI   R16, TURN_OFF_SOUND               ;turns off the speaker
   LDI   R17, TURN_OFF_SOUND               ;turns off the speaker
   RCALL PlayNote
   RCALL ClearDisplay                      ;clears the display
   LDS   R20, gameNumber 
   INC   R20                       		   ;goes to the next game
   LDI   R21, MAX_GAMES                    ;once at the last game 
   										   ;board, resets to the 
										   ;first game board
   RCALL Mod                               ;once at the last game 
                                           ;board, resets to the 
										   ;first game board
   STS   gameNumber, R20                   ;stores the new game 
                                           ;number in the shared 
										   ;variable
   RCALL SetGameState                      ;sets up a new game 
                                           ;board
   RET


;Description:             When the UD rotary encoder is rotated 
;                         counter-clockwise, we move the cursor one 
;                         spot upwards
;Operational Description: Sets the first cursor color to yellow and 
;                         the second to no color and decrements the 
;                         cursor row position
;Arguments:               None
;Return Values:           None
;Global Variables:        None
;Shared Variables:        Accesses and sets rowPos, columnPos
;                         blinkCounter
;Local Variables:         None
;Registers changed:       R16, R17, R18, R19, R20, R21
;Inputs:                  None
;Outputs:                 Calls function to set cursor
;User Interface:          None
;Error Handling:          None
;Algorithms:              None
;Data Structures:         None
;Limitations:             None
;Known Bugs:              None

UpdateCursorUpRot:
   LDI R18, YELLOW_COLOR_VALUE             ;sets the first cursor 
   										   ;color to yellow
   LDI   R19, LED_OFF                      ;sets the second cursor 
   										   ;color to no color
   STS   blinkCounter, R19                 ;resets blink counter 
   										   ;so it starts at red 
										   ;everytime
   LDS   R20, rowPos 
   DEC   R20                               ;decrements the cursor 
                                           ;row position by 1
   LDI   R21, TOTAL_ROWS                   ;total rows in the LED 
   RCALL Mod                               ;Calculates rowPos % 
   										   ;TOTAL_ROWS
   MOV   R16, R20                          ;the mod row is inputted 
   										   ;into the set cursor 
										   ;function
   STS   rowPos, R16                       ;stores new column value 
                                           ;back into shared 
										   ;variable
   LDS   R17, columnPos 
   RCALL SetCursor                         ;sets cursor to blink 
                                           ;between yellow and 
										   ;no color at original 
										   ;column
   RET



;Description:             When the UD rotary encoder is rotated 
;                         clockwise, we move the cursor one 
;                         spot downwards
;Operational Description: Sets the first cursor color to yellow and 
;                         the second to no color and increments the 
;                         cursor row position
;Arguments:               None
;Return Values:           None
;Global Variables:        None
;Shared Variables:        Accesses and sets rowPos, columnPos
;                         blinkCounter
;Local Variables:         None
;Registers changed:       R16, R17, R18, R19, R20, R21
;Inputs:                  None
;Outputs:                 Calls function to set cursor
;User Interface:          None
;Error Handling:          None
;Algorithms:              None
;Data Structures:         None
;Limitations:             None
;Known Bugs:              None 
UpdateCursorDownRot:
   LDI   R18, YELLOW_COLOR_VALUE           ;sets the first cursor color to 
   										   ;yellow
   LDI   R19, LED_OFF                      ;sets the second cursor color 
   										   ;to no color
   STS   blinkCounter, R19                 ;resets blink counter so it 
                                           ;starts at red everytime
   LDS   R20, rowPos 
   INC   R20                               ;increments the cursor row 
                                           ;position by 1
   LDI   R21, TOTAL_ROWS                   ;total rows in the LED 
   RCALL Mod                               ;Calculates rowPos % 
                                           ;TOTAL_ROWS
   MOV   R16, R20                          ;the mod row is inputted into 
                                           ;the set cursor function
   STS   rowPos, R16                       ;stores new column value back 
                                           ;into shared variable
   LDS   R17, columnPos 
   RCALL SetCursor                         ;sets cursor to blink between 
                                           ;yellow and no color at 
										   ;original column
   RET


;Description:             When the LR rotary encoder is rotated 
;                         clockwise, we move the cursor one 
;                         spot to the right
;Operational Description: Sets the first cursor color to yellow and 
;                         the second to no color and increments the 
;                         cursor column position
;Arguments:               None
;Return Values:           None
;Global Variables:        None
;Shared Variables:        Accesses and sets rowPos, columnPos
;                         blinkCounter
;Local Variables:         None
;Registers changed:       R16, R17, R18, R19, R20, R21
;Inputs:                  None
;Outputs:                 Calls function to set cursor
;User Interface:          None
;Error Handling:          None
;Algorithms:              None
;Data Structures:         None
;Limitations:             None
;Known Bugs:              None

UpdateCursorRightRot:
   LDI   R18, YELLOW_COLOR_VALUE           ;sets the first cursor color to
                                           ;yellow
   LDI   R19, LED_OFF                      ;sets the second cursor color 
   										   ;to no color
   STS   blinkCounter, R19                 ;resets blink counter so it 
    									   ;starts at red everytime
   LDS   R20, columnPos 
   INC   R20                               ;increments the cursor column 
   									       ;position by 1
   LDI   R21, TOTAL_COLUMNS                ;total columns in the LED 
   RCALL Mod                               ;Calculates columnPos % 
   										   ;TOTAL_COLUMNS
   MOV   R17, R20                          ;the mod column is inputted 
   										   ;into the set cursor function
   STS   columnPos, R17                    ;stores new column value back 
   										   ;into shared variable
   LDS   R16, rowPos
   RCALL SetCursor                         ;sets cursor to blink between 
                                           ;yellow and no color at 
										   ;original column
   RET

;Description:             When the LR rotary encoder is rotated 
;                         counter-clockwise, we move the cursor one 
;                         spot to the left
;Operational Description: Sets the first cursor color to yellow and 
;                         the second to no color and decrements the 
;                         cursor column position
;Arguments:               None
;Return Values:           None
;Global Variables:        None
;Shared Variables:        Accesses and sets rowPos, columnPos
;                         blinkCounter
;Local Variables:         None
;Registers changed:       R16, R17, R18, R19, R20, R21
;Inputs:                  None
;Outputs:                 Calls function to set cursor
;User Interface:          None
;Error Handling:          None
;Algorithms:              None
;Data Structures:         None
;Limitations:             None
;Known Bugs:              None

UpdateCursorLeftRot:
   LDI   R18, YELLOW_COLOR_VALUE           ;sets the first cursor color to 
   										   ;yellow
   LDI   R19, LED_OFF                      ;sets the second cursor color
                                           ;to no color
   STS   blinkCounter, R19                 ;resets blink counter so it 
   	 									   ;starts at red everytime
   LDS   R20, columnPos 
   DEC   R20                               ;decrements the cursor column 
   										   ;position by 1
   LDI   R21, TOTAL_COLUMNS                ;total columns in the LED 
   RCALL Mod                               ;Calculates columnPos % 
   										   ;TOTAL_COLUMNS
   MOV   R17, R20                          ;the mod column is inputted 
   										   ;into the set cursor function
   STS   columnPos, R17                    ;stores new column value back 
   										   ;into shared variable
   LDS   R16, rowPos
   RCALL SetCursor                         ;sets cursor to blink between 
   										   ;yellow and no color at 
										   ;original column
   RET



;Description:             This function takes row number (r -> R16) and column 
;                         number (c->17) and sets the LED to a certain color 
;                         (R18) in the specific pixel in Red/Green 
;                         game state buffers.A color value of 0 means the pixel 
;                         is off, a color value of 1 means the pixel is red, 
;                         and a color value of 2 means it is green, and 3 means 
;                         yellow. 0 for r means the top row and 0 for c means 
;                         the left most column. 
;Operational Description: If the color value is equal to zero, then this 
;                         function accesses  column C in both the 
;                         gameStateRedBuffer and gameStateGreenBuffer and sets 
;                         bit r equal to 0. For color = 1, the function 
;                         accesses column C in gameStateGreenBuffer and 
;                         gameStateRedBuffer and sets bits r equal to 1 and 0, 
;                         respectively. For color = 2, the function accesses 
;                         column C in gameStateGreenBuffer and 
;                         gameStateRedBuffer and sets bits r equal to 0 and 1, 
;                         respectively. For color = 3, the function accesses 
;                         column C in gameStateGreenBuffer and 
;                         gameStateRedBuffer and sets bits r equal to 1 and 1, 
;                         respectively.
;Arguments:               This function takes in the row number (r) from 0->8, 
;                         the column number (c) from 0->8, and the color from 
;                         0->3. A color value of 0 means the pixel is off, a 
;                         color value of 1 means the pixel is red, and a color 
;                         value of 2 means it is green, and 3 means yellow. 0 
;                         for r means the top row and 0 for c means the left 
;                         most column.
;Registers changed:       R16, R17, R18, R19, R20, R21, R22, YL, YH, ZL, ZH
;Return Values:           None
;Global Variables:        None
;Shared Variables:        Modifies gameStateRedBuffer and gameStateGreenBuffer
;                         rowMask
;Local Variables:         None
;Inputs:                  None
;Outputs:                 None
;User Interface:          None
;Error Handling:          If the arguments are not valid (for example, if the 
;                         column value entered is greater than max columns), 
;                         then this function returns back to the function 
;                         that called it
;Algorithms:              None
;Data Structures:         Very similar to a 2-D array, this employs a 2-D 
;                         matrix
;Limitations:             None
;Known Bugs:              None


UpdateGameStateBuffer:
CheckGameInvalidArguments:
   CPI   R16, TOTAL_ROWS                   ;checks if row number is invalid 
   										   ;(greater than or equal to total 
										   ;rows)
   BRGE  GamePixelEndLoop                  ;if row number is invalid, end 
   										   ;function
   CPI   R17, TOTAL_COLUMNS                ;checks if column number is 
   										   ;invalid (greater than or equal 
										   ;to total columns)
   BRGE  GamePixelEndLoop                  ;if column number is invalid, 
                                           ;end function
   CPI   R18, MAX_COLOR                    ;checks if color number is 
   										   ;invalid (greater than or equal 
										   ;to max color)
   BRGE  GamePixelEndLoop                  ;if color number is invalid, 
                                           ;end function
  ;RJMP InitializeRowMask
InitializeRowMask:
   LDI   R22, SET_HIGH_ROW_BIT             ;turns on the high row bit for 
   										   ;initialize row mask
   STS   rowMask, R22
  ;RJMP InitializeBuffers
InitializeBuffers:
   LDI   YL, LOW(gameStateRedBuffer)       ;initializes pointer for 
                                           ;gameStateRedBuffer
   LDI   YH, HIGH(gameStateRedBuffer)      ;initializes pointer for 
                                           ;gameStateRedBuffer
   LDI   ZL, LOW(gameStateGreenBuffer)     ;initializes pointer for 
                                           ;gameStateGreenBuffer
   LDI   ZH, HIGH(gameStateGreenBuffer)    ;initializes pointer for 
                                           ;gameStateGreenBuffer
  ;RJMP InitializeGameCounter
InitializeGameCounter:
   LDI   R21, 0                            ;initializes counter determining 
                                           ;which row bit is on
   RJMP  CheckCorrectRowMask               ;start executing the for loop 
                                           ;details

CheckCorrectRowMask:
   CP    R21, R16                          ;determines if the row mask rth 
                                           ;bit is set high
   BRLT  ShiftRowMask                      ;shifts the row mask if it hasn't 
                                           ;looped through enough times
   RJMP  GamePixelCheckColor               ;checks which color was inputted 
                                           ;in the arguments by comparing to 
										   ;constants

ShiftRowMask:
   LDS   R22, rowMask
   LSR   R22                               ;selects a different row every 
   										   ;time LSR is called
   STS   rowMask, R22                      ;updates row mask back into the 
   										   ;shared variable
   INC   R21                               ;indicates which bit is currently 
                                           ;set
   RJMP  CheckCorrectRowMask               ;jumps back to run more loops 

GamePixelCheckColor:
   CPI   R18, GREEN_COLOR_VALUE            ;checks if the color is green 
   BREQ  GameColorIsGreen                  ;if so, it handles it in the 
                                           ;buffers
   CPI   R18, RED_COLOR_VALUE              ;checks if the color is red
   BREQ  GameColorIsRed                    ;if so, it handles it in the 
                                           ;buffers
   CPI   R18, LED_OFF                      ;checks if there is no color
   BREQ  GameNoColor                       ;if so, it handles it in the 
                                           ;buffers
   CPI   R18, YELLOW_COLOR_VALUE           ;checks if the color is yellow
   BREQ  GameColorIsYellow                 ;if so, it handles it in the 
                                           ;buffers

GamePixelEndLoop:
   RET                                     ;terminates current function
GameColorIsGreen:
   ADD  ZL, R17                            ;moves the pointer to the 
                                           ;correct column            
   LDI  R19, 0
   ADC  ZH, R19
   LD   R20, Z                             ;stores the green buffer row byte at 
                                           ;a certain column c 
   LDS  R21, rowMask 
   OR   R20, R21                           ;turns on the bit in a certain column 
                                           ;and row for the green LED
   ST   Z, R20                             ;rewrites this new row byte 
   ADD  YL, R17                            ;moves the pointer to the correct
                                           ;column   
   ADC  YH, R19
   LD   R22, Y                             ;stores the red buffer row byte at a 
                                           ;certain column c
   COM  R21                                ;reverses rowMask so that a bit at a 
   ;                                        certain column/row can be turned off
   AND  R22, R21                           ;turns a bit at a certain column/row 
                                           ;off for the red LED 
   ST   Y, R22                             ;rewrites this new row byte into the 
                                           ;red buffer for the certain column 
   RJMP GamePEndLoop                       ;returns to the function that called 
                                           ;this function - terminates current 
										   ;function

GameColorIsRed:
   ADD  YL, R17                            ;moves the pointer to the correct 
                                           ;column            
   LDI  R19, 0
   ADC  YH, R19
   LD   R20, Y                             ;stores the red buffer row byte at 
     									   ;a certain column c 
   LDS  R21, rowMask 
   OR   R20, R21                           ;turns on the bit in certain column 
   										   ;and row for the red LED
   ST   Y, R20                             ;rewrites this new row byte 
   ADD  ZL, R17                            ;moves the pointer to the correct 
   										   ;column            
   ADC  ZH, R19
   LD   R22, Z                             ;stores the green buffer row byte 
   										   ;at a certain column c
   COM  R21                                ;reverses rowMask so that a bit at 
                                           ;a certain column/row can be turned 
										   ;off
   AND  R22, R21                           ;turns a bit at a certain column/row 
                                           ;off for the green LED 
   ST   Z, R22                             ;rewrites this new row byte into the 
                                           ;green buffer for the certain column 
   RJMP GamePEndLoop                       ;returns to the function that called 
                                           ;this function - terminates current 
										   ;function

GameNoColor:
   ADD  ZL, R17                            ;moves the pointer to the correct 
                                           ;column           
   LDI  R19, 0
   ADC  ZH, R19 
   LD   R20, Z                             ;stores the green buffer row byte 
                                           ;at a certain column c 
   LDS  R21, rowMask 
   COM  R21                                ;reverses rowMask so that a bit 
                                           ;at a certain column/row can be 
										   ;turned off
   AND  R20, R21                           ;turns a bit at a certain column/row 
                                           ;off for the green LED 
   ST   Z, R20                             ;rewrites this new row byte 
   ADD  YL, R17                            ;moves the pointer to the correct 
                                           ;column           
   ADC  YH, R19  
   LD   R22, Y                             ;stores the red buffer row byte at 
                                           ;a certain column c
   AND  R22, R21                           ;turns a bit at a certain column/row 
                                           ;off for the red LED 
   ST   Y, R22                             ;rewrites this new row byte into the 
                                           ;red buffer for the certain column 
   RJMP GamePEndLoop                       ;returns to the function that called 
   										   ;this function - terminates current 
										   ;function

GameColorIsYellow:
   ADD  ZL, R17                            ;moves the pointer to the correct 
                                           ;column            
   LDI  R19, 0
   ADC  ZH, R19
   LD   R20, Z                             ;stores the green buffer row byte at 
                                           ;a certain column c 
   LDS  R21, rowMask 
   OR   R20, R21                           ;turns on the bit in a certain 
                                           ;column and row for the green LED
   ST   Z, R20                             ;rewrites this new row byte 
   ADD  YL, R17                            ;moves the pointer to the correct 
                                           ;column           
   ADC  YH, R19
   LD   R22, Y                             ;stores the red buffer row byte 
                                           ;at a certain column c
   OR   R22, R21                           ;turns on the bit in a certain 
                                           ;column and row for the red LED
   ST   Y, R22                             ;rewrites this new row byte into 
                                           ;the red buffer for the certain 
										   ;column 
   RJMP GamePEndLoop                       ;returns to the function thatcalled 
                                           ;this function - terminates current 
										   ;function
GamePEndLoop:
   RET                                     ;terminates current function


;Description:             This function calculates the mod of two numbers. 
;                         R20 and R21 are the arguments such that the format 
;                         is R20 mod R21. The final value is stored in R20
;                         changes any of the pixels initially set. 
;Operational Description: This function checks if the value passed into R20 
;                         is greater than R21. If so, it resets to zero. If 
;                         it is less than 0, it resets to the max value - 1. 
;                         Otherwise, it stays as is.
;Arguments:               Takes in the number being modded and the number 
;                         modding it by
;Return Values:           The value after the mod function applied is in 
;                         R20 
;Global Variables:        None
;Shared Variables:        ReadBuffer
;Local Variables:         None
;Registers changed:       R17, R19, R20, R21, R22, YL, YH
;Inputs:                  None
;Outputs:                 None
;User Interface:          None
;Error Handling:          None
;Algorithms:              None
;Data Structures:         None
;Limitations:             None
;Known Bugs:              None 

Mod:
   CP   R20, R21  
   BRGE ResetToZero                        ;if the value is greater than or 
                                           ;equal to the limit, reset to 0
   CPI  R20, 0
   BRLT ResetToMax                         ;if the value is less than 0, 
                                           ;reset to max value - 1
   RJMP ModEndLoop                         ;end function
ResetToZero:
   LDI  R20, 0                             ;resets value to zero if greater 
                                           ;than or equal to the limit 
   RJMP ModEndLoop
ResetToMax:
   DEC  R21          
   MOV  R20, R21                           ;reset to max value - 1
   RJMP ModEndLoop                         ;end function
ModEndLoop:
   RET                                     ;end function




;Description:             When called, this function checks if the user 
;                         has made an illegal move -> when the user 
;                         changes any of the pixels initially set. 
;Operational Description: This function checks if the led at the 
;                         position inputted into the function has been 
;                         previously set by checking the fixed byte
;                         If either or both of these equal a nonzero 
;                         value, then it returns true indicating that 
;                         it is an illegal move. Otherwise, it returns 
;                         false. 
;Arguments:               Takes in the column number and row number
;Return Values:           True if the move is illegal (trying to change 
;                         a fixed value). Otherwise, it returns false 
;                         if the move is legal. 
;Global Variables:        None
;Shared Variables:        ReadBuffer
;Local Variables:         None
;Registers changed:       R17, R19, R20, R21, R22, YL, YH
;Inputs:                  None
;Outputs:                 None
;User Interface:          None
;Error Handling:          None
;Algorithms:              None
;Data Structures:         None
;Limitations:             None
;Known Bugs:              None              

CheckIllegalMove:
InitializeFixedByteRowMask:
   LDI  R22, SET_HIGH_ROW_BIT              ;turns on the high row bit for 
                                           ;initialize row mask
  ;RJMP InitializeReadBuffers
InitializeReadBuffers:
   LDI  YL, LOW(ReadBuffer)                ;initializes pointer for read buffer 
                                           ;to get fixed byte value
   LDI  YH, HIGH(ReadBuffer)               ;initializes pointer for read buffer 
                                           ;to get fixed byte value
  ;RJMP InitializeFixedBitCounter
InitializeFixedBitCounter:
   LDI  R21, 0                             ;initializes counter determining 
                                           ;which row bit is on
   RJMP CheckCorrectFixedByteRowMask       ;start executing for loop details
 
CheckCorrectFixedByteRowMask:
   CP   R21, R16                           ;determines the row mask rth bit is 
                                           ;set high
   BRLT ShiftFixedByteRowMask              ;shifts the row mask if it hasn't 
                                           ;looped through enough times
   RJMP GetFixedByte                       ;if row mask is done, gets fixed 
                                           ;byte from the buffer

ShiftFixedByteRowMask:
   LSR  R22                                ;selects a different row when
                                           ;LSR is called
   INC  R21                                ;indicates which bit is 
                                           ;currently set
   RJMP CheckCorrectFixedByteRowMask       ;jumps back to run more loops 
  ;RJMP GetFixedByte
GetFixedByte:
   LDI  R19, TOTAL_COLUMNS
   ADD  YL, R19                            ;moves the pointer to access 
                                           ;the the beginning of the fixed 
										   ;position bytes
   ADD  YL, R17                            ;moves the pointer to access the 
                                           ;fixed position byte at that 
										   ;column
   LDI  R19, 0
   ADC  YH, R19
   LD   R20, Y                             ;stores fixed byte value at column

CheckBitSetAtRow:
   AND  R20, R22                           ;turns on the bit in a certain 
                                           ;column and row for the green LED
   TST  R20                                ;if bit was not fixed, sets zero 
                                           ;flag
   RET                                     ;terminates function


;Description:             When called, this function checks if all the spaces 
;                         in the LED board are filled with red or green LEDs          
;Operational Description: This function checks if redByte or greenByte from 
;                         the buffers are turned on. If they are not, then 
;                         it returns false. It iterates through all the bytes 
;                         in the red and green buffers. 
;Arguments:               None
;Return Values:           Returns false if any of the LEDs are not set. 
;                         Otherwise, it returns true. 
;Global Variables:        None
;Shared Variables:        gameStateRedBuffer and gameStateGreenBuffer
;Registers changed:       R16, R20, R21
;Registers accessed:      XL, XH, ZL, ZH
;Local Variables:         None
;Inputs:                  None
;Outputs:                 None
;User Interface:          None
;Error Handling:          None
;Algorithms:              None
;Data Structures:         None
;Limitations:             None
;Known Bugs:              None 

AllSpacesAreFilled:
InitializeColumnNumber:
   LDI  R16, 0     ;sets starting column number to zero
  ;RJMP  InitializeStateBuffers
InitializeStateBuffers:
   LDI  XL, LOW(gameStateRedBuffer)        ;initializes pointer for 
                                           ;gameStateRedBuffer
   LDI  XH, HIGH(gameStateRedBuffer)       ;initializes pointer for 
                                           ;gameStateRedBuffer
   LDI  ZL, LOW(gameStateGreenBuffer)      ;initializes pointer for 
                                           ;gameStateGreenBuffer
   LDI  ZH, HIGH(gameStateGreenBuffer)     ;initializes pointer for 
                                           ;gameStateGreenBuffer
;  RJMP  CheckBoardColumnNumber            ;start executing the for 
                                           ;loop details

CheckBoardColumnNumber:
   CPI  R16, TOTAL_COLUMNS                 ;check if has looped through 
                                           ;all the columns
   BRLT CheckAllSpacesFilled               ;checks if all LEDs are 
                                           ;turned on
   RJMP CheckSpacesAreFilledEndLoop        ;terminates the function if 
                                           ;has looped through all 
										   ;the columns

CheckAllSpacesFilled:
   LD   R21, Z+                            ;stores the green buffer byte
   LD   R20, X+                            ;stores the red buffer byte
   OR   R20, R21                           ;if all the LEDs are on 
                                           ;then all bits in R20 should 
										   ;be set high
   CPI  R20, CHECK_ALL_BITS_SET            ;checks if all the bits in a 
                                           ;column are set
   BRNE CheckSpacesAreFilledEndLoop        ;terminates the function if 
                                           ;a LED in a column is not set
   INC  R16                                ;increments current column 
                                           ;number by one to highlight 
										   ;one completed loop
   RJMP CheckBoardColumnNumber             ;jumps back to run more loops 

CheckSpacesAreFilledEndLoop:
   RET  ;terminates the function 


;Description:             When called, this function checks if the user
;                         won the game. 
;Operational Description: This function iterates through all the bytes in 
;                         gameStateRedBuffer and gameStateGreenBuffer and 
;                         compares it to the solution bytes. If even one 
;                         bit is different, it outputs false. Otherwise, 
;                         it outputs true at the very end. 
;Arguments:               None
;Return Values:           True if the user has won the game. False if 
;                         the user has won the game
;Global Variables:        None
;Shared Variables:        gameStateRedBuffer, gameStateGreenBuffer
;Local Variables:         None.
;Registers accessed:      YL, YH, XL, XH, R16, R20, R22
;Inputs:                  None
;Outputs:                 None
;User Interface:          None
;Error Handling:          None
;Algorithms:              None
;Data Structures:         None
;Limitations:             None
;Known Bugs:              None 

CheckWinGame:
InitGameColumnNumber:
   LDI  R16, 0                             ;sets starting column number 
                                           ;to zero
  ;RJMP  InitializeStateBuffers
InitBuffers:
   LDI  XL, LOW(gameStateRedBuffer)        ;initializes pointer for 
                                           ;gameStateRedBuffer
   LDI  XH, HIGH(gameStateRedBuffer)       ;initializes pointer for 
                                           ;gameStateRedBuffer
   LDI  YL, LOW(ReadBuffer)                ;accesses the first byte 
                                           ;of the EEROM data
   LDI  YH, HIGH(ReadBuffer)               ;accesses the first byte 
                                           ;of the EEROM data
;  RJMP  CheckBoardColNumber               ;start executing the for 
                                           ;loop details

CheckColNumber:
   CPI  R16, TOTAL_COLUMNS                 ;check if has looped through 
                                           ;all the columns
   BRLT CheckLoseGame                      ;checks whether game has been 
   										   ;won or lost
   RJMP GameStatusEndLoop                  ;terminates the function if 
   									       ;has looped through all the 
										   ;columns (aka user won the 
										   ;game)

CheckLoseGame:
   LD   R22, Y+                            ;stores the EEROM fixed 
                                           ;position byte of a certain 
										   ;column (R16)
   LD   R20, X+                            ;stores the red buffer byte
   CP   R22, R20                           ;checks if the red LEDs on 
                                           ;the board match the solution 
										   ;byte
   BRNE GameStatusEndLoop                  ;terminates the function with 
                                           ;the zero flag not set if the 
										   ;player lost the game
   INC  R16                                ;increments current column 
                                           ;number by one to highlight 
										   ;one completed loop
   RJMP CheckColNumber                     ;jumps back to run more loops 

GameStatusEndLoop:
   RET  ;terminates the function 

.dseg
gameStateRedBuffer:   .BYTE   8            ;stores all on/off values for 
                                           ;red LED in the game
gameStateGreenBuffer: .BYTE   8            ;stores all on/off values for 
                                           ;green LED in the game
gameNumber:           .BYTE   1            ;stores the game board the user 
                                           ;is currently on
blinkColorSelect:     .BYTE   1            ;determines what color the LED 
                                           ;is blinking when trying to select 
										   ;a color
rowPos:               .BYTE   1            ;cursor row number
columnPos:            .BYTE   1            ;cursor column number


