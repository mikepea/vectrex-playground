                    BSS      
                    ORG      clip_end                     ; start of our ram space 
title_phase         ds       1 
title_phase_counter  ds      2 
title_scale         ds       1 
vector_print_scale ds 1
print_angle ds 2
print_angle_2 ds 2
print_letter_angle_dif ds 2
work_angle ds 2
angle_speed ds 2
;dif_add_delay ds 1
ADD_DELAY = 5

vector_move_scale ds 1
dummyCounter ds 1
                    code     
PHASE_0_NONE        =        0 
PHASE_1_SHOW_NOTHING  =      1 
PHASE_2_SHOW_X      =        2 
PHASE_3_SHOW_HX      =        3 
PHASE_4_SHOW_HUNTER      =       4 
PHASE_5_SHOW_BOMBER      =       5
PHASE_6_SHOW_DRAGON      =       6
PHASE_7_SHOW_BONUS      =       7
PHASE_8_SHOW_SCORER      =       8
PHASE_END_SHOW_END  =        9
INITIAL_TITLE_PHASE_LENGTH  =  200 
;
;
 direct $d0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
initTitel 
                    lda      #PHASE_8_SHOW_SCORER 
                    sta      title_phase 
                    ldd      #1                           ; is titel 
                    std      title_phase_counter 
                    stb      return_state 
                    rts      

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; removes from list all objects that can be "exploded" (positive)
remove_unwanted_objects
                    ldu      list_objects_head 
test_text_unwanted
 cmpu #PC_TITLE
 beq unwanted_done
 ldb TYPE,u
 bmi do_next_one
 jsr removeObject_rts
 bra test_text_unwanted
do_next_one
 ldu NEXT_OBJECT, u 
 bra test_text_unwanted
unwanted_done:
 rts


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
do_one_title_round: 
                    _ZERO_VECTOR_BEAM  
                    ldx      title_phase_counter 
                    leax     -1,x 
                    stx      title_phase_counter 
                    lbne      no_title_phase_switch 
                    ldd      #INITIAL_TITLE_PHASE_LENGTH 
                    std      title_phase_counter 


; change some circle stuff


 lda Vec_Loop_Count
 lsra
 anda #1
 beq do_slow
do_fast
 ldb Vec_Loop_Count
 andb #%00001111
 lsrb
 lslb
 sex
 addd angle_speed
 beq speed_done
 std angle_speed

 bra speed_done
do_slow
 ldb Vec_Loop_Count
 andb #%00001111
 lsrb
 lslb
 sex
 NEG_D
 ldx angle_speed
 leax d,x
 tfr x,d

 beq speed_done
 std angle_speed

speed_done


 cmpd #8
 blt no_to_hi_speed
 ldd #4
 std angle_speed
no_to_hi_speed
 cmpd #-8
 bgt no_to_lo_speed
 ldd #-4
 std angle_speed
no_to_lo_speed




                    lda      title_phase 
                    inca     
                    cmpa     #PHASE_END_SHOW_END 
                    bne      was_not_last_phase 
                    lda      #PHASE_1_SHOW_NOTHING 
was_not_last_phase: 
                    sta      title_phase 
; do deinit old phase
                    jsr      remove_unwanted_objects 
                    lda      title_phase 
                    ldb      #$ff                         ; spawn allowed 
                    cmpa     #PHASE_2_SHOW_X 
                    beq      init_title_phase_2 
                    cmpa     #PHASE_3_SHOW_HX 
                    beq      init_title_phase_3 
                    cmpa     #PHASE_4_SHOW_HUNTER 
                    beq      init_title_phase_4
                    cmpa     #PHASE_5_SHOW_BOMBER 
                    beq      init_title_phase_5
                    cmpa     #PHASE_6_SHOW_DRAGON 
                    beq      init_title_phase_6
                    cmpa     #PHASE_7_SHOW_BONUS 
                    lbeq      init_title_phase_7
                    cmpa     #PHASE_8_SHOW_SCORER 
                    lbeq      init_title_phase_8


                    jmp      done_title_init_phase 

