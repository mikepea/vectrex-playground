phaseList 
; FIRST_PHASE
                    dw       phase1 
                    dw       phase2 
                    dw       phase3 
                    dw       phase4 
                    dw       phase5 
                    dw       phase6 
                    dw       phase7 
                    dw       phase8 
     ;               dw       phase8 
                    dw       0 

; slow spawn, 
; very slow hiddens
phase1: 
                    db       DEFAULT_ALL_SPAWN            ; spawn types allowed 
                    db       SHIELD_WIDTH_GROWTH_DEFAULT  ;4 2 up , ec -> bpl than width grow 
                    db       SHIELD_DEFAULT_SPEED         ;2 shield major speed ; update every tick, must be in sum greater than minor increase 
                    db       SHIELD_MINOR_DELAY_COUNTER_DEFAULT ; 2 shield minor counter delay; test for dec -> bpl 
                    db       SHIELD_MINOR_INCREASE_DEFAULT ; 0 shield minor speed increase 
                    db       1;INITIAL_SHIELD_WIDTH_ADDER   ; 1 1-4 shield width adder 
                    db       INITIAL_SHOT_MOVE_DELAY      ;1 shot move delay ; test for dec -> bpl 
                    db       INITIAL_SHOT_MOVE_STRENGTH   ;1 shot move strength 
                    db       INITIAL_X_MOVE_DELAY         ;1 x move delay ; test for dec -> bpl 
                    db       INITIAL_X_MOVE_STRENGTH      ;1 x move strength 
                    db       3;INITIAL_HX_MOVE_DELAY         ;1 x move delay ; test for dec -> bpl 
                    db       INITIAL_HX_MOVE_STRENGTH      ;1 x move strength 
                    db       INITIAL_HUNTER_MOVE_DELAY    ;0 hunter move delay ; test for dec -> bpl 
                    db       INITIAL_HUNTER_MOVE_STRENGTH ;1 hunter move strength 
                    db       INITIAL_BOMBER_MOVE_DELAY    ;1 bomber move delay ; test for dec -> bpl 
                    db       INITIAL_BOMBER_MOVE_STRENGTH ;1 bomber move strength 
                    db       INITIAL_BOMBER_SHOT_DELAY    ; first shot can also be shorter timed than minimum 200 bomber shot delay ; test for dec -> bpl, decreased by 25 every shot down to 50 (50 = 1 s) 
                    db       8;INITIAL_DRAGON_MOVE_DELAY    ;5 (scale) dragon inner move delay; test for dec -> bpl 
 dw INITIAL_DRAGON_MOVE_STRENGTH;2 Dragon_angle add ANGLES must be *2 since angles go up to 720
 db 1;INITIAL_DRAGON_ANGLE_DELAY; 0 angle delay
                    db       DRAGON_CHILD_FREE_SPEED      ;1 dragonchild (free) speed; update per tick 
                    db       DEFAULT_MINIMUM_BOMB_RELOAD_DELAY ; 50 
                    db       INITIAL_BONUS_MOVE_DELAY     ; 3 x move delay ; test for dec -> bpl 
                    db       INITIAL_BONUS_MOVE_STRENGTH  ; 1 x move strength 
                    db       DEFAULT_BONUS_ACTIVE_TIME    ; 30 in seconds 
 db INITIAL_SPAWN_RESET_TIMER ; phase_spawn_reset -1 == stay unchanged INITIAL_SPAWN_RESET_TIMER
 db INITIAL_SPAWN_INCREASE_DELAY; phase_spawn_increase_delay -1 == stay unchanged INITIAL_SPAWN_INCREASE_DELAY
 db FASTEST_SPAWN_RATE; phase_min_spawn_reset -1 == stay unchanged FASTEST_SPAWN_RATE
 db MAXIMUM_RESET_INCREASE_SLOWDOWN; phase_max_spawn_increase_delay -1 == stay unchanged MAXIMUM_RESET_INCREASE_SLOWDOWN
                    dw       50                          ; next phase after 20 spawns 

