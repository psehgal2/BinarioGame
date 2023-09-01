;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                            ;
;                              ReadEEROM.asm                                 ;
;                        Read from the EEROM Functions                       ;
;    Reads a certain number of bytes from the EEROM & outputs them at address;
;                                                                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; This file contains the functions for playing a sound at a specific frequency 
; passed into registers R17 and R16. A frequency of zero m*eans no sound should 
; be produced 
;
; The functions included are:
;        InitSPI - initializes the SPI by initializing the SPCR register and 
;                  setting chip select to zero
;        ReadEEROM - this reads from a certain 6-bit address in the EEROM
;                    gets N number of bytes, and adds them to a specific 
;                    address in memory
;
; Revision History:
;    05/26/22  Purvi Sehgal          wrote InitSPI & WaitInterruptStatusFlag 
;    05/27/22  Purvi Sehgal          wrote the ReadEEROM mainloop
;    05/28/22  Purvi Sehgal          finished writing EEROM
;    05/28/22  Purvi Sehgal          debugged code - fixed byte decrementer
;    06/06/22  Purvi Sehgal          demo'd                                                                                                                                                                             




.cseg

;Description:             This method initializes the registers needed 
;                         for the SPI. This method is exited when SPCR 
;                         is set. 
;Operational Description: This method sets SPCR equal to a value that 
;                         sets the SPI clock frequency, enables the SPI, 
;                         sets up the SPI clock, whether it is a 
;                         Master/Slave SPI, etc. 
;Arguments:               None
;Return Values:           None
;Global Variables:        None
;Shared Variables:        None
;Local Variables:         None
;Inputs:                  None
;Outputs:                 None
;User Interface:          None
;Error Handling:          None
;Algorithms:              None
;Data Structures:         None
;Limitations:             None
;Known Bugs:              None
;Registers changed:       R16, SPCR, R18


InitSPI:
  LDI   R16, INIT_SPCR 
  OUT   SPCR, R16                   ;enables the SPI, sets the MSB of the 
                                    ;data word to be transmitted first, 
									;selects Master SPI, and sets up the 
									;SPI clock
  IN    R18, PORTB                  ;retrieves the values written to port 
                                    ;B by putting them in a register
  ANDI  R18, UNSELECT_EEROM_CHIP    ;unselects the EEROM chip by setting 
                                    ;CS LOW
  OUT   PORTB, R18                  ;writes the port B values with the 
                                    ;chip select high back to port B
  RET       


;Description:             This method checks to see if the interrupt flag 
;                         is set, and if it is, the method returns back 
;                         to the function that called it. 
;Operational Description: This function first ANDs what it gets out of
;                         the SPSR with a byte, so if the 7th bit (high bit) 
;                         is 0, the SPSR value gets zero’d out, so the zero 
;                         flag is set. If the zero flag is set, the method 
;                         calls itself to recheck the if statement. If the 
;                         interrupt flag is set, the highest bit is 1, so 
;                         ANDing with a byte with the high bit set
;                         produces a nonzero result, 
;                         so then the zero flag is not set, and the function 
;                         returns to what called it. 
;Arguments:               None
;Global Variables:        None
;Shared Variables:        None
;Local Variables:         None
;Inputs:                  None
;Outputs:                 None
;User Interface:          None
;Error Handling:          None 
;Algorithms:              None
;Data Structures:         None
;Limitations:             None
;Known Bugs:              None 
;Registers changed:       R18



WaitInterruptStatusFlag:
  IN    R18, SPSR    
  ANDI  R18, CHECK_SPI_Flag_Set     ;if the SPI flag is not set, zeros 
                                    ;out R18 value, which sets the zero 
									;flag
  BREQ  WaitInterruptStatusFlag     ;loop back to the beginning if the 
                                    ;SPI flag is not set
  RET                               ;returns back to the function that 
                                    ;called this one if the SPI flag is 
									;set -> this means all the bits have 
									;been read/written in the SPI, and 
									;we can proceed with the next 
									;instruction  





;Description:             This function reads n bytes from the EEROM at 
;                         the address passed in (a -> R17). It puts the 
;                         values in starting at address (p -> Y register). 
;Operational Description: This starts by setting the chip select to high 
;                         in PortB bit 0, then it sets the total count 
;                         equal to the total number of bytes we want to 
;                         read from the EEROM. It starts a while loop 
;                         that stops when the count equals zero. In the 
;                         while loop, a modified address is fed into the 
;                         SPI, which outputs the address to the EEROM. 
;                         Then, to continue generating clocks, a garbage 
;                         byte is fed into the SPI so that the EEROM 
;                         sends the byte at that address. In between each 
;                         write/read, we wait for the interrupt flag to 
;                         go high, which symbolizes that the action has been 
;                         completed for the entire byte. The byte values are 
;                         stored, and based on the original address number 
;                         (odd/even), the byte is stored at the Y pointer 
;                         address. The count is then decreased, address is 
;                         incremented, and Port B is turned off outside the
;                         while loop. 
;Arguments:               The EEROM address a is passed into R17, the 
;                         address p is stored in the Y register, and the 
;                         number of bytes (n) is passed into the function
;Global Variables:        None
;Shared Variables:        None
;Local Variables:         count, address, Byte1, and Byte2
;Inputs:                  None
;Outputs:                 None
;User Interface:          None
;Error Handling:          None 
;Algorithms:              None
;Data Structures:         None
;Limitations:             None
;Known Bugs:              None 
;Registers update:        R16, R17, R18, PortB, SPDR, R19, R20, R21, R22,
;                         R23, Y register