init_title_phase_2 
; init new phase
                    jsr      spawnX 
                    ldd      #PC_TITLE 
                    std      NEXT_OBJECT,x 
                    ldd      #behaviourXTitel 
                    std      BEHAVIOUR,x 
                    lda      #$00 
                    sta      SCALE,x 
                    ldd      #$00b0 
                    std      Y_POS,x 
                    jmp      done_title_init_phase 
init_title_phase_3
; init new phase
                    jsr      spawnHiddenX 
                    ldd      #PC_TITLE 
                    std      NEXT_OBJECT,x 
                    ldd      #behaviourHXTitel 
                    std      BEHAVIOUR,x 
                    lda      #$00 
                    sta      SCALE,x 
                    ldd      #$00b0 
                    std      Y_POS,x 
                    jmp      done_title_init_phase 
init_title_phase_4
; init new phase
                    jsr      spawnHunter 
                    ldd      #PC_TITLE 
                    std      NEXT_OBJECT,x 
                    ldd      #behaviourHunterTitel 
                    std      BEHAVIOUR,x 
                    lda      #$00 
                    sta      SCALE,x 
                    ldd      #$00a0 
                    std      Y_POS,x 
                    bra      done_title_init_phase 
init_title_phase_5
; init new phase
                    jsr      spawnBomber 
                    ldd      #PC_TITLE 
                    std      NEXT_OBJECT,x 
                    ldd      #behaviourBomberTitel 
                    std      BEHAVIOUR,x 
                    lda      #$00 
                    sta      SCALE,x 
                    ldd      #$00b0 
                    std      Y_POS,x 
                    bra      done_title_init_phase 
init_title_phase_6
; init new phase
                    jsr      spawnDragon 
                    ldd      #behaviourDragonTitel 
                    std      BEHAVIOUR,y 
                    lda      #$00 
                    sta      SCALE,y
                    ldd      #$00b0 
                    std      Y_POS,y 

; child 2
                    lda      #$00 
                    sta      SCALE,x
                    ldd      #$20b0 
                    std      Y_POS,x 

                    ldd      #PC_TITLE 
                    std      NEXT_OBJECT,x 

                    ldd      #behaviourDragonChildTitel 
                    std      BEHAVIOUR,x
; child 1
 ldx CHILD_1,y
                    lda      #$00 
                    sta      SCALE,x
                    ldd      #$15b0 
                    std      Y_POS,x 

                    ldd      #behaviourDragonChildTitel 
                    std      BEHAVIOUR,x

                    bra      done_title_init_phase 
init_title_phase_7
; init new phase
                    jsr      spawnBonus 
                    ldd      #PC_TITLE 
                    std      NEXT_OBJECT,x 
                    ldd      #behaviourBonusTitel 
                    std      BEHAVIOUR,x 
                    lda      #$00 
                    sta      SCALE,x 
                    ldd      #$00b0 
                    std      Y_POS,x 
                    bra      done_title_init_phase 
init_title_phase_8
; init new phase
                    jsr      spawnStarlet 
                    ldd      #PC_TITLE 
                    std      NEXT_OBJECT,x 
                    ldd      #behaviourStarletTitel 
                    std      BEHAVIOUR,x 
                    lda      #$00 
                    sta      SCALE,x 
                    ldd      #$00b0 
                    std      Y_POS,x 
                    bra      done_title_init_phase 

done_title_init_phase: 
no_title_phase_switch: 
                    lda      #$40 
                    sta      title_scale 
                    ldd      title_phase_counter 
                    cmpd     #(INITIAL_TITLE_PHASE_LENGTH-$40) 
                    blt      not_high_scale 
                    subd     #(INITIAL_TITLE_PHASE_LENGTH) 
                    NEG_D    
                    stb      title_scale 
not_high_scale 
                    ldd      title_phase_counter 
                    cmpd     #$40 
                    bhi      not_low_scale 
                    stb      title_scale 
