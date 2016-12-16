;***************************************************************************
; DEFINE SECTION
;***************************************************************************
                include "VECTREX.I"
; start of vectrex memory with cartridge name...
                org     0
;***************************************************************************
; HEADER SECTION
;***************************************************************************
                db      "g GCE 1998", $80       ; 'g' is copyright sign
                dw      music1                  ; music from the rom
                db      $F8, $50, $20, -$55     ; height, width, rel y, rel x
                                                ; (from 0,0)
                db      "VECTOR LIST TEST",$80  ; some game information,
                                                ; ending with $80
                db      0                       ; end of game header
;***************************************************************************
; CODE SECTION
;***************************************************************************
; here the cartridge program starts off
main:
                jsr     Wait_Recal              ; Vectrex BIOS recalibration
                lda     #$10                    ; scaling factor of $80 to A
                sta     VIA_t1_cnt_lo           ; move to time 1 lo, this
                                                ; means scaling
                lda     #0                      ; to 0 (y)
                ldb     #0                      ; to 0 (x)
                jsr     Moveto_d                ; move the vector beam the
                                                ; relative position
                jsr     Intensity_5F            ; Sets the intensity of the
                                                ; vector beam to $5f
                ldx     #turtle_line_list       ; load the address of the to be
                                                ; drawn vector list to X
                jsr     Draw_VLc                ; draw the line now
                bra     main                    ; and repeat forever
;***************************************************************************
SPRITE_BLOW_UP equ 25
turtle_line_list:
                db 23                           ; number of vectors - 1
                db  2*SPRITE_BLOW_UP,  2*SPRITE_BLOW_UP
                db -1*SPRITE_BLOW_UP,  2*SPRITE_BLOW_UP
                db  2*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                db  2*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                db  0*SPRITE_BLOW_UP,  2*SPRITE_BLOW_UP
                db -1*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                db  1*SPRITE_BLOW_UP,  3*SPRITE_BLOW_UP
                db -1*SPRITE_BLOW_UP,  4*SPRITE_BLOW_UP
                db  1*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                db -1*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                db -1*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                db -3*SPRITE_BLOW_UP,  2*SPRITE_BLOW_UP
                db -3*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                db -1*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                db -1*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
                db  1*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                db -1*SPRITE_BLOW_UP, -4*SPRITE_BLOW_UP
                db  1*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP
                db -1*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
                db  0*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                db  2*SPRITE_BLOW_UP,  2*SPRITE_BLOW_UP
                db  2*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
                db -1*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                db  2*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
;***************************************************************************
                end main
;***************************************************************************
