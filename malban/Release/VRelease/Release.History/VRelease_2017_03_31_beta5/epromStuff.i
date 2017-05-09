; this file is part of Karl Quappe, written by Malban in 2016
;
; Most parts were written by:
;
;   2016 Thomas G. Sontowski:
;   based on Alex Herbert's ds2430 driver
;
; if 32 byte save is enabled only a dirty "translation" of bigger data is done, much redundancy!
;***************************************************************************
                    include  "ds2431LowLevel.i"
                    include  "ds2431HighLevel.i"
;***************************************************************************
;;;;;;;;;;;;;
EEPROM_CHECKSUM     equ      $87                          ; any value other than $00 or $e0 
EEPROM_STORESIZE_HS  equ     32                           ;32 only 31 bytes must be used, last byte is always a generated checksum 
EEPROM_STORESIZE_OPTIONS  equ  8                          ;8 only 7 bytes must be used, last byte is always a generated checksum 
EEPROM_OPTION_BLOCK  EQU     0 
EEPROM_HS1_BLOCK    EQU      8 
;;;;;;;;;;;;;
resetEprom 
                    jsr      copyDefaultsToRAM 
                    tst      ignoreDs2431 
                    bne      noDevice1 
                    tst      ds2431Present 
                    beq      noDSDevice 
                    ldd      #(EEPROM_STORESIZE_OPTIONS*256)+EEPROM_OPTION_BLOCK 
                    std      current_eprom_blocksize 
                    ldx      #optionsBlock 
                    bSR      eeprom_save_options 
                    ldd      #(EEPROM_STORESIZE_HS*256)+EEPROM_HS1_BLOCK 
                    std      current_eprom_blocksize 
                    ldx      #highScoreBlock 
                    bSR      eeprom_save_highscore 

noDSDevice 
                    tst      v4ecartflags 
                    bpl      noDevice1 
 jsr  ensureBank1
                    jmp      store_score 

noDevice1 
 jsr  ensureBank1
                    rts      

cleanStart 
 jsr  ensureBank1
                    jmp      copyDefaultsToRAM 

;***************************************************************************
checkEprom 
                    tst      ignoreDs2431 
                    bne      cleanStart 
                    clr      ds2431Present 
                    jsr      ds1w_open                    ; open 1-wire port 
                    jsr      ds1w_reset                   ; reset device 
                    ;tsta     
                    bne      notPresent 
                    inc      ds2431Present 
notPresent 
                    jsr      ds1w_close                   ; close port 
 jmp ensureBank1

;***************************************************************************
; current_eprom_blocksize = blocksize
; current_eprom_blockadr = block address in eeprom
; x = address to save
eeprom_save_highscore 
;                    tfr      x,y 
;                    bsr      toNewEeprom 
;                    ldx      #newEepromRAMStart 
eeprom_save_options 
                    ldb      #$d0 
                    tfr      b,dp 
                    direct   $D0 
                    ldb      current_eprom_blocksize 
                    decb     
                    tst      ignoreDs2431 
                    bne      noDevice1 
                    tst      v4ecartflags 
                    bpl      eepromSave_1 
 jsr ensureBank1
                    bra      store_score 

eepromSave_1 
                    pshs     x 
                    lda      #(EEPROM_CHECKSUM)           ;<<8)+(EEPROM_STORESIZE-1) ; 
eesave_loop                                               ;        
                    suba     ,x+                          ; create checksum byte 
                    decb                                  ; 
                    bne      eesave_loop                  ; 
                    sta      ,x                           ; 
                    puls     x 
                    lbsr     ds2431_verify                ; compare ram to eeprom 
                    tsta                                  ; 
                    lbne     ds2431_save                  ; if different, then update eeprom 
 jsr ensureBank1
                    rts      

;***************************************************************************
; current_eprom_blocksize = blocksize
; current_eprom_blockadr = block address in eeprom
; x = address to load To 

eeprom_load_highscore 
;                    stx      eeprom_tmp 
;                    ldx      #v4e_saveBlockStart
eeprom_load_option 
eeprom_load_1 
                    tst      ignoreDs2431 
                    bne      noDevice1 
 
                    tst      v4ecartflags 
                    bpl      eeprom_load_2
; COPY_VECROM_TO_RAM
                ldu #vec4SaveBuffer            ; Source copy the vec4ever switching function into place
                ldx #v4e_saveBlockStart ; destination
                lda #1+(v4e_saveBlockEnd-v4e_saveBlockStart)
                jmp Move_Mem_a
; rts
eeprom_load_2
                    jsr      ds2431_load                  ; load 32 byte eeprom to ram 
                    ldb      current_eprom_blocksize 
                    clra     
eeload_loop                                               ;        
                    adda     ,x+                          ; sum the bytes 
                    decb                                  ; 
                    bne      eeload_loop                  ; 
                    cmpa     #EEPROM_CHECKSUM             ; equal to checksum? 
                    lbne     resetEprom                   ; if not, then format the eeprom 
                    lda      current_eprom_blocksize 
                    cmpa     #8 
                    beq      doneEEL 
;                    ldx      eeprom_tmp 
;                    bsr      fromNewEeprom 
doneEEL 
 jsr ensureBank1
                    rts                                   ; otherwise, return 
;***************************************************************************