not_low_scale 
                    lda      title_phase 
                    cmpa     #PHASE_2_SHOW_X 
                    beq      title_phase_2 
                    cmpa     #PHASE_3_SHOW_HX 
                    beq      title_phase_3 
                    cmpa     #PHASE_4_SHOW_HUNTER
                    beq      title_phase_4
                    cmpa     #PHASE_5_SHOW_BOMBER
                    beq      title_phase_5
                    cmpa     #PHASE_6_SHOW_DRAGON
                    beq      title_phase_6
                    cmpa     #PHASE_7_SHOW_BONUS
                    beq      title_phase_7
                    cmpa     #PHASE_8_SHOW_SCORER
                    beq      title_phase_8
                    bra      completely_done_title_phase 

title_phase_2 
                    ldu      #x_in_title 
                    bra      done_title_phase 
title_phase_3 
                    ldu      #hx_in_title 
                    bra      done_title_phase 
title_phase_4 
                    ldu      #hunter_in_title 
                    bra      done_title_phase 
title_phase_5
                    ldu      #bomber_in_title 
                    bra      done_title_phase 
title_phase_6
                    ldu      #dragon_in_title 
                    bra      done_title_phase 
title_phase_7
                    ldu      #helper_in_title 
                    bra      done_title_phase 
title_phase_8
                    ldu      #bonus_in_title 
                    bra      done_title_phase 

done_title_phase 
                    ldd      #$fc00 
                    jsr      vectorPrint 
completely_done_title_phase 


; dec dif_add_delay 
; bne done_donedone
; lda #ADD_DELAY 
; sta dif_add_delay

; ldd print_angle_2;

; ldx #circle
; leax d,x
; ldd d,x;

; tstb 
; bmi do_minus
; ldd print_letter_angle_dif
; addd #2
; std  print_letter_angle_dif
; rts
;do_minus
; ldd print_letter_angle_dif
; subd #2
; std  print_letter_angle_dif
;done_donedone
                    rts      

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
x_in_title 
                    db       "TERRIBLE X",$80
hx_in_title 
                    db       "HIDDEN X",$80
hunter_in_title 
                    db       "HUNTER",$80
bomber_in_title 
                    db       "BOMBER",$80
dragon_in_title 
                     db       "DRAGON",$80
helper_in_title 
                     db       "HELP",$80
bonus_in_title 
                     db       "GIFTS",$80
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

initTitle2
 jsr spawnStarfield
                    ldd      #PC_TITLE
                    std      NEXT_OBJECT,u 
 jsr spawnStarfield
                    ldd      #PC_TITLE
                    std      NEXT_OBJECT,u 

INITIAL_ANGLE_DIFFERENCE = 60
 lda #40
 sta vector_print_scale
  lda #$60
 sta vector_move_scale
 ldd #0
 std print_angle
 std print_angle_2
 ldd #2
 std angle_speed
 ldd #INITIAL_ANGLE_DIFFERENCE
 std print_letter_angle_dif

;;;
 lda #'R'
 jsr spawnLetter
                    ldd      #PC_TITLE
                    std      NEXT_OBJECT,x 
                    ldy print_angle
  sty ANGLE, x
    tfr y,d
    ldu      #circle 
    leau     d,u                          ; u pointer to spwan angle coordinates 
    ldd      ,u 
    std      Y_POS,x            ; save start pos 
  ldd #0
  std <SPACE_TO_PREVIOUS, x
  std <PREVIOUS_LETTER,x
  lda #TYPE_LETTER_1
  sta TYPE,x

;;;
 leay INITIAL_ANGLE_DIFFERENCE,y
 pshs x
 lda #'E'
 jsr spawnLetter
                    ldd      #PC_TITLE
                    std      NEXT_OBJECT,x 
  sty ANGLE, x
    tfr y,d
    ldu      #circle 
    leau     d,u                          ; u pointer to spwan angle coordinates 
    ldd      ,u 
    std      Y_POS,x            ; save start pos 
 ldd print_letter_angle_dif
  std <SPACE_TO_PREVIOUS, x
 puls d
  std <PREVIOUS_LETTER,x
  lda #TYPE_LETTER_2
  sta TYPE,x
 
