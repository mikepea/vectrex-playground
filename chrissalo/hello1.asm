;***************************************************************************
; DEFINE SECTION
;***************************************************************************
Intensity_5F    equ     $F2A5                   ; BIOS Intensity routine
Print_Str_d     equ     $F37A                   ; BIOS print routine
Wait_Recal      equ     $F192                   ; BIOS recalibration
music1          equ     $FD0D                   ; address of a (BIOS ROM)
                                                ; music
; start of vectrex memory with cartridge name...
                org     0
;***************************************************************************
; HEADER SECTION
;***************************************************************************
                db      "g GCE 1998", $80       ; 'g' is copyright sign
                dw      music1                  ; music from the rom
                db      $F8, $50, $20, -$56     ; height, width, rel y, rel x
                                                ; (from 0,0)
                db      "HELLO WORLD PROG 1",$80; some game information,
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
                ldu     #hello_world_string     ; address of string
                lda     #$10                    ; Text position relative Y
                ldb     #-$50                   ; Text position relative X
                jsr     Print_Str_d             ; Vectrex BIOS print routine
                bra     main                    ; and repeat forever
;***************************************************************************
; DATA SECTION
;***************************************************************************
hello_world_string:
                db   "HELLO WORLD"              ; only capital letters
                db   $80                        ; $80 is end of string
;***************************************************************************
                end  main
;***************************************************************************
