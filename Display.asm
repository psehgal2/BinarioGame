;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                            ;
;                               Display.asm                                  ;
;                         G/R Plotting Functions                             ;
;                   Plots Pixels and Multiplexing display                    ;
;                                                                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; This file contains the functions for plotting pixels and multiplexing the
; display among other functions. This file handles the LEDs for the binario
; game
;
; Revision History:
;    05/10/22  Purvi Sehgal             wrote InitVariables, SetCursor section
;    05/10/22  Purvi Sehgal             wrote ClearDisplay
;    05/11/22  Purvi Sehgal             wrote PlotPixel and Multiplexing
;    05/20/22  Purvi Sehgal             debugged code - didn't correctly 
;                                       increment column counter and 
;                                       initialize cursor
;    06/10/22  Purvi Sehgal             demo'd                                                                                                                                                                             


.cseg

;Description:             This method initializes all variables needed for LED 
;                         This method is exited out of when variables are set
;Operational Description: This method first starts by initializing the 
;                         display by calling the ClearDisplay() method. It 
;                         also sets the high bits of the column index word 
;                         equal to 0x01 and the low bits of column index 
;                         word equal to 0x00 in order to initialize column 
;                         incrementers for both the red and green LEDs. 
;                         Then, it initializes the currentColumn which is 
;                         the index incrementer for the buffer tables. It 
;                         also sets the blink counter equal to zero to 
;                         initialize it. It also sets the cursor to an 
;                         invalid row, column value so that there is no 
;                         cursor initially. 
;Arguments:               None
;Return Values:           None
;Global Variables:        None
;Shared Variables:        All the following variables are set: RedColumnIndex, 
;                         GreenColumnIndex, currentColumn, and blinkCounter. 
;Local Variables:         None
;Registers changed:       R16, R17, R18, R19
;Inputs:                  None
;Outputs:                 None
;User Interface:          None
;Error Handling:          None
;Algorithms:              None
;Data Structures:         None
;Limitations:             None
;Known Bugs:              None

InitLEDVariables:
   RCALL ClearDisplay ;clears LEDs
   LDI   R16, INIT_RED_INDEX               ;turns on the first column for 
                                           ;the red LED on the display 
										   ;board
   STS   redColumnEnable, R16 
   LDI   R16, INIT_GREEN_INDEX             ;turns off all columns for the 
                                           ;green LED on the display 
   STS   greenColumnEnable, R16 
   LDI   R16, SELECT_LEFT_COLUMN           ;initializes the current column 
                                           ;to be the left-most column
   STS   currentColumn, R16 
   STS   blinkCounter, R16                 ;sets the blink counter to start 
                                           ;counting at 0
   LDI   R16, INVALID_ROW                  ;sets the row to an invalid value 
                                           ;so nothing blinks initially
   LDI   R17, INVALID_COLUMN               ;sets the column to an invalid 
                                           ;value so nothing blinks 
										   ;initially
   LDI   R18, RED_COLOR_VALUE              ;sets to a random color
   LDI   R19, GREEN_COLOR_VALUE            ;sets to a random second color
   RCALL SetCursor                         ;sets the cursor to an invalid 
                                           ;point on the display so that 
										   ;nothing blinks initially
   RET                                     ;terminates function


;Description:             This function takes in a row number (r) and 
;                         column number (c) and sets the cursor to the 
;                         row and column. It creates shared variables 
;                         that the multiplexer uses to make the specific 
;                         row/column blink between two colors passed as 
;                         arguments to the function. 
;Operational Description: This function first creates shared variables for 
;                         two colors and sets the two colors passed in the 
;                         argument equal to these shared variables. It also 
;                         creates a cursorColumn shared variable & sets it 
;                         equal to c column value passed in as an argument. 
;                         Then, it initializes the rowMask to be equal to a 
;                         constant with all zeros except for a 1 in the 7th 
;                         bit location. It then shifts this bit to the left 
;                         based on the number of rows passed as an argument 
;                         to the function. 
;Arguments:               This function takes in row number (r) from 0->7, 
;                         the column number (c) from 0->7, and two colors  
;                         to blink with range from 0->3. A color value 
;                         of 0 means pixel is off, a color value of 1 means 
;                         pixel is red, and a color value of 2 means it is 
;                         green, and 3 means yellow. 0 for r means the top 
;                         row and 0 for c means the left most column. 
;Return Values:           None
;Global Variables:        None
;Shared Variables:        Sets color1 (shared) to c1 and color2 (shared) 
;                         to c2. Sets cursorColumn shared variable to c 
;                         (an argument denoting cursor column). Lastly, 
;                         it sets rowMask (shared) equal to an 8 bit byte 
;                         with a 1 in the location of the cursor row r. 
;Local Variables:         None
;Registers used:          R16, R17, R18, R19, R20, R21, R22
;Inputs:                  None
;Outputs:                 None
;User Interface:          None 
;Error Handling:          If the arguments are not valid (for example, 
;                         if the column value entered is greater than 7), 
;                         then this function returns back to the 
;                         function that called it
;Algorithms:              None
;Data Structures:         None
;Limitations:             None
;Known Bugs:              None