;;;
 leay INITIAL_ANGLE_DIFFERENCE,y
 pshs x
 lda #'L'
 jsr spawnLetter
                    ldd      #PC_TITLE
                    std      NEXT_OBJECT,x 
  sty ANGLE, x
    tfr y,d
    ldu      #circle 
    leau     d,u                          ; u pointer to spwan angle coordinates 
    ldd      ,u 
    std      Y_POS,x            ; save start pos 
 ldd print_letter_angle_dif
  std <SPACE_TO_PREVIOUS, x
 puls d
  std <PREVIOUS_LETTER,x
  lda #TYPE_LETTER_3
  sta TYPE,x

;;;
 leay INITIAL_ANGLE_DIFFERENCE,y
 pshs x
 lda #'E'
 jsr spawnLetter
                    ldd      #PC_TITLE
                    std      NEXT_OBJECT,x 
  sty ANGLE, x
    tfr y,d
    ldu      #circle 
    leau     d,u                          ; u pointer to spwan angle coordinates 
    ldd      ,u 
    std      Y_POS,x            ; save start pos 
 ldd print_letter_angle_dif
  std <SPACE_TO_PREVIOUS, x
 puls d
  std <PREVIOUS_LETTER,x
  lda #TYPE_LETTER_4
  sta TYPE,x

;;;
 leay INITIAL_ANGLE_DIFFERENCE,y
 pshs x
 lda #'A'
 jsr spawnLetter
                    ldd      #PC_TITLE
                    std      NEXT_OBJECT,x 
  sty ANGLE, x
    tfr y,d
    ldu      #circle 
    leau     d,u                          ; u pointer to spwan angle coordinates 
    ldd      ,u 
    std      Y_POS,x            ; save start pos 
 ldd print_letter_angle_dif
  std <SPACE_TO_PREVIOUS, x
 puls d
  std <PREVIOUS_LETTER,x
  lda #TYPE_LETTER_5
  sta TYPE,x

;;;
 leay INITIAL_ANGLE_DIFFERENCE,y
 pshs x
 lda #'S'
 jsr spawnLetter
                    ldd      #PC_TITLE
                    std      NEXT_OBJECT,x 
  sty ANGLE, x
    tfr y,d
    ldu      #circle 
    leau     d,u                          ; u pointer to spwan angle coordinates 
    ldd      ,u 
    std      Y_POS,x            ; save start pos 
 ldd print_letter_angle_dif
  std <SPACE_TO_PREVIOUS, x
 puls d
  std <PREVIOUS_LETTER,x
  lda #TYPE_LETTER_6
  sta TYPE,x

;;;
 leay INITIAL_ANGLE_DIFFERENCE,y
 pshs x
 lda #'E'
 jsr spawnLetter
                    ldd      #PC_TITLE
                    std      NEXT_OBJECT,x 
  sty ANGLE, x
    tfr y,d
    ldu      #circle 
    leau     d,u                          ; u pointer to spwan angle coordinates 
    ldd      ,u 
    std      Y_POS,x            ; save start pos 
 ldd print_letter_angle_dif
  std <SPACE_TO_PREVIOUS, x
 puls d
  std <PREVIOUS_LETTER,x
  lda #TYPE_LETTER_7
  sta TYPE,x
 rts

; print text pointed to by u as vector string
; only large letters and "."
; terminated by $80
; position in D
; positioning done with $20 scale
; print done with ## scale
vectorPrint ;#isfunction
                    std      tmp1 
                    lda      #$40 
                    _INTENSITY_A  
next_name_letter_vp 
                    lda      title_scale 
                    _SCALE_A  
;                    _SCALE   ($40)                        ; everything we do with "positioning" is scale SCALE_FACTOR_GAME 
                    ldd      tmp1                         ; the current move vector 
                    MY_MOVE_TO_D_START_NT  
                    LDB      ,u+                          ; first char of three letter name 
                                                          ; lets calculate the abc-table offset... 
 cmpb #' '
 bne _no_space_found
                    ldx      #ABC_28                        ; and add the abc (table of vector list address of the alphabet's letters) 
 bra cont_vp
