;***************************************************************************
; DEFINE SECTION
;***************************************************************************
                include "VECTREX.I"             ; vectrex function includes
; start of vectrex memory with cartridge name...
                org     0
;***************************************************************************
; HEADER SECTION
;***************************************************************************
                db      "g GCE 1998", $80       ; 'g' is copyright sign
                dw      music1                  ; music from the rom
                db      $F8, $50, $20, -$56     ; height, width, rel y, rel x
                                                ; (from 0,0)
                db      "PLOT A DOT",$80        ; some game information,
                                                ; ending with $80
                db      0                       ; end of game header
;***************************************************************************
; CODE SECTION
;***************************************************************************
; here the cartridge program starts off
main:
                jsr     Wait_Recal              ; Vectrex BIOS recalibration
                jsr     Intensity_5F            ; Sets the intensity of the
                                                ; vector beam to $5f
                ; special attention here!!!
                jsr     Dot_here                ; Plot a dot at the center of
                                                ; the screen
                bra     main                    ; and repeat forever
;***************************************************************************
                end  main
;***************************************************************************
