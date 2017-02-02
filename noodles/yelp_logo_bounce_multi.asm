;***************************************************************************
; DEFINE SECTION
;***************************************************************************
                include "VECTREX.I"
; start of vectrex memory with cartridge name...
                org     0
;***************************************************************************
; HEADER SECTION
;***************************************************************************
                db      "g GCE 2016", $80       ; 'g' is copyright sign
                dw      music1                  ; music from the rom
                db      $F8, $50, $20, -$60     ; height, width, rel y, rel x
                                                ; (from 0,0)
                db      "YELP MULTI BOUNCE",$80  ; some game information,
                                                ; ending with $80
                db      0                       ; end of game header
;***************************************************************************
; CODE SECTION
;***************************************************************************
; here the cartridge program starts off

MAX_Y           equ     120
MAX_X           equ     100
MIN_Y           equ     -120
MIN_X           equ     -100

INITIAL_X       equ     24
INITIAL_Y       equ     -2
INITIAL_X_DIR       equ     +5
INITIAL_Y_DIR       equ     +7

watch1          equ     $C880
watch2          equ     $C881

burst1_addr       equ     $C888
burst2_addr       equ     $C890
burst3_addr       equ     $C898


burst_position_offset   equ 0
burst_position_y_offset equ 0
burst_position_x_offset equ 1
burst_y_dir_offset      equ 2
burst_x_dir_offset      equ 3
burst_intesity_offset   equ 4
burst_scaling_offset    equ 5

init:
                ldx     #burst1_addr
                lda     #INITIAL_Y ; initial burst Y pos
                ldb     #INITIAL_X  ; initial burst X pos-
                std     burst_position_offset,x
                lda     #INITIAL_Y_DIR ; initial Y dir
                sta     burst_y_dir_offset,x
                lda     #INITIAL_X_DIR ; initial X dir
                sta     burst_x_dir_offset,x
                lda     #$7f
                sta     burst_scaling_offset,x

                ldx     #burst2_addr
                lda     #INITIAL_Y + 5
                ldb     #INITIAL_X - 5
                std     burst_position_offset,x
                lda     #INITIAL_Y_DIR + 1
                sta     burst_y_dir_offset,x
                lda     #INITIAL_X_DIR - 1
                sta     burst_x_dir_offset,x
                lda     #$af
                sta     burst_scaling_offset,x

main:
                jsr     recalibrate

                ldx     #burst1_addr
                jsr     move_burst_position
                jsr     set_intensity_scaling_x
                jsr     draw_yelp_burst

                jsr     recalibrate

                ldx     #burst2_addr
                jsr     move_burst_position
                jsr     set_intensity_scaling_x
                jsr     draw_yelp_burst

                bra     main                    ; and repeat forever
;***************************************************************************

recalibrate:
                jsr     Wait_Recal              ; Vectrex BIOS recalibration
                lda     #$7f                    ; scaling factor to A
                sta     VIA_t1_cnt_lo           ; move to time 1 lo, this
                                                ; means scaling
                jsr     Intensity_5F            ; Sets the intensity of the
                                                ; vector beam to $5f
                rts

set_intensity_scaling_x:
                lda     burst_scaling_offset,x
                sta     VIA_t1_cnt_lo           ; move to time 1 lo, this
                                                ; means scaling
                rts

move_burst_position:
                jsr     calculate_next_y_burst_pos
                jsr     calculate_next_x_burst_pos
                ldd     burst_position_offset,x
                jsr     Moveto_d                ; move the pen
                rts


; X contains the base addr of the object
calculate_next_y_burst_pos:
                lda     #1
                sta     watch1
                lda     burst_y_dir_offset,x
                bmi     check_y_min      ; direction negative
                lda     burst_position_y_offset,x
                bpl     y_positive
                adda    burst_y_dir_offset,x ; negative or zero, so we don't need to test limit
                bra     y_ok
y_positive:
                adda    burst_y_dir_offset,x
                cmpa    #MAX_Y
                blo     y_ok
                clrb
                subb    burst_y_dir_offset,x
                stb     burst_y_dir_offset,x
                bra     y_ok
check_y_min:
                lda     burst_position_y_offset,x
                bmi     y_negative
                adda    burst_y_dir_offset,x ; positive or zero, so we don't need to test limit
                bra     y_ok
y_negative:
                adda    burst_y_dir_offset,x
                cmpa    #MIN_Y
                bcc     y_ok ;  hmm not sure this is right
                clrb
                subb    burst_y_dir_offset,x
                stb     burst_y_dir_offset,x
y_ok:
                sta     burst_position_y_offset,x
                rts

calculate_next_x_burst_pos:
                ;lda     #1
                ;sta     watch1
                lda     burst_x_dir_offset,x
                bmi     check_x_min      ; direction negative
                lda     burst_position_x_offset,x
                bpl     x_positive
                adda    burst_x_dir_offset,x ; negative or zero, so we don't need to test limit
                bra     x_ok
x_positive:
                adda    burst_x_dir_offset,x
                cmpa    #MAX_X
                blo     x_ok
                clrb
                subb    burst_x_dir_offset,x
                stb     burst_x_dir_offset,x
                bra     x_ok
check_x_min:
                lda     burst_position_x_offset,x
                bmi     x_negative
                adda    burst_x_dir_offset,x ; positive or zero, so we don't need to test limit
                bra     x_ok
x_negative:
                adda    burst_x_dir_offset,x
                cmpa    #MIN_X
                bcc     x_ok
                clrb
                subb    burst_x_dir_offset,x
                stb     burst_x_dir_offset,x