SetCursor:                          
CursorInitialize:
   STS   colorOne, R18                     ;stores the color 1 (c1) 
                                           ;argument
   STS   colorTwo, R19                     ;stores the color 2 (c2) 
                                           ;argument
   STS   cursorColumn, R17                 ;stores column number of the 
                                           ;cursor 
   LDI   R20, INIT_ROW_MASK                ;selects the 0th row value 
                                           ;in a column for 
                                           ;the cursor location
   STS   cursorRowMask, R20                ;selects a certain row in a 
                                           ;column
   RJMP  CursorInitializeCounter 

CursorInitializeCounter:
   LDI   R21, 0                            ;create a counter (to do a for 
     									   ;loop)
   RJMP  CursorForLoopCondition            ;start executing the for loop 
                                           ;details
CursorForLoopCondition:
   CP    R21, R16                          ;determine if the code has looped 
                                           ;through r times 
   BRLT  CursorGenerateRowMask             ;execute the inside of the for 
                                           ;loop if it hasn't looped through 
										   ;enough times
   RJMP  CursorEndLoop                     ;terminates the program when row 
                                           ;mask has rth bit set

CursorGenerateRowMask:
   LDS   R22, cursorRowMask
   LSR   R22                               ;selects a different row 
   STS   cursorRowMask, R22                ;updates row mask 
   INC   R21                               ;increments row counter
   RJMP  CursorForLoopCondition            ;jumps back to run more loops 
CursorEndLoop:
   RET                                     ;terminates the function 
  

;Description:             The function clears the LED buffer, such 
;                         that none of the LEDs are on. It exits the 
;                         code when it has gone through all the 8 
;                         columns of the LED. 
;Operational Description: This function initializes two 8 x 8 buffers, 
;                         called RedBuffer and GreenBuffer and loops 
;                         through all the columns. For each column, 
;                         it sets the rows equal to zero. 
;Arguments:               None
;Return Values:           None
;Global Variables:        None
;Shared Variables:        It initializes the RedBuffer and 
;                         GreenBuffer shared variables
;Local Variables:         None
;Registers changed:       R18, R21, YL, YH, ZL, ZH
;Inputs:                  None
;Outputs:                 None
;User Interface:          None
;Error Handling:          None
;Algorithms:              None
;Data Structures:         Very similar to a 2-D array, this employs 
;                         a 2-D matrix
;Limitations:             None
;Known Bugs:              None

ClearDisplay:
InitializeCounter:
   LDI   R21, 0                            ;create a counter (to do a 
                                           ;for loop)
   LDI   YL, LOW(redBuffer)                ;initializes the start of 
                                           ;the pointer
   LDI   YH, HIGH(redBuffer)               ;initializes the start of 
                                           ;the pointer
   LDI   ZL, LOW(greenBuffer)              ;initializes the start of 
                                           ;the pointer
   LDI   ZH, HIGH(greenBuffer)             ;initializes the start of 
                                           ;the pointer
   LDI   R18, LED_OFF                      ;turns off LEDs in column  
   RJMP  ForLoopCondition                  ;start executing the for 
                                           ;loop details

ForLoopCondition:
   CPI   R21, MAX_COLUMNS                  ;determine if the code has 
                                           ;looped through all the 
										   ;columns
   BRLT  TurnOffLEDs                       ;execute the inside of the 
                                           ;for loop if it hasn't 
										   ;looped through all columns
   RJMP  DisplayEndLoop                    ;terminates function 

TurnOffLEDs:
   ST    Y+, R18                           ;turns off LEDs in the red 
                                           ;buffer column 
   ST    Z+, R18                           ;turns off LEDs in the green 
                                           ;buffer column 
   INC   R21                               ;increments column counter
   RJMP  ForLoopCondition                  ;jumps back to run more 
                                           ;loops 

