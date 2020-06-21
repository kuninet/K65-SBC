;
; YM2151 PLAY
;  Universal Minitor for 6502 & SBC68toSBC80 Adapter
;

	CPU	6502

TARGET:	EQU	"6502"

;
;;; Functions
low	function	x,(x & 255)
high	function	x,(x >> 8)
;
;
MUSIC       EQU     $1000
OPM_ADDR    EQU     $8040
OPM_DATA    EQU     $8041

;
        org $0200
MAIN:
        LDA     #low(MUSIC)
        STA     MUSIC_PTR
        LDA     #high(MUSIC)
        STA     MUSIC_PTR+1
LOOP:
        LDY     #0
        LDA     (MUSIC_PTR),Y
        CMP     #$54
        BEQ     PLAY
        CMP     #$61
        BEQ     WAIT1_S
        CMP     #$62
        BEQ     WAIT2_S
        CMP     #$63
        BEQ     WAIT3_S
        CMP     #$64
        BEQ     WAIT3_S
        CMP     #$66
        BEQ     END_RTN
;
        CMP     #$70
        BEQ     WAIT4_S
        JMP     CHK_WAIT_S
;
NEXT:
        JSR     ADD_PTR
        JMP     LOOP
;
END_RTN:
        BRK
;
; SUB ROUTINE JUMP
;
PLAY:
        JMP     PLAY_S
;WAIT1:
;        LDX     #2
;        JMP     GO_SUB
;WAIT2:
;        LDX     #4
;        JMP     GO_SUB
;WAIT3:
;        LDX     #6
;        JMP     GO_SUB
;WAIT4:
;        LDX     #8
;        JMP     GO_SUB
;
ADD_PTR:
        LDA     #1
        CLC
        ADC     MUSIC_PTR
        STA     MUSIC_PTR
        LDA     #0
        ADC     MUSIC_PTR+1
        STA     MUSIC_PTR+1
        RTS
WAIT1_S:
        INY
        LDA     (MUSIC_PTR),Y
        STA     WAIT_CNT
        INY
        LDA     (MUSIC_PTR),Y
        STA     WAIT_CNT+1
        JSR     WAIT
        JSR     ADD_PTR
        JSR     ADD_PTR
        JMP     NEXT
;
WAIT2_S:
        LDA     #low(735)
        STA     WAIT_CNT
        LDA     #high(735)
        STA     WAIT_CNT+1
        JSR     WAIT
        JMP     NEXT
;
WAIT3_S:
        LDA     #low(882)
        STA     WAIT_CNT
        LDA     #high(882)
        STA     WAIT_CNT+1
        JSR    WAIT
        JMP     NEXT
;
CHK_WAIT_S:
        CMP     #$80
        BCS     WAIT4_EXIT
WAIT4_S:
        AND     #$0F
        CLC
        ADC     #1
        STA     WAIT_CNT
        LDA     #0
        STA     WAIT_CNT+1
        JSR    WAIT
WAIT4_EXIT:
        JMP     NEXT
;
WAIT:
        JSR     WAIT_1MS
        SEC
        LDA     WAIT_CNT
        SBC     #1
        STA     WAIT_CNT
        LDA     WAIT_CNT+1
        SBC     #0
        STA     WAIT_CNT+1
;
        LDA     WAIT_CNT
        CMP     WAIT_CNT+1
        BNE     WAIT
WAIT_EXIT:
        RTS
WAIT_1MS:
        LDA     #$E0
        STA     WAIT_1MS_CNT
WAIT_1MS_LOOP:
        DEC     WAIT_1MS_CNT
        NOP
        NOP
        BNE     WAIT_1MS_LOOP
        RTS
;
;
PLAY_S:
        INY
        LDA     (MUSIC_PTR),Y
        STA     WK_ADDR
        INY
        LDA     (MUSIC_PTR),Y
        STA     WK_DATA
;
WRITE_OPM
        LDA     OPM_DATA
        CMP     #$80
        BEQ     WRITE_OPM
;
        LDA     WK_ADDR
        STA     OPM_ADDR
        NOP
        NOP        
        NOP
        NOP     
        LDA     WK_DATA
        STA     OPM_DATA
        JSR     ADD_PTR
        JSR     ADD_PTR
        JMP     NEXT
;

;
SUB_PTR_TBL:
        FDB     PLAY_S
        FDB     WAIT1_S
        FDB     WAIT2_S
        FDB     WAIT3_S
        FDB     WAIT4_S
;
; Work Area
;
        org  $30
MUSIC_PTR RMB 2
WK_ADDR  RMB 1
WK_DATA  RMB 1
WAIT_CNT RMB 2
WAIT_1MS_CNT RMB 1
SUB_PTR  FDB    SUB_PTR_TBL
;
        END