x_ok:
                sta     burst_position_x_offset,x
                rts

set_scaling:

draw_yelp_burst:
                ldx     #yelp_11oclock          ; load next vector list address
                jsr     Mov_Draw_VLc_a          ; move & draw the line now
                ldx     #yelp_09oclock          ; load next vector list address
                jsr     Mov_Draw_VLc_a          ; move & draw the line now
                ldx     #yelp_07oclock          ; load next vector list address
                jsr     Mov_Draw_VLc_a          ; move & draw the line now
                ldx     #yelp_04oclock          ; load next vector list address
                jsr     Mov_Draw_VLc_a          ; move & draw the line now
                ldx     #yelp_02oclock          ; load next vector list address
                jsr     Mov_Draw_VLc_a          ; move & draw the line now
                rts

SPRITE_BLOW_UP equ 1
yelp_11oclock:
                db   10                                   ; number of vectors - 1
                db   5*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP  ; 25,0    => 5,  0 (from 0,0)
                db  13*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP  ; 91,0    => 18, 0
                db   1*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP  ; 97,-6   => 19,-1
                db   1*SPRITE_BLOW_UP, -4*SPRITE_BLOW_UP  ; 100,-25 => 20,-5
                db  -1*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP  ; 94,-40  => 19,-8
                db  -2*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP  ; 85,-50  => 17,-10
                db  -1*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP  ; 80,-50  => 16,-10
                db -12*SPRITE_BLOW_UP,  7*SPRITE_BLOW_UP  ; 22,-15  => 4, -3
                db   0*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP  ; 18,-8   => 4, -2
                db   0*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP  ; 19,-3   => 4, -1
                db   1*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP  ; 25,0    => 5,  0

yelp_09oclock:
                db 8                                     ; number of vectors - 1
                db  -3*SPRITE_BLOW_UP,  -4*SPRITE_BLOW_UP  ; 8,-20  => 2, -4  (from 5,0)
                db   2*SPRITE_BLOW_UP,  -8*SPRITE_BLOW_UP  ; 20,-60  => 4, -12
                db  -2*SPRITE_BLOW_UP,  -1*SPRITE_BLOW_UP  ; 12,-65  => 2, -13
                db  -6*SPRITE_BLOW_UP,   0*SPRITE_BLOW_UP  ; -20,-65 => -4,-13
                db  -1*SPRITE_BLOW_UP,   2*SPRITE_BLOW_UP  ; -25,-55 => -5,-11
                db   3*SPRITE_BLOW_UP,   7*SPRITE_BLOW_UP  ; -10,-20 => -2,-4
                db   1*SPRITE_BLOW_UP,   1*SPRITE_BLOW_UP  ; -5,-15  => -1,-3
                db   1*SPRITE_BLOW_UP,   0*SPRITE_BLOW_UP  ; 0,-15    => 0,-3
                db   2*SPRITE_BLOW_UP,  -1*SPRITE_BLOW_UP  ; 8,-20   =>  2,-4

yelp_07oclock:
                db 8                                     ; number of vectors - 1
                db  -7*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP  ; -25,-15  => -5,-3 (from 2,-4)
                db  -6*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP  ; -55,-40  => -11,-8
                db  -2*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP  ; -65,-38  => -13,-8
                db  -2*SPRITE_BLOW_UP,  6*SPRITE_BLOW_UP  ; -75,-10  => -15,-2
                db   1*SPRITE_BLOW_UP,  2*SPRITE_BLOW_UP  ; -70,0    => -14,0
                db   9*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP  ; -25,0    => -5,0
                db   1*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP  ; -20,-5   => -4,-1
                db   0*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP  ; -20,-10  => -4,-2
                db  -1*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP  ; -25,-15  => -5,-3

yelp_04oclock:
                db 7                                     ; number of vectors - 1
                db   1*SPRITE_BLOW_UP,  6*SPRITE_BLOW_UP  ; -22,15   => -4,3  (from -5,-3)
                db  -8*SPRITE_BLOW_UP,  4*SPRITE_BLOW_UP  ; -60,35   => -12,7
                db   0*SPRITE_BLOW_UP,  2*SPRITE_BLOW_UP  ; -60,45   => -12,9
                db   5*SPRITE_BLOW_UP,  4*SPRITE_BLOW_UP  ; -35,65   => -7,13
                db   2*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP  ; -25,60   => -5,12
                db   2*SPRITE_BLOW_UP, -7*SPRITE_BLOW_UP  ; -15,25   => -3,5
                db   0*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP  ; -15,15   => -3,3
                db  -1*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP  ; -22,15   => -4,3

yelp_02oclock:
                db 9                                     ; number of vectors - 1
                db   5*SPRITE_BLOW_UP,  2*SPRITE_BLOW_UP  ; 5,25     => 1,5 (from -4,3)
                db   1*SPRITE_BLOW_UP,  7*SPRITE_BLOW_UP  ; 10,60    => 2,12
                db   1*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP  ; 15,65    => 3,13
                db   2*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP  ; 25,65    => 5,13
                db   4*SPRITE_BLOW_UP, -4*SPRITE_BLOW_UP  ; 45,45    => 9,9
                db   0*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP  ; 45,35    => 9.7
                db  -5*SPRITE_BLOW_UP, -4*SPRITE_BLOW_UP  ; 20,15    => 4,3
                db  -2*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP  ; 10,15    => 2,3
                db  -1*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP  ; 5,20     => 1,4
                db   0*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP  ; 5,25     => 1,5

;***************************************************************************
                end main
;***************************************************************************
