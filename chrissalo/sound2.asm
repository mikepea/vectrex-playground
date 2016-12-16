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
                ldu     #yankee                 ; get some music, here yankee
                jsr     Init_Music_chk          ; and init new notes
                jsr     Wait_Recal              ; Vectrex BIOS recalibration
                jsr     Do_Sound                ; ROM function that does the
                                                ; sound playing
                bra     main_loop               ; and repeat forever
;***************************************************************************
yankee:
                fdb     $FEE8, $FEB6            ; ADSR and twang address tables, in Vectrex ROM
                fcb     2,12                    ;;;;;;;;
                fcb     0,12                    ; first byte is a note, to be
                fcb     2,12                    ; found in vectrex rom, is a
                fcb     0,12                    ; 64 byte table...
                fcb     2,6                     ; last byte is length of note
                fcb     0,6
                fcb     2,6
                fcb     0,6
                fcb     2,6
                fcb     0,6
                fcb     2,12
                fcb     0,12                    ;;;;;;;;
                fcb     2,12
                fcb     0,12
                fcb     2,12
                fcb     0,12                    ;;;;;;;;
                fcb     2,6
                fcb     0,6
                fcb     2,6
                fcb     0,6
                fcb     2,6
                fcb     0,6
                fcb     2,6                     ;;;;;;;;
                fcb     0,6
                fcb     2,12
                fcb     0,12
                fcb     128+2,128+26,26-12, 12  ;
                fcb     128+0,128+31,31-12, 12  ;;;;;;;;
                fcb     128+2,128+31,31-12, 12  ; a 128 means the next byte is
                fcb     128+0,128+33,33-12, 12  ; a note for the next channel
                fcb     128+2,128+35,35-12, 12  ; channel...
                fcb     128+0,128+31,31-12, 12  ;;;;;;;;
                fcb     128+2,128+35,35-12, 12
                fcb     128+0,128+33,33-12, 12
                fcb     128+2,128+26,26-12, 12
                fcb     128+0,128+31,31-12, 12  ;;;;;;;;
                fcb     128+2,128+31,31-12, 12
                fcb     128+0,128+33,33-12, 12
                fcb     128+2,128+35,35-12, 12
                fcb     128+0,128+31,31-12, 12  ;;;;;;;;
                fcb     2,12
                fcb     128+0,128+30,30-12, 12
                fcb     128+2,128+26,26-12, 12
                fcb     128+0,128+31,31-12, 12  ;;;;;;;;
                fcb     128+2,128+31,31-12, 12
                fcb     128+0,128+33,33-12, 12
                fcb     128+2,128+35,35-12, 12
                fcb     128+0,128+36,36-12, 12  ;;;;;;;;
                fcb     128+2,128+35,35-12, 12
                fcb     128+0,128+33,33-12, 12
                fcb     128+2,128+31,31-12, 12
                fcb     128+0,128+30,30-12, 12  ;;;;;;;;
                fcb     128+2,128+26,26-12, 12
                fcb     128+0,128+28,28-12, 12
                fcb     128+2,128+30,30-12, 12
                fcb     128+0,128+31,31-12, 12  ;;;;;;;;
                fcb     2, 12
                fcb     128+0,128+31,31-12, 12
                fcb     2, 12
                fcb     128+0,128+28,28-12, 18  ;;;;;;;;
                fcb     128+30,30-12, 06
                fcb     128+2,128+28,28-12, 12
                fcb     128+0,128+26,26-12, 12
                fcb     128+2,128+28,28-12, 12  ;;;;;;;;
                fcb     128+0,128+30,30-12, 12
                fcb     128+2,128+31,31-12, 12
                fcb     0, 12
                fcb     128+0,128+26,26-12, 18  ;;;;;;;;
                fcb     128+28,28-12, 06
                fcb     128+2,128+26,26-12, 12
                fcb     128+0,128+24,24-12, 12
                fcb     128+2,128+23,23-12, 12  ;;;;;;;;
                fcb     0, 12
                fcb     128+2,128+26,26-12, 12
                fcb     0, 12
                fcb     128+2,128+28,28-12, 18  ;;;;;;;;
                fcb     128+30,30-12, 06
                fcb     128+0,128+28,28-12, 12
                fcb     128+2,128+26,26-12, 12
                fcb     128+0,128+28,28-12, 12  ;;;;;;;;
                fcb     128+2,128+30,30-12, 12
                fcb     128+0,128+31,31-12, 12
                fcb     128+2,128+28,28-12, 12
                fcb     128+0,128+26,26-12, 12  ;;;;;;;;
                fcb     128+2,128+31,31-12, 12
                fcb     128+0,128+30,30-12, 12
                fcb     128+2,128+33,33-12, 12
                fcb     128+0,128+31,31-12, 12  ;;;;;;;;
                fcb     2, 12
                fcb     128+0,128+31,31-12, 12
                fcb     2, 12
                fcb     19, $80                 ; $80 is end marker for music
                                                ; (high byte set)
;***************************************************************************
                end main
;***************************************************************************