ReadEEROM:
Initialize:
  MOV   R21, R16                    ;saves the total number of bytes to 
                                    ;read (used for comparisons below)
  MOV   R22, R17                    ;saves the original address (used 
                                    ;for comparisons below)
  LSR   R17                         ;removes the last bit so we can 
                                    ;refer to the entire word with 
									;an address instead of two byte 
									;addresses
  LSL   R17                         ;shifts to the left to eliminate 
                                    ;the leading zero when reading the 
									;byte
 
StartWhileLoop:
  CPI   R16, 0                      ;checks if there are no more bytes 
                                    ;left to read in 
  BREQ  EndLoop                     ;ends the loop since there are no 
                                    ;more bytes left to read 
  RJMP  SPIHandling                 ;jump to the section that handles 
                                    ;reading/writing to the SPI 


SPIHandling:
  IN    R18, PORTB                  ;retrieves the values written to 
                                    ;port B by putting them in a 
									;register
  ORI   R18, SELECT_EEROM_CHIP      ;selects the EEROM chip by setting 
                                    ;SS high  
  OUT   PORTB, R18                  ;writes the port B values with the 
                                    ;chip select high back to port B
  LDI   R18, INITIATE_WRITE_EEROM1    
  OUT   SPDR, R18                   ;initiates writing to the EEROM
  RCALL WaitInterruptStatusFlag     ;waits for the status flag to be 
                                    ;set meaning all the bits have 
									;been written to the EEROM
  OUT   SPDR, R17                   ;writes the address of the EEROM 
                                    ;data to the SPI
  RCALL WaitInterruptStatusFlag     ;waits for the status flag to be 
                                    ;set meaning all the bits have 
									;been written to the EEROM
  LDI   R23, GARBAGE_BYTE
  OUT   SPDR, R23                   ;adds garbage values to the SPDR 
                                    ;to generate clocks so that the 
									;EEROM sends bytes back 
  RCALL WaitInterruptStatusFlag     ;waits for the status flag to be 
                                    ;set meaning all the bits have 
									;been written to the EEROM
  IN    R19, SPDR                   ;stores byte 1 from the SPDR in R19 
  OUT   SPDR, R23                   ;adds garbage values to the SPDR 
                                    ;to generate clocks so that the 
									;EEROM sends bytes back 
  RCALL WaitInterruptStatusFlag     ;waits for status flag to be set 
                                    ;meaning all the bits have been 
									;written to the EEROM
  IN    R20, SPDR                   ;stores byte 2 from the SPDR in 
                                    ;R20
  IN    R18, PORTB                  ;retrieves the values written 
                                    ;to port B by putting them in 
									;a register
  ANDI  R18, UNSELECT_EEROM_CHIP    ;unselects the EEROM chip by setting 
                                    ;SS LOW
  OUT   PORTB, R18                  ;writes the port B values with the 
                                    ;chip select high back to port B
  RJMP  CheckFirstCondition         ;jumps to the section that checks 
                                    ;various conditions and branches 
									;out depending on the conditions

CheckFirstCondition:
  CP    R16, R21                    ;compares the number of bytes 
                                    ;left to the total number of bytes 
									;to check whether it is the first 
									;iteration 
  BREQ  CheckStartingPosition       ;if it is the first iteration, 
                                    ;checks if the address originally 
									;pointed at the second byte 
  RJMP  CheckSecondCondition        ;if one or more bytes have already 
                                    ;been added at the address, we check 
									;the second condition since the first 
									;condition no longer applies 

CheckStartingPosition:
  MOV   R23, R22                    ;clones the address so it can be 
                                    ;modified
  ANDI  R23, CHECK_START_POSITION   ;checks if the address was initially 
                                    ;odd
  BREQ  CheckSecondCondition        ;if the address was initially 
                                    ;even, it jumps to check the second 
									;condition
  ST    Y+, R20                     ;if the address was initially odd, 
                                    ;it stores the second byte at the 
									;address and increments the address
  DEC   R16                         ;decreases the byte count by one since 
                                    ;we have stored one byte at the 
									;address 
  RJMP  RepeatLoop                  ;restarts the entire process since the
                                    ;byte has been added 

CheckSecondCondition:
  CPI   R16, 1                      ;checks if only one byte left 
  BRNE  AddTwoBytes                 ;if more than one byte can be added,we 
                                    ;add two bytes
  ST    Y+, R19                     ;if only one more byte can be added, 
                                    ;it stores the first byte at address 
									;and increments the address
  DEC   R16                         ;decreases the count by one since we
                                    ;stored one byte at the address 
  RJMP  RepeatLoop                  ;restarts the entire process since 
                                    ;the byte has been added 

AddTwoBytes:
  ST    Y+, R19                     ;it stores the first byte at address 
                                    ;and increments the address
  DEC   R16                         ;decreases the count by 1 since we have 
                                    ;stored one byte at the address 
  ST    Y+, R20                     ;it stores the second byte at address 
                                    ;and increments the address
  DEC   R16                         ;decreases count by one since we have 
                                    ;stored one byte at the address
  RJMP  RepeatLoop                  ;increments address and jumps back to 
                                    ;initial condition which checks if n 
									;bytes is greater than zero
 
RepeatLoop:
  LDI   R23, INCREMENT_WORD_ADDRESS ;increments the word address 
  ADD   R17, R23                    ;increments the word address
  RJMP  StartWhileLoop              ;checks whether the number of  
                                    ;bytes left to read is greater than 
									;zero

EndLoop:
  RET


.dseg 