; minor shield speed increase
; hidden same as x
; bomber shoots fast - but long reload
phase2: 
                    db       DEFAULT_ALL_SPAWN            ; spawn types allowed 
                    db       SHIELD_WIDTH_GROWTH_DEFAULT  ;4 2 up , ec -> bpl than width grow 
                    db       SHIELD_DEFAULT_SPEED         ;2 shield major speed ; update every tick, must be in sum greater than minor increase 
                    db       3                            ; shield minor counter delay; test for dec -> bpl 
                    db       1                            ; 0 shield minor speed increase 
                    db       INITIAL_SHIELD_WIDTH_ADDER   ; 1 1-4 shield width adder 
                    db       INITIAL_SHOT_MOVE_DELAY      ;0 shot move delay ; test for dec -> bpl 
                    db       INITIAL_SHOT_MOVE_STRENGTH   ;0 shot move strength 
                    db       INITIAL_X_MOVE_DELAY         ;1 x move delay ; test for dec -> bpl 
                    db       INITIAL_X_MOVE_STRENGTH      ;1 x move strength 
                    db       2;INITIAL_HX_MOVE_DELAY         ;1 x move delay ; test for dec -> bpl 
                    db       INITIAL_HX_MOVE_STRENGTH      ;1 x move strength 
                    db       INITIAL_HUNTER_MOVE_DELAY    ;0 hunter move delay ; test for dec -> bpl 
                    db       INITIAL_HUNTER_MOVE_STRENGTH ;1 hunter move strength 
                    db       INITIAL_BOMBER_MOVE_DELAY    ;1 bomber move delay ; test for dec -> bpl 
                    db       INITIAL_BOMBER_MOVE_STRENGTH ;1 bomber move strength 
                    db       20; INITIAL_BOMBER_SHOT_DELAY    ; 200 bomber shot delay ; test for dec -> bpl, decreased by 25 every shot down to 50 (50 = 1 s) 
                    db       INITIAL_DRAGON_MOVE_DELAY    ;5 dragon inner move delay; test for dec -> bpl 
 dw INITIAL_DRAGON_MOVE_STRENGTH;2 Dragon_angle add ANGLES must be *2 since angles go up to 720
 db INITIAL_DRAGON_ANGLE_DELAY; 0 angle delay
                    db       DRAGON_CHILD_FREE_SPEED      ;2 dragonchild (free) speed; update per tick 
                    db       200;DEFAULT_MINIMUM_BOMB_RELOAD_DELAY 
                    db       INITIAL_BONUS_MOVE_DELAY     ; 3 
                    db       INITIAL_BONUS_MOVE_STRENGTH  ; 1 
                    db       DEFAULT_BONUS_ACTIVE_TIME    ; 9 
 db INITIAL_SPAWN_RESET_TIMER ; phase_spawn_reset -1 == stay unchanged INITIAL_SPAWN_RESET_TIMER
 db INITIAL_SPAWN_INCREASE_DELAY; phase_spawn_increase_delay -1 == stay unchanged INITIAL_SPAWN_INCREASE_DELAY
 db FASTEST_SPAWN_RATE; phase_min_spawn_reset -1 == stay unchanged FASTEST_SPAWN_RATE
 db MAXIMUM_RESET_INCREASE_SLOWDOWN; phase_max_spawn_increase_delay -1 == stay unchanged MAXIMUM_RESET_INCREASE_SLOWDOWN
                    dw       50 