DisplayEndLoop:
   RET  ;terminates the function 
  


;Description:             This function takes in the row number (r) and 
;                         column number (c) and sets the LED to a 
;                         certain color (another argument) in the 
;                         specific pixel in the Red/Green buffers. A color 
;                         value of 0 means the pixel is off, a color value 
;                         of 1 means the pixel is red, and a color value of 
;                         2 means it is green, and 3 means yellow. 0 for r
;                         means the top row and 0 for c means the left most 
;                         column. 
;Operational Description: If the color value is equal to zero, then this 
;                         function accesses  column C in both the RedBuffer 
;                         and GreenBuffer and sets bit r equal to 0. For 
;                         color = 1, the function accesses column C in 
;                         GreenBuffer and RedBuffer and sets bits r equal 
;                         to 1 and 0, respectively. For color = 2, the 
;                         function accesses column C in GreenBuffer and 
;                         RedBuffer and sets bits r equal to 0 and 1, 
;                         respectively. For color = 3, function accesses 
;                         column C in GreenBuffer and RedBuffer and sets 
;                         bits r equal to 1 and 1, respectively.
;Arguments:               This function takes in the row number (r) from 
;                         0->7, the column number (c) from 0->7, and 
;                         the color from 0->3. A color value of 0 means 
;                         the pixel is off, a color value of 1 means the 
;                         pixel is red, and a color value of 2 means it 
;                         is green, and 3 means yellow. 0 for r means 
;                         the top row and 0 for c means the left 
;                         most column. 
;Return Values:           None
;Global Variables:        None
;Shared Variables:        Modifies RedBuffer and GreenBuffer
;Local Variables:         None
;Registers ussed:         R16, R17, R18. R19, R20, R21, R22, YL, YH, 
;                         ZL, ZH
;Inputs:                  None
;Outputs:                 None
;User Interface:          None
;Error Handling:          If the arguments are not valid (for example, 
;                         if the column value entered is greater than 
;                         7), then this function returns back to the 
;                         function that called it
;Algorithms:              None
;Data Structures:         Very similar to a 2-D array, this employs 
;                         a 2-D matrix
;Limitations:             None
;Known Bugs:              None


PlotPixel:
CheckInvalidPixelArguments:
   CPI   R16, TOTAL_ROWS                   ;checks if row number is invalid 
   										   ;(greater than or equal to total 
										   ;rows)
   BRGE  PixelEndLoop                      ;if row number is invalid, end 
   										   ;function
   CPI   R17, TOTAL_COLUMNS                ;checks if column number is 
   										   ;invalid (greater than or equal 
										   ;to total columns)
   BRGE  PixelEndLoop                      ;if column number is invalid, 
                                           ;end function
   CPI   R18, MAX_COLOR                    ;checks if color number is 
   										   ;invalid (greater than or equal 
										   ;to max color)
   BRGE  PixelEndLoop                      ;if color number is invalid, 
                                           ;end function
  ;RJMP InitializeRowMask
InitializePixelRowMask:
   LDI   R22, SET_HIGH_ROW_BIT             ;turns on the high row bit for 
   										   ;initialize row mask
   STS   rowMask, R22
  ;RJMP InitializeBuffers
InitializePixelBuffers:
   LDI   YL, LOW(redBuffer)                ;initializes pointer for 
                                           ;redBuffer
   LDI   YH, HIGH(redBuffer)               ;initializes pointer for 
                                           ;redBuffer
   LDI   ZL, LOW(greenBuffer)              ;initializes pointer for 
                                           ;greenBuffer
   LDI   ZH, HIGH(greenBuffer)             ;initializes pointer for 
                                           ;greenBuffer
  ;RJMP InitializePixelCounter
InitializePixelCounter:
   LDI   R21, 0                            ;initializes counter determining 
                                           ;which row bit is on
   RJMP  PixelCheckCorrectRowMask          ;start executing the for loop 
                                           ;details

PixelCheckCorrectRowMask:
   CP    R21, R16                          ;determines if the row mask rth 
                                           ;bit is set high
   BRLT  PixelShiftRowMask                 ;shifts the row mask if it hasn't 
                                           ;looped through enough times
   RJMP  PixelCheckColor                   ;checks which color was inputted 
                                           ;in the arguments by comparing to 
										   ;constants
