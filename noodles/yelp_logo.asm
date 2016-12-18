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
                db      "YELP LOGO TEST",$80    ; some game information,
                                                ; ending with $80
                db      0                       ; end of game header
;***************************************************************************
; CODE SECTION
;***************************************************************************
; here the cartridge program starts off
main:
                jsr     Wait_Recal              ; Vectrex BIOS recalibration
                lda     #$80                    ; scaling factor of $80 to A
                sta     VIA_t1_cnt_lo           ; move to time 1 lo, this
                                                ; means scaling

                lda     #0                      ; to 0 (y)
                ldb     #0                      ; to 0 (x)
                jsr     Moveto_d                ; move the vector beam the
                                                ; relative position
                jsr     Intensity_5F            ; Sets the intensity of the
                                                ; vector beam to $5f

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

                bra     main                    ; and repeat forever
;***************************************************************************
SPRITE_BLOW_UP equ 5
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
