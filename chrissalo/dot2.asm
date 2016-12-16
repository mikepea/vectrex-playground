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
                db      "PLOT A LIST OF DOTS",$80; some game information,
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
                jsr     Delay_3                 ; delay for 30 cycles
                lda     #50                     ; load 50
                sta     VIA_t1_cnt_lo           ; 50 as scaling
                lda     #6                      ; load A with 6, dots - 1
                sta     Vec_Misc_Count          ; set it as counter for dots
                ldx     #dot_list               ; load the address of dot_list
                jsr     Dot_List                ; Plot a series of dots
                bra     main                    ; and repeat forever
;***************************************************************************
; DATA SECTION
;***************************************************************************
dot_list:
                db       30,-70                 ; seven dots, relative
                db      -40, 10                 ; position, Y, X
                db        0, 30
                db       40, 10
                db       10, 30
                db        5, 30
                db       -10,40
;***************************************************************************
                end  main
;***************************************************************************