PixelShiftRowMask:
   LDS   R22, rowMask
   LSR   R22                               ;selects a different row every 
   										   ;time LSR is called
   STS   rowMask, R22                      ;updates row mask back into the 
   										   ;shared variable
   INC   R21                               ;indicates which bit is currently 
                                           ;set
   RJMP  PixelCheckCorrectRowMask          ;jumps back to run more loops 

PixelCheckColor:
   CPI   R18, GREEN_COLOR_VALUE            ;checks if the color is green 
   BREQ  ColorIsGreen                      ;if so, it handles it in the 
                                           ;buffers
   CPI   R18, RED_COLOR_VALUE              ;checks if the color is red
   BREQ  ColorIsRed                        ;if so, it handles it in the 
                                           ;buffers
   CPI   R18, LED_OFF                      ;checks if there is no color
   BREQ  NoColor                           ;if so, it handles it in the 
                                           ;buffers
   CPI   R18, YELLOW_COLOR_VALUE           ;checks if the color is yellow
   BREQ  ColorIsYellow                     ;if so, it handles it in the 
                                           ;buffers

PixelEndLoop:
   RET                                     ;terminates current function
ColorIsGreen:
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
   RJMP PEndLoop                           ;returns to the function that called 
                                           ;this function - terminates current 
										   ;function

ColorIsRed:
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
   RJMP PEndLoop                           ;returns to the function that called 
                                           ;this function - terminates current 
										   ;function

NoColor:
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
   RJMP PEndLoop                           ;returns to the function that called 
   									  	   ;this function - terminates current 
										   ;function

ColorIsYellow:
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
   RJMP PEndLoop                           ;returns to the function thatcalled 
                                           ;this function - terminates current 
										   ;function
PEndLoop:
   RET                                     ;terminates current function


;Description:             This is the multiplexer function, which updates 
;                         the display one column at a time based on the LED 
;                         values stored in the red/green buffers. It also 
;                         handles blinking between two colors.
;Operational Description: The multiplexer first sets a blink counter that 
;                         increments by 1 every time the multiplexer is called. 
;                         Once a certain count number is hit, it switches to 
;                         the other color. Then, it selects a column and 
;                         LED color in the display, and rotates byte so that 
;                         a different column is activated in the display each 
;                         time the multiplexer is called. Then, it reads the 
;                         value of each row in a single column by indexing 
;                         into the buffer. It handles the cursor if the 
;                         cursor column is the same as the current column 
;                         by identifying the desired cursor color, comparing 
;                         it to the current LED color, and adjusting the color 
;                         value accordingly. Then, it writes to port c. 
;Arguments:               None
;Return Values:           None
;Global Variables:        None
;Shared Variables:        color1, color2, RedColumnIndex, GreenColumnIndex, 
;                         currentColumn, GreenBuffer,  RedBuffer, cursorColumn, 
;                         rowMask, blinkCounter
;Local Variables:         None
;Registers used:          R16, R17, R18, R19, R20, R21, R22, ZL, ZH, YL, YH
;Inputs:                  None
;Outputs:                 Writes green/red LED on/off (1/0) values to Port 
;                         C of the display. 
;User Interface:          The user selects an LED light color at a specific 
;                         point in the display, and the multiplexer updates 
;                         the display to reflect this change
;Error Handling:          None
;Algorithms:              None
;Data Structures:         None
;Limitations:             None 
;Known Bugs:              None  

Multiplexer:
HandleBlinkingLED:
   LDS  R16, blinkCounter
   CPI  R16, C1_TIME                       ;so that it stays on a color for 
                                           ;longer (gives the appearance of 
										   ;blinking when switch)
   BRLO SetColorToFirstColor               ;if less than, set color equal to 
                                           ;the first one
   CPI  R16, C2_TIME                       ;so that it stays on the second 
                                           ;color for longer (gives the 
										   ;appearance of blinking when 
										   ;switch)
   BRLO SetColorToSecondColor              ;if less than, set the color 
                                           ;equal to the second one 
   BRSH SetColorToFirstColorAndReset       ;if greater than second color 
                                           ;time, set the color equal to the 
										   ;first one and reset the 
										   ;blinkCounter so that we have a 
										   ;full loop

SetColorToFirstColor:
   LDS  R17, colorOne                      ;first color in the blink pattern
   STS  color, R17                         ;first color in the blink pattern
   RJMP ChangeCounters                     ;increments the counter for the 
                                           ;next time the Multiplexer is 
										   ;called 

