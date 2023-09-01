;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                            ;
;                               ReadEEROM.inc                                ;
;       InitSPI, WaitInterruptStatusFlag, and ReadEEROM Function Constants   ;
;                               Include File                                 ;
;                                                                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; This file contains the constants for the ReadEEROM functions file
; to read values from the EEROM and input them into a specific address
;
; Revision History:
;     06/01  Purvi Sehgal        Added constants and values 


.EQU   INIT_SPCR = 0b01010001              ;enables the SPI, sets the MSB of 
                                           ;the data word to be transmitted 
										   ;first, selects Master SPI, and sets 
										   ;up the SPI clock 
.EQU   CHECK_SPI_Flag_Set = 0b10000000     ;used to check if the SPI flag is 
                                           ;set
.EQU   SELECT_EEROM_CHIP = 0b00000001      ;selects the EEROM chip by setting 
                                           ;SS high 
.EQU   UNSELECT_EEROM_CHIP = 0b11111110    ;unselects the EEROM chip by setting 
                                           ;SS LOW
.EQU   CLEAR_LAST_BIT = 0b11111110         ;clears the zeroth bit
.EQU   INITIATE_WRITE_EEROM1 = 0b00000011  ;initiates writing to the EEROM -> 
                                           ;this is part of the 110 + address 
										   ;required for the EEROM to start 
										   ;transmitting. Since this makes up 
										   ;9 bits, we send the instruction as 
										   ;two separate bytes, and the first 
										   ;is this one. To account for the 
										   ;zero when receiving the bytes, 
										   ;we shift both bytes to the left. 
.EQU   GARBAGE_BYTE = 0b00000000           ;adds garbage values to the SPDR to 
                                           ;generate clocks so that the EEROM 
										   ;sends bytes back 
.EQU   CHECK_START_POSITION = 0b00000001   ;checks if the address was initially 
                                           ;odd
.EQU   INCREMENT_WORD_ADDRESS = 0b00000010 ;increment the word address
