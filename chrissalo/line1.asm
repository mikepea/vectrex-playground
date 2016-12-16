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
                db      $F8, $50, $20, -$45     ; height, width, rel y, rel x
                                                ; (from 0,0)
                db      "SINGLE LINE",$80       ; some game information,
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
                clr     Vec_Misc_Count          ; in order for drawing only 1
                                                ; vector, this must be set to
                                                ; 0
                lda     #100                    ; to 100 (y)
                ldb     #50                     ; to 50 (x)
                jsr     Draw_Line_d             ; draw the line now
                bra     main                    ; and repeat forever
;***************************************************************************
                end main
;***************************************************************************