phase3: 
                    db       DEFAULT_ALL_SPAWN            ; spawn types allowed 
                    db       SHIELD_WIDTH_GROWTH_DEFAULT  ;4 2 up , ec -> bpl than width grow 
                    db       SHIELD_DEFAULT_SPEED         ;2 shield major speed ; update every tick, must be in sum greater than minor increase 
                    db       2                            ; shield minor counter delay; test for dec -> bpl 
                    db       1                            ; 0 shield minor speed increase 
                    db       INITIAL_SHIELD_WIDTH_ADDER   ; 1 1-4 shield width adder 
                    db       INITIAL_SHOT_MOVE_DELAY      ;0 shot move delay ; test for dec -> bpl 
                    db       INITIAL_SHOT_MOVE_STRENGTH   ;0 shot move strength 
                    db       INITIAL_X_MOVE_DELAY         ;1 x move delay ; test for dec -> bpl 
                    db       INITIAL_X_MOVE_STRENGTH      ;1 x move strength 
                    db       INITIAL_HX_MOVE_DELAY         ;1 x move delay ; test for dec -> bpl 
                    db       INITIAL_HX_MOVE_STRENGTH      ;1 x move strength 
                    db       INITIAL_HUNTER_MOVE_DELAY    ;0 hunter move delay ; test for dec -> bpl 
                    db       INITIAL_HUNTER_MOVE_STRENGTH ;1 hunter move strength 
                    db       INITIAL_BOMBER_MOVE_DELAY    ;1 bomber move delay ; test for dec -> bpl 
                    db       INITIAL_BOMBER_MOVE_STRENGTH ;1 bomber move strength 
                    db       INITIAL_BOMBER_SHOT_DELAY    ; bomber shot delay ; test for dec -> bpl, decreased by 25 every shot down to 50 (50 = 1 s) 
                    db       INITIAL_DRAGON_MOVE_DELAY    ;5 dragon inner move delay; test for dec -> bpl 
 dw 4;INITIAL_DRAGON_MOVE_STRENGTH;2 Dragon_angle add ANGLES must be *2 since angles go up to 720
 db INITIAL_DRAGON_ANGLE_DELAY; 0 angle delay
                    db       DRAGON_CHILD_FREE_SPEED      ;2 dragonchild (free) speed; update per tick 
                    db       DEFAULT_MINIMUM_BOMB_RELOAD_DELAY 
                    db       INITIAL_BONUS_MOVE_DELAY     ; 3 
                    db       INITIAL_BONUS_MOVE_STRENGTH  ; 1 
                    db       DEFAULT_BONUS_ACTIVE_TIME    ; 9 
 db INITIAL_SPAWN_RESET_TIMER ; phase_spawn_reset -1 == stay unchanged INITIAL_SPAWN_RESET_TIMER
 db INITIAL_SPAWN_INCREASE_DELAY; phase_spawn_increase_delay -1 == stay unchanged INITIAL_SPAWN_INCREASE_DELAY
 db FASTEST_SPAWN_RATE; phase_min_spawn_reset -1 == stay unchanged FASTEST_SPAWN_RATE
 db MAXIMUM_RESET_INCREASE_SLOWDOWN; phase_max_spawn_increase_delay -1 == stay unchanged MAXIMUM_RESET_INCREASE_SLOWDOWN
; db 25;10 ; phase_spawn_reset -1 == stay unchanged
; db 1;0; phase_spawn_increase_delay -1 == stay unchanged
; db 25;5; CANON -1; phase_min_spawn_reset -1 == stay unchanged
; db 1;1; -1; phase_max_spawn_increase_delay -1 == stay unchanged
                    dw       50 
; spawning slow down!

phase4: 
                    db       DEFAULT_ALL_SPAWN            ; spawn types allowed 
                    db       3                            ;4 2 up , ec -> bpl than width grow 
                    db       3                            ;2 shield major speed ; update every tick, must be in sum greater than minor increase 
                    db       20                           ; shield minor counter delay; test for dec -> bpl 
                    db       0                            ; 0 shield minor speed increase 
                    db       2                            ;INITIAL_SHIELD_WIDTH_ADDER ; 1 1-4 shield width adder 
                    db       INITIAL_SHOT_MOVE_DELAY      ;0 shot move delay ; test for dec -> bpl 
                    db       INITIAL_SHOT_MOVE_STRENGTH   ;0 shot move strength 
                    db       INITIAL_X_MOVE_DELAY         ;1 x move delay ; test for dec -> bpl 
                    db       INITIAL_X_MOVE_STRENGTH      ;1 x move strength 
                    db       INITIAL_HX_MOVE_DELAY         ;1 x move delay ; test for dec -> bpl 
                    db       INITIAL_HX_MOVE_STRENGTH      ;1 x move strength 
                    db       INITIAL_HUNTER_MOVE_DELAY    ;0 hunter move delay ; test for dec -> bpl 
                    db       1                            ;INITIAL_HUNTER_MOVE_STRENGTH ;1 hunter move strength 
                    db       INITIAL_BOMBER_MOVE_DELAY    ;1 bomber move delay ; test for dec -> bpl 
                    db       INITIAL_BOMBER_MOVE_STRENGTH ;1 bomber move strength 
                    db       25                           ; INITIAL_BOMBER_SHOT_DELAY ; 200 bomber shot delay ; test for dec -> bpl, decreased by 25 every shot down to 50 (50 = 1 s) 
                    db       INITIAL_DRAGON_MOVE_DELAY    ;5 dragon inner move delay; test for dec -> bpl 
 dw 4;INITIAL_DRAGON_MOVE_STRENGTH;2 Dragon_angle add ANGLES must be *2 since angles go up to 720
 db INITIAL_DRAGON_ANGLE_DELAY; 0 angle delay
                    db       DRAGON_CHILD_FREE_SPEED      ;2 dragonchild (free) speed; update per tick 
                    db       DEFAULT_MINIMUM_BOMB_RELOAD_DELAY 
                    db       INITIAL_BONUS_MOVE_DELAY     ; 3 
                    db       INITIAL_BONUS_MOVE_STRENGTH  ; 1 
                    db       DEFAULT_BONUS_ACTIVE_TIME    ; 9 
 db INITIAL_SPAWN_RESET_TIMER ; phase_spawn_reset -1 == stay unchanged INITIAL_SPAWN_RESET_TIMER
 db INITIAL_SPAWN_INCREASE_DELAY; phase_spawn_increase_delay -1 == stay unchanged INITIAL_SPAWN_INCREASE_DELAY
 db FASTEST_SPAWN_RATE; phase_min_spawn_reset -1 == stay unchanged FASTEST_SPAWN_RATE
 db MAXIMUM_RESET_INCREASE_SLOWDOWN; phase_max_spawn_increase_delay -1 == stay unchanged MAXIMUM_RESET_INCREASE_SLOWDOWN
                    dw       100 
