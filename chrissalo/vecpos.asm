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
                db      $F8, $50, $20, -$70     ; height, width, rel y, rel x
                                                ; (from 0,0)
                db      "POSITION SOME DOTS",$80; some game information,
                                                ; ending with $80
                db      0                       ; end of game header
;***************************************************************************
; CODE SECTION
;***************************************************************************
; here the cartridge program starts off
main:
                jsr     Wait_Recal              ; Vectrex BIOS recalibration

                ; prepare dot 0
                jsr     Intensity_5F            ; Sets the intensity of the
                                                ; vector beam to $5f
                jsr     Delay_3                 ; delay for 30 cycles
                jsr     Dot_here                ; Plot a dot here
                ; end of dot 0

                ; prepare dot 1
                lda     #100                    ; load 100
                sta     VIA_t1_cnt_lo           ; 100 as scaling
                lda     #-100                   ; relative Y position = -100
                ldb     #-50                    ; relative X position = -50
                                                ; register D = 256*A+B
                jsr     Moveto_d                ; move to position specified
                                                ; in D register
                jsr     Dot_here                ; Plot a dot here
                ; end of dot 1

                ; prepare dot 2
                lda     #50                     ; load 50
                sta     VIA_t1_cnt_lo           ; 50 as scaling
                lda     #100                    ; relative Y position = 100
                ldb     #50                     ; relative X position = 50
                                                ; register D = 256*A+B
                jsr     Moveto_d                ; move to position specified
                                                ; in D register
                jsr     Dot_here                ; Plot a dot here
                ; end of dot 2

                ; prepare dot 3
                lda     #200                    ; scale factor of 200
                ldx     #position               ; load address of position
                jsr     Moveto_ix_a             ; move to position specified
                                                ; in address pointed to by X
                                                ; and set scaling factor found
                                                ; register B
                                                ; (befor positioning)
                jsr     Dot_here                ; Plot a dot here
                ; end of dot 3
                bra     main                    ; and repeat forever
;***************************************************************************
; DATA SECTION
;***************************************************************************
position:
                db      100, 50                 ; relative Y, X position
;***************************************************************************
                end  main
;***************************************************************************
