;
; LED BLINK for SBC-IO(PIA)
;   KUNI-NET


	CPU	6502

TARGET:	EQU	"6502"

;
; PIA ADDRESS
;
PIACTLB         EQU     $8053
PIADATB         EQU     $8052
PIACTLA         EQU     $8051
PIADATA         EQU     $8050
;
WORK_AD         EQU     $30
;
        ORG     $200

START:
        JSR PIA_INIT
        LDA     #$20
        STA     CNT
LED_LOOP:
        LDA     #$55
        STA     PIADATA
        JSR     WAIT
        LDA     #$AA
        STA     PIADATA
        JSR     WAIT
        DEC     CNT
        BNE     LED_LOOP
;
        BRK
;
; PIA INIT
;
PIA_INIT:
        LDA     #$00
        STA     PIACTLA
        STA     PIACTLB
        LDA     #$FF
        STA     PIADATA
        LDA     #$00
        STA     PIADATB
        LDA     #$04
        STA     PIACTLA
        STA     PIACTLB
        RTS
;
; WAIT
;
WAIT:
        LDA     #$FF
        STA     WAIT_CNT
WAIT_LOOP:
        JSR     WAIT2
        DEC     WAIT_CNT
        BNE     WAIT_LOOP        
        RTS
;
WAIT2:
        LDA     #$FF
        STA     WAIT_CNT2
WAIT2_LOOP:
        DEC     WAIT_CNT2
        BNE     WAIT2_LOOP
        RTS
;
; WORK AREA
;
        ORG WORK_AD
CNT:	RMB	1		; COUNTER
WAIT_CNT:   RMB     1               ; WAIT COUNTER
WAIT_CNT2:   RMB     1               ; WAIT COUNTER
WAIT_CNT3:   RMB     1               ; WAIT COUNTER