phase5: 
                    db       DEFAULT_ALL_SPAWN            ; spawn types allowed 
                    db       3                            ;4 2 up , ec -> bpl than width grow 
                    db       3                            ;2 shield major speed ; update every tick, must be in sum greater than minor increase 
                    db       2                            ; shield minor counter delay; test for dec -> bpl 
                    db       1                            ; 0 shield minor speed increase 
                    db       2                            ;INITIAL_SHIELD_WIDTH_ADDER ; 1 1-4 shield width adder 
                    db       INITIAL_SHOT_MOVE_DELAY      ;0 shot move delay ; test for dec -> bpl 
                    db       INITIAL_SHOT_MOVE_STRENGTH   ;0 shot move strength 
                    db       INITIAL_X_MOVE_DELAY         ;1 x move delay ; test for dec -> bpl 
                    db       INITIAL_X_MOVE_STRENGTH      ;1 x move strength 
                    db       INITIAL_HX_MOVE_DELAY         ;1 x move delay ; test for dec -> bpl 
                    db       INITIAL_HX_MOVE_STRENGTH      ;1 x move strength 
                    db       INITIAL_HUNTER_MOVE_DELAY    ;0 hunter move delay ; test for dec -> bpl 
                    db       1                            ;INITIAL_HUNTER_MOVE_STRENGTH ;1 hunter move strength 
                    db       INITIAL_BOMBER_MOVE_DELAY    ;1 bomber move delay ; test for dec -> bpl 
                    db       INITIAL_BOMBER_MOVE_STRENGTH ;1 bomber move strength 
                    db       25                           ; INITIAL_BOMBER_SHOT_DELAY ; 200 bomber shot delay ; test for dec -> bpl, decreased by 25 every shot down to 50 (50 = 1 s) 
                    db       INITIAL_DRAGON_MOVE_DELAY    ;5 dragon inner move delay; test for dec -> bpl 
 dw 4;INITIAL_DRAGON_MOVE_STRENGTH;2 Dragon_angle add ANGLES must be *2 since angles go up to 720
 db INITIAL_DRAGON_ANGLE_DELAY; 0 angle delay
                    db       DRAGON_CHILD_FREE_SPEED      ;2 dragonchild (free) speed; update per tick 
                    db       DEFAULT_MINIMUM_BOMB_RELOAD_DELAY 
                    db       INITIAL_BONUS_MOVE_DELAY     ; 3 
                    db       INITIAL_BONUS_MOVE_STRENGTH  ; 1 
                    db       DEFAULT_BONUS_ACTIVE_TIME    ; 9 
 db 25;10 ; phase_spawn_reset -1 == stay unchanged
 db 1;0; phase_spawn_increase_delay -1 == stay unchanged
 db 25;5; CANON -1; phase_min_spawn_reset -1 == stay unchanged
 db 1;1; -1; phase_max_spawn_increase_delay -1 == stay unchanged
                    dw       100 

