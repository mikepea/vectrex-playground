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
                lda     #1                      ; one means, we are about to
                                                ; start a piece of music
                sta     Vec_Music_Flag          ; store it in appropriate RAM
                                                ; location
main_loop:
                jsr     DP_to_C8                ; DP to RAM
                ldu     #music1                 ; get some music, here music1
                jsr     Init_Music_chk          ; and init new notes
                jsr     Wait_Recal              ; Vectrex BIOS recalibration
                jsr     Do_Sound                ; ROM function that does the
                                                ; sound playing
                bra     main_loop               ; and repeat forever
;***************************************************************************
                end main
;***************************************************************************