_no_space_found

                    SUBB     # 'A'                        ; subtract smallest letter, so A has 0 offset
                    LSLB                                  ; multiply by two, since addresses are 16 bit 
                    ldx      #_abc                        ; and add the abc (table of vector list address of the alphabet's letters) 
                    LDX      b,X                          ; in x now address of first letter vectorlist 
cont_vp
                    lda      mov_x 
                    adda     #10 
                    sta      mov_x 
                    lda      title_scale 
                    lsra     
                    lsra     
                    lsra     
                    _SCALE_A  
;                    _SCALE   8                            ; (SCROLL_SCALE_FACTOR) ; drawing of letters is done in SCROLL_SCALE_FACTOR 
                    lda      title_scale 
                    MY_MOVE_TO_B_END  
                    _INTENSITY_A  
                    jsr      myDraw_VL_mode               ;2 
                    _ZERO_VECTOR_BEAM                     ; draw each letter with a move from zero, more stable 
                    LDB      ,u 
                    bpl      next_name_letter_vp 
                    rts      
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

vectorPrint_r ;#isfunction
                    std      tmp1 
next_name_letter_vp_r 
 lda vector_move_scale
                    _SCALE_A  
                    ldd      tmp1                         ; the current move vector 
                    MY_MOVE_TO_D_START_NT  
                    LDB      ,u+                          ; first char of three letter name 
                                                          ; lets calculate the abc-table offset... 
 cmpb #' '
 bne _no_space_found2
                    ldx      #ABC_28                        ; and add the abc (table of vector list address of the alphabet's letters) 
 bra cont_vp2
_no_space_found2


                    SUBB     # 'A'                        ; subtract smallest letter, so A has 0 offset
                    LSLB                                  ; multiply by two, since addresses are 16 bit 
                    ldx      #_abc                        ; and add the abc (table of vector list address of the alphabet's letters) 
                    LDX      b,X                          ; in x now address of first letter vectorlist 