SetColorToSecondColor:
   LDS  R17, colorTwo                      ;second color in blink pattern
   STS  color, R17                         ;second color in blink pattern 
   RJMP ChangeCounters  

SetColorToFirstColorAndReset:
   LDI  R18, 0                             ;resets the blinkCounter 
   STS  blinkCounter, R18                  ;resets the blinkCounter 
   LDS  R17, colorOne                      ;sets  first color in the 
                                           ;blink pattern      
   STS  color, R17                         ;sets first color in the 
                                           ;blink pattern 
   RJMP ChangeCounters     

ChangeCounters:
   LDI  ZL, LOW(greenBuffer)               ;initializes the start of 
                                           ;the Z pointer
   LDI  ZH, HIGH(greenBuffer)              ;initializes the start of 
                                           ;the Z pointer
   LDI  YL, LOW(redBuffer)                 ;initializes the start of 
                                           ;the Y pointer
   LDI  YH, HIGH(redBuffer)                ;initializes the start of 
                                           ;the Y pointer
   LDS  R20, blinkCounter    
   INC  R20                                ;increment blink counter for 
                                           ;the next time the MUX is 
										   ;called 
   STS  blinkCounter, R20                  ;saves the new incremented 
                                           ;value 
   LDS  R16, redColumnEnable 
   LDS  R17, greenColumnEnable 
   OUT  PortA, R17                         ;turns on the column in the 
                                           ;display for the green LED 
   OUT  PortD, R16                         ;turns on the column in the 
                                           ;display for the red LED
   CPI  R16, 0                             ;checks if the program is 
                                           ;writing the green LED
   BREQ GreenLEDUpdate                     ;if the program is writing 
                                           ;the green LED values, it 
										   ;jumps to this section 
   RJMP RedLEDUpdate                       ;otherwise, it jumps to the 
                                           ;section writing the red LED 
										   ;values 

GreenLEDUpdate:
   LDS  R17, currentColumn  
   LDS  R18, cursorColumn
   ADD  ZL, R17                            ;skips to the correct column 
                                           ;in the green buffer
   LDI  R19, 0
   ADC  ZH, R19
   LD   R16, Z                             ;stores the green buffer row 
                                           ;byte at a certain column c 
   CP   R17, R18                           ;checks if the cursor column 
                                           ;and current column are the 
										   ;same
   BREQ HandleDifferentColorBlinks 
   RJMP GreenUpdatePort

HandleDifferentColorBlinks:
   LDS  R20, color
   CPI  R20, GREEN_COLOR_VALUE             ;checks if the blink color 
                                           ;is green 
   BREQ GreenLEDHandleGreenYellowBlink  
   CPI  R20, YELLOW_COLOR_VALUE            ;checks if the color is 
                                           ;yellow
   BREQ GreenLEDHandleGreenYellowBlink  
   RJMP GreenLEDHandleRedNoBlink

GreenLEDHandleGreenYellowBlink:            ;handles a green yellow 
                                           ;blink
   LDS  R21, cursorRowMask
   OR   R16, R21 
   RJMP GreenUpdatePort

GreenLEDHandleRedNoBlink:                  ;handles a red no color 
                                           ;blink
   LDS  R21, cursorRowMask 
   COM  R21 
   AND  R16, R21
   RJMP GreenUpdatePort

GreenUpdatePort:
   OUT  PORTC, R16                         ;outputs green color 
                                           ;column values to the 
										   ;board 
   RJMP LEDEndLoop  

   
RedLEDUpdate:
   LDS  R17, currentColumn  
   LDS  R18, cursorColumn
   ADD  YL, R17                            ;skips to the correct 
                                           ;column in the red buffer         
   LDI  R19, 0    
   ADC  YH, R19
   LD   R16, Y                             ;stores the red buffer row 
                                           ;byte at a certain column 
										   ;c 
   CP   R17, R18                           ;checks if the cursor 
                                           ;column and current column 
										   ;are the same
   BREQ RedLEDHandleDifferentColorBlinks
   RJMP RedLEDUpdatePort

RedLEDHandleDifferentColorBlinks:
   LDS  R22, color
   CPI  R22, RED_COLOR_VALUE               ;checks if the blink color 
                                           ;is red
   BREQ RedLEDHandleRedYellowBlink   
   CPI  R22, YELLOW_COLOR_VALUE            ;checks if the color is 
                                           ;yellow
   BREQ RedLEDHandleRedYellowBlink   
   RJMP RedLEDHandleGreenNoBlink

