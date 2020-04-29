;
; MC6840 PLAY
;  Universal Minitor for 6502 
;

	CPU	6502

TARGET:	EQU	"6502"

;
;;; Functions
low	function	x,(x & 255)
high	function	x,(x >> 8)
;
STROUT  EQU        $FF98
PT0     EQU        $28
;
; MC6840 PTM Address
;
        ORG $8030
PTM_CR13  RMB 1
PTM_CR2   RMB 1
PTM_MSBT1 RMB 1
PTM_T1LSB RMB 1
PTM_MSBT2 RMB 1
PTM_T2LSB RMB 1
PTM_MSBT3 RMB 1
PTM_T3LSB RMB 1
;
        org $0200
MAIN:


        JSR     PRINT_START
;
        JSR     INIT_6840
;
        JSR     PLAY
;
        LDA     #$00
        STA     PTM_MSBT1
        STA     PTM_T1LSB
        STA     PTM_MSBT2
        STA     PTM_T2LSB
        STA     PTM_MSBT3
        STA     PTM_T3LSB
;
        JSR     PRINT_END
        BRK
;
PLAY:
        LDA     #$8
        STA     PLAY_CNT
        LDX     #$00
        STX     WK_X
;
PLAY_LOOP:
        JSR     SOUND_OUT
        DEC     PLAY_CNT
        BNE     PLAY_LOOP
;
        RTS
;
SOUND_OUT:
        LDX     WK_X
        INX
        LDA     S_DO1,X
        STA     PTM_MSBT2
        DEX
        LDA     S_DO1,X
        STA     PTM_T2LSB
        INX
        INX
        STX     WK_X
        JSR     WAIT
        RTS
;
INIT_6840:
        LDA     #$01
        STA     PTM_CR2
        STA     PTM_CR13
;
        LDA     #$FF
        STA     PTM_MSBT1
        STA     PTM_T1LSB
        STA     PTM_MSBT2
        STA     PTM_T2LSB
        STA     PTM_MSBT3
        STA     PTM_T3LSB
;
        LDA     #$82
        STA     PTM_CR2
        LDA     PTM_CR13
        LDA     #$93
        STA     PTM_CR2
        LDA     #$82
        STA     PTM_CR13
;
        RTS
;
WAIT:
        LDA     #$FF
        STA     TIMER1
W_LOOP1:
        LDA     #$FF
        STA     TIMER2
W_LOOP2:
        NOP
        NOP
        DEC     TIMER2
        BNE     W_LOOP2
;
        DEC     TIMER1
        BNE     W_LOOP1
;
        RTS
;
PRINT_START:
        LDA	#low(START_MSG)
        STA	PT0
        LDA	#high(START_MSG)
        STA	PT0+1
        JSR     STROUT
        RTS
;
PRINT_END:
        LDA	#low(END_MSG)
        STA	PT0
        LDA	#high(END_MSG)
        STA	PT0+1
        JSR     STROUT
        RTS
;
        BRK   ; PROGRAM END
;
; SOUND DEFINE
;
S_DO1   FDB  $0DC2
;S_DO1S  FDB  $0CFC
S_RE1   FDB  $0C42
;S_RE1S  FDB  $0B92
S_MI1   FDB  $0AEB
S_FA1   FDB  $0A4E
;S_FA1S  FDB  $09BA
S_SO1   FDB  $092F
;S_SO1S  FDB  $08AB
S_RA1   FDB  $082E
;S_RA1S  FDB  $07B8
S_SI1   FDB  $074A
S_DO2   FDB  $06E1
;S_DO2S  FDB  $067E
;S_RE2   FDB  $0621
;S_RE2S  FDB  $05C9
;S_MI2   FDB  $0575
;S_FA2   FDB  $0527
;S_FA2S  FDB  $04DD
;S_SO2   FDB  $0497
;S_SO2S  FDB  $0455
;S_RA2   FDB  $0417
;S_RA2S  FDB  $03DC
;S_SI2   FDB  $03A5
;S_DO3   FDB  $0370
;

;
; MSG DEFINE
;
START_MSG FCB "PLAY START",$0D,$0A,$00
END_MSG FCB "PLAY END",$0D,$0A,$00
;
; WORK AREA
;
        org $30
;
TIMER1  RMB 1
TIMER2  RMB 1
;
PLAY_CNT  RMB 1
WK_X    RMB 1

        END