phase6: 
                    db       DEFAULT_ALL_SPAWN            ; spawn types allowed 
                    db       3                            ;4 2 up , ec -> bpl than width grow 
                    db       3                            ;2 shield major speed ; update every tick, must be in sum greater than minor increase 
                    db       1                            ; shield minor counter delay; test for dec -> bpl 
                    db       1                            ; 0 shield minor speed increase 
                    db       2                            ;INITIAL_SHIELD_WIDTH_ADDER ; 1 1-4 shield width adder 
                    db       3;INITIAL_SHOT_MOVE_DELAY      ;0 shot move delay ; test for dec -> bpl 
                    db       INITIAL_SHOT_MOVE_STRENGTH   ;0 shot move strength 
                    db       INITIAL_X_MOVE_DELAY         ;1 x move delay ; test for dec -> bpl 
                    db       INITIAL_X_MOVE_STRENGTH      ;1 x move strength 
                    db       INITIAL_HX_MOVE_DELAY         ;1 x move delay ; test for dec -> bpl 
                    db       INITIAL_HX_MOVE_STRENGTH      ;1 x move strength 
                    db       INITIAL_HUNTER_MOVE_DELAY    ;0 hunter move delay ; test for dec -> bpl 
                    db       2                            ;INITIAL_HUNTER_MOVE_STRENGTH ;1 hunter move strength 
                    db       0;INITIAL_BOMBER_MOVE_DELAY    ;1 bomber move delay ; test for dec -> bpl 
                    db       INITIAL_BOMBER_MOVE_STRENGTH ;1 bomber move strength 
                    db       25                           ; INITIAL_BOMBER_SHOT_DELAY ; 200 bomber shot delay ; test for dec -> bpl, decreased by 25 every shot down to 50 (50 = 1 s) 
                    db       4;INITIAL_DRAGON_MOVE_DELAY    ;5 dragon inner move delay; test for dec -> bpl 
 dw 4;INITIAL_DRAGON_MOVE_STRENGTH;2 Dragon_angle add ANGLES must be *2 since angles go up to 720
 db INITIAL_DRAGON_ANGLE_DELAY; 0 angle delay
                    db       DRAGON_CHILD_FREE_SPEED      ;2 dragonchild (free) speed; update per tick 
                    db       25; DEFAULT_MINIMUM_BOMB_RELOAD_DELAY 
                    db       INITIAL_BONUS_MOVE_DELAY     ; 3 
                    db       3;INITIAL_BONUS_MOVE_STRENGTH  ; 1 
                    db       DEFAULT_BONUS_ACTIVE_TIME    ; 9 
 db 50;10 ; phase_spawn_reset -1 == stay unchanged
 db 1;0; phase_spawn_increase_delay -1 == stay unchanged
 db 25;5; CANON -1; phase_min_spawn_reset -1 == stay unchanged
 db 10;1; -1; phase_max_spawn_increase_delay -1 == stay unchanged
                    dw       50 

phase7: 
                    db       DEFAULT_ALL_SPAWN            ; spawn types allowed 
                    db       3                            ;4 2 up , ec -> bpl than width grow 
                    db       3                            ;2 shield major speed ; update every tick, must be in sum greater than minor increase 
                    db       0                            ; shield minor counter delay; test for dec -> bpl 
                    db       1                            ; 0 shield minor speed increase 
                    db       2                            ;INITIAL_SHIELD_WIDTH_ADDER ; 1 1-4 shield width adder 
                    db       1;INITIAL_SHOT_MOVE_DELAY      ;0 shot move delay ; test for dec -> bpl 
                    db       INITIAL_SHOT_MOVE_STRENGTH   ;0 shot move strength 
                    db       INITIAL_X_MOVE_DELAY         ;1 x move delay ; test for dec -> bpl 
                    db       INITIAL_X_MOVE_STRENGTH      ;1 x move strength 
                    db       INITIAL_HX_MOVE_DELAY         ;1 x move delay ; test for dec -> bpl 
                    db       INITIAL_HX_MOVE_STRENGTH      ;1 x move strength 
                    db       INITIAL_HUNTER_MOVE_DELAY    ;0 hunter move delay ; test for dec -> bpl 
                    db       2                            ;INITIAL_HUNTER_MOVE_STRENGTH ;1 hunter move strength 
                    db       0;INITIAL_BOMBER_MOVE_DELAY    ;1 bomber move delay ; test for dec -> bpl 
                    db       INITIAL_BOMBER_MOVE_STRENGTH ;1 bomber move strength 
                    db       25                           ; INITIAL_BOMBER_SHOT_DELAY ; 200 bomber shot delay ; test for dec -> bpl, decreased by 25 every shot down to 50 (50 = 1 s) 
                    db       4;INITIAL_DRAGON_MOVE_DELAY    ;5 dragon inner move delay; test for dec -> bpl 
 dw 4;INITIAL_DRAGON_MOVE_STRENGTH;2 Dragon_angle add ANGLES must be *2 since angles go up to 720
 db INITIAL_DRAGON_ANGLE_DELAY; 0 angle delay
                    db       DRAGON_CHILD_FREE_SPEED      ;2 dragonchild (free) speed; update per tick 
                    db       25; DEFAULT_MINIMUM_BOMB_RELOAD_DELAY 
                    db       INITIAL_BONUS_MOVE_DELAY     ; 3 
                    db       3;INITIAL_BONUS_MOVE_STRENGTH  ; 1 
                    db       DEFAULT_BONUS_ACTIVE_TIME    ; 9 
 db -1;10 ; phase_spawn_reset -1 == stay unchanged
 db -1;0; phase_spawn_increase_delay -1 == stay unchanged
 db -1;5; CANON -1; phase_min_spawn_reset -1 == stay unchanged
 db -1;1; -1; phase_max_spawn_increase_delay -1 == stay unchanged
                    dw       100 