cont_vp2
                    lda      mov_x 
                    adda     #18 
                    sta      mov_x 
                    lda      vector_print_scale 
                    _SCALE_A  
                    MY_MOVE_TO_B_END  
 pshs u
                    jsr      myDraw_VL_mode4               ;2 
 puls u
                    _ZERO_VECTOR_BEAM                     ; draw each letter with a move from zero, more stable 
                    LDB      ,u 
                    bpl      next_name_letter_vp_r 
                    rts      


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; vectorlist in u
; print text pointed to by u as vector string
; only large letters and "."
; terminated by $80
; position scale in vector_move_scale
; print scale in vector_print_scale (expected to use myDraw_VL_mode4)
; 
; current print angle is held in print_angle (can/must be changed from outside) 0-720 (16 bit pointer to circle must be divideable by 2
; difference for angles for each letter in print_letter_angle_dif
; 
circlePrint ; #isfunction
 leay ,u
 ldd print_angle
 std work_angle



next_name_letter_circle
 lda vector_move_scale
                    _SCALE_A  

 ldd work_angle
 ldx #circle
 ldd d,x ; in d coordinates of first letter
                    MY_MOVE_TO_D_START_NT  
 ldd work_angle
 subd print_letter_angle_dif;
 bpl no_circle_overflow
 addd #720
no_circle_overflow:
; std work_angle
 cmpd #720
 blt no_circle_overflow2
 subd #720
no_circle_overflow2:
 std work_angle

                    LDB      ,y+                          ; first char
                                                          ; lets calculate the abc-table offset... 
 cmpb #' '
 bne _no_space_found_circle
                    ldx      #ABC_28                        ; and add the abc (table of vector list address of the alphabet's letters) 
 bra cont_circle
_no_space_found_circle


                    SUBB     # 'A'                        ; subtract smallest letter, so A has 0 offset
                    LSLB                                  ; multiply by two, since addresses are 16 bit 
                    ldx      #_abc                        ; and add the abc (table of vector list address of the alphabet's letters) 
                    LDX      b,X                          ; in x now address of first letter vectorlist 
cont_circle

                    lda      vector_print_scale 
                    _SCALE_A  
                    MY_MOVE_TO_B_END  
; pshs u
                    jsr      myDraw_VL_mode4               ;2 
; puls u
                    _ZERO_VECTOR_BEAM                     ; draw each letter with a move from zero, more stable 
                    LDB      ,y 
                    bpl      next_name_letter_circle 






 rts


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; behaviours control (action) and draw all objects
; each object type has an individual behaviour
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; values are set from "u" list as:
;      pulu     pc,d,x,y ; (D = y,x, X = vectorlist, Y = DDRA+Scale) 
behaviourXTitel                                           ;#isfunction  
                                                          ; do the scaling 
                    sty      VIA_DDR_a                    ; also stores to scale :-() VIA_t1_cnt_lo ; to timer t1 (lo) 
; start the move to
; following calcs can be done within that move
                    MY_MOVE_TO_D_START  
                    dec      ANIM_COUNTER+u_offset1, u    ; see if wee need calc at all, compare tick counter with below zero 
                    bpl      no_anim_update_ti_xb         ; if not, scale will not be updated 
                    lda      #X_ANIM_DELAY                ; anim reset 
                    sta      ANIM_COUNTER+u_offset1, u 
                    ldd      CURRENT_LIST+u_offset1,u 
                    addd     #(enemyXList_1-enemyXList_0) 
                    cmpd     #(enemyXList_3+(enemyXList_1-enemyXList_0)) 
                    bne      not_last_anim_ti_xb 
                    ldd      #enemyXList_0 
not_last_anim_ti_xb: 
                    std      CURRENT_LIST+u_offset1,u 
no_anim_update_ti_xb: 
do_behaviourRest1
                    lda      title_scale 
                    sta      SCALE+u_offset1, u 
                    ldu      NEXT_OBJECT+u_offset1,u      ; preload next user stack 
                    lda      title_scale 
                    lsra     
                    lsra     
                    lsra     
                    lsra     
                    cmpa     #6 
                    blo      noscale_max_bxt 
                    lda      #6 
noscale_max_bxt 
                    sta      VIA_t1_cnt_lo                ; to timer t1 (lo= 
;                    lda      #$5f                         ; intensity 
                    lda      title_scale 
do_behaviourRest2
                    MY_MOVE_TO_B_END                      ; end a move to 
                    _INTENSITY_A  
                    jsr      myDraw_VL_mode 
                    _ZERO_VECTOR_BEAM  
                    pulu     d,x,y,pc                     ; (D = y,x, X = vectorlist, Y = DDRA+Scale) 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; behaviours control (action) and draw all objects
; each object type has an individual behaviour
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; values are set from "u" list as:
;      pulu     pc,d,x,y ; (D = y,x, X = vectorlist, Y = DDRA+Scale) 
behaviourHXTitel                                           ;#isfunction  
                                                          ; do the scaling 
                    sty      VIA_DDR_a                    ; also stores to scale :-() VIA_t1_cnt_lo ; to timer t1 (lo) 
; start the move to
; following calcs can be done within that move
                    MY_MOVE_TO_D_START  
                    dec      ANIM_COUNTER+u_offset1, u    ; see if wee need calc at all, compare tick counter with below zero 
                    bpl      no_anim_update_ti_Hxb         ; if not, scale will not be updated 
                    lda      #X_ANIM_DELAY                ; anim reset 
                    sta      ANIM_COUNTER+u_offset1, u 
                    ldd      CURRENT_LIST+u_offset1,u 
                    addd     #(enemyXList_1-enemyXList_0) 
                    cmpd     #(enemyXList_3+(enemyXList_1-enemyXList_0)) 
                    bne      not_last_anim_ti_Hxb 
                    ldd      #enemyXList_0 
not_last_anim_ti_Hxb: 
                    std      CURRENT_LIST+u_offset1,u 
no_anim_update_ti_Hxb: 
                    lda      title_scale 
                    sta      SCALE+u_offset1, u 
                    ldu      NEXT_OBJECT+u_offset1,u      ; preload next user stack 
                    lda      title_scale 
                    lsra     
                    lsra     
                    lsra     
                    lsra     
                    cmpa     #6 
                    blo      noscale_max_bHxt 
                    lda      #6 
noscale_max_bHxt 
                    sta      VIA_t1_cnt_lo                ; to timer t1 (lo= 
;                    lda      #$5f                         ; intensity 
                    lda      title_scale 
 lsra
 bra do_behaviourRest2

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; behaviours control (action) and draw all objects
; each object type has an individual behaviour
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; values are set from "u" list as:
;      pulu     pc,d,x,y ; (D = y,x, X = vectorlist, Y = DDRA+Scale) 
behaviourHunterTitel                                           ;#isfunction  
                                                          ; do the scaling 
                    sty      VIA_DDR_a                    ; also stores to scale :-() VIA_t1_cnt_lo ; to timer t1 (lo) 
; start the move to
; following calcs can be done within that move
                    MY_MOVE_TO_D_START  
do_behaviourRest3
                    lda      title_scale 
                    sta      SCALE+u_offset1, u 

                    ldu      NEXT_OBJECT+u_offset1,u      ; preload next user stack 
                    ldy      ,x++                         ; load offset of vector list draw 
                    leay     >(unloop_start_addressSub+LENGTH_OF_HEADER),y ; 

                    lda      title_scale 
                    lsra     
                    lsra     
                    lsra     
                    lsra     
                    cmpa     #6 
                    blo      noscale_max_bHuntert 
                    lda      #6 
noscale_max_bHuntert 


                    lda      title_scale 
                    MY_MOVE_TO_B_END                      ; end a move to 
                    _INTENSITY_A  
                    jsr      entry_optimized_draw_mvlc_unloop 
                    ldd      #$cc98 
                    sta      <VIA_cntl                    ; 22 cycles from switch on ZERO disabled, and BLANK enabled 
                    STb      <VIA_aux_cntl                ; 
                    pulu     d,x,y,pc                     ; (D = y,x, X = vectorlist, Y = DDRA+Scale) 


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; behaviours control (action) and draw all objects
; each object type has an individual behaviour
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; values are set from "u" list as:
;      pulu     pc,d,x,y ; (D = y,x, X = vectorlist, Y = DDRA+Scale) 
behaviourBomberTitel:                                          ;#isfunction  
                                                          ; do the scaling 
                    sty      VIA_DDR_a                    ; also stores to scale :-() VIA_t1_cnt_lo ; to timer t1 (lo) 
; start the move to
; following calcs can be done within that move
                    MY_MOVE_TO_D_START  
; check anim
                    dec      ANIM_COUNTER+u_offset1, u    ; see if wee need calc at all, compare tick counter with below zero 
                    bpl      no_anim_update_bbt            ; if not, scale will not be updated 
                    lda      #BOMBER_ANIM_DELAY           ; anim reset 
                    sta      ANIM_COUNTER+u_offset1, u 
                    ldd      CURRENT_LIST+u_offset1,u 
                    addd     #(BomberList_1-BomberList_0) 
                    cmpd     #(BomberList_8+(BomberList_1-BomberList_0)) 
                    bne      not_last_anim_bbt 
                    ldd      #BomberList_0 
not_last_anim_bbt: 
                    std      CURRENT_LIST+u_offset1,u 
no_anim_update_bbt: 
 bra do_behaviourRest3


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; behaviours control (action) and draw all objects
; each object type has an individual behaviour
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; values are set from "u" list as:
;      pulu     pc,d,x,y ; (D = y,x, X = vectorlist, Y = DDRA+Scale) 
behaviourDragonTitel                                           ;#isfunction  
                                                          ; do the scaling 
                    sty      VIA_DDR_a                    ; also stores to scale :-() VIA_t1_cnt_lo ; to timer t1 (lo) 
; start the move to
; following calcs can be done within that move
                    MY_MOVE_TO_D_START  
 inc dummyCounter
                    lda      dummyCounter              ; only every second tick 
                    bita     #$01 
                    beq      no_anim_update_dbt 
                    ldd      CURRENT_LIST+u_offset1,u 
                    addd     #(DragonList_1-DragonList_0) 
                    cmpd     #(DragonList_3+(DragonList_1-DragonList_0)) 
                    bne      not_last_anim_dbt 
                    ldd      #DragonList_0 
not_last_anim_dbt: 
                    std      CURRENT_LIST+u_offset1,u 
no_anim_update_dbt: 

 jmp do_behaviourRest3
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

behaviourDragonChildTitel

                                                          ; do the scaling 
                    sty      VIA_DDR_a                    ; also stores to scale :-() VIA_t1_cnt_lo ; to timer t1 (lo) 
; start the move to
; following calcs can be done within that move
                    MY_MOVE_TO_D_START  



 ldb WIGGLE+u_offset1,u
 lda WIGGLE_DIRECTION+u_offset1,u
 beq wiggle_minus_t
 inc X_POS+u_offset1, u
 incb
 stb WIGGLE+u_offset1,u
 cmpb #4
 bne do_changescale_t
 dec WIGGLE_DIRECTION+u_offset1,u
 bra do_changescale_t
wiggle_minus_t
 dec X_POS+u_offset1, u
 decb
 stb WIGGLE+u_offset1,u
 cmpb #-4
 bne do_changescale_t
 inc WIGGLE_DIRECTION+u_offset1,u


do_changescale_t

 ldx #Dragonchild_List

 jmp do_behaviourRest1


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; values are set from "u" list as:
;      pulu     pc,d,x,y ; (D = y,x, X = vectorlist, Y = DDRA+Scale) 
behaviourBonusTitel                                           ;#isfunction  
                                                          ; do the scaling 
                    sty      VIA_DDR_a                    ; also stores to scale :-() VIA_t1_cnt_lo ; to timer t1 (lo) 
; start the move to
; following calcs can be done within that move
                    MY_MOVE_TO_D_START  

                    dec      ANIM_COUNTER+u_offset1, u    ; see if wee need calc at all, compare tick counter with below zero 
                    bpl      no_anim_update_bobt           ; if not, scale will not be updated 
                    lda      #X_ANIM_DELAY                ; anim reset 
                    sta      ANIM_COUNTER+u_offset1, u 
                    ldd      CURRENT_LIST+u_offset1,u 
                    addd     #(BonusList_1-BonusList_0) 
                    cmpd     #(BonusList_16+(BonusList_1-BonusList_0)) 
                    bne      not_last_anim_bobt 
                    ldd      #BonusList_0 
not_last_anim_bobt: 
                    std      CURRENT_LIST+u_offset1,u 
no_anim_update_bobt: 

 jmp do_behaviourRest1





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; values are set from "u" list as:
;      pulu     pc,d,x,y ; (D = y,x, X = vectorlist, Y = DDRA+Scale) 
behaviourStarletTitel                                          ;#isfunction  
                                                          ; do the scaling 
                    sty      VIA_DDR_a                    ; also stores to scale :-() VIA_t1_cnt_lo ; to timer t1 (lo) 
; start the move to
; following calcs can be done within that move
                    MY_MOVE_TO_D_START  

                    dec      ANIM_COUNTER+u_offset1, u    ; see if wee need calc at all, compare tick counter with below zero 
                    bpl      no_anim_update_sb_t            ; if not, scale will not be updated 
                    lda      #STARLET_ANIM_DELAY          ; anim reset 
                    sta      ANIM_COUNTER+u_offset1, u 
                    ldd      CURRENT_LIST+u_offset1,u 
                    addd     #(StarletList_1-StarletList_0) 
                    cmpd     #(StarletList_10+(StarletList_1-StarletList_0)) 
                    bne      not_last_anim_sb_t 
                    ldd      #StarletList_0 
not_last_anim_sb_t: 
                    std      CURRENT_LIST+u_offset1,u 
no_anim_update_sb_t: 

 jmp do_behaviourRest3

