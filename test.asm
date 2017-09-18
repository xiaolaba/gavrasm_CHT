;
; *********************************
; *                               *
; *                               *
; *********************************
;
.nolist
.include "tn13def.inc" ; Define device ATtiny13
.list
;
; **********************************
;        H A R D W A R E
; **********************************
;
; **********************************
;  P O R T S   A N D   P I N S
; **********************************
;
.equ pOut = PORTB ; Define a output port
.equ pDir = DDRB ; Define a direction port
.equ pIn = PINB ; Define an input port
.equ bMyPinO = PORTB0 ; Define an output pin
.equ bDir0 = DDB0 ; Define a direction pin
.equ bMyIn = PINB0 ; Define an input pin
;
; **********************************
;   A D J U S T A B L E   C O N S T
; **********************************
;
.equ clock=1200000 ; Define clock frequency
;
; **********************************
;  F I X  &  D E R I V.  C O N S T
; **********************************
;
.equ cTc0Clk = clock / 256 ; Define from clock
;
; **********************************
;       R E G I S T E R S
; **********************************
;
; free: R0 to R14
.def rSreg = R15 ; Save/Restore status port
.def rmp = R16 ; Define multipurpose register
; free: R17 to R29
; used: R31:R30 = Z for ...
;
; **********************************
;           S R A M
; **********************************
;
.dseg
.org SRAM_START
sLabel1:
.byte 16 ; Reserve 16 bytes
;
; **********************************
;         C O D E
; **********************************
;
.cseg
.org 000000
;
; **********************************
; R E S E T  &  I N T - V E C T O R S
; **********************************
	rjmp Main ; Reset vector
; Add all int vesctors here with reti
;
; **********************************
;  I N T - S E R V I C E   R O U T .
; **********************************
;
; Add all interrupt service routines
;
; **********************************
;  M A I N   P R O G R A M   I N I T
; **********************************
;
Main:
	ldi rmp,Low(RAMEND)
	out SPL,rmp ; Init LSB stack pointer
; ...
	sei ; Enable interrupts
;
; **********************************
;    P R O G R A M   L O O P
; **********************************
;
Loop:
	rjmp loop
; End of source code
