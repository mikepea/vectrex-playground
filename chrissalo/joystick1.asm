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
                db      "JOYSTICK 1 TEST",$80   ; some game information,
                                                ; ending with $80
                db      0                       ; end of game header
;***************************************************************************
; CODE SECTION
;***************************************************************************
; here the cartridge program starts off
                ldd     #$FC20                  ; HEIGTH, WIDTH (-4, 32)
                std     Vec_Text_HW             ; store to BIOS RAM location
                lda     #1                      ; these set up the joystick
                sta     Vec_Joy_Mux_1_X         ; enquiries
                lda     #3                      ; allowing only all directions
                sta     Vec_Joy_Mux_1_Y         ; for joystick one
                lda     #0                      ; this setting up saves a few
                sta     Vec_Joy_Mux_2_X         ; hundred cycles
                sta     Vec_Joy_Mux_2_Y         ; don't miss it, if you don't
                                                ; need the second joystick!
main:
main_loop:
                jsr     Wait_Recal              ; Vectrex BIOS recalibration
                jsr     Intensity_5F            ; Sets the intensity of the
                                                ; vector beam to $5f
                jsr     Joy_Digital             ; read joystick positions
                lda     Vec_Joy_1_X             ; load joystick 1 position
                                                ; X to A
                beq     no_x_movement           ; if zero, than no x position
                bmi     left_move               ; if negative, than left
                                                ; otherwise right
right_move:
                ldu     #joypad_right_string    ; display right string
                bra     x_done                  ; goto x done
left_move:
                ldu     #joypad_left_string     ; display left string
                bra     x_done                  ; goto x done
no_x_movement:
                ldu     #no_joypad_x_string     ; display no x string
x_done:
                jsr     Print_Str_yx            ; using string function
                lda     Vec_Joy_1_Y             ; load joystick 1 position
                                                ; Y to A
                beq     no_y_movement           ; if zero, than no y position
                bmi     down_move               ; if negative, than down
                                                ; otherwise up
up_move:
                ldu     #joypad_up_string       ; display up string
                bra     y_done                  ; goto y done
down_move:
                ldu     #joypad_down_string     ; display down string
                bra     y_done                  ; goto y done
no_y_movement:
                ldu     #no_joypad_y_string     ; display no y string
y_done:
                jsr     Print_Str_yx            ; using string function
                bra     main_loop               ; and repeat forever
;***************************************************************************
no_joypad_x_string:
                db 40,-50,"NO JOYPAD X INPUT", $80
joypad_right_string:
                db 40,-50,"JOYPAD 1 RIGHT", $80
joypad_left_string:
                db 40,-50,"JOYPAD 1 LEFT", $80
no_joypad_y_string:
                db 20,-50,"NO JOYPAD Y INPUT", $80
joypad_up_string:
                db 20,-50,"JOYPAD 1 UP", $80
joypad_down_string:
                db 20,-50,"JOYPAD 1 DOWN", $80
;***************************************************************************
                end main
;***************************************************************************