phase8: 
                    db       DEFAULT_ALL_SPAWN            ; spawn types allowed 
                    db       3                            ;4 2 up , ec -> bpl than width grow 
                    db       3                            ;2 shield major speed ; update every tick, must be in sum greater than minor increase 
                    db       1                            ; shield minor counter delay; test for dec -> bpl 
                    db       3                            ; 0 shield minor speed increase 
                    db       3                            ;INITIAL_SHIELD_WIDTH_ADDER ; 1 1-4 shield width adder 
                    db       0;INITIAL_SHOT_MOVE_DELAY      ;0 shot move delay ; test for dec -> bpl 
                    db       2;INITIAL_SHOT_MOVE_STRENGTH   ;0 shot move strength 
                    db       0;INITIAL_X_MOVE_DELAY         ;1 x move delay ; test for dec -> bpl 
                    db       1;INITIAL_X_MOVE_STRENGTH      ;1 x move strength 
                    db       INITIAL_HX_MOVE_DELAY         ;1 x move delay ; test for dec -> bpl 
                    db       INITIAL_HX_MOVE_STRENGTH      ;1 x move strength 
                    db       INITIAL_HUNTER_MOVE_DELAY    ;0 hunter move delay ; test for dec -> bpl 
                    db       2                            ;INITIAL_HUNTER_MOVE_STRENGTH ;1 hunter move strength 
                    db       0;INITIAL_BOMBER_MOVE_DELAY    ;1 bomber move delay ; test for dec -> bpl 
                    db       2;INITIAL_BOMBER_MOVE_STRENGTH ;1 bomber move strength 
                    db       40                           ; INITIAL_BOMBER_SHOT_DELAY ; 200 bomber shot delay ; test for dec -> bpl, decreased by 25 every shot down to 50 (50 = 1 s) 
                    db       1;INITIAL_DRAGON_MOVE_DELAY    ;5 dragon inner move delay; test for dec -> bpl 
 dw 6;INITIAL_DRAGON_MOVE_STRENGTH;2 Dragon_angle add ANGLES must be *2 since angles go up to 720
 db INITIAL_DRAGON_ANGLE_DELAY; 0 angle delay
                    db       3;DRAGON_CHILD_FREE_SPEED      ;2 dragonchild (free) speed; update per tick 
                    db       10; DEFAULT_MINIMUM_BOMB_RELOAD_DELAY 
                    db       INITIAL_BONUS_MOVE_DELAY     ; 3 
                    db       3;INITIAL_BONUS_MOVE_STRENGTH  ; 1 
                    db       DEFAULT_BONUS_ACTIVE_TIME    ; 9 
 db 50;10 ; phase_spawn_reset -1 == stay unchanged
 db 1;0; phase_spawn_increase_delay -1 == stay unchanged
 db 15;5; CANON -1; phase_min_spawn_reset -1 == stay unchanged
 db 20;1; -1; phase_max_spawn_increase_delay -1 == stay unchanged
                    dw       0 
