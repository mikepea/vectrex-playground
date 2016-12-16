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
                db      "BUTTON TEST",$80       ; some game information,
                                                ; ending with $80
                db      0                       ; end of game header
;***************************************************************************
; CODE SECTION
;***************************************************************************
; here the cartridge program starts off
                ldd     #$FC20                  ; HEIGTH, WIDTH (-4, 32)
                std     Vec_Text_HW             ; store to BIOS RAM location
main:
main_loop:
                jsr     Wait_Recal              ; Vectrex BIOS recalibration
                jsr     Intensity_5F            ; Sets the intensity of the
                                                ; vector beam to $5f
                jsr     Read_Btns               ; get button status
                lda     Vec_Btn_State           ; get the current state of all
                                                ; buttons
                cmpa    #$00                    ; is a button pressed?
                beq     no_button               ; no, than go on
                bita    #$01                    ; test for button 1 1
                beq     button_1_1_not          ; if not pressed jump
                ldu     #button_1_1_string      ; otherwise display the
                pshs    a                       ; store A
                jsr     Print_Str_yx            ; string using string function
                puls    a                       ; restore A
button_1_1_not:
                bita    #$02                    ; test for button 1 2
                beq     button_1_2_not          ; if not pressed jump
                ldu     #button_1_2_string      ; otherwise display the
                pshs    a                       ; store A
                jsr     Print_Str_yx            ; string using string function
                puls    a                       ; restore A
button_1_2_not:
                bita    #$04                    ; test for button 1 3
                beq     button_1_3_not          ; if not pressed jump
                ldu     #button_1_3_string      ; otherwise display the
                pshs    a                       ; store A
                jsr     Print_Str_yx            ; string using string function
                puls    a                       ; restore A
button_1_3_not:
                bita    #$08                    ; test for button 1 4
                beq     button_1_4_not          ; if not pressed jump
                ldu     #button_1_4_string      ; otherwise display the
                pshs    a                       ; store A
                jsr     Print_Str_yx            ; string using string function
                puls    a                       ; restore A
button_1_4_not:
                bita    #$10                    ; test for button 2 1
                beq     button_2_1_not          ; if not pressed jump
                ldu     #button_2_1_string      ; otherwise display the
                pshs    a                       ; store A
                jsr     Print_Str_yx            ; string using string function
                puls    a                       ; restore A
button_2_1_not:
                bita    #$20                    ; test for button 2 2
                beq     button_2_2_not          ; if not pressed jump
                ldu     #button_2_2_string      ; otherwise display the
                pshs    a                       ; store A
                jsr     Print_Str_yx            ; string using string function
                puls    a                       ; restore A
button_2_2_not:
                bita    #$40                    ; test for button 2 3
                beq     button_2_3_not          ; if not pressed jump
                ldu     #button_2_3_string      ; otherwise display the
                pshs    a                       ; store A
                jsr     Print_Str_yx            ; string using string function
                puls    a                       ; restore A
button_2_3_not:
                bita    #$80                    ; test for button 2 4
                beq     button_2_4_not          ; if not pressed jump
                ldu     #button_2_4_string      ; otherwise display the
                jsr     Print_Str_yx            ; string using string function
button_2_4_not:
                bra     main_loop               ; go on, repeat...
no_button:
                ldu     #no_button_string
                jsr     Print_Str_yx
                bra     main_loop               ; and repeat forever
;***************************************************************************
no_button_string:
                db 50,-50,"NO BUTTON PRESSED", $80
button_1_1_string:
                db 40,-50,"JOYPAD 1 BUTTON 1", $80
button_1_2_string:
                db 30,-50,"JOYPAD 1 BUTTON 2", $80
button_1_3_string:
                db 20,-50,"JOYPAD 1 BUTTON 3", $80
button_1_4_string:
                db 10,-50,"JOYPAD 1 BUTTON 4", $80
button_2_1_string:
                db 0,-50,"JOYPAD 2 BUTTON 1", $80
button_2_2_string:
                db -10,-50,"JOYPAD 2 BUTTON 2", $80
button_2_3_string:
                db -20,-50,"JOYPAD 2 BUTTON 3", $80
button_2_4_string:
                db -30,-50,"JOYPAD 2 BUTTON 4", $80
;***************************************************************************
                end main
;***************************************************************************