RedLEDHandleRedYellowBlink:                ;handles a red yellow 
                                           ;blink
   LDS  R21, cursorRowMask
   OR   R16, R21 
   RJMP RedLEDUpdatePort

RedLEDHandleGreenNoBlink:                  ;handles a red no color 
                                           ;blink
   LDS  R21, cursorRowMask 
   COM  R21 
   AND  R16, R21
   RJMP RedLEDUpdatePort

RedLEDUpdatePort:
   OUT  PORTC, R16                        ;outputs green color 
                                          ;column values to the 
										  ;board
   RJMP LEDEndLoop

LEDEndLoop:
   LDS  R19, greenColumnEnable            ;used to check what 
                                          ;green column is enabled
   LDI  R20, LAST_GREEN_COLUMN            ;constant which checks 
                                          ;whether last green column 
										  ;has been enabled 
   CP   R19, R20                          ;checks if the last green 
                                          ;columnn has been enabled 
										  ;so that it can reset to 
										  ;red column 
   BREQ ResetColumnEnable                 ;jumps to enabling red 
                                          ;columns, thus resetting 
										  ;column enable 
   LDS  R16, redColumnEnable              ;stores in a register so 
                                          ;that LSL can be applied 
										  ;on it 
   LSL  R16                               ;shifts left to turn on 
                                          ;the next column for the 
										  ;red LEDs 
   STS  redColumnEnable, R16              ;makes the next column 
                                          ;value the current column 
										  ;value 
   LDS  R17, greenColumnEnable            ;stores in a register so 
                                          ;that ROR can be applied 
										  ;on it
   ROR  R17                               ;shifts right to turn on 
                                          ;the next column for the 
										  ;green LEDs 
   STS  greenColumnEnable, R17            ;makes the next column 
                                          ;value the current column 
										  ;value 
   RJMP RetLoop

ResetColumnEnable:
   LDI  R17, FIRST_RED_COLUMN             ;constant which enables 
                                          ;the first red column, 
										  ;therefore resetting 
										  ;column enable 
   STS  redColumnEnable, R17              ;resets the local variable 
                                          ;to enable first column 
										  ;red LEDs 
   LDI  R18, GREEN_COLUMN_DISABLE         ;constant which turns off 
                                          ;all the green LED column 
										  ;enables so that no green 
										  ;LED can be set 
   STS  greenColumnEnable, R18            ;resets the local variable 
                                          ;to disable green LEDs 
   RJMP RetLoop                           ;returns back to the 
                                          ;function that called 
										  ;it -> terminates the 
										  ;function 
RetLoop:
   LDS  R16, currentColumn 
   INC  R16                               ;increments the current 
                                          ;column
   CPI  R16, TOTAL_COLUMNS                ;checks if exceeded total 
                                          ;column value 
   BREQ IfGreaterThanEightColumns  

ReturnLoop:
   STS  currentColumn, R16                ;updates column counter 
                                          ;value
   RET                                    ;terminates function

IfGreaterThanEightColumns:
   LDI  R16, 0                            ;resets column counter to 
                                          ;0 if exceeded total column 
										  ;value
   STS  currentColumn, R16
   RJMP ReturnLoop      




.dseg 

redBuffer:         .BYTE    8  ;stores all the on/off values for the red LED
greenBuffer:       .BYTE    8  ;stores all the on/off values for green LED
color:             .BYTE    1  ;current color (when blinking btw two colors)
greenColumnEnable: .BYTE    1  ;initializes redColumnEnable which turns on 
                               ;the column the multiplexer should be 
							   ;modifying on the display for the green LED
redColumnEnable:   .BYTE    1  ;initializes redColumnEnable which turns on 
                               ;the column the multiplexer should be 
							   ;modifying on the display for the red LED
currentColumn:     .BYTE    1  ;initializes currentColumn which tracks the 
                               ;column number 
blinkCounter:      .BYTE    1  ;initializes blinkCounter which allows the 
                               ;program to count to a certain number (and 
							   ;then switch LED colors and repeat)
colorOne:          .BYTE    1  ;stores the color 1 (c1) for blinking
colorTwo:          .BYTE    1  ;stores the color 2 (c2) for blinking
cursorColumn:      .BYTE    1  ;stores column number of the cursor
rowMask:           .BYTE    1  ;selects a certain row in a column
cursorRowMask:     .BYTE    1  ;selects a certain row in a column for the 
                               ;cursor
