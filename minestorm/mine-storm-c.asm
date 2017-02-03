;  *********************************************************
;  *********************************************************
;  ***                                                   ***
;  ***          G C E     === V E C T R E X ===          ***
;  ***                                                   ***
;  ***                     M I N E   S T O R M           ***
;  ***                                                   ***
;  *********************************************************
;  *********************************************************
;
;
;
;  C O M M E N T S
;  ---------------
;
;       MUST BE ASSEMBLED USING AVOCET 'ASM09'
;
;
;
;=============================================================================
;
;  REV     DATE     PROG     COMMENT(S)
;  ---     ----     ----     ----------
;
;   C    12/23/82   JJH      CORRECTED GAME LEVEL SEQUENCING PROBLEM
;                            LIMITED NUMBER OF MARKERS THAT CAN BE DISPLAYED
;                            MUST KILL MINE-LAYER DURING RESEEDING
;                            MODIFIED MINE FIELD MESSAGE FOR THREE DIGITS
;                                (REV. B & C CAUSED BY RUM CHANGES)
;
;   B    07/29/82   JJH      CORRECTED HIGH-SCORE PROBLEM
;
;   A    07/15/82   JJH      MODIFIED TO REFLECT 'RUM' REV. A CHANGES
;
;   -    05/16/82   RELEASE FROM WESTERN TECHNOLOGIES
;
;=============================================================================
;
;
;
;  'EXECUTIVE' EQUATES
;  ===================
;
;
REG0     equ     $C800            ;  SOUND GENERATOR (PSG) MIRROR IMAGE
REG2     equ     $C802            ;  .
;
TRIGGR   equ     $C80F            ;  COLLECTIVE SWITCH SETTINGS
KEY0     equ     $C812            ;  CONTROLLER #1 - SWITCH #0 (LEFT)
KEY1     equ     $C813            ;  .
KEY2     equ     $C814            ;  .
KEY3     equ     $C815            ;  .             - SWITCH #3 (RIGHT)
;
POT0     equ     $C81B            ;  JOYSTICK #1 - 'X' AXIS
POT1     equ     $C81C            ;  .           - 'Y' AXIS
;
EPOT0    equ     $C81F            ;  ENABLE POT READ
EPOT2    equ     $C821            ;  .
;
LIST     equ     $C823            ;  NUMBER OF VECTORS - 1
ZSKIP    equ     $C824            ;  SKIP INTEGRATOR ZEROING AND ACTIVE GROUND
FRAME    equ     $C826            ;  FRAME COUNTER
;
SIZRAS   equ     $C82A            ;  RASTER MESSAGE SIZE
LEG      equ     $C83B            ;  EXECUTIVE WORKING STORAGE
TSTAT    equ     $C856            ;  TUNE STATUS
;
PLAYRS   equ     $C879            ;  NUMBER OF PLAYERS IN GAME
OPTION   equ     $C87A            ;  GAME OPTION NUMBER
;
HISCOR   equ     $CBEB            ;  HIGH-SCORE
;
;
T1LOLC   equ     $D004            ;  TIMER #1 (LSB)
;
;
PWRUP    equ     $F000            ;  POWER-UP HANDLER
COLD0    equ     $F01C            ;  VECTREX RESTART ENTRY FOR MINE-STORM
INTALL   equ     $F18B            ;  COMPLETE INTIALIZATION
FRWAIT   equ     $F192            ;  WAIT FOR FRAME BOUNDARY
;
DPIO     equ     $F1AA            ;  SET DIRECT REGISTER
DPRAM    equ     $F1AF            ;  .
;
DBNCE    equ     $F1B4            ;  READ CONTROLLER BUTTONS
INPUT    equ     $F1BA            ;  .
JOYBIT   equ     $F1F8            ;  READ JOYSTICKS
;
WRREG    equ     $F256            ;  WRITE TO PSG
INTPSG   equ     $F272            ;  INITIALIZE SOUND GENERATOR
PSGLST   equ     $F27D            ;  SEND SOUND STRING TO PSG
REQOUT   equ     $F289            ;  SEND 'REQX' TO PSG AND MIRROR
;
INT3Q    equ     $F2A5            ;  SET INTENSITY
INTMAX   equ     $F2A9            ;  .
INTENS   equ     $F2AB            ;  .
;
DOTAB    equ     $F2C3            ;  DRAW ONE DOT FROM THE CONTENTS OF 'A' & 'B'
DIFDOT   equ     $F2D5            ;  DRAW DOTS ACCORDING TO 'DIFFY' FORMAT
;
DEFLOK   equ     $F2E6            ;  OVER-COME SCAN COLLAPSE CIRCUITRY
POSWID   equ     $F2F2            ;  POSITION RELATIVE VECTOR
POSITD   equ     $F2FC            ;  .
POSITN   equ     $F312            ;  .
ZERGND   equ     $F354            ;  ZERO INTEGRATORS AND SET ACTIVE GROUND
RSTSIZ   equ     $F373            ;  DISPLAY RASTER MESSAGE
;
TPACK    equ     $F40E            ;  DRAW FROM 'PACKET' STYLE LIST
PACKET   equ     $F410            ;  .
RASTER   equ     $F495            ;  DISPLAY RASTER STRING
;
RANDOM   equ     $F517            ;  CALCULATE RANDOM NUMBER
BCLR     equ     $F53F            ;  CLEAR MEMORY BLOCK
CMPASS   equ     $F593            ;  DETERMINE ANGLE FROM DELTA 'Y:X'
LNROT    equ     $F601            ;  SINGLE LINE ROTATE
PROT     equ     $F61F            ;  'PACKET' STYLE ROTATE
;
REPLAY   equ     $F687            ;  SET 'REQX' FOR GIVEN TUNE
SPLAY    equ     $F68D            ;  .
;
SELOPT   equ     $F7A9            ;  FETCH GAME OPTIONS
;
SCLR     equ     $F84F            ;  CLEAR INDICATED SCORE
SCRADD   equ     $F87C            ;  ADD CONTENTS OF 'D' TO INDICATED SCORE
HISCR    equ     $F8D8            ;  CALCULATE HIGH SCORE AND SAVE FOR LOGO
BXTEST   equ     $F8FF            ;  SYMMETRIC COLLISION TEST
;
VIBENL   equ     $FEB6
;
;
;
;
;  ***************************************
;  ***************************************
;  ***                                 ***
;  ***          E Q U A T E S          ***
;  ***                                 ***
;  ***************************************
;  ***************************************
;
;
RATE     equ     50               ;  FRAME RATE (HERTZ)
;
;
THYPER   equ     $20              ;  HYPER-SPACE TIME
;
BULLETS  equ     4                ;  NUMBER OF BULLETS
MINES    equ     28               ;  NUMBER OF MINES
;
;
PSCOR1   equ     $7FA0            ;  POSITION OF PLAYER #1 SCORE
PSCOR2   equ     $7F10            ;  POSITION OF PLAYER #2 SCORE
;
;
P_SHPSZ  equ     $0C              ;  INITIAL STAR-SWEEPER SIZE
;
P_LYRSZ  equ     $08              ;  INITIAL MINE-LAYER SIZE
P_LYRSP  equ     $10              ;  MINE-LAYER SPEED OFFSET
P_LYRBX  equ     $0616            ;  MINE-LAYER COLLISION BOX
;
;
MIN_SIZ1 equ     $10              ;  MINE #1 (LARGE) SIZE
MIN_SIZ2 equ     $07              ;  MINE #2
MIN_SIZ3 equ     $02              ;  MINE #3 (SMALLEST)
;
MIN_SPD1 equ     $10              ;  MINE #1 (LARGE) SPEED
MIN_SPD2 equ     $18              ;  MINE #2
MIN_SPD3 equ     $20              ;  MINE #3 (SMALLEST)
;
MIN_BOX1 equ     $0D0D            ;  MINE #1 (LARGE) COLLISION BOX
MIN_BOX2 equ     $0808            ;  MINE #2
MIN_BOX3 equ     $0404            ;  MINE #3 (SMALLEST)
;
M_DUMB   equ     $00              ;  'DUMB' MINE FLAG
M_MAG    equ     $01              ;  'MAGNETIC' MINE FLAG
M_FIRE   equ     $02              ;  'FIREBALL' MINE FLAG
M_MFIRE  equ     $03              ;  'MAGNETIC FIREBALL' MINE FLAG
FIRBALL  equ     $04              ;  'RELEASED' FIREBALL
;
;
S_ABRT   equ     KEY3             ;  TITLE PAGE ABORT
S_THRST  equ     KEY2             ;  THRUST SWITCH
S_FIRE   equ     KEY3             ;  FIRE SWITCH
S_HYPER  equ     KEY1             ;  HYPERSPACE SWITCH
;
;
;
;  *******************************************************
;  *******************************************************
;  ***                                                 ***
;  ***          W O R K I N G   S T O R A G E          ***
;  ***                                                 ***
;  *******************************************************
;  *******************************************************
;
;
         org     $C880
;        ===     =====
;
SBTN     db      0                ;  CONTROLLER DEBOUNCE FLAGS
SJOY     dw      0                ;  JOYSTICK 'BANG' FLAGS
;
;
ETMP1    db      0                ;  TEMPORARY WORKING STORAGE (FIRST LEVEL)
ETMP2    db      0                ;  .
ETMP3    db      0                ;  .
ETMP4    db      0                ;  .
ETMP5    db      0                ;  .
ETMP6    db      0                ;  .
ETMP7    db      0                ;  .
ETMP8    db      0                ;  .
ETMP9    db      0                ;  .
ETMP10   db      0                ;  .
;
         dw      0                ;  .    WORKING STORAGE SLOP
;
TEMP1    db      0                ;  TEMPORARY WORKING STORAGE (SECOND LEVEL)
TEMP2    db      0                ;  .
TEMP3    db      0                ;  .
TEMP4    db      0                ;  .
TEMP5    db      0                ;  .
TEMP6    db      0                ;  .
TEMP7    db      0                ;  .
TEMP8    db      0                ;  .
TEMP9    db      0                ;  .
TEMP10   db      0                ;  .
;
         dw      0                ;  .    WORKING STORAGE SLOP
;
;
ACTPLY   db      0                ;  ACTIVE PLAYER FLAG ($00 / $02)
;
;
TMR1     db      0                ;  TIMER #1 - DOWN COUNTER
         dw      0                ;  .        - TIME-OUT ROUTINE POINTER
;
TMR2     db      0                ;  TIMER #2 - DOWN COUNTER
         dw      0                ;  .        - TIME-OUT ROUTINE POINTER
;
TMR3     db      0                ;  TIMER #3 - DOWN COUNTER
         dw      0                ;  .        - TIME-OUT ROUTINE POINTER
;
TMR4     db      0                ;  TIMER #4 - DOWN COUNTER
         dw      0                ;  .        - TIME-OUT ROUTINE POINTER
;
;
SCOR1    ds      7                ;  PLAYER #1 SCORE
SCOR2    ds      7                ;  PLAYER #2 SCORE
;
;
BLTSND   db      0                ;  BULLET SOUND FLAG
;
;
STAR1    db      0                ;  TEMPORARY WORKING STORAGE (THIRD LEVEL)
STAR2    db      0                ;  .
STAR3    db      0                ;  .
STAR4    db      0                ;  .
STAR5    db      0                ;  .
STAR6    db      0                ;  .
;
ABORT    db      0                ;  GAME ABORT FLAG
LOCK     db      0                ;  LOCK-UP ON GAME SEQUENCE
;
RSMINES  db      0                ;  MINE-LAYER RE-SEED MINE COUNT
RESEED   db      0                ;  MINE-LAYER RESEED FLAG
FRCTIME  db      0                ;  FORCED GROWTH COUNTER
;
MINTABLE dw      0                ;  MINE FIELD POINTER FOR LAYER SEQUENCE
TBLPTR1  dw      0                ;  MINE FIELD POINTER FOR PLAYER #1
TBLPTR2  dw      0                ;  MINE FIELD POINTER FOR PLAYER #2
;
WSHIPY   dw      0                ;  WORKING 'Y' POSITION
WSHIPX   dw      0                ;  WORKING 'X' POSITION
DSHIPY1  dw      0                ;  'Y' DISPLACEMENT FOR MOMENTUM AXIS #1
DSHIPX1  dw      0                ;  'X' DISPLACEMENT FOR MOMENTUM AXIS #1
DSHIPY2  dw      0                ;  'Y' DISPLACEMENT FOR MOMENTUM AXIS #2
DSHIPX2  dw      0                ;  'X' DISPLACEMENT FOR MOMENTUM AXIS #2
SHIPROT  db      0                ;  CURRENT SHIP ROTATION
SHIPSPD1 db      0                ;  SPEED ALONG MOMENTUM AXIS #1
SHIPDIR1 db      0                ;  DIRECTION OF MOMENTUM AXIS #1
SHIPSPD2 db      0                ;  SPEED ALONG MOMENTUM AXIS #2
SHIPDIR2 db      0                ;  DIRECTION OF MOMENTUM AXIS #2
SHIPCNT  db      0                ;  CURRENT SHIP COUNT FOR ACTIVE PLAYER
SHIPCNT0 db      0                ;  CURRENT SHIP COUNT FOR PLAYER #1
SHIPCNT1 db      0                ;  CURRENT SHIP COUNT FOR PLAYER #2
;
LAYRYX   dw      0                ;  CURRENT MINE-LAYER POSITION (Y:X)
WLAYRY   dw      0                ;  .    WORKING 'Y' POSITION
WLAYRX   dw      0                ;  .    WORKING 'X' POSITION
DLAYRY   dw      0                ;  .    'Y' DISPLACEMENT
DLAYRX   dw      0                ;  .    'X' DISPLACEMENT
LAYRDIR  db      0                ;  CURRENT MINE-LAYER DIRECTION
LAYRSPD  db      0                ;  CURRENT MINE-LAYER SPEED
LAYRPTR  dw      0                ;  MINE-LAYER RE-SEEDING SEQUENCE POINTER
;
CBULLET  db      0                ;  ACTIVE BULLET COUNTER
CMINES   db      0                ;  ACTIVE MINE COUNTER
CEXPLS   db      0                ;  ACTIVE EXPLOSION COUNTER
;
MINMAX   db      0                ;  MAXIMUM MINES COUNT
;
HYPFLAG  db      0                ;  HYPER-SPACE FLAG
HYPCNT   db      0                ;  HYPER-SPACE SEQUENCE COUNTER
;
TIMEOUT  dw      0                ;  LONG TIME-OUT DELAY
;
THRSND   db      0                ;  THRUSTER SOUND FLAG
EXPLSND  db      0                ;  OBJECT EXPLOSION SOUND FLAG
POPSND   db      0                ;  MINE 'POP' SOUND FLAG
FIRSND   db      0                ;  'RELEASED' FIRE-BALL SOUND FLAG
HYPSND   db      0                ;  HYPER-SPACE SOUND FLAG
;
SEXPCNT  db      0                ;  SHIP EXPLOSION COUNTERS
SEXP1    db      0                ;  .
;
MNLVL1   ds      7                ;  ACTIVE MINE-FIELD LEVEL FOR PLAYER #1
MNLVL2   ds      7                ;  ACTIVE MINE-FIELD LEVEL FOR PLAYER #2;
;
;        BULLET TABLE
;        ------------
;
DBLTY    dw      0                ;  'Y' DISPLACEMENT FOR ALL NEW BULLETS
DBLTX    dw      0                ;  'X' DISPLACMENET FOR ALL NEW BULLETS
;
;
BLT_FLG  equ     0                ;  BULLET FLAG
BLT_YD   equ     BLT_FLG + 1      ;  WORKING 'Y' DISPLACEMENT
BLT_XD   equ     BLT_YD + 2       ;  WORKING 'X' DISPLACEMENT
BLT_WY   equ     BLT_XD + 2       ;  WORKING 'Y' POSITION
BLT_WX   equ     BLT_WY + 2       ;  WORKING 'X' POSITION
BLT_DC   equ     BLT_WX + 2       ;  BULLET DOWN-COUNTER
;
BLT_LEN  equ     BLT_DC + 1       ;  BULLET TABLE LENGTH
;
BLT_TBL  ds      BLT_LEN * BULLETS
;
;      
;        MINE TABLE
;        ----------
;
MIN_FLG  equ     0                ;  MINE FLAG
MIN_PAK  equ     MIN_FLG + 1      ;  PACKET TYPE (NUMBER)
MIN_SIZ  equ     MIN_PAK + 1      ;  SIZE (ZOOM VALUE)
MIN_BSZ  equ     MIN_SIZ + 1      ;  BASE MINE SIZE (0 - 3)
MIN_YW   equ     MIN_BSZ + 1      ;  WORKING 'Y' POSITION
MIN_XW   equ     MIN_YW + 2       ;  WORKING 'X' POSITION
MIN_YD   equ     MIN_XW + 2       ;  WORKING 'Y' DISPLACEMENT
MIN_XD   equ     MIN_YD + 2       ;  WORKING 'X' DISPLACEMENT
MIN_BOX  equ     MIN_XD + 2       ;  COLLISION BOX PARAMETERS
MIN_SCR  equ     MIN_BOX + 2      ;  SCORE VALUE
MIN_T1   equ     MIN_SCR + 2      ;  MINE TEMPORARY WORKING STORAGE
MIN_T2   equ     MIN_T1 + 1       ;  .
;
MIN_LEN  equ     MIN_T2 + 1       ;  MINE TABLE LENGTH
;
MIN_TBL  ds      MIN_LEN * MINES  
;
;
;        EXPLOSION TABLE
;        ---------------
;
EXP_FLG  equ     0                ;  EXPLOSION FLAG
EXP_SIZ  equ     EXP_FLG + 1      ;  SIZE (ZOOM VALUE)
EXP_YX   equ     EXP_SIZ + 1      ;  ABSOLUTE Y:X POSITIONS
EXP_CNT  equ     EXP_YX + 2       ;  FRAME COUNTER
;
EXP_LEN  equ     EXP_CNT + 1      ;  EXPLOSION TABLE LENGTH
EXPLSN   equ     14               ;  NUMBER OF EXPLOSION ENTRIES
;
EXP_TBL  ds      EXP_LEN * EXPLSN
;
;
;        STAR FIELD TABLES
;        -----------------
;
FSTAR    ds      16
ZSTAR    ds      8
;
;
;
;==========================================================================JJH
;PACKET1 ds      30               ;  CODE DELETED - REV. C CHANGES   ======JJH
;PACKET2 ds      30               ;  .                               ======JJH
;==========================================================================JJH
;
;==========================================================================JJH
PACKET1  ds      27               ;  CODE ADDED - REV. C CHANGES     ======JJH
PACKET2  ds      15               ;  .    PACKET WORKING AREA        ======JJH
;==========================================================================JJH
;
;==========================================================================JJH
MINTBL1  db      0                ;  MINE TABLE FOR PLAYER #1        ======JJH
         db      0                ;  .    CODE ADDED -               ======JJH
         db      0                ;  .        REV. C CHANGES         ======JJH
         db      0                ;  .                               ======JJH
;                                                                    ======JJH
;                                                                    ======JJH
MINTBL2  db      0                ;  MINE TABLE FOR PLAYER #2        ======JJH
         db      0                ;  .                               ======JJH
         db      0                ;  .                               ======JJH
         db      0                ;  .                               ======JJH
;==========================================================================JJH
;
ENDRAM   db      0                ;  END-OF-RAM FLAG
;
;
;
;  ***************************************************
;  ***************************************************
;  ***                                             ***
;  ***          R E S I D E N T   G A M E          ***
;  ***                                             ***
;  ***************************************************
;  ***************************************************
;
;
         org     $E000
;        ===     =====
;
         dw      LAYTUNE
;
         dw      $F850
         dw      $30E8
         db      'MINE',$80
;
         dw      $F850
         dw      $00DE
         db      'STORM',$80
         db      0
;
;
;
;
;  POWER-UP INITIALIZATION
;  =======================
;
        ;SETDP   $D0
;        =====   ===
;
ENTRY    ldx     #ETMP1           ;  CLEAR MEMORY
CLRALL   clr     ,x+               ;  .
         cmpx    #ENDRAM          ;  .
         bne     CLRALL           ;  .
;
         jsr     I_STARS          ;  INITIALIZE STAR FIELDS
;
;==========================================================================JJH
;        ldx     #HISCOR          ;  CODE DELETED - REV. B CHANGES   ======JJH
;        jsr     SCLR             ;  .                               ======JJH
;==========================================================================JJH
;
;==========================================================================JJH
;        NOP                      ;  CODE ADDED - REV. B CHANGES     ======JJH
;        NOP                      ;  CODE DELETED - REV. C CHANGES   ======JJH
;        NOP                      ;  .                               ======JJH
;        NOP                      ;  .                               ======JJH
;        NOP                      ;  .                               ======JJH
;        NOP                      ;  .                               ======JJH
;==========================================================================JJH
;
         inc     ZSKIP            ;  SET POST-PACKET ZEROING FLAG
;
         lda     #$BB             ;  SET-UP CONTROLLER FLAGS
         sta     SBTN             ;  .
         ldx     #$0101           ;  .
         stx     SJOY             ;  .
;
;
;  INITIALIZE MINE-SWEEPER
;  =======================
;
;
NEWGAME  ldx     #ETMP1           ;  CLEAR MEMORY
CLRMEM   clr     ,x+               ;  .
         cmpx    #FSTAR - 1       ;  .
         bne     CLRMEM           ;  .
         bra     GAME1            ;  .
;
GAME1    jsr     DPRAM            ;  SET "DP" REGISTER FOR RAM
        ;SETDP   $C8              ;  .
;
         ldd     #$0200           ;  SELECT OPTIONS
         jsr     SELOPT           ;  .
         dec     <PLAYRS          ;  .
;
         clr     <TSTAT           ;  CLEAR TUNE FLAG
         clr     <ACTPLY          ;  CLEAR ACTIVE PLAYER FLAG
;
         ldx     #SCOR1           ;  CLEAR PLAYERS SCORE
         jsr     SCLR             ;  .
         ldx     #SCOR2           ;  .
         jsr     SCLR             ;  .
;
         ldx     #MNLVL1          ;  CLEAR ACTIVE MINE-FIELD COUNTER
         jsr     SCLR             ;  .    FOR PLAYER #1
         ldd     #$0001           ;  .    .
         jsr     SCRADD           ;  .    .
;
         ldx     #MNLVL2          ;  .    FOR PLAYER #2
         jsr     SCLR             ;  .    .
         ldd     #$0001           ;  .    .
         jsr     SCRADD           ;  .    .
;
;==========================================================================JJH
;        ldx     #MINTBL1         ;  CODE DELETED - REV. C CHANGES   ======JJH
;        stx     <TBLPTR1         ;  .                               ======JJH
;        stx     <TBLPTR2         ;  .                               ======JJH
;==========================================================================JJH
;
;==========================================================================JJH
         ldx     #MINTBL1         ;  CODE ADDED - REV. C CHANGES     ======JJH
         stx     <TBLPTR1         ;  .    SET-UP NEW MINE TABLES     ======JJH
         ldx     #MINTBL2         ;  .    .                          ======JJH
         stx     <TBLPTR2         ;  .    .                          ======JJH
         ldb     #$08             ;  .    CLEAR NEW MINE TABLES      ======JJH
         ldx     #MINTBL1         ;  .    .                          ======JJH
         jsr     BCLR             ;  .    .                          ======JJH
;==========================================================================JJH
;
         lda     #5               ;  SET SHIP COUNT
         sta     <SHIPCNT         ;  .
         sta     <SHIPCNT0        ;  .
         sta     <SHIPCNT1        ;  .
;
         bra     LVLN1            ;  LEVEL #1 ENTRY POINT IS DIFFERENT
;   
;
;  GAME LEVEL SEQUENCER
;  ====================
;
;
LEVELN   jsr     FALL             ;  FALL-THRU TO NEXT GAME LEVEL
;
         ldy     #TBLPTR1         ;  BUMP GAME DATA POINTER FOR ACTIVE PLAYER
         lda     <ACTPLY          ;  .
         ldx     a,y              ;  .
;
;==========================================================================JJH
;        LEAX    4,x              ;  CODE DELETED - REV. C CHANGES   ======JJH
;        stx     a,y              ;  .                               ======JJH
;==========================================================================JJH
;
;==========================================================================JJH
         jsr     REVC_0           ;  CODE ADDED - REV. C CHANGES     ======JJH
;==========================================================================JJH
;
         ldx     #PMNLVL          ;  BUMP ACTIVE MINE-FIELD COUNTER
         lda     <ACTPLY          ;  .    WHICH PLAYER IS ACTIVE ?
         ldx     a,x              ;  .    .
;
         lda     5,x              ;  .    BONUS SHIP ?
         anda    #$03             ;  .    .
         bne     LVLN01           ;  .    .
         inc     SHIPCNT          ;  .    .    BUMP SHIP COUNT FOR ACTIVE PLAYER
;
LVLN01   ldd     #$0001           ;  .    BUMP GAME LEVEL
         jsr     SCRADD           ;  .    .
;
LVLN1    jsr     SWPINT           ;  ENTRY FOR LEVEL RE-START
;
         ldx     #TBLPTR1         ;  .    SET-UP FOR NEXT GAME LEVEL
         lda     <ACTPLY          ;  .    .    WHICH PLAYER IS ACTIVE
         ldx     a,x              ;  .    .    .
;
;==========================================================================JJH
;        lda     0,x              ;  CODE DELETED - REV. C CHANGES   ======JJH
;        BMI     LVLN2            ;  .                               ======JJH
;==========================================================================JJH
;
         jsr     MINLAY           ;  INITIALIZE FOR GAME LEVEL
         bra     LVLN3            ;  .
;
LVLN2    ldd     <TIMEOUT         ;  LOCK-UP ON GAME SEQUENCE
         subd    #$0001           ;  .    TIME-OUT ON SEQUENCE ?
         std     <TIMEOUT         ;  .    .
         beq     LVLN21           ;  .    .
;
         pshs    dp               ;  .    DISPLAY BOTH PLAYERS SCORE
         jsr     DPIO             ;  .    .
         jsr     SCRBTH           ;  .    .
         ldu     #M_END           ;  .    DISPLAY 'GAME OVER' MESSAGE
         jsr     MESS             ;  .    .
         puls    dp               ;  .    .
;
;==========================================================================JJH
;        lda     <TRIGGR          ;  CODE DELETED - REV. B CHANGES   ======JJH
;        BEQ     LVLN3            ;  .                               ======JJH
;==========================================================================JJH
;
         ldx     #SCOR1           ;  ESCAPE FROM GAME LEVEL LOCK-UP
         ldu     #HISCOR          ;  .    IS PLAYER #1 SCORE HIGHEST ?
         jsr     HISCR            ;  .    .
;
         ldx     #SCOR2           ;  .    IS PLAYER #2 SCORE HIGHEST ?
         ldu     #HISCOR          ;  .    .
         jsr     HISCR            ;  .    .
;
;==========================================================================JJH
         lda     <TRIGGR          ;  CODE ADDED - REV. B CHANGES     ======JJH
         beq     LVLN3            ;  .                               ======JJH
;==========================================================================JJH
;
LVLN21   ldd     <TIMEOUT         ;  LOCK TIME-OUT ?
         lbne    NEWGAME          ;  .    START GAME OVER
;
;==========================================================================JJH
;        clr     $CBFE            ;  CODE DELETED - REV. B CHANGES   ======JJH
;        jmp     $F01C            ;  .                               ======JJH
;==========================================================================JJH
;
;==========================================================================JJH
         jmp     REVB_0           ;  CODE ADDED - REV. B CHANGES     ======JJH
         nop                      ;  .    FILLER                     ======JJH
         nop                      ;  .    .                          ======JJH
         nop                      ;  .    .                          ======JJH
;==========================================================================JJH
;
;
LVLN3    pshs    dp               ;  SAVE "DP" REGISTER
         jsr     WAIT             ;  WAIT FOR FRAME BOUNDARY
         jsr     GMINE            ;  HANDLE MINE GAME LOGIC
         jsr     GSHIP            ;  HANDLE SWEEPER GAME LOGIC
         jsr     GBULLET          ;  HANDLE BULLET GAME LOGIC
         jsr     MSHIP            ;  HANDLE MINE-LAYER GAME LOGIC
;
         puls    dp               ;  SET "DP" REGISTER TO RAM
        ;SETDP   $C8              ;  .
;
         jsr     CBULMIN          ;  HANDLE BULLET/MINE COLLISIONS
         jsr     CMINSHIP         ;  HANDLE SHIP/MINE COLLISIONS
         jsr     CSHPLYR          ;  HANDLE SHIP/LAYER COLLISIONS
         jsr     TAIL             ;  HANDLE TAIL-END LOGIC
         bcs     LVLN3            ;  .    MORE GAME LOGIC ?
;
         lda     <ABORT           ;  RESTART CURRENT GAME POSITION ?
         lbeq    LEVELN           ;  .    WAS GAME ABORTED ?
         lda     <LOCK            ;  .    .    LOCK-UP ON GAME SEQUENCE ?
         lbne    LVLN2            ;  .    .    .
         jmp     LVLN1            ;  .    .    RESTART GAME SEQUENCE
;
;
;  ***********************************************
;  ***********************************************
;  ***                                         ***
;  ***          S U B R O U T I N E S          ***
;  ***                                         ***
;  ***********************************************
;  ***********************************************
;
;
;
;  HANDLE MINE-LAYING SEQUENCE
;  ===========================
;
        ;SETDP   $C8
;        =====   ===
;
MINLAY   stx     <MINTABLE        ;  SET-UP FOR INITIAL MINE-LAYING
         ldd     #$7F00           ;  .    SET POSITION OF MINE-LAYER
         std     <LAYRYX          ;  .    .
         sta     <STAR1           ;  .    SET MINE-LAYER ZOOM VALUE
;
         lda     #$20             ;  SET MINE INSERTION TIME
         sta     <TMR1            ;  .
         ldx     #INSINT          ;  .
         stx     <TMR1+1          ;  .
         ldx     #MIN_TBL         ;  .    SET-UP FOR MINE INSERTION
         stx     <STAR3           ;  .    .    NEXT MINE TABLE ENTRY
         lda     #MINES + 1       ;  .    .    TOTAL MINES TO INSERT
         sta     <STAR2           ;  .    .    .
;
         clr     <TSTAT           ;  SET-UP FOR MINE-LAYING TUNE
         ldu     #LAYTUNE         ;  .
         jsr     SPLAY            ;  .
;
;
MNLY1    pshs    dp               ;  DEPOSIT INITIAL MINES
         jsr     STAIL            ;  .    DRAW EXPLOSIONS AND SHIP COUNTER
         jsr     REPLAY           ;  .    SET-UP FOR TUNE
;
         lda     <FRAME           ;  .    CHANGE ZOOM VALUE ?
         bita    #$01             ;  .    .
         bne     MNLY2            ;  .    .
         dec     <STAR1           ;  .    .    INCREMENT LAYER ZOOM VALUE
;
MNLY2    jsr     WAIT             ;  .    WAIT FOR FRAME BOUNDARY
        ;SETDP   $D0              ;  .    .
         jsr     SCRBTH           ;  .    DISPLAY BOTH PLAYER'S SCORES
         jsr     REQOUT           ;  .    PLAY LAYING TUNE
         jsr     GMINE            ;  .    HANDLE MINE GAME LOGIC
;
         jsr     INT3Q            ;  .    DISPLAY MINE-LAYER
         ldb     STAR1            ;  .    .    SKIP IF ZOOM VALUE IS ZERO
         beq     MNLY3            ;  .    .    .
         ldx     #LLAYR           ;  .    .    DRAW LEFT PACKET
         ldy     LAYRYX           ;  .    .    .
         jsr     APACK            ;  .    .    .
         ldx     #RLAYR           ;  .    .    DRAW RIGHT PACKET
         jsr     APACK            ;  .    .    .
         ldx     #MLAYR           ;  .    .    DRAW MIDDLE PACKET
         jsr     APACK            ;  .    .    .
;
         puls    dp               ;  .    .
        ;SETDP   $C8              ;  .    .
         dec     <LAYRYX          ;  .    .
         bra     MNLY1            ;  .    .
;
;
MNLY3    puls    dp               ;  GROW FOUR LARGE MINES
        ;SETDP   $C8              ;  .    .
;
         clr     <TMR1            ;  .
         lda     #$04             ;  .    SET MINE COUNT
         sta     <STAR1           ;  .    .
         lda     #$7F             ;  .    SET GROWING DELAY TIME
         sta     <STAR2           ;  .    .
;
MNLY4    lda     <STAR1           ;  .    START SEQUENTIAL MINE GROWTH
         beq     MNLY7            ;  .    .
;
         ldb     <STAR2           ;  .    .    GROWING DELAY TIME ?
         beq     MNLY5            ;  .    .    .
         dec     <STAR2           ;  .    .    .    DECREMENT DELAY TIMER
         bra     MNLY6            ;  .    .    .    SKIP MINE GROWTH
;
MNLY5    ldb     <FRAME           ;  .    .    ADJUST GROWTH-TO-GROWTH TIME
         andb    #$1F             ;  .    .    .
         bne     MNLY6            ;  .    .    .
;
         deca                     ;  .    GROW ONE LARGE MINE
         sta     <STAR1           ;  .    .    DECREMENT MINE COUNTER
;
         ldx     <MINTABLE        ;  .    .    SET SEED ENTRY FOR GROWTH
         lda     a,x              ;  .    .    .    SET MINE TYPE
         ldb     #$03             ;  .    .    .    SET MINE SIZE (LARGE)
         jsr     RANSEED          ;  .    .    .    FIND AND SET ENTRY
;
MNLY6    pshs    dp               ;  .    WAIT FOR FRAME BOUNDARY
         jsr     WAIT             ;  .    .
        ;SETDP   $D0              ;  .    .
;
         jsr     INTMAX           ;  .    DISPLAY ACTIVE MINE-FIELD MESSAGE
         ldu     #M_MNFLD         ;  .    .    DRAW MINE-FIELD MESSAGE
         jsr     MESS             ;  .    .    .
         ldy     #$E000           ;  .    .    DRAW MINE-FIELD COUNTER
         ldu     #PMNLVL          ;  .    .    .    FIND MESSAGE FOR ACTIVE PLAYER
         lda     ACTPLY           ;  .    .    .    .
         ldu     a,u              ;  .    .    .    .
         jsr     AMESS            ;  .    .    .
;
         jsr     GMINE            ;  .    HANDLE MINE GAME LOGIC
         jsr     GSHIP            ;  .    HANDLE SWEEPER GAME LOGIC
         jsr     GBULLET          ;  .    HANDLE BULLET GAME LOGIC
;
         puls    dp               ;  .    SET "DP" REGISTER TO RAM
        ;SETDP   $C8              ;  .    .
;
         jsr     CBULMIN          ;  .    HANDLE BULLET/MINE COLLISIONS
         jsr     TAIL             ;  .    HANDLE TAIL-END LOGIC
         bra     MNLY4            ;  .    .
;
MNLY7    rts                      ;  RETURN TO CALLER
;
;
;  INITIAL MINE INSERTION
;  ======================
;
;
INSINT  ;SETDP   $C8              ;  TIMER "DP" SET TO RAM
;
         dec     <STAR2           ;  END-OF-MINE INSERTION ?
         beq     INSINT9          ;  .
;
         inc     <MINMAX          ;  BUMP MINE-SEED COUNTER
;
         jsr     RANDOM           ;  RESET INSERTION TIME
         anda    #$07             ;  .
         adda    #$04             ;  .
         sta     <TMR1            ;  .
;
         ldu     <STAR3           ;  INSERT INITIAL MINE BEHAVIOR PARAMETERS
;
         lda     #$80             ;  .    SET MINE TO INITIAL LOCATION
         sta     MIN_FLG,u        ;  .    .
;
         ldd     <LAYRYX          ;  .    SET SEED RESTING LOCATION
         adda    #$08             ;  .    .    FUDGE MINE UP FOR LAYER OPENING
         sta     MIN_YW,u         ;  .    .    SET WORKING VALUES
         clr     MIN_YW+1,u       ;  .    .    .
         stb     MIN_XW,u         ;  .    .    .
         clr     MIN_XW+1,u       ;  .    .    .
;
INSINT0  jsr     RANDOM           ;  .    SET SEED DESTINATION LOCATION
         tsta                     ;  .    .    SET MINIMUM DISTANCE FROM CENTRE
         bmi     INSINT3          ;  .    .    .
;
INSINT1  cmpa    #$10             ;  .    .    .    'X' IS POSITIVE
         bge     INSINT2          ;  .    .    .    .    BELOW 'X' WINDOW ?
         adda    #$0C             ;  .    .    .    .    .    FUDGE IT UP
INSINT2  cmpa    #$60             ;  .    .    .    .    ABOVE 'X' WINDOW ?
         ble     INSINT5          ;  .    .    .    .    .    FUDGE IT DOWN
         bra     INSINT0          ;  .    .    .    .    .    .
;
INSINT3  cmpa    #$F0             ;  .    .    .    'X' IS NEGATIVE
         ble     INSINT4          ;  .    .    .    .    ABOVE 'X' WINDOW ?
         suba    #$0C             ;  .    .    .    .    .    FUDGE IT DOWN
INSINT4  cmpa    #$A0             ;  .    .    .    .    BELOW 'X' WINDOW ?
         bge     INSINT5          ;  .    .    .    .    .    FUDGE IT UP
         bra     INSINT0          ;  .    .    .    .    .    .
;
INSINT5  sta     MIN_T2,u         ;  .    .    .    .
;
         tfr     a,b              ;  .    SET DISPLACEMENT VALUE ($01 OR $FF)
         sex                      ;  .    .
         ora     #$01             ;  .    .
         sta     MIN_T1,u         ;  .    .
;
         clr     MIN_SIZ,u        ;  .    SET INITIAL ZOOM VALUE
;
         leay    MIN_LEN,u        ;  .    BUMP TO NEXT ENTRY
         sty     <STAR3           ;  .    .
;
INSINT9  rts                      ;  RETURN TO CALLER
;
;
MINSZ    db      0                ;  MINE SIZE TABLE
         db      MIN_SIZ3         ;  .    SMALL
         db      MIN_SIZ2         ;  .    MEDIUM
         db      MIN_SIZ1         ;  .    LARGE
;
MINSPD   db      0                ;  MINE SPEED TABLE
         db      MIN_SPD3         ;  .    SMALL
         db      MIN_SPD2         ;  .    MEDIUM
         db      MIN_SPD1         ;  .    LARGE
;
MINSCR   dw      $0100            ;  MINE SCORE TABLE
         dw      $0500            ;  .
         dw      $0325            ;  .
         dw      $0750            ;  .
;
MINSSCR  dw      0                ;  MINE SCORE VS. SPEED TABLE
         dw      $0100            ;  .    SMALL
         dw      $0035            ;  .    MEDIUM
         dw      $0000            ;  .    LARGE
;
MINBOX   dw      0                ;  MINE COLLISION BOX PARAMETERS
         dw      MIN_BOX3         ;  .
         dw      MIN_BOX2         ;  .
         dw      MIN_BOX1         ;  .
;
MINOBJ   dw      MINE1            ;  MINE PACKET TABLE
         dw      MINE2            ;  .
         dw      MINE3            ;  .
         dw      MINE4            ;  .
;
;
;  STAR-SWEEPER GAME LOGIC
;  =======================
;
;
GSHIP    pshs    dp               ;  SAVE ENTRY "DP"
         lda     #$C8             ;  SET "DP" REGISTER TO RAM
         tfr     a,dp             ;  .
        ;SETDP   $C8              ;  .
;
         lda     <ABORT           ;  GAME ABORTED ?
         lbne    SHPON2           ;  .    SKIP STAR-SWEEPER LOGIC
;
         lda     <HYPFLAG         ;  STATUS OF HYPER-SPACE SEQUENCE ?
         lbne    HYPER1           ;  .    HYPER-SPACE SEQUENCE GOING ALREADY
         lda     <S_HYPER         ;  .    HYPER-SPACE BUTTON PRESSED ?
         lbne    HYPER            ;  .    .
;
GSHP1    lda     <S_THRST         ;  THRUSTING ?
         beq     GSHP5            ;  .
;
         lda     <SHIPROT         ;  .    THRUSTING ALONG EXISTING AXIS ?
         cmpa    <SHIPDIR1        ;  .    .    ALONG FIRST AXIS ?
         beq     GSHP3            ;  .    .    .
         cmpa    <SHIPDIR2        ;  .    .    ALONG SECOND AXIS ?
         beq     GSHP2            ;  .    .    .
;
         lda     <SHIPSPD1        ;  .    WHICH AXIS IS FREE ?
         beq     GSHP3            ;  .    .    FIRST AXIS ?
         lda     <SHIPSPD2        ;  .    .    SECOND AXIS ?
         bne     GSHP5            ;  .    .    .
;
GSHP2    lda     <SHIPSPD2        ;  .    ACCELERATE SPEED ALONG AXIS #2
         adda    #$0C             ;  .    .
         cmpa    #$7F             ;  .    .    MAXIMUM SPEED ?
         bhi     GSHP5            ;  .    .    .
         sta     <SHIPSPD2        ;  .    .    SAVE NEW SPEED
         lda     <SHIPROT         ;  .    .    SET DIRECTION OF AXIS
         sta     <SHIPDIR2        ;  .    .    .
         bra     GSHP4            ;  .    .    SET THRUSTER SOUND
;
;
GSHP3    lda     <SHIPSPD1        ;  .    ACCELERATE SPEED ALONG AXIS #1
         adda    #$0C             ;  .    .
         cmpa    #$7F             ;  .    .    MAXIMUM SPEED ?
         bhi     GSHP5            ;  .    .    .
         sta     <SHIPSPD1        ;  .    .    SAVE NEW SPEED
         lda     <SHIPROT         ;  .    .    SET DIRECTION OF AXIS
         sta     <SHIPDIR1        ;  .    .    .
;
GSHP4    inc     THRSND           ;  .    .    SET THRUSTER SOUND
;
GSHP5    lda     <SHIPSPD1        ;  DECELERATE SPEED ALONG FIRST AXIS
         beq     GSHP6            ;  .
         suba    #$02             ;  .
         sta     <SHIPSPD1        ;  .
;
         ldb     <SHIPDIR1        ;  .    CALCULATE SHIP DISPLACEMENTS
         jsr     MLTY8            ;  .    .    FORM DISPLACEMENTS
         sty     <DSHIPY1         ;  .    .    .    SAVE 'Y' DISPLACEMENT
         stx     <DSHIPX1         ;  .    .    .    SAVE 'X' DISPLACEMENT
;
GSHP6    lda     <SHIPSPD2        ;  DECELERATE SPEED ALONG SECOND AXIS
         beq     GSHP7            ;  .
         suba    #$02             ;  .
         sta     <SHIPSPD2        ;  .
;
         ldb     <SHIPDIR2        ;  .    CALCULATE SHIP DISPLACEMENTS
         jsr     MLTY8            ;  .    .    FORM DISPLACEMENTS
         sty     <DSHIPY2         ;  .    .    .    SAVE 'Y' DISPLACEMENT
         stx     <DSHIPX2         ;  .    .    .    SAVE 'X' DISPLACEMENT
;
GSHP7    ldd     <WSHIPY          ;  MOVE SHIP 'Y' AXIS
         addd    <DSHIPY1         ;  .
         addd    <DSHIPY2         ;  .
         std     <WSHIPY          ;  .
;
         ldd     <WSHIPX          ;  MOVE SHIP 'X' AXIS
         addd    <DSHIPX1         ;  .
         addd    <DSHIPX2         ;  .
         std     <WSHIPX          ;  .
;
GSHP8    lda     <POT0            ;  ROTATE STAR-SWEEPER ?
         beq     SHPON1           ;  .    NO ROTATION ?
         bmi     GSHP9            ;  .    ROTATE LEFT ?
;
         dec     <SHIPROT         ;  .    ROTATE RIGHT
         bra     SHPON0           ;  .    .
;
GSHP9    inc     <SHIPROT         ;  .    ROTATE LEFT
         bra     SHPON0           ;  .    .
;
;
SHPONLY  pshs    dp               ;  SHIP-ONLY ENTRY POINT
;
SHPON0   jsr     SWPROT           ;  ROTATE STAR-SWEEPER
;
SHPON1   lda     #$D0             ;  SET "DP" REGISTER TO I/O
         tfr     a,dp             ;  .
        ;SETDP   $D0              ;  .
;
         jsr     INT3Q            ;  DISPLAY MINE-SWEEPER
         ldb     #P_SHPSZ         ;  .    SET SIZE
         ldy     #WSHIPY          ;  .    SET POSITION
         ldx     #PACKET1         ;  .    SET SHIP PACKET ADDRESS
         jsr     DPACK            ;  .    DRAW PACKET
;
SHPON2   puls    dp,pc            ;  RETURN TO CALLER
;
;
;  HYPER-SPACE SEQUENCE
;  ====================
;
        ;SETDP   $C8
;        =====   ===
;
HYPER    lda     #$80             ;  START HYPER-SPACE SEQUENCE
         sta     <HYPFLAG         ;  .    SET FLAG FOR RNG MIXING
         jsr     RANDOM           ;  .    SET COUNTER
         anda    #$03             ;  .    .
         adda    #$03             ;  .    .
         sta     <HYPCNT          ;  .    .
         inc     HYPSND           ;  .    SET HYPER-SPACE SOUND FLAG
;
HYPER1   lda     <HYPFLAG         ;  SELECT HYPER-SPACE SEQUENCE
         bpl     HYPER30          ;  .    WAITING FOR NEW LOCATION ?
;
HYPER20  dec     <HYPCNT          ;  WAIT FOR SHIP RE-APPERANCE
         beq     HYPER21          ;  .    SEQUENCE DONE ?
;
         jsr     RANPOS           ;  .    STIR-UP RANDOM NUMBER GENERATOR
         sta     <WSHIPY          ;  .    .
         clr     <WSHIPY + 1      ;  .    .
         stb     <WSHIPX          ;  .    .
         clr     <WSHIPX + 1      ;  .    .
         puls    dp,pc            ;  .    .
;
HYPER21  lsr     <HYPFLAG         ;  .    SET FLAG FOR NEXT SEQUENCE
         lda     #$1F             ;  .    .
         sta     <HYPCNT          ;  .    .
         puls    dp,pc            ;  .    .
;
;
HYPER30  ldb     <HYPCNT          ;  SHIP RE-APPERANCE
         cmpb    #$E0             ;  .
         ble     HYPER31          ;  .
         lda     <HYPCNT          ;  .
         suba    #$04             ;  .
         sta     <HYPCNT          ;  .
;
         clra                     ;  .    DRAW STAR FIELD
         jsr     H_STARS          ;  .    .
         puls    dp,pc            ;  .    .
;
HYPER31  clr     <HYPCNT          ;  HYPER-SPACE SEQUENCE DONE
         clr     <HYPFLAG         ;  .
         jsr     HSWPRST          ;  .    INITIALIZE SWEEPER PARAMETERS
;
         puls    dp,pc            ;  RETURN TO CALLER

;
;
;  MINE-LAYER GAME LOGIC
;  =======================
;
        ;SETDP   $D0
;        =====   ===
;
MSHIP    lda     LAYRSPD          ;  IS THE MINE-LAYER ON-SCREEN ?
         beq     MSHIP1           ;  .
;
         pshs    dp               ;  SAVE ENTRY "DP"
         lda     #$C8             ;  SET "DP" REGISTER TO RAM
         tfr     a,dp             ;  .
        ;SETDP   $C8              ;  .
;
;==========================================================================JJH
;        lda     <LAYRSPD         ;  CODE DELETED - REV. C CHANGES   ======JJH
;        BEQ     MSHIP1           ;  .                               ======JJH
;==========================================================================JJH
;
;==========================================================================JJH
         nop                      ;  CODE ADDED - REV. C CHANGES     ======JJH
         nop                      ;  .                               ======JJH
         nop                      ;  .                               ======JJH
         nop                      ;  .                               ======JJH
;==========================================================================JJH
;
         ldd     <WLAYRY          ;  MOVE SHIP 'Y' AXIS
         addd    <DLAYRY          ;  .
         std     <WLAYRY          ;  .
         sta     <LAYRYX          ;  .
;
         ldd     <WLAYRX          ;  MOVE SHIP 'X' AXIS
         addd    <DLAYRX          ;  .
         std     <WLAYRX          ;  .
         sta     <LAYRYX+1        ;  .
;
         puls    dp               ;  SET "DP" REGISTER TO I/O
        ;SETDP   $D0              ;  .
;
         jsr     INT3Q            ;  DISPLAY MINI MINE-LAYER
         ldb     #P_LYRSZ         ;  .    SET SIZE
         ldy     LAYRYX           ;  .    SET POSITION
         ldx     #LAYER           ;  .    SET PACKET ADDRESS
         jsr     APACK            ;  .    DRAW PACKET
;
MSHIP1   rts                      ;  RETURN TO CALLER
;
;
;  MINE-LAYER PARAMETER MODIFICATIONS
;  ==================================
;
;        FIRST MINE-LAYER MOTION MODIFICATION
;        ------------------------------------
;
BEGLAYR ;SETDP   $C8              ;  TIMER "DP" SET TO RAM
;
         ldx     #INSLAYR         ;  SET-UP FOR GENERAL MINE-LAYER MOTION
         stx     <TMR3 + 1        ;  .
;
         jsr     RANDOM           ;  SELECT PRE-PROGRAMMED MINE-LAYING SEQUENCE
         ldx     #RSTABL          ;  .
         anda    #$06             ;  .
         ldx     a,x              ;  .
;
         ldd     ,x++              ;  SET INITIAL MINE-LAYER LOCATION
         std     <LAYRYX          ;  .
         sta     <WLAYRY          ;  .    WORKING 'Y' LOCATION
         clr     <WLAYRY + 1      ;  .    .
         stb     <WLAYRX          ;  .    WORKING 'X' LOCATION
         clr     <WLAYRX + 1      ;  .    .
;
         bra     INSLYR6          ;  FETCH MOTION MODIFICATIONS
;
;
;        GENERAL MINE-LAYER MOTION MODIFICATIONS
;        ---------------------------------------
;
;
INSLAYR ;SETDP   $C8              ;  TIMER "DP" SET TO RAM
;
         lda     <RSMINES         ;  USE RANDOM MOTION OR PROGRAMMED SEQUENCE ?
         bne     INSLYR2          ;  .
;
;
INSLYR1  jsr     RANDOM           ;  RANDOM MOTION
         anda    #$7F             ;  .    SET PARAMETER CHANGE TIME
         adda    #$30             ;  .    .
         sta     <TMR3            ;  .    .
;
         jsr     RANDOM           ;  .    SET MINE-LAYER DIRECTION
         anda    #$3F             ;  .    .
         sta     <LAYRDIR         ;  .    .
;
         jsr     RANDOM           ;  .    SET MINE-LAYER SPEED
         adda    #$10             ;  .    .
         sta     <LAYRSPD         ;  .    .
         bra     INSLYR7          ;  .    .
;
;
INSLYR2  lda     <ABORT           ;  PRE-PROGRAMMED MINE-LAYING SEQUENCE
         bne     INSLYR1          ;  .    GAME ABORTED ?
;
;        lda     <CMINES          ;  .    ALL ACTIVE MINES DESTROYED ?
;        BEQ     INSLYR1          ;  .    .
;
         ldb     #MINES           ;  .    FIND HOLE FOR NEW MINE
         ldu     #MIN_TBL         ;  .    .
;
INSLYR3  lda     0,u              ;  .    .
         beq     INSLYR4          ;  .    .
;
         leau    MIN_LEN,u        ;  .    .
         decb                     ;  .    .    END-OF-TABLE ?
         bne     INSLYR3          ;  .    .    .
         bra     INSLYR7          ;  .    .    .    WHAT THE HEY ?
;
;
INSLYR4  inc     <MINMAX          ;  .    INSERT NEW MINE
         dec     <RSMINES         ;  .    .    DECREMENT RE-SEED MINE COUNT
;
         ldx     <WLAYRY          ;  .    .    SET MINE TO LAYER POSITION
         stx     MIN_YW,u         ;  .    .    .    WORKING DISPLACMENETS
         ldx     <WLAYRX          ;  .    .    .    .
         stx     MIN_XW,u         ;  .    .    .    .
;
         lda     #$40             ;  .    .    SET MINE-SEED TO IDLE
         sta     MIN_FLG,u        ;  .    .    .
;
         lda     <RESEED          ;  .    .    MINE RE-SEEDING ALREADY STARTED ?
         bne     INSLYR5          ;  .    .    .
;
         ldx     #RSGROW          ;  .    .    SET-UP DELAYED MINE GROWTH
         stx     <TMR1 + 1        ;  .    .    .
         jsr     RANDOM           ;  .    .    .    SET DELAY TIME
         anda    #$7F             ;  .    .    .    .
         adda    #$40             ;  .    .    .    .
         sta     <TMR1            ;  .    .    .    .
;
         inc     <RESEED          ;  .    .    SET RE-SEEDING FLAG
;
INSLYR5  ldx     <LAYRPTR         ;  .    FETCH PRE-PROGRAMMED VALUES
INSLYR6  lda     ,x+               ;  .    .    SET NEXT PARAMETER CHANGE TIME
         sta     <TMR3            ;  .    .    .
;
         lda     ,x+               ;  .    .    SET MINE-LAYER DIRECTION
         sta     <LAYRDIR         ;  .    .    .
;
         lda     ,x+               ;  .    .    SET MINE-LAYER SPEED
         sta     <LAYRSPD         ;  .    .    .
         stx     <LAYRPTR         ;  .    .    .    SAVE UPDATED SEQUENCE POINTER
;
;
INSLYR7  ldb     <LAYRDIR         ;  CALCULATE SHIP DISPLACEMENTS FOR SPEED
         jsr     MLTY8            ;  .    FORM DISPLACEMENTS
         sty     <DLAYRY          ;  .    .    SAVE 'Y' DISPLACEMENT
         stx     <DLAYRX          ;  .    .    SAVE 'X' DISPLACEMENT
;
         rts                      ;  .    RETURN TO CALLER
;
;
;        RE-SEEDED MINE GROWTH HANDLER
;        -----------------------------
;
;
RSGROW  ;SETDP   $C8              ;  TIMER "DP" SET TO RAM
;
         ldu     #TBLPTR1         ;  GROW FEATURED MINE
         lda     <ACTPLY          ;  .    SELECT POINTER FOR ACTIVE PLAYER
         ldu     a,u              ;  .    .
         lda     0,u              ;  .    SET MINE TYPE
         ldb     #3               ;  .    SET MINE SIZE
         jsr     RANSEED          ;  .    FIND AND SET ENTRY
;
         ldx     #FRCGROW         ;  SET-UP FOR FORCED MINE GROWTH
         stx     <TMR1 + 1        ;  .
;
         rts                      ;  .    RETURN TO CALLER
;
;
;        FORCED MINE GROWTH HANDLER
;        --------------------------
;
;
FRCGROW ;SETDP   $C8              ;  TIMER "DP" SET TO RAM
;
         dec     <FRCTIME         ;  DOWN-COUNT FORCE TIMER
         beq     FRC1             ;  .
         lda     #$FF             ;  .    RESET TIMER #1
         sta     <TMR1            ;  .    .
         bra     FRC9             ;  .    SKIP FORCED MINE GROWTH
;
FRC1     jsr     RANDOM           ;  FETCH RANDOM NUMBER FOR MINE SIZE
         tfr     a,b              ;  .    NUMBER MUST BE BETWEEN 1 - 3
         andb    #$03             ;  .    .
         bne     FRC2             ;  .    .    BUMP IF ZERO
         addb    #$01             ;  .    .    .
;
FRC2     ldu     #TBLPTR1         ;  GROW FEATURED MINE
         lda     <ACTPLY          ;  .    SELECT POINTER FOR ACTIVE PLAYER
         ldu     a,u              ;  .    .
         lda     0,u              ;  .    SET MINE TYPE
         jsr     RANSEED          ;  .    FIND AND SET ENTRY
;
FRC9     rts                      ;  .    RETURN TO CALLER
;
;
;        MINE-LAYER RE-SEEDING SEQUENCES
;        -------------------------------
;
;
RSTABL   dw      RESEED1          ;  RE-SEEDING SEQUENCE LOOK-UP TABLE
         dw      RESEED2          ;  .
         dw      RESEED3          ;  .
         dw      RESEED4          ;  .
;
;
RESEED1  dw      $7F00            ;  RE-SEED SEQUENCE #1
         db      $28              ;  .    DELAY TO NEXT CHANGE
         db      $20              ;  .    DIRECTION OF CURRENT MOTION
         db      $30              ;  .    SPEED OF CURRENT MOTION
         db      $40,$28,$30      ;  .
         db      $28,$00,$10      ;  .
         db      $30,$10,$40      ;  .
         db      $18,$20,$50      ;  .
         db      $40,$30,$28      ;  .
         db      $30,$08,$60      ;  .
         db      $7F,$38,$70      ;  .
;
;
RESEED2  dw      $8000            ;  RE-SEED SEQUENCE #2
         db      $40              ;  .    DELAY TO NEXT CHANGE
         db      $00              ;  .    DIRECTION OF CURRENT MOTION
         db      $30              ;  .    SPEED OF CURRENT MOTION
         db      $20,$10,$50      ;  .
         db      $20,$28,$40      ;  .
         db      $30,$3E,$70      ;  .
         db      $18,$30,$60      ;  .
         db      $20,$18,$40      ;  .
         db      $30,$24,$50      ;  .
         db      $7F,$06,$70      ;  .
;
;
RESEED3  dw      $007F            ;  RE-SEED SEQUENCE #3
         db      $40              ;  .    DELAY TO NEXT CHANGE
         db      $10              ;  .    DIRECTION OF CURRENT MOTION
         db      $60              ;  .    SPEED OF CURRENT MOTION
         db      $28,$38,$30      ;  .
         db      $28,$08,$40      ;  .
         db      $30,$28,$7F      ;  .
         db      $20,$18,$30      ;  .
         db      $30,$08,$68      ;  .
         db      $40,$20,$50      ;  .
         db      $7F,$38,$70      ;  .
;
;
RESEED4  dw      $0080            ;  RE-SEED SEQUENCE #4
         db      $40              ;  .    DELAY TO NEXT CHANGE
         db      $30              ;  .    DIRECTION OF CURRENT MOTION
         db      $60              ;  .    SPEED OF CURRENT MOTION
         db      $38,$18,$30      ;  .
         db      $30,$20,$18      ;  .
         db      $20,$38,$40      ;  .
         db      $28,$10,$60      ;  .
         db      $20,$00,$30      ;  .
         db      $40,$38,$50      ;  .
         db      $7F,$1C,$70      ;  .
;
;
;  BULLET GAME LOGIC
;  =================
;
        ;SETDP   $D0
;        =====   ===
;
GBULLET  lda     #BULLETS         ;  DISPLAY 'BULLETS' TABLE
         ldu     #BLT_TBL         ;  .
         ldx     #S_FIRE          ;  .
;
SBULLET  sta     TEMP1            ;  .
         jsr     INTMAX           ;  .
;
GBLT1    lda     BLT_FLG,u        ;  .    BULLET ACTIVE ?
         beq     GBLT4            ;  .    .
;
         dec     BLT_DC,u         ;  .    DECREMENT BULLET DOWN-COUNTER
         beq     GBLT3            ;  .    .
;
         ldd     BLT_WY,u         ;  .    CALCULATE NEW BULLET POSITION
         addd    BLT_YD,u         ;  .    .    'Y' POSITION
         std     BLT_WY,u         ;  .    .    .
;
         ldd     BLT_WX,u         ;  .    .    'X' POSITION
         addd    BLT_XD,u         ;  .    .    .
         std     BLT_WX,u         ;  .    .    .
;
         leay    BLT_WY,u         ;  .    DISPLAY BULLET FOR THIS ENTRY
         jsr     DDOT             ;  .    .    POSITION BULLET
;
GBLT2    leau    BLT_LEN,u        ;  .    BUMP TO NEXT ENTRY
         dec     TEMP1            ;  .    .    END-OF-BULLET TABLE ?
         bne     GBLT1            ;  .    .    .
         rts                      ;  .    .    RETURN TO CALLER
;
GBLT3    clr     BLT_FLG,u        ;  .    THIS ENTRY HAS MOVED OFF-SCREEN
         dec     CBULLET          ;  .    .    DECREMENT ACTIVE BULLET COUNTER
;
GBLT4    lda     ABORT            ;  .    ZERO ENTRY FOUND, GAME ABORTED ?
         bne     GBLT2            ;  .    .
;
         lda     HYPFLAG          ;  .    .    HYPER-SPACE SEQUENCE ACTIVE ?
         bne     GBLT2            ;  .    .    .
;
         lda     0,x              ;  .    INSERT NEW BULLET ?
         beq     GBLT2            ;  .    .    IS FIRE BUTTON DEPRESSED ?
;
         clr     0,x              ;  .    .    CLEAR 'FIRE' FLAG
         inc     BLTSND           ;  .    .    SET BULLET SOUND FLAG
;
         inc     BLT_FLG,u        ;  .    .    SET BULLET 'ON'
         ldd     WSHIPY           ;  .    .    SET SHIP WORKING POSITION
         std     BLT_WY,u         ;  .    .    .    'Y' AXIS
         ldd     WSHIPX           ;  .    .    .    'X' AXIS
         std     BLT_WX,u         ;  .    .    .    .
         ldd     DBLTY            ;  .    .    SET BULLET DISPLACEMENT VALUES
         std     BLT_YD,u         ;  .    .    .    'Y' AXIS
         ldd     DBLTX            ;  .    .    .    'X' AXIS
         std     BLT_XD,u         ;  .    .    .    .
         lda     #$18             ;  .    .    SET DOWN-COUNTERS
         sta     BLT_DC,u         ;  .    .    .
         inc     CBULLET          ;  .    .    BUMP ACTIVE BULLET COUNTER
         bra     GBLT2            ;  .    .
;
;
;  MINE GAME LOGIC
;  ===============
;
        ;SETDP   $D0
;        =====   ===
;
GMINE    lda     #MINES           ;  SET-UP TO DISPLAY MINE TABLE
         sta     TEMP1            ;  .
         ldu     #MIN_TBL         ;  .
;
GMIN1    lda     MIN_FLG,u        ;  FETCH MINE FLAG
         bne     GMIN3            ;  .    SKIP THIS ENTRY ?
;
GMIN2    leau    MIN_LEN,u        ;  .    .    BUMP TO NEXT ENTRY
         dec     TEMP1            ;  .    .    .    END-OF-OBJECT TABLE ?
         bne     GMIN1            ;  .    .    .    .
         rts                      ;  .    .    .    RETURN TO CALLER
;
GMIN3    lbmi    MINIT            ;  .    MINE MOVING TO INITIAL POSITION ?
         bita    #$40             ;  .    IDLE MINE ?
         lbne    MIDLE            ;  .    .
         bita    #$20             ;  .    MINE ZOOMING UP FROM SEED ?
         lbne    MZOOM            ;  .    .
         bita    #$10             ;  .    IDLE MINE ?
         lbne    MWAIT            ;  .    .
         bita    #$01             ;  .    MINE COLLISION DETECTED ?
         lbne    MBOOM            ;  .    .
;        
MMOVE    lda     MIN_PAK,u        ;  MINE IN MOTION
;
         cmpa    #FIRBALL         ;  .    'RELEASED' FIRE-BALL ?
         beq     MFBALL           ;  .    .
;
         bita    #$01             ;  .    'DUMB' MINE MOTION ?
         beq     MOVDUMB          ;  .    .
;
;
MOVMAG   lda     HYPFLAG          ;  HYPER-SPACE ACTIVE ?
         bne     MOVDUMB          ;  .    IF SO, USE 'DUMB' MINE MOTION
;
         lda     ABORT            ;  GAME ABORTED ?
         bne     MOVDUMB          ;  .    IF SO, USE 'DUMB' MINE MOTION
;
         pshs    dp               ;  SAVE ENTRY "DP"
         jsr     DPRAM            ;  SET "DP" REGISTER TO RAM
        ;SETDP   $C8              ;  .
;
         lda     <WSHIPY          ;  CALCULATE DELTA YX VALUES
         suba    MIN_YW,u         ;  .
         ldb     <WSHIPX          ;  .
         subb    MIN_XW,u         ;  .
;
         jsr     CMPASS           ;  .    CALCULATE ANGLE TO SHIP
         suba    #$10             ;  .    .
         sta     <ETMP1           ;  .    .
;
         ldx     #MINSPD          ;  .    CALCULATE NEW DISPLACEMENTS
         ldb     MIN_BSZ,u        ;  .    .    FETCH MINE SPEED FOR SIZE
         lda     b,x              ;  .    .    .
         ldb     <ETMP1           ;  .    .    FETCH DIRECTION
         jsr     MLTY8            ;  .    .    FETCH NEW DISPLACEMENTS
         sty     MIN_YD,u         ;  .    .    .    SAVE 'Y' DISPLACEMENT
         stx     MIN_XD,u         ;  .    .    .    SAVE 'X' DISPLACEMENT
;
         puls    dp               ;  .    RECOVER DIRECT REGISTER
        ;SETDP   $D0              ;  .    .
;
;
MOVDUMB  ldd     MIN_YW,u         ;  CALCULATE NEW ABSOLUTE 'Y' VALUE
         addd    MIN_YD,u         ;  .
         std     MIN_YW,u         ;  .
;
         ldd     MIN_XW,u         ;  CALCULATE NEW ABSOLUTE 'X' VALUE
         addd    MIN_XD,u         ;  .
         std     MIN_XW,u         ;  .
;
;
MDRAW    jsr     INT3Q            ;  DISPLAY MINE PACKET FOR THIS ENTRY
         ldx     #MINOBJ          ;  .    LOOK-UP PACKET ADDRESS
         lda     MIN_PAK,u        ;  .    .
         asla                     ;  .    .
         ldx     a,x              ;  .    .
         leay    MIN_YW,u         ;  .    SET POSITION
         ldb     MIN_SIZ,u        ;  .    SET ZOOM VALUE
         jsr     DPACK            ;  .    .
;
         jmp     GMIN2            ;  DO NEXT MINE ENTRY
;
;
MFBALL   ldd     MIN_YW,u         ;  HANDLE 'RELEASED' FIRE-BALL
         addd    MIN_YD,u         ;  .    'Y' AXIS
         bvs     MFBALL1          ;  .    .    OFF-SCREEN ?
         std     MIN_YW,u         ;  .    .
;
         ldd     MIN_XW,u         ;  .    'X' AXIS
         addd    MIN_XD,u         ;  .    .
         bvs     MFBALL1          ;  .    .    OFF-SCREEN ?
         std     MIN_XW,u         ;  .    .
;
         jsr     INTMAX           ;  .    DRAW FIRE-BALL
         leay    MIN_YW,u         ;  .    .    SET POSITION
         ldx     #PACKET2         ;  .    .    DRAW PACKET
         ldb     #$04             ;  .    .    .
         jsr     DPACK            ;  .    .    .
         jmp     GMIN2            ;  .
;
MFBALL1  clr     MIN_FLG,u        ;  .    MINE OFF-SCREEN - CLEAR ENTRY
         dec     CMINES           ;  .    .
         jmp     GMIN2            ;  .    .
;
;
MINIT    lda     MIN_XW,u         ;  HANDLE INITIAL MINE MOTION
         adda    MIN_T1,u         ;  .    ADD DISPLACEMENT VALUE
         sta     MIN_XW,u         ;  .
;
         cmpa    MIN_T2,u         ;  .    HAS MINE REACHED DESTINATION ?
         bne     MIDLE            ;  .    .
;
         lsr     MIN_FLG,u        ;  .    MINE HAS REACHED IDLE DESTINATION
;
;
MIDLE    jsr     INT3Q            ;  IDLE MINE ACTION
         leay    MIN_YW,u         ;  .    DRAW MINE SEED
         jsr     DDOT             ;  .    .
         jmp     GMIN2            ;  .    .
;
;
MZOOM    lda     MIN_BSZ,u        ;  HANDLE THE MINE ZOOMING
         cmpa    #$03             ;  .    SMALL OR MEDIUM MINE ?
         bne     MZOOM1           ;  .    .     SKIP ZOOMING
;
         lda     MIN_SIZ,u        ;  IS MINE ZOOMING DONE ?
         cmpa    MIN_T1,u         ;  .
         bge     MZOOM1           ;  .
;
         adda    #$08             ;  .    ZOOM MINE TO PRESET VALUE
         sta     MIN_SIZ,u        ;  .    .
         bra     MZOOM9           ;  .    .
;
MZOOM1   lsr     MIN_FLG,u        ;  MINE HAS REACHED ITS PROPER SIZE
;
         lda     MIN_T1,u         ;  .    SET ACTUAL MINE SIZE
         sta     MIN_SIZ,u        ;  .    .
;
         lda     #$18             ;  .    SET MINE IDLE TIME
         sta     MIN_T1,u         ;  .    .
;
         lda     MINMAX           ;  .    LAST MINE-SEED ?
         bne     MZOOM9           ;  .    .
;
         lda     RESEED           ;  .    .    MINE RE-SEEDING ALREADY STARTED ?
         bne     MZOOM9           ;  .    .    .
;
         lda     #$7F             ;  .    .    SET-UP FOR MINE-LAYER INSERTION
         sta     TMR3             ;  .    .    .
;
MZOOM9   jmp     MDRAW            ;  .    DRAW MINE
;
;
MWAIT    dec     MIN_T1,u         ;  IDLE MINE
         bne     MWAIT9           ;  .
;
         lsr     MIN_FLG,u        ;  .    SET MINE FLAG FOR NEXT ACTIVITY
;
MWAIT9   jmp     MDRAW            ;  .    DRAW MINE
;
;
MBOOM    clr     MIN_FLG,u        ;  HANDLE MINE COLLISION
;
         lda     MIN_PAK,u        ;  DETERMINE TYPE AND SIZE OF CURRENT MINE
         cmpa    #$04             ;  .    RELEASED FIRE-BALL ?
         beq     MBOOM9           ;  .    .
         ldb     MIN_BSZ,u        ;  .    SET NEW MINE SIZE
         decb                     ;  .    .    SET TO NEXT SMALLER SIZE
         beq     MBOOM9           ;  .    .    .
;
         pshs    a,dp             ;  ESTABLISH TWO NEW MINES
         lda     #$C8             ;  .    SET "DP" REGISTER TO RAM
         tfr     a,dp             ;  .    .
;
         lda     0,s              ;  .    GROW TWO NEW MINES
         jsr     RANSEED          ;  .    .
         jsr     RANSEED          ;  .    .
         puls    a,dp             ;  .
;
MBOOM9   jmp     GMIN2            ;  .    DO NEXT MINE ENTRY
;
;
;  TAIL-END OF GAME LOGIC SEQUENCE
;  ===============================
;
;
TAIL     pshs    dp               ;  SET "DP" REGISTER TO I/O
         jsr     DPIO             ;  .
        ;SETDP   $D0              ;  .
;
DEXPL    jsr     INTMAX           ;  DRAW EXPLOSIONS
         ldu     #EXP_TBL         ;  .
         lda     #EXPLSN          ;  .
         sta     TEMP1            ;  .
;
EXPL1    lda     EXP_FLG,u        ;  .    EXPLOSION ACTIVE ?
         lbeq    EXPL9            ;  .    .
;
         ldb     EXP_CNT,u        ;  .    BUMP EXPLOSION COUNTER
         cmpb    EXP_SIZ,u        ;  .    .    EXPLOSION FULLY EXPANDED ?
         bhs     EXPL10           ;  .    .    .
         addb    #$03             ;  .    .
         stb     EXP_CNT,u        ;  .    .
;
         ldy     EXP_YX,u         ;  .    DRAW EXPANDING EXPLOSION CLOUD
         ldx     #EXPLODE         ;  .    .
         jsr     APACK            ;  .    .
;
EXPL10   tsta                     ;  .    SWEEPER EXPLODING ?
         lbpl    EXPL2            ;  .    .
;
         dec     SEXPCNT          ;  .    .    SWEEPER EXPLODING
         lbeq    EXPL3            ;  .    .    .    EXPLOSION COMPLETE ?
;
         lda     FRAME            ;  .    .    .    BUMP EXPLOSION ON EVEN FRAME
         anda    #$01             ;  .    .    .    .
         bne     EXPL11           ;  .    .    .    .
         inc     SEXP1            ;  .    .    .    .
;
EXPL11   lda     SEXP1            ;  .    .    .    DISPLAY SWEEPER EXPLOSION
         ldy     #$7F00           ;  .    .    .    .
         ldx     #SHPEX1          ;  .    .    .    .
         jsr     DSHPEXP          ;  .    .    .    .
;
         ldy     #$6080           ;  .    .    .    .
         ldx     #SHPEX2          ;  .    .    .    .
         jsr     DSHPEXP          ;  .    .    .    .
;
         ldy     #$8050           ;  .    .    .    .
         ldx     #SHPEX3          ;  .    .    .    .
         jsr     DSHPEXP          ;  .    .    .    .
;
         ldy     #$A080           ;  .    .    .    .
         ldx     #SHPEX4          ;  .    .    .    .
         jsr     DSHPEXP          ;  .    .    .    .
         bra     EXPL9            ;  .    .    .    .
;
EXPL3    dec     SHIPCNT          ;  .    RESET SWEEPER EXPLOSION
;
         clr     CMINES           ;  .    .    CLEAR ACTIVE MINE COUNT
         clr     MINMAX           ;  .    .    CLEAR MAXIMUM MINE COUNT
;
         lda     PLAYRS           ;  .    .    SWITCH PLAYERS ?
         beq     EXPL30           ;  .    .    .
;
         lda     ACTPLY           ;  .    .    .    SAVE CURRENT PLAYER STATUS
         lsra                     ;  .    .    .    .
         ldx     #SHIPCNT0        ;  .    .    .    .    SAVE SHIP COUNTER
         ldb     SHIPCNT          ;  .    .    .    .    .
         stb     a,x              ;  .    .    .    .    .
;
         lda     SHIPCNT0         ;  .    CONTINUE GAME ?
         bne     EXPL31           ;  .    .
         lda     SHIPCNT1         ;  .    .
         beq     EXPL32           ;  .    .
;
EXPL31   lda     ACTPLY           ;  .    .    .    BUMP PLAYER FLAG
         adda    #$02             ;  .    .    .    .
         anda    #$02             ;  .    .    .    .
         sta     ACTPLY           ;  .    .    .    .
;
         lsra                     ;  .    .    .    FETCH NEW PLAYER STATUS
         ldx     #SHIPCNT0        ;  .    .    .    .    FETCH SHIP COUNTER
         ldb     a,x              ;  .    .    .    .    .
         stb     SHIPCNT          ;  .    .    .    .    .
         beq     EXPL31           ;  .    .    .    .    .    SKIP IF NO SHIPS
;
EXPL30   lda     SHIPCNT          ;  .    .    ONE PLAYER - SHIPS LEFT ?
         bne     EXPL8            ;  .    .    .
;
EXPL32   lda     #$01             ;  .    .    LOCK-UP ON GAME SEQUENCE
         sta     LOCK             ;  .    .    .
         bra     EXPL8            ;  .    .    .
;
;
EXPL2    ldb     EXP_CNT,u        ;  .    EXPLOSION COMPLETE ?
         cmpb    EXP_SIZ,u        ;  .    .
         blo     EXPL9            ;  .    .
;
EXPL8    clr     EXP_FLG,u        ;  .    .    RESET EXPLOSION ENTRY
         dec     CEXPLS           ;  .    .    .
;
EXPL9    leau    EXP_LEN,u        ;  .    BUMP TO NEXT ENTRY
         dec     TEMP1            ;  .    .
         lbne    EXPL1            ;  .    .
;
         jsr     SOUND            ;  UPDATE SOUND HANDLER
         bra     SHPCNT0          ;  .
;
;
STAIL    pshs    dp               ;  SHORT 'TAIL' ENTRY
         jsr     DPIO             ;  .    SET "DP" REGISTER TO I/O
;
SHPCNT0  jsr     INT3Q            ;  DISPLAY REMAINING SHIPS
         ldx     #$8038           ;  .    SET INITIAL POSITION
         stx     TEMP2            ;  .    .
;==========================================================================JJH
;        lda     SHIPCNT          ;  CODE DELETED - REV. C CHANGES   ======JJH
;        BEQ     SHPCNT9          ;  .                               ======JJH
;        sta     TEMP1            ;  .                               ======JJH
;==========================================================================JJH
;
;==========================================================================JJH
         jsr     REVC_1           ;  CODE ADDED - REV. C CHANGES     ======JJH
         beq     SHPCNT9          ;  .                               ======JJH
         nop                      ;  .                               ======JJH
         nop                      ;  .                               ======JJH
         nop                      ;  .                               ======JJH
;==========================================================================JJH
;
SHPCNT1  dec     TEMP1            ;  .    DRAW THIS SHIP ?
         beq     SHPCNT9          ;  .    .
;
         lda     TEMP2 + 1        ;  .    MOVE SHIP POSITION
         adda    #$06             ;  .    .
         sta     TEMP2 + 1        ;  .    .
;
         ldb     #$04             ;  .    DRAW SHIP COUNTER
         ldy     TEMP2            ;  .    .    SET POSITION
         ldx     #NSHIP           ;  .    .    SET PACKET ADDRESS
         jsr     APACK            ;  .    .    .
         bra     SHPCNT1          ;  .    .    DO IT AGAIN
;
SHPCNT9  puls    dp               ;  SET "DP" REGISTER TO RAM
        ;SETDP   $C8              ;  .
;
         lda     <FRAME           ;  ROTATE FIREBALL
         anda    #$01             ;  .    FORM ROTATION ANGLE
         lsla                     ;  .    .
         lsla                     ;  .    .
         lsla                     ;  .    .
         ldx     #MINE5           ;  .    FETCH SOURCE PACKET ADDRESS
         ldu     #PACKET2         ;  .    FETCH DESTINATION PACKET ADDRESS
         jsr     PROT             ;  .    ROTATE PACKET
;
         ldb     <CEXPLS          ;  END-OF-SEQUENCE
         bne     TAIL1            ;  .    EXPLOSIONS DONE ?
         lda     <ABORT           ;  .    GAME ABORTED ?
         bne     TAIL0            ;  .    .
;
;==========================================================================JJH
;        ldb     <CMINES          ;  CODE DELETED - REV. C CHANGES   ======JJH
;        BNE     TAIL1            ;  .                               ======JJH
;        ldb     <MINMAX          ;  .                               ======JJH
;        BNE     TAIL1            ;  .                               ======JJH
;==========================================================================JJH
;
;==========================================================================JJH
         ldb     <CMINES          ;  CODE ADDED - REV. C CHANGES     ======JJH
         orb     <MINMAX          ;  .                               ======JJH
         orb     <LAYRSPD         ;  .                               ======JJH
         bne     TAIL1            ;  .                               ======JJH
;==========================================================================JJH
;
TAIL0    andcc   #$FE             ;  SET 'C' TO '0' - LEVEL COMPLETE
         rts                      ;  .    RETURN TO CALLER
;
TAIL1    orcc    #$01             ;  SET 'C' TO '1' - MORE GAME LOGIC
         rts                      ;  .    RETURN TO CALLER
;
;
;        SHIP EXPLOSION HANDLER
;        ----------------------
;
        ;SETDP   $D0
;
DSHPEXP  pshs    a,x,y            ;  SAVE ENTRY VALUES
         ldx     #WSHIPY          ;  POSITION TO CENETER OF EXPLOSION
         jsr     POSWID           ;  .
;
         lda     0,s              ;  POSITION SHIP FRAGMENT
         sta     <T1LOLC          ;  .
         tfr     y,d              ;  .
         jsr     POSITN           ;  .
;
         ldb     #P_SHPSZ         ;  DRAW SHIP FRAGMENT
         ldx     1,s              ;  .
         jsr     TPACK            ;  .
;
         puls    a,x,y,pc         ;  RETURN TO CALLER
;
;
;  SET EXPLOSION IN TABLE
;  ======================
;
;        ENTRY VALUES:
;             A = STARTING SIZE OF EXPLOSION
;             B = MAXIMUM SIZE OF EXPLOSION
;             X = POSITION OF EXPLOSION
;
;        RETURN VALUES:
;             SAME AS ENTRY VALUES
;
        ;SETDP   $C8
;        =====   ===
;
SETEXP   pshs    a,b,x            ;  SAVE ENTRY VALUES
;
         ldx     #EXP_TBL         ;  FIND OPENING IN EXPLOSION TABLE
         lda     #EXPLSN          ;  .
;
STEX1    ldb     EXP_FLG,x        ;  .    EXPLOSION ENTRY ACTIVE ?
         beq     STEX2            ;  .    .
;
         leax    EXP_LEN,x        ;  .    BUMP TO NEXT ENTRY
         deca                     ;  .    .
         bne     STEX1            ;  .    .
         bra     STEX4            ;  .    .    NO ROOM FOR MORE EXPLOSIONS
;
STEX2    lda     0,s              ;  ENTER EXPLOSION PARAMETERS
         anda    #$80             ;  .    SET EXPLOSION FLAG 
         inca                     ;  .    .
         sta     EXP_FLG,x        ;  .    .
;
         bpl     STEX3            ;  .    .    EXPLOSION FATAL TO SWEEPER ?
         inc     <ABORT           ;  .    .    .    SET ABORT FLAG
;
STEX3    lda     0,s              ;  .    SET STARTING EXPLOSION SIZE
         anda    #$7F             ;  .    .
         sta     EXP_CNT,x        ;  .    .
;
         lda     1,s              ;  .    SET MAXIMUM EXPLOSION SIZE
         sta     EXP_SIZ,x        ;  .    .
;
         ldd     2,s              ;  .    SET EXPLOSION CENTRE
         std     EXP_YX,x         ;  .    .
;
         inc     <CEXPLS          ;  .    BUMP ACTIVE EXPLOSION COUNTER
         inc     EXPLSND          ;  .    TRIGGER EXPLOSION SOUND
;
STEX4    puls    a,b,x,pc         ;  RETURN TO CALLER
;
;
;  FORM 'YX' DISPLACEMENTS
;  =======================
;
;        ENTRY VALUES:
;             A = SPEED VECTOR
;             B = DIRECTION
;
;        RETURN VALUES:
;             Y = 'Y' DISPLACEMENT VALUE (MSB/LSB)
;             X = 'X' DISPLACEMENT VALUE (MSB/LSB)
;
        ;SETDP   $C8
;        =====   ===
;
MLTY8    pshs    a,b,x,y          ;  SAVE ENTRY VALUES
;
         jsr     LNROT            ;  CALCULATE SHIP DISPLACEMENTS
         sta     4,s              ;  .
;
         sex                      ;  .    FORM 'X' DISPLACEMENT (8X)
         aslb                     ;  .    .    MULTIPLY BY EIGHT
         rola                     ;  .    .    .
         aslb                     ;  .    .    .
         rola                     ;  .    .    .
         aslb                     ;  .    .    .
         rola                     ;  .    .    .
         std     2,s              ;  .    .    .
;
         ldb     4,s              ;  .    FORM 'Y' DISPLACEMENT (8X)
         sex                      ;  .    .    EXTEND SIGN
         aslb                     ;  .    .    MULTIPLY BY EIGHT
         rola                     ;  .    .    .
         aslb                     ;  .    .    .
         rola                     ;  .    .    .
         aslb                     ;  .    .    .
         rola                     ;  .    .    .
         std     4,s              ;  .    .    .
;
         puls    a,b,x,y,pc       ;  .    RETURN TO CALLER
;
;
;
MLTY16   pshs    a,b,x,y          ;  SAVE ENTRY VALUES
;
         bsr     MLTY8            ;  CALCULATE 16X SHIP DISPLACEMENTS
;
         ldd     -4,s             ;  .    FORM 'Y' DISPLACEMENT (16X)
         aslb                     ;  .    .    MULTIPLY BY TWO
         rola                     ;  .    .    .
         std     4,s              ;  .    .    .
;
         ldd     -6,s             ;  .    FORM 'X' DISPLACEMENT (16X)
         aslb                     ;  .    .    MULTIPLY BY TWO
         rola                     ;  .    .    .
         std     2,s              ;  .    .    .
;
         puls    a,b,x,y,pc       ;  .    RETURN TO CALLER
;
;
;  INITIALIZE STAR-SWEEPER
;  =======================
;
;
SWPINT   lda     #$D0             ;  SET "DP" REGISTER TO I/O
         tfr     a,dp             ;  .
        ;SETDP   $D0              ;  .
;
         jsr     INTPSG           ;  INITIALIZE SOUND GENERATOR
;
         lda     #$C8             ;  SET "DP" REGISTER TO RAM
         tfr     a,dp             ;  .
        ;SETDP   $C8              ;  .
;
         clr     <TMR1            ;  CLEAR PROGRAMMABLE TIMERS
         clr     <TMR2            ;  .
         clr     <TMR3            ;  .
         clr     <TMR4            ;  .
;
         ldx     #BLT_TBL         ;  CLEAR TABLES
CLROBJ   clr     ,x+               ;  .
         cmpx    #FSTAR           ;  .
         bne     CLROBJ           ;  .
;
         ldd     #$0000           ;  CLEAR MINE-LAYER PARAMETERS
         std     <WLAYRY          ;  .
         std     <WLAYRX          ;  .
         std     <DLAYRY          ;  .
         std     <DLAYRX          ;  .
         sta     <LAYRSPD         ;  .    CLEAR LAYER SPEED
;
         sta     <ABORT           ;  RESET ABORT FLAG
         sta     <LOCK            ;  RESET LOCK-UP FLAG
;
         sta     <CBULLET         ;  CLEAR ACTIVE BULLET COUNTER
         sta     <CMINES          ;  CLEAR ACTIVE MINE COUNTER
         sta     <CEXPLS          ;  CLEAR ACTIVE EXPLOSION COUNTER
;
         sta     SEXP1            ;  SET SHIP EXPLOSION COUNTERS
         ldb     #$40             ;  .    SHIP EXPLOSION DURATION
         stb     SEXPCNT          ;  .    .
;
         sta     <MINMAX          ;  RESET MINE-SEED COUNTER
         sta     <RESEED          ;  RESET MINE RE-SEEDING COUNTER
;
         ldx     #$0800           ;  SET LONG TIME-OUT DELAY
         stx     TIMEOUT          ;  .
;
         lda     #$07             ;  SET MINE RE-SEED COUNT
         sta     <RSMINES         ;  .
;
         ldx     #BEGLAYR         ;  SET-UP FOR FIRST MINE-LAYER MODIFICATION
         stx     <TMR3 + 1        ;  .
;
;
;  RESET STAR-SWEEPER PARAMETERS
;  =============================
;
;
SWPRST   ldd     #0               ;  CLEAR STAR-SWEEPER PARAMETERS
         std     <WSHIPY          ;  .    WORKING POSITIONS
         std     <WSHIPX          ;  .    .
;
HSWPRST  ldd     #$0000           ;  .    SHIP ROTATION
         sta     <SHIPROT         ;  .    .
         std     <DSHIPY1         ;  .    AXIS #1 DISPLACEMENTS
         std     <DSHIPX1         ;  .    .
         sta     <SHIPSPD1        ;  .    .    CLEAR SHIP SPEED
         sta     <SHIPDIR1        ;  .    .    CLEAR SHIP DIRECTION
         std     <DSHIPY2         ;  .    AXIS #2 DISPLACEMENTS
         std     <DSHIPX2         ;  .    .
         sta     <SHIPSPD2        ;  .    .    CLEAR SHIP SPEED
         sta     <SHIPDIR2        ;  .    .    CLEAR SHIP DIRECTION
;
SWPROT   lda     <SHIPROT         ;  ROTATE SWEEPER
         ldx     #NSHIP           ;  .
         ldu     #PACKET1         ;  .
         jsr     PROT             ;  .
;
         lda     #$7F             ;  CALCULATE NEW BULLET DISPLACEMENTS
         ldb     <SHIPROT         ;  .    FETCH DIRECTION
         jsr     MLTY16           ;  .    FORM DISPLACEMENTS
         sty     DBLTY            ;  .    .    SAVE 'Y' DISPLACEMENT
         stx     DBLTX            ;  .    .    SAVE 'X' DISPLACEMENT
;
         rts                      ;  RETURN TO CALLER
;
;
;  FALL THRU STAR FIELD AS LEAD-IN TO NEXT SEQUENCE
;  ================================================
;
        ;SETDP   $C8
;        =====   ===
;
FALL     pshs    x,y              ;  SAVE THE INDEX REGISTERS
         pshs    dp               ;  SAVE THE ENTRY "DP"
;
         jsr     DPIO             ;  SET "DP" REGISTER TO I/O
         jsr     INTPSG           ;  CLEAR-OUT SOUND
;
         puls    dp               ;  SET "DP" REGISTER TO RAM
;
         lda     #$A0             ;  SET MINIMUM FALL-THRU TIME
         sta     <TEMP1           ;  .
;
FALL1    lda     <WSHIPY          ;  MOVE SHIP TO CENTER POSITION
         beq     FALL2            ;  .    'Y' AXIS
         bmi     FALL10           ;  .    .
         deca                     ;  .    .    CURRENT POSITION POSITIVE
         bra     FALL11           ;  .    .    .
;
FALL10   inca                     ;  .    .    CURRENT POSITION NEGATIVE
FALL11   sta     <WSHIPY          ;  .    .    .
         clr     <WSHIPY + 1      ;  .    .    .
;
FALL2    lda     <WSHIPX          ;  .    'X' AXIS
         beq     FALL3            ;  .    .
         bmi     FALL20           ;  .    
         deca                     ;  .    .    CURRENT POSITION POSITIVE
         bra     FALL21           ;  .    .    .
;
FALL20   inca                     ;  .    .    CURRENT POSITION NEGATIVE
FALL21   sta     <WSHIPX          ;  .    .    .
         clr     <WSHIPX + 1      ;  .    .    .
;
FALL3    lda     <SHIPROT         ;  .    ROTATION
         beq     FALL4            ;  .    .
         cmpa    #$1F             ;  .    .
         bgt     FALL30           ;  .    .    ROTATE LEFT
         deca                     ;  .    .    .
         bra     FALL31           ;  .    .    .
;
FALL30   inca                     ;  .    .    ROTATE RIGHT
FALL31   anda    #$3F             ;  .    .    .
         sta     <SHIPROT         ;  .    .    .
;
FALL4    jsr     SHPONLY          ;  ROTATE AND DISPLAY STAR-SWEEPER
;
         ldx     #ZSTAR           ;  ADVANCE STAR FIELD
         ldb     #$08             ;  .
FALL5    lda     0,x              ;  .
         adda    #$03             ;  .
         sta     ,x+               ;  .
         decb                     ;  .
         bne     FALL5            ;  .
;
         pshs    dp               ;  SET "DP" REGISTER TO I/O
         jsr     DPIO             ;  .
        ;SETDP   $D0              ;  .
;
         jsr     SCRBTH           ;  DISPLAY PLAYER SCORES
;
         clrb                     ;  DISPLAY STAR FIELDS
         lda     #$20             ;  .
         jsr     D_STARS          ;  .
         jsr     F_STARS          ;  .
;
         puls    dp               ;  SET "DP" REGISTER TO RAM
        ;SETDP   $C8              ;  .
;  
FALL91   lda     <WSHIPY          ;  FALL-THRU COMPLETED ?
         lbne    FALL1            ;  .
         lda     <WSHIPX          ;  .
         lbne    FALL1            ;  .
         lda     <SHIPROT         ;  .
         lbne    FALL1            ;  .
         dec     <TEMP1           ;  .    END-OF-SEQUENCE ?
         lbne    FALL1            ;  .    .
;
         jsr     SWPINT           ;  RESET VALUES
         puls    x,y,pc           ;  .    RETURN TO CALLER
;
;
;  INITIALIZE STAR FIELDS
;  ======================
;
;
I_STARS  ldx     #STAR_1
         ldy     #FSTAR
         ldu     #ZSTAR
;
         ldb     #$08
         lda     #$16
;
ST_101   stx     ,y++
         leax    8,x
         sta     ,u+
         adda    #$0F
         decb
         bne     ST_101
         rts
;
;
;  ZOOM STAR FIELDS FORWARD AND DISPLAY
;  ====================================
;
;        ENTRY VALUES
;             A = STAR FIELD LIMIT
;             B = ZOOM VALUE
;
;        RETURN VALUES
;             SAME AS ENTRY
;
        ;SETDP   $D0
;        =====   ===
;
F_STARS  pshs    a,b,x,dp         ;  SAVE ENTRY VALUES
;
         ldx     #ZSTAR           ;  BUMP ZOOM VALUES
         lda     #$08             ;  .
ST_201   inc     ,x+               ;  .
         deca                     ;  .
         bne     ST_201           ;  .
;
         bra     DSTARS1          ;  DISPLAY NEW STAR FIELDS
;
;
;  DISPLAY STAR FIELDS
;  ===================
;
;        ENTRY VALUES
;             A = STAR FIELD INNER LIMIT
;             B = ZOOM VALUE
;
;        RETURN VALUES
;             SAME AS ENTRY
;
        ;SETDP   $D0
;        =====   ===
;
D_STARS  pshs    a,b,x,dp         ;  SAVE ENTRY VALUES
;
DSTARS1  lda     #$D0             ;  SET "DP" REGISTER TO I/O
         tfr     a,dp             ;  .
;
         lda     #$09             ;  SET FIELD COUNT
         pshs    a                ;  .
;
ST_000   dec     0,s              ;  MOVE TO NEXT STAR FIELD
         bne     ST_010           ;  .
;
         jsr     ZERGND           ;  ZERO INTEGRATORS
;
         puls    a                ;  RETURN TO CALLER
         puls    a,b,x,dp,pc      ;  .
;
;
ST_010   jsr     ZERGND           ;  TURN-OFF CRT GUN AND ZERO INTEGRATORS
;
         lda     #$03             ;  SET DOT COUNT
         sta     LIST             ;  .
;
         lda     0,s              ;  FETCH ZOOM VALUE FOR THIS FIELD
         deca                     ;  .
         ldx     #ZSTAR           ;  .
         ldb     a,x              ;  .
         andb    #$7F             ;  .
;
         cmpb    1,s              ;  HAS STAR FIELD REACHED ITS LIMIT ?
         bls     ST_000           ;  .    IF SO, FETCH NEXT STAR FIELD
         subb    2,s              ;  .    MODIFY VECTOR LENGTH WITH ZOOM VALUE
         ble     ST_000           ;  .    .
         stb     <T1LOLC          ;  .    SET VECTOR LENGTH
;
         ldx     #FSTAR           ;  FETCH STAR FIELD POINTER
         lsla                     ;  .
         ldx     a,x              ;  .
;
         jsr     INTMAX           ;  SET BRIGHTNESS
         jsr     DIFDOT           ;  DRAW STAR FIELD
         bra     ST_000           ;  SET-UP FOR NEXT STAR-FIELD
;
;
;  DISPLAY STAR FIELDS FOR HYPERSPACE SEQUENCE
;  ===========================================
;
;        ENTRY VALUES
;             A = OVER-RIDING INTENSITY 
;             B = ZOOM VALUE
;
;        RETURN VALUES
;             SAME AS ENTRY
;
        ;SETDP   $D0
;        =====   ===
;
H_STARS  pshs    a,b,x,dp         ;  SAVE ENTRY VALUES
;
         lda     #$D0             ;  SET "DP" REGISTER TO I/O
         tfr     a,dp             ;  .
;
         lda     #$09             ;  SET FIELD COUNT
         pshs    a                ;  .
;
ST_200   dec     0,s              ;  MOVE TO NEXT STAR FIELD
         bne     ST_210           ;  .
;
         jsr     ZERGND           ;  ZERO INTEGRATORS
;
         puls    a                ;  RETURN TO CALLER
         puls    a,b,x,dp,pc      ;  .
;
;
ST_210   jsr     ZERGND           ;  TURN-OFF CRT GUN AND ZERO INTEGRATORS
;
         lda     #$03             ;  SET DOT COUNTER
         sta     LIST             ;  .
;
         ldx     #WSHIPY          ;  POSITION FOR SWEEPER CENTER
         jsr     POSWID           ;  .
;
         ldb     0,s              ;  FETCH ZOOM VALUE FOR THIS FIELD
         lslb                     ;  .
         lslb                     ;  .
         addb    2,s              ;  .
         ble     ST_200           ;  .    SKIP THIS STAR FIELD ?
         andb    #$7F             ;  .    SET VECTOR LENGTH
         stb     <T1LOLC          ;  .    .
;
         ldx     #FSTAR           ;  FETCH STAR FIELD POINTER
         lda     0,s              ;  .
         deca                     ;  .
         lsla                     ;  .
         ldx     a,x              ;  .
;
         jsr     INTMAX           ;  SET BRIGHTNESS
         jsr     DIFDOT           ;  DRAW STAR FIELD
         bra     ST_200           ;  SET-UP FOR NEXT STAR-FIELD
;
;
;  DETERMINE RANDOM 'Y:X' POSITION
;  ===============================
;
        ;SETDP   $C8
;        =====   ===
;
RANPOS   pshs    d                ;  SAVE ENTRY VALUES
;
         jsr     RANDOM           ;  'Y' POSITION
         sta     0,s              ;  .
;
RANPOS1  jsr     RANDOM           ;  'X' POSITION
         cmpa    #$60             ;  .
         bgt     RANPOS1          ;  .
         cmpa    #$A0             ;  .
         blt     RANPOS1          ;  .
         sta     1,s              ;  .
;
         puls    d                ;  RETURN TO CALLER
         rts                      ;  .
;
;
;  SELECT RANDOM SEED/MINE ENTRY
;  =============================
;
;        ENTRY VALUES:
;             A = MINE TYPE
;             B = MINE SIZE
;
;        RETURN VALUES:
;             SAME AS ENTRY VALUES
;
        ;SETDP   $C8
;        =====   ===
;
RANSEED  pshs    a,b,x,y,u        ;  SAVE ENTRY VALUES
;
         lda     <MINMAX          ;  ALL THE MINES DISPLAYED ?
         lbeq    RANS9            ;  .
         dec     <MINMAX          ;  .
;
         jsr     RANDOM           ;  SET-UP FOR RANDOM ENTRY
         anda    #$1F             ;  .    ENTRY MUST BE BETWEEN $00 AND $1B
RANS1    sta     <ETMP9           ;  .    .
         cmpa    #27              ;  .    .
         bls     RANS2            ;  .    .
         suba    #$4              ;  .    .    TOO BIG - FUDGE DOWN
         bra     RANS1            ;  .    .    .
;
RANS2    ldb     #MIN_LEN         ;  .    CALCULATE ACTUAL MINE ENTRY
         mul                      ;  .    .
         addd    #MIN_TBL         ;  .    .
         tfr     d,u              ;  .    .
;
         lda     MIN_FLG,u        ;  .    MINE ENTRY ACTIVE ?
         anda    #$C0             ;  .    .    MOVING TO INITIAL POSITION OR IDLE ?
         bne     RANS3            ;  .    .
         inc     <ETMP9           ;  .    .    TRY ANOTHER ENTRY
         lda     <ETMP9           ;  .    .    .
         cmpa    #27              ;  .    .    .    STILL WITHIN RANGE ?
         ble     RANS2            ;  .    .    .    .
;
         clr     <ETMP9           ;  .    .    .    OUT-OF-RANGE
         clra                     ;  .    .    .    .
         bra     RANS2            ;  .    .    .    .
;
RANS3    lda     0,s              ;  .    SET MINE TYPE
         sta     MIN_PAK,u        ;  .    .
;
         ldx     #MINSCR          ;  .    SELECT MINE'S BASIC SCORE
         asla                     ;  .    .
         ldy     a,x              ;  .    .
         sty     <ETMP7           ;  .    .
;
         ldb     #$20             ;  .    SET ZOOM FLAG
         stb     MIN_FLG,u        ;  .    .
;
         ldx     #MINSPD          ;  .    SELECT MINE SPEED
         lda     1,s              ;  .    .    FETCH MINE SIZE
         ldb     a,x              ;  .    .
         stb     <ETMP9           ;  .    .
;
         ldx     #MINSZ           ;  .    SET MINE SIZE
         ldb     a,x              ;  .    .
         stb     MIN_T1,u         ;  .    .
         sta     MIN_BSZ,u        ;  .    .
;
         ldx     #MINBOX          ;  .    SELECT COLLISION BOX PARAMETERS
         lsla                     ;  .    .
         ldy     a,x              ;  .    .
         sty     MIN_BOX,u        ;  .    .
;
         ldx     #MINSSCR         ;  .    SELECT MINE'S SCORE VS. SPEED VALUE
         ldy     a,x              ;  .    .
         sty     <ETMP5           ;  .    .
;
         cmpa    #$06             ;  .    SET 'POP' SOUND
         bne     RANS4            ;  .    .    BIG MINES ONLY
         inc     POPSND           ;  .    .    .
;
RANS4    lda     <ETMP5 + 1       ;  .    CALCULATE MINE SCORE VALUE
         adda    <ETMP7 + 1       ;  .    .    LSB
         daa                      ;  .    .    .
         sta     MIN_SCR+1,u      ;  .    .    .
         lda     <ETMP5           ;  .    .    MSB
         adca    <ETMP7           ;  .    .    .
         daa                      ;  .    .    .
         sta     MIN_SCR,u        ;  .    .    .
;
         lda     <ETMP9           ;  .    CALCULATE MINE DISPLACEMENTS
         jsr     CONE             ;  .    .    SELECT ANGLE
         jsr     MLTY8            ;  .    .    FORM DISPLACEMENTS
         sty     MIN_YD,u         ;  .    .    .    SAVE 'Y' DISPLACEMENTS
         stx     MIN_XD,u         ;  .    .    .    SAVE 'X' DISPLACEMENTS
;
         inc     <CMINES          ;  .    BUMP ACTIVE MINE COUNTER
;
         lda     <RESEED          ;  .    RESET FORCED MINE GROWTH TIMER
         beq     RANS9            ;  .    .    SKIP IF NOT RE-SEEDED
;
         lda     #$FF             ;  .    .    RESET TIMER #1
         sta     <TMR1            ;  .    .    .
         lda     #$03             ;  .    .    RESET FORCE COUNTER
         sta     <FRCTIME         ;  .    .    .
;
RANS9    puls    a,b,x,y,u,pc     ;  RETURN TO CALLER
;   
;
;  SELECT DIRECTION WITHIN LIMIT CONES
;  ===================================
;
;        ENTRY VALUES
;             NONE REQUIRED
;
;        RETURN VALUES
;             B = RANDOM ANGLE WITHIN LIMIT CONES
;
        ;SETDP   $C8
;        =====   ===
;
CONE     pshs    a,b              ;  SAVE ENTRY VALUES
;
         jsr     RANDOM           ;  FETCH RANDOM NUMBER
         tfr     a,b              ;  .    SET-UP FOR CONE TESTS
         anda    #$30             ;  .    .
         sta     1,s              ;  .    .
;
         andb    #$0F             ;  LIMIT DIRECTION WITHIN CONE
         cmpb    #$04             ;  .    TEST AGAINST LOW-END LIMIT
         bhs     CONE1            ;  .    .
         addb    #$04             ;  .    .    MOVE LOW-END UP
;
CONE1    cmpb    #$0C             ;  .    TEST AGAINST UPPER-END LIMIT
         bls     CONE2            ;  .    .
         subb    #$04             ;  .    .    MOVE UPPER-END DOWN
;
CONE2    addb    1,s              ;  ADD QUADRANT TO DIRECTION
         stb     1,s              ;  .
         puls    a,b,pc           ;  .    RETURN TO CALLER
;
;
;  POSITION AND DRAW DOT
;  =====================
;
;        ENTRY VALUES
;             Y = ABSOLUTE 'YX' POSITION
;
;        RETURN VALUES
;             SAME AS ENTRY VALUES
;
;
        ;SETDP   $D0
;        =====   ===
;
ADOT     pshs    a,b              ;  SAVE ENTRY VALUES
;
         lda     #$7F             ;  POSITION DOT
         sta     <T1LOLC          ;  .    SET VECTOR LENGTH
         tfr     y,d              ;  .    SET 'YX' POSITION
         jsr     DOTAB            ;  .    .
;
         jsr     ZERGND           ;  ZERO INTEGRATORS
;
         puls    a,b,pc           ;  RETURN TO CALLER
;
;
;  POSITION WITH 16-BIT VALUES AND DRAW DOT
;  ========================================
;
;        ENTRY VALUES
;             Y = POINTER TO 32-BIT ABSOLUTE 'YX' POSITION
;
;        RETURN VALUES
;             SAME AS ENTRY VALUES
;
;
        ;SETDP   $D0
;        =====   ===
;
DDOT     pshs    a,b              ;  SAVE ENTRY VALUES
;
         lda     #$7F             ;  POSITION DOT
         sta     <T1LOLC          ;  .    SET VECTOR LENGTH
;
         lda     0,y              ;  .    SET 'YX' POSITION
         ldb     2,y              ;  .    .
         jsr     DOTAB            ;  .    .
;
         jsr     ZERGND           ;  ZERO INTEGRATORS
;
         puls    a,b,pc           ;  RETURN TO CALLER
;
;
;  POSITION AND DRAW PACKET
;  ========================
;
;        ENTRY VALUES
;             B = ZOOM VALUE
;             X = PACKET ADDRESS
;             Y = ABSOLUTE 'YX' POSITION
;
;        RETURN VALUES
;             SAME AS ENTRY VALUES
;
;
        ;SETDP   $D0
;        =====   ===
;
APACK    pshs    a,b,x            ;  SAVE ENTRY VALUES
;
         tfr     y,d              ;  .    SET 'YX' POSITION
         jsr     POSITD           ;  .    .
;
         ldb     1,s              ;  DRAW PACKET
         jsr     TPACK            ;  .    DRAW PACKET
;
         puls    a,b,x,pc         ;  RETURN TO CALLER
;
;
;  POSITION WITH 16-BIT VALUES AND DRAW PACKET
;  ===========================================
;
;        ENTRY VALUES
;             B = ZOOM VALUE
;             X = ADDRESS OF PACKET
;             Y = POINTER TO 32-BIT ABSOLUTE 'YX' POSITION
;
;        RETURN VALUES
;             SAME AS ENTRY VALUES
;
;
        ;SETDP   $D0
;        =====   ===
;
DPACK    pshs    a,b,x            ;  SAVE ENTRY VALUES
;
         tfr     y,x              ;  POSITION PACKET
         jsr     POSWID           ;  .
;
         ldb     1,s              ;  DRAW PACKET
         ldx     2,s              ;  .    FETCH PACKET POINTER
         jsr     TPACK            ;  .    DRAW PACKET
;
         puls    a,b,x,pc         ;  RETURN TO CALLER
;
;
;  DRAW COMPACT RASTER MESSAGE
;  ===========================
;
;        ENTRY VALUES
;             U = ADDRESS OF MESSAGE
;
;        RETURN VALUES
;             SAME AS ENTRY VALUES
;
;
        ;SETDP   $D0
;        =====   ===
;
MESS     pshs    a,b,x,u          ;  SAVE ENTRY VALUES
;
         lda     #$7F             ;  POSITION PACKET
         sta     <T1LOLC          ;  .    SET VECTOR LENGTH
;
         jsr     RSTSIZ           ;  DRAW RASTER MESSAGE
;
         puls    a,b,x,u,pc       ;  RETURN TO CALLER
;
;
;  POSITION AND DRAW RASTER MESSAGE
;  ================================
;
;        ENTRY VALUES
;             U = ADDRESS OF MESSAGE
;             Y = ABSOLUTE 'YX' POSITION
;
;        RETURN VALUES
;             SAME AS ENTRY VALUES
;
;
        ;SETDP   $D0
;        =====   ===
;
AMESS    pshs    a,b,x,u          ;  SAVE ENTRY VALUES
;
         tfr     y,d              ;  .    SET 'YX' POSITION
         jsr     POSITD           ;  .    .
;
         jsr     RASTER           ;  .    DRAW PACKET
;
         puls    a,b,x,y,pc       ;  RETURN TO CALLER
;
;
;  DRAW ACTIVE PLAYER'S SCORES
;  ===========================
;
        ;SETDP   $D0
;        =====   ===
;
SCRMES   jsr     INTMAX           ;  SET MAXIMUM INTENSITY
;
         ldd     #$FC38           ;  SET RASTER SIZE
         std     SIZRAS           ;  .
;
         lda     ACTPLY           ;  FETCH POSITION OF SCORE
         ldy     #PSCRPTR         ;  .
         ldy     a,y              ;  .
;
         ldu     #SCRPTR          ;  FETCH ADDRESS OF SCORE
         ldu     a,u              ;  .
         bsr     AMESS            ;  .
;
         rts                      ;  RETURN TO CALLER
;
;
;  DRAW BOTH PLAYER'S SCORES
;  =========================
;
        ;SETDP   $D0
;        =====   ===
;
SCRBTH   jsr     INTMAX           ;  SET MAXIMUM INTENSITY
;
         ldd     #$FC38           ;  SET RASTER SIZE
         std     SIZRAS           ;  .
;
         ldy     #PSCOR1          ;  DRAW PLAYER #1 SCORE
         ldu     #SCOR1           ;  .
         bsr     AMESS            ;  .
;
         lda     PLAYRS           ;  ONE OR TWO PLAYERS ?
         beq     BOTH9            ;  .
         ldy     #PSCOR2          ;  .    DRAW PLAYER #2 SCORE
         ldu     #SCOR2           ;  .    .
         bsr     AMESS            ;  .    .
;
BOTH9    rts                      ;  RETURN TO CALLER
;
;
;  WAIT FOR FRAME BOUNDARY AND INPUT FROM CONTROLLER
;  =================================================
;
;
WAIT     jsr     FRWAIT           ;  WAIT FOR FRAME BOUNDARY
         pshs    dp               ;  .
        ;SETDP   $D0              ;  .
;
         jsr     DEFLOK           ;  PREVENT SCAN COLLAPSE
         jsr     SCRMES           ;  DRAW PLAYER'S SCORES
;
         lda     SBTN             ;  INPUT CONSOLE SWITCHES
         jsr     DBNCE            ;  .
         ldd     SJOY             ;  READ JOYSTICK
         std     EPOT0            ;  .    ENABLE BOTH POTS ON JOYSTICK #1
         std     EPOT2            ;  .    ENABLE BOTH POTS ON JOYSTICK #2
         jsr     JOYBIT           ;  .
;
         lda     #$C8             ;  SET "DP" REGISTER TO RAM
         tfr     a,dp             ;  .
        ;SETDP   $C8              ;  .
;
TIMER    lda     <TMR1            ;  DOWN-COUNT TIMER #1
         beq     DCT2             ;  .    IS TIMER INHIBITED ?
         dec     <TMR1            ;  .
         bne     DCT2             ;  .
         jsr     [TMR1+1]         ;  .    EXECUTE THE USER PROGRAM
;
DCT2     lda     <TMR2            ;  DOWN-COUNT TIMER #2
         beq     DCT3             ;  .    IS TIMER INHIBITED ?
         dec     <TMR2            ;  .
         bne     DCT3             ;  .
         jsr     [TMR2+1]         ;  .    EXECUTE THE USER PROGRAM
;
DCT3     lda     <TMR3            ;  DOWN-COUNT TIMER #3
         beq     DCT4             ;  .    IS TIMER INHIBITED ?
         dec     <TMR3            ;  .
         bne     DCT4             ;  .
         jsr     [TMR3+1]         ;  .    EXECUTE THE USER PROGRAM
;
DCT4     lda     <TMR4            ;  DOWN-COUNT TIMER #4
         beq     WAIT9            ;  .    IS TIMER INHIBITED ?
         dec     <TMR4            ;  .
         bne     WAIT9            ;  .
         jsr     [TMR4+1]         ;  .    EXECUTE THE USER PROGRAM
;
WAIT9    puls    dp,pc            ;  RETURN TO CALLER
;
;
;  HANDLE BULLET VS. MINE COLLISIONS
;  =================================
;
        ;SETDP   $C8
;        =====   ===
;
CBULMIN  lda     <CBULLET         ;  ACTIVE BULLETS ?
         beq     CBUL20           ;  .
;
         ldy     #BLT_TBL         ;  FIND BULLET TO COMPARE WITH
         lda     #BULLETS         ;  .
         sta     <TEMP1           ;  .
;
CBUL1    tst     BLT_FLG,y        ;  .    BULLET ACTIVE ?
         bne     CBUL3            ;  .    .
;
CBUL2    leay    BLT_LEN,y        ;  .    BUMP TO NEXT ENTRY
         dec     <TEMP1           ;  .    .    END OF TABLE ?
         bne     CBUL1            ;  .    .    .
CBUL20   rts                      ;  .    RETURN - NO ACTIVE BULLET FOUND
;
;
CBUL3    lda     <LAYRSPD         ;  COMPARE BULLET VS. MINE-LAYER
         beq     CBUL30           ;  .    IS MINE-LAYER OFF-SCREEN ?
;
         pshs    y                ;  .    FINE COLLISION TEST
         lda     BLT_WY,y         ;  .    .    FETCH BULLET POSITION
         ldb     BLT_WX,y         ;  .    .    .
         tfr     d,x              ;  .    .    .
         ldd     #P_LYRBX         ;  .    .    FETCH MINE-LAYER BOX SIZE
         ldy     <LAYRYX          ;  .    .    FETCH MINE-LAYER POSITION
         jsr     BXTEST           ;  .    .    DO BOX TEST
         puls    y                ;  .    .    .    FAILED COLLISION ?
         bcc     CBUL30           ;  .    .    .    .
;
         clr     BLT_FLG,y        ;  .    COLLISION DETECTED - RESET CONDITIONS
         clr     <LAYRSPD         ;  .    .    RESET MINE LAYER
         clr     <TMR3            ;  .    .    .    INSERTION TIMER
;
         ldx     #SCRPTR          ;  .    .    ADD POINTS TO ACTIVE PLAYER SCORE
         lda     <ACTPLY          ;  .    .    .    PLAYER #1 OR #2 ?
         ldx     a,x              ;  .    .    .    .
         ldd     #$1000           ;  .    .    .
         jsr     SCRADD           ;  .    .    .
;
         lda     #$30             ;  .    .    ENTER COLLISION IN EXPLOSION TABLE
         ldb     #$70             ;  .    .    .    SET EXPLOSION SIZE
         ldx     <LAYRYX          ;  .    .    .    SET EXPLOSION CENTRE
         jsr     SETEXP           ;  .    .    .    SET EXPLOSION IN TABLE
;
         dec     <CBULLET         ;  .    .    DECREMENT ACTIVE BULLET COUNTER
         bra     CBUL20           ;  .    .    .
;
;
CBUL30   ldu     #MIN_TBL         ;  FIND MINE TO COMPARE AGAINST BULLET
         lda     #MINES           ;  .
         sta     <TEMP2           ;  .
;
CBUL4    lda     MIN_FLG,u        ;  .    MINE ACTIVE ?
         anda    #$3F             ;  .    .
         bne     CBUL6            ;  .    .
;
CBUL5    leau    MIN_LEN,u        ;  .    BUMP TO NEXT ENTRY
         dec     <TEMP2           ;  .    .    END OF TABLE ?
         bne     CBUL4            ;  .    .    .
         bra     CBUL2            ;  .    NO ACTIVE MINE FOUND - NEXT BULLET
;
CBUL6    pshs    y                ;  .    FINE COLLISION TEST
         lda     BLT_WY,y         ;  .    .    FETCH BULLET POSITION
         ldb     BLT_WX,y         ;  .    .    .
         tfr     d,x              ;  .    .    .
         lda     MIN_YW,u         ;  .    .    FETCH MINE POSITION
         ldb     MIN_XW,u         ;  .    .    .
         tfr     d,y              ;  .    .    .
         ldd     MIN_BOX,u        ;  .    .    FETCH MINE BOX SIZE
         jsr     BXTEST           ;  .    .    DO BOX TEST
         puls    y                ;  .    .    .    FAILED COLLISION ?
         bcc     CBUL5            ;  .    .    .    .
;
         lda     MIN_PAK,u        ;  .    COLLISION DETECTED
         anda    #$02             ;  .    .     FIREBALL RELEASED ?
         beq     CBUL7            ;  .    .     .
;
;
         ldx     #SCRPTR          ;  'FIRE-BALL' RELEASED
         lda     <ACTPLY          ;  .    ADD MINE TO ACTIVE PLAYER SCORE
         ldx     a,x              ;  .    .    PLAYER #1 OR #2 ?
         ldd     MIN_SCR,u        ;  .    .   
         jsr     SCRADD           ;  .    .
;
         inc     FIRSND           ;  .    SET 'FIRE-BALL' SOUND
;
         lda     MIN_YW,u         ;  .    SET SMALL EXPLOSION
         ldb     MIN_XW,u         ;  .    .    SET POSITION
         tfr     d,x              ;  .    .    .
         lda     MIN_SIZ,u        ;  .    .    SET STARTING SIZE
         ldb     #$20             ;  .    .    SET MAXIMUM SIZE
         jsr     SETEXP           ;  .    .    .
;
         ldd     #$0110           ;  .    CHANGE SCORE VALUE FOR FIRE-BALL
         std     MIN_SCR,u        ;  .    .
;
         lda     <WSHIPY          ;  .    CALCULATE DELTA YX VALUES
         suba    MIN_YW,u         ;  .    .
         ldb     <WSHIPX          ;  .    .
         subb    MIN_XW,u         ;  .    .
;
         jsr     CMPASS           ;  .    CALCULATE ANGLE TO SHIP
         suba    #$10             ;  .    .
         tfr     a,b              ;  .    .
;
         pshs    y                ;  .    CALCULATE NEW DISPLACEMENTS
         lda     #$3F             ;  .    .    SET FIRE-BALL SPEED
         jsr     MLTY8            ;  .    .    FETCH NEW DISPLACEMENTS
;
         sty     MIN_YD,u         ;  .    .    SAVE NEW 'Y' DISPLACEMENT
         stx     MIN_XD,u         ;  .    .    SAVE NEW 'X' DISPLACEMENT
         puls    y                ;  .    .
;
         clr     BLT_FLG,y        ;  .    RESET BULLET FLAG
;
         ldd     #$0404           ;  .    SET NEW COLLISION BOX
         std     MIN_BOX,u        ;  .    .
;
         lda     MIN_PAK,u        ;  .    GROW 2 NEW MINES
         ldb     MIN_BSZ,u        ;  .    .
         decb                     ;  .    .
         beq     CBUL60           ;  .    .
         jsr     RANSEED          ;  .    .
         jsr     RANSEED          ;  .    .
;
CBUL60   lda     #$04             ;  .    SET FIRE-BALL FLAG
         sta     MIN_PAK,u        ;  .    .
;
         dec     <CBULLET         ;  .    DECREMENT ACTIVE BULLET COUNT
         jmp     CBUL2            ;  .    TRY NEXT BULLET FOR COLLISION
;
;
CBUL7    lda     #$01             ;  'DUMB' OR 'MAGNETIC' MINE COLLISION
         sta     MIN_FLG,u        ;  .    FLAG MINE FOR EXPLOSION
         clr     BLT_FLG,y        ;  .    RESET BULLET
;
         ldx     #SCRPTR          ;  .    ADD MINE TO ACTIVE PLAYER SCORE
         lda     <ACTPLY          ;  .    .    PLAYER #1 OR #2 ?
         ldx     a,x              ;  .    .    .
         ldd     MIN_SCR,u        ;  ADD MINE TO SCORE
         jsr     SCRADD           ;  .
;
         lda     MIN_YW,u         ;  ENTER COLLISION IN EXPLOSION TABLE
         ldb     MIN_XW,u         ;  .    SET EXPLOSION CENTRE
         tfr     d,x              ;  .    .
         lda     MIN_SIZ,u        ;  .    SET EXPLOSION STARTING SIZE
         ldb     #$40             ;  .    SET EXPLOSION MAXIMUM SIZE
         jsr     SETEXP           ;  .    SET EXPLOSION IN TABLE
;
         dec     <CMINES          ;  .    DECREMENT ACTIVE MINE COUNT
         dec     <CBULLET         ;  .    DECREMENT ACTIVE BULLET COUNT
CBUL9    jmp     CBUL2            ;  .    TRY NEXT BULLET FOR COLLISION
;
;
;  HANDLE MINE VS. SHIP COLLISIONS
;  ===============================
;
        ;SETDP   $C8
;        =====   ===
;
CMINSHIP lda     <ABORT           ;  GAME ABORTED ?
         bne     CMIN3            ;  .    SKIP COLLISION DETECTION
;
         lda     <HYPFLAG         ;  .    HYPER-SPACE SEQUENCE ?
         bne     CMIN3            ;  .    .
;
         ldy     #MIN_TBL         ;  FIND MINE TO COMPARE WITH
         lda     #MINES           ;  .
         sta     <TEMP1           ;  .
;
CMIN1    lda     MIN_FLG,y        ;  .    MINE ACTIVE ?
         anda    #$3F             ;  .    .
         bne     CMIN4            ;  .    .
;
CMIN2    leay    MIN_LEN,y        ;  .    BUMP TO NEXT ENTRY
         dec     <TEMP1           ;  .    .    END OF TABLE ?
         bne     CMIN1            ;  .    .    .
CMIN3    rts                      ;  .    RETURN - NO ACTIVE MINE
;
CMIN4    pshs    y                ;  FINE COLLISION TEST
         lda     <WSHIPY          ;  .    FETCH SHIP POSITION
         ldb     <WSHIPX          ;  .    .
         tfr     d,x              ;  .    .
         lda     MIN_YW,y         ;  .    FETCH MINE POSITION
         ldb     MIN_XW,y         ;  .    .
         ldy     MIN_BOX,y        ;  .    FETCH MINE BOX SIZE
         exg     y,d              ;  .    .
         jsr     BXTEST           ;  .    DO BOX TEST
         puls    y                ;  .    .    FAILED COLLISION ?
         bcc     CMIN2            ;  .    .    .
;
         clr     MIN_FLG,y        ;  COLLISION DETECTED - RESET CONDITIONS
         clr     <MINMAX          ;  .    RESET TOTAL MINE COUNT
;
         lda     <WSHIPY          ;  ENTER COLLISION IN EXPLOSION TABLE
         ldb     <WSHIPX          ;  .    SET EXPLOSION CENTRE
         tfr     d,x              ;  .    .
         lda     MIN_SIZ,y        ;  .    SET STARTING EXPLOSION SIZE
         ora     #$80             ;  .    .    FATAL HIT TO SWEEPER
         ldb     #$30             ;  .    SET EXPLOSION SIZE
         jsr     SETEXP           ;  .    SET EXPLOSION IN TABLE
;
         inc     EXPLSND          ;  SET EXPLOSION SOUND FLAG
;
         dec     <CMINES          ;  DECREMENT ACTIVE MINE COUNT
         bra     CMIN3            ;  TRY NEXT MINE ENTRY
;
;
;  HANDLE SHIP VS. MINE-LAYER COLLISION
;  ====================================
;
        ;SETDP   $C8
;        =====   ===
;
CSHPLYR  lda     <ABORT           ;  GAME ABORTED ?
         bne     CSHP0            ;  .    SKIP COLLISION DETECTION
;
         lda     <HYPFLAG         ;  .    HYPER-SPACE SEQUENCE ?
         bne     CSHP0            ;  .    .
;
         lda     <LAYRSPD         ;  MINE-LAYER OFF-SCREEN ?
         beq     CSHP0            ;  .    IF SO, SKIP COLLISION DETECTION
;
         lda     <WSHIPY          ;  PERFORM FINE BOX TEST
         ldb     <WSHIPX          ;  .    FETCH SHIP POSITION
         tfr     d,x              ;  .    .
         ldd     #P_LYRBX         ;  .    FETCH MINE-LAYER COLLISION BOX
         ldy     <LAYRYX          ;  .    FETCH MINE-LAYER POSITION
         jsr     BXTEST           ;  .    DO BOX TEST
         bcs     CSHP1            ;  .    .    PASS COLLISION TEST ?
CSHP0    rts                      ;  .    .    .    NO COLLISION - RETURN
;
CSHP1    clr     <LAYRSPD         ;  COLLISION DETECTED - RESET MINE-LAYER
         clr     <TMR3            ;  .
;
         lda     <WSHIPY          ;  ENTER COLLISION IN EXPLOSION TABLE
         ldb     <WSHIPX          ;  .    SET EXPLOSION CENTRE
         tfr     d,x              ;  .    .
         lda     #P_LYRSZ         ;  .    SET STARTING EXPLOSION SIZE
         ora     #$80             ;  .    .    FATAL TO SWEEPER
         ldb     #$30             ;  .    SET EXPLOSION SIZE
         jsr     SETEXP           ;  .    SET EXPLOSION IN TABLE
;
         inc     EXPLSND          ;  SET EXPLOSION SOUND FLAG
;
         rts                      ;  RETURN TO CALLER
;
;   
;
;  SOUND HANDLER
;  =============
;
        ;SETDP   $D0
;        =====   ===
;
SOUND    lda     THRSND           ;  THRUSTER SOUND ?
         beq     SND1             ;  .
;
         clr     THRSND           ;  .    RESET THRUSTER SOUND FLAG
         ldu     #SS_THR          ;  .    SET THRUSTER SOUND
         bra     SND10            ;  .    .
;
SND1     lda     EXPLSND          ;  EXPLOSION SOUND ?
         beq     SND2             ;  .
;
         clr     EXPLSND          ;  .    RESET EXPLOSION SOUND FLAG
         ldu     #SS_EXP          ;  .    SET EXPLOSION SOUND
         bra     SND10            ;  .    .
;
SND2     lda     BLTSND           ;  BULLET SOUND ?
         beq     SND3             ;  .
;
         clr     BLTSND           ;  .    RESET BULLET SOUND FLAG
         ldu     #SS_BLT          ;  .    SET BULLET SOUND
         bra     SND10            ;  .    .
;
SND3     lda     POPSND           ;  MINE-SEED 'POP' SOUND ?
         beq     SND31            ;  .
;
SND32    clr     POPSND           ;  .    RESET 'POP' SOUND FLAG
         clr     HYPSND           ;  .    RESET 'HYPER-SPACE' SOUND FLAG
         ldu     #SS_POP          ;  .    SET 'POP' SOUND
         bra     SND10            ;  .    .
;
SND31    lda     HYPSND           ;  HYPER-SPACE SOUND ?
         bne     SND32            ;  .
;
         bra     SND18            ;  UPDATE SOUND
;
;
SND10    jsr     PSGLST           ;  UPDATE PSG
;
SND18    ldb     REG0             ;  SLIDE TONE 'A' FREQUENCY
         addb    #$10             ;  .
         cmpb    #$A0             ;  .
         bhs     STTNA            ;  .
         lda     #00              ;  .
         jsr     WRREG            ;  .
         bra     CKTNB            ;  .
;
STTNA    ldd     #$0800           ;  .    SET 'A' AMPLITUDE = $00
         jsr     WRREG            ;  .    .
;
CKTNB    ldb     REG2             ;  SLIDE TONE 'B' FREQUENCY
         addb    #$20             ;  .
         cmpb    #$F0             ;  .
         bhs     STTNB            ;  .
         lda     #$02             ;  .
         jsr     WRREG            ;  .
         bra     RUSND            ;  .
;
STTNB    ldd     #$0900           ;  .    SET 'B' AMPLITUDE = $00
         jsr     WRREG            ;  .    .
;
RUSND    rts                      ;  RETURN TO CALLER
;     
;
;        SOUND LIBRARY
;        -------------
;
;
SS_THR   dw      $0010            ;  THRUSTER SOUND
         dw      $0100            ;  .
         dw      $061F            ;  .
         dw      $0706            ;  .
         dw      $080F            ;  .
         db      $FF              ;  .    TERMINATOR
;
;
SS_BLT   dw      $0239            ;  BULLET SOUND
         dw      $0300            ;  .
         dw      $061F            ;  .
         dw      $0705            ;  .
         dw      $090F            ;  .
         db      $FF              ;  .    TERMINATOR
;
;
SS_EXP   dw      $061F            ;  OJECT EXPLOSION SOUND
         dw      $0707            ;  .
         dw      $0A10            ;  .
         dw      $0B00            ;  .
         dw      $0C38            ;  .
         dw      $0D00            ;  .
         db      $FF              ;  .    TERMINATOR
;
;
SS_POP   dw      $0000            ;  MINE 'POP' SOUND
         dw      $0100            ;  .
         dw      $0230            ;  .
         dw      $0300            ;  .
         dw      $0400            ;  .
         dw      $0500            ;  .
         dw      $061F            ;  .
         dw      $073D            ;  .
         dw      $0800            ;  .
         dw      $090F            ;  .
         dw      $0A00            ;  .
         dw      $0B00            ;  .
         dw      $0C00            ;  .
         dw      $0D00            ;  .
         db      $FF              ;  .    TERMINATOR
;
;
;       LAYER TUNE
;       ----------
;
;
QSC      equ     50
SC8      equ     25
;
G2       equ     $00
GS2      equ     $01
CS3      equ     $06
C3       equ     $05
;
LAYTUNE  dw      FADE66
         dw      VIBENL
         db      G2,SC8
         db      GS2,SC8
         db      G2,SC8
         db      GS2,QSC
         db      G2,SC8
         db      GS2,SC8
         db      G2,SC8
         db      CS3,SC8
         db      C3,SC8
         db      G2,$80
;
;
FADE66   dw      $FFEE,$DDCC,$BBAA,$9988,$7777
         dw      $7777,$7777,$7777
;
;
;
SCRPTR   dw      SCOR1            ;  POINTERS TO PLAYER SCORES
         dw      SCOR2            ;  .
;
PSCRPTR  dw      PSCOR1           ;  SCREEN POSITIONS OF PLAYER SCORES
         dw      PSCOR2           ;  .
;
PMNLVL   dw      MNLVL1           ;  POINTERS TO PLAYERS MINE-LEVEL MESSAGES
         dw      MNLVL2           ;  .
;
;==========================================================================JJH
;                                   =======================================JJH
;  GAME SEQUENCE PARAMETER TABLES   ==  DELETED - REV. C CHANGES  =========JJH
;  ==============================   =======================================JJH
;                                                                    ======JJH
;        LEVEL #1 PARAMETER TABLES                                   ======JJH
;        -------------------------                                   ======JJH
;                                                                    ======JJH
;MINTBL1 db      M_DUMB           ;  MINE TYPE TABLE                 ======JJH
;        db      M_DUMB           ;  .                               ======JJH
;        db      M_DUMB           ;  .                               ======JJH
;        db      M_DUMB           ;  .                               ======JJH
;                                                                    ======JJH
;        LEVEL #2 PARAMETER TABLE                                    ======JJH
;        ------------------------                                    ======JJH
;                                                                    ======JJH
;MINTBL2 db      M_FIRE           ;  MINE TYPE TABLE                 ======JJH
;        db      M_DUMB           ;  .                               ======JJH
;        db      M_DUMB           ;  .                               ======JJH
;        db      M_DUMB           ;  .                               ======JJH
;                                                                    ======JJH
;        LEVEL #3 PARAMETER TABLE                                    ======JJH
;        ------------------------                                    ======JJH
;                                                                    ======JJH
;MINTBL3 db      M_MAG            ;  MINE TYPE TABLE                 ======JJH
;        db      M_DUMB           ;  .                               ======JJH
;        db      M_DUMB           ;  .                               ======JJH
;        db      M_DUMB           ;  .                               ======JJH
;                                                                    ======JJH
;        LEVEL #4 PARAMETER TABLE                                    ======JJH
;        ------------------------                                    ======JJH
;                                                                    ======JJH
;MINTBL4 db      M_MFIRE          ;  MINE TYPE TABLE                 ======JJH
;        db      M_DUMB           ;  .                               ======JJH
;        db      M_DUMB           ;  .                               ======JJH
;        db      M_DUMB           ;  .                               ======JJH
;                                                                    ======JJH
;        LEVEL #5 PARAMETER TABLE                                    ======JJH
;        ------------------------                                    ======JJH
;                                                                    ======JJH
;MINTBL5 db      M_FIRE           ;  MINE TYPE TABLE                 ======JJH
;        db      M_MAG            ;  .                               ======JJH
;        db      M_DUMB           ;  .                               ======JJH
;        db      M_DUMB           ;  .                               ======JJH
;                                                                    ======JJH
;        LEVEL #6 PARAMETER TABLE                                    ======JJH
;        ------------------------                                    ======JJH
;                                                                    ======JJH
;MINTBL6 db      M_FIRE           ;  MINE TYPE TABLE                 ======JJH
;        db      M_MFIRE          ;  .                               ======JJH
;        db      M_DUMB           ;  .                               ======JJH
;        db      M_DUMB           ;  .                               ======JJH
;                                                                    ======JJH
;        LEVEL #7 PARAMETER TABLE                                    ======JJH
;        ------------------------                                    ======JJH
;                                                                    ======JJH
;MINTBL7 db      M_MAG            ;  MINE TYPE TABLE                 ======JJH
;        db      M_MFIRE          ;  .                               ======JJH
;        db      M_DUMB           ;  .                               ======JJH
;        db      M_DUMB           ;  .                               ======JJH
;                                                                    ======JJH
;        LEVEL #8 PARAMETER TABLE                                    ======JJH
;        ------------------------                                    ======JJH
;                                                                    ======JJH
;MINTBL8 db      M_FIRE           ;  MINE TYPE TABLE                 ======JJH
;        db      M_FIRE           ;  .                               ======JJH
;        db      M_DUMB           ;  .                               ======JJH
;        db      M_DUMB           ;  .                               ======JJH
;                                                                    ======JJH
;        LEVEL #9 PARAMETER TABLE                                    ======JJH
;        ------------------------                                    ======JJH
;                                                                    ======JJH
;MINTBL9 db      M_MAG            ;  MINE TYPE TABLE                 ======JJH
;        db      M_MAG            ;  .                               ======JJH
;        db      M_DUMB           ;  .                               ======JJH
;        db      M_DUMB           ;  .                               ======JJH
;                                                                    ======JJH
;        LEVEL #10 PARAMETER TABLE                                   ======JJH
;        -------------------------                                   ======JJH
;                                                                    ======JJH
;MINTBL10DB      M_MFIRE          ;  MINE TYPE TABLE                 ======JJH
;        db      M_MFIRE          ;  .                               ======JJH
;        db      M_DUMB           ;  .                               ======JJH
;        db      M_DUMB           ;  .                               ======JJH
;                                                                    ======JJH
;        LEVEL #11 PARAMETER TABLE                                   ======JJH
;        -------------------------                                   ======JJH
;                                                                    ======JJH
;MINTBL11DB      M_FIRE           ;  MINE TYPE TABLE                 ======JJH
;        db      M_FIRE           ;  .                               ======JJH
;        db      M_FIRE           ;  .                               ======JJH
;        db      M_DUMB           ;  .                               ======JJH
;                                                                    ======JJH
;        LEVEL #12 PARAMETER TABLE                                   ======JJH
;        -------------------------                                   ======JJH
;                                                                    ======JJH
;MINTBL12DB      M_MAG            ;  MINE TYPE TABLE                 ======JJH
;        db      M_MAG            ;  .                               ======JJH
;        db      M_MAG            ;  .                               ======JJH
;        db      M_DUMB           ;  .                               ======JJH
;                                                                    ======JJH
;        LEVEL #13 PARAMETER TABLE                                   ======JJH
;        -------------------------                                   ======JJH
;                                                                    ======JJH
;MINTBL13DB      M_MFIRE          ;  MINE TYPE TABLE                 ======JJH
;        db      M_MFIRE          ;  .                               ======JJH
;        db      M_MFIRE          ;  .                               ======JJH
;        db      M_DUMB           ;  .                               ======JJH
;                                                                    ======JJH
;        db      $80              ;  LEVEL PARAMETER TABLE TERMINATOR======JJH
;==========================================================================JJH
;
;==========================================================================JJH
        ;SETDP   $C8              ;  CODE ADDED - REV. C CHANGES     ======JJH
;        =====   ===                                                 ======JJH
;                                                                    ======JJH
REVC_0   lda     #$0C             ;  .    LAST GAME SEQUENCE ?       ======JJH
         suba    0,x              ;  .    .                          ======JJH
         suba    1,x              ;  .    .                          ======JJH
         suba    2,x              ;  .    .                          ======JJH
         suba    3,x              ;  .    .                          ======JJH
         beq     REVC_09          ;  .    .                          ======JJH
;                                                                    ======JJH
         ldb     0,x              ;  .    INCREMENT MINE #1 TYPE     ======JJH
         addb    #$FD             ;  .    .                          ======JJH
         andb    #$03             ;  .    .                          ======JJH
         stb     0,x              ;  .    .                          ======JJH
;                                                                    ======JJH
         ldb     #$FC             ;  .    INCREMENT MINE #2 TYPE     ======JJH
         adcb    1,x              ;  .    .                          ======JJH
         andb    #$03             ;  .    .                          ======JJH
         stb     1,x              ;  .    .                          ======JJH
;                                                                    ======JJH
         ldb     #$FC             ;  .    INCREMENT MINE #3 TYPE     ======JJH
         adcb    2,x              ;  .    .                          ======JJH
         andb    #$03             ;  .    .                          ======JJH
         stb     2,x              ;  .    .                          ======JJH
;                                                                    ======JJH
         ldb     #$FC             ;  .    INCREMENT MINE #4 TYPE     ======JJH
         adcb    3,x              ;  .    .                          ======JJH
         andb    #$03             ;  .    .                          ======JJH
         stb     3,x              ;  .    .                          ======JJH
;                                                                    ======JJH
REVC_09  rts                      ;  .    RETURN TO CALLER           ======JJH
;==========================================================================JJH
;
;==========================================================================JJH
         ds      8                ;  CODE ADDED - REV. C CHANGES     ======JJH
;==========================================================================JJH
;
;
;
;  STAR-FIELD TABLES
;  =================
;
;
STAR_1   db      $C8,$40          ;  STAR FIELD #1
         db      $3F,$00          ;  .
         db      $20,$80          ;  .
         db      $10,$1F          ;  .
;
STAR_2   db      $3F,$3F          ;  STAR FIELD #2
         db      $00,$BF          ;  .
         db      $BF,$BF          ;  .
         db      $C0,$20          ;  .
;
STAR_3   db      $48,$08          ;  STAR FIELD #3
         db      $F8,$30          ;  .
         db      $A8,$10          ;  .
         db      $D0,$A0          ;  .
;
STAR_4   db      $BF,$BF          ;  STAR FIELD #4
         db      $00,$3F          ;  .
         db      $3F,$48          ;  .
         db      $20,$80          ;  .
;
STAR_5   db      $00,$B0          ;  STAR FIELD #5
         db      $48,$38          ;  .
         db      $FB,$38          ;  .
         db      $80,$28          ;  .
;
STAR_6   db      $30,$48          ;  STAR FIELD #6
         db      $80,$80          ;  .
         db      $45,$F0          ;  .
         db      $28,$7F          ;  .
;
STAR_7   db      $3F,$BF          ;  STAR FIELD #7
         db      $A5,$00          ;  .
         db      $D0,$60          ;  .
         db      $20,$28          ;  .
;
STAR_8   db      $B8,$40          ;  STAR FIELD #8
         db      $15,$80          ;  .
         db      $40,$F8          ;  .
         db      $40,$18          ;  .
;
;
;  RASTER MESSAGES
;  ===============
;
;
M_MNFLD  dw      $FA38
         dw      $E0C0
         db      "MINE FIELD",$80
;
M_END    dw      $FA38
         dw      $E0D8
         db      "GAME OVER",$80
;
;
;
;
;  MINES
;  =====
;
;
MINE1    db      $00,$10,$00      ;  'DUMB' MINE
         db      $FF,$20,$A0      ;  .
         db      $FF,$C0,$40      ;  .
         db      $FF,$90,$20      ;  .
         db      $FF,$70,$20      ;  .
         db      $FF,$50,$50      ;  .
         db      $FF,$D0,$90      ;  .
         db      $01              ;  .    PACKET TERMINATOR
;
MINE2    db      $00,$20,$00      ;  'MAGNETIC' MINE
         db      $FF,$30,$B0      ;  .
         db      $FF,$B0,$30      ;  .
         db      $FF,$B0,$D0      ;  .
         db      $FF,$30,$50      ;  .
         db      $FF,$D0,$50      ;  .
         db      $FF,$50,$D0      ;  .
         db      $FF,$50,$30      ;  .
         db      $FF,$D0,$B0      ;  .
         db      $01              ;  .    PACKET TERMINATOR
;
MINE3    db      $FF,$00,$00      ;  'DUMB FIRE-BALL' MINE
         db      $00,$30,$00      ;  .
         db      $FF,$10,$C0      ;  .
         db      $FF,$C0,$10      ;  .
         db      $FF,$C0,$F0      ;  .
         db      $FF,$10,$40      ;  .
         db      $FF,$F0,$40      ;  .
         db      $FF,$40,$F0      ;  .
         db      $FF,$40,$10      ;  .
         db      $FF,$F0,$C0      ;  .
         db      $01              ;  .    PACKET TERMINATOR
;
MINE4    db      $FF,$00,$00      ;  'MAGNETIC FIRE-BALL' MINE
         db      $00,$F0,$D0      ;  .
         db      $FF,$C0,$40      ;  .
         db      $FF,$20,$00      ;  .
         db      $FF,$40,$40      ;  .
         db      $FF,$00,$E0      ;  .
         db      $FF,$40,$C0      ;  .
         db      $FF,$E0,$00      ;  .
         db      $FF,$C0,$C0      ;  .
         db      $FF,$00,$20      ;  .
         db      $01              ;  .    PACKET TERMINATOR
;
MINE5    db      $00,$3F,$00      ;  'RELEASED FIRE-BALL' MINE
         db      $FF,$80,$00      ;  .
         db      $00,$3F,$3F      ;  .
         db      $FF,$00,$80      ;  .
         db      $01              ;  .    PACKET TERMINATOR
;
;
;  EXPLOSION CLOUD
;  ===============
;
;
EXPLODE  db      $FF,$7F,$20
         db      $00,$C0,$10
         db      $FF,$C0,$D0
         db      $FF,$20,$7F
         db      $00,$E0,$C0
         db      $FF,$00,$C0
         db      $FF,$E0,$30
         db      $00,$C0,$00
         db      $FF,$60,$CD
         db      $FF,$A0,$00
         db      $00,$20,$D0
         db      $FF,$3C,$30
         db      $FF,$00,$82
         db      $00,$30,$30
         db      $FF,$D0,$50
         db      $FF,$20,$F0
         db      $01
;
;
;  STAR-SWEEPER SHIP
;  =================
;
;
NSHIP    db      $00,$3F,$00      ;  ANOTHER NEW SHIP
         db      $FF,$C4,$08      ;  .
         db      $FF,$D8,$D8      ;  .
         db      $FF,$20,$00      ;  .
         db      $00,$00,$40      ;  .
         db      $FF,$E0,$00      ;  .
         db      $FF,$28,$D8      ;  .
         db      $FF,$3C,$08      ;  .
         db      $01              ;  .
;
;
;        SHIP PACKETS FOR EXPLOSION
;        --------------------------
;
SHPEX1   db      $00,$3F,$00
         db      $FF,$C4,$08
         db      $01
;
SHPEX2   db      $00,$04,$08
         db      $FF,$D8,$D8
         db      $FF,$20,$00
         db      $01
;
SHPEX3   db      $00,$3F,$00
         db      $FF,$C4,$F8
         db      $01
;
SHPEX4   db      $00,$04,$F8
         db      $FF,$D8,$28
         db      $FF,$20,$00
         db      $01
;
;
;  MINE-LAYER
;  ==========
;
;
LLAYR    db      $00,$20,$00      ;  LEFT PORTION OF MINE-LAYER
         db      $FF,$00,$D8      ;  .
         db      $FF,$D0,$A8      ;  .
         db      $FF,$F0,$40      ;  .
         db      $FF,$08,$18      ;  .
         db      $FF,$18,$F0      ;  .
         db      $FF,$F0,$B8      ;  .
         db      $00,$10,$48      ;  .
         db      $FF,$08,$00      ;  .
         db      $FF,$E8,$10      ;  .
         db      $FF,$F8,$00      ;  .
         db      $00,$08,$00      ;  .
         db      $FF,$00,$06      ;  .
         db      $00,$10,$FA      ;  .
         db      $FF,$08,$00      ;  .
         db      $FF,$00,$F0      ;  .
         db      $00,$10,$18      ;  .
         db      $FF,$F0,$08      ;  .
         db      $01              ;  .    PACKET TERMINATOR
;
RLAYR    db      $00,$20,$00      ;  RIGHT PORTION OF MINE-LAYER
         db      $FF,$00,$28      ;  .
         db      $FF,$D0,$58      ;  .
         db      $FF,$F0,$C0      ;  .
         db      $FF,$08,$E8      ;  .
         db      $FF,$18,$10      ;  .
         db      $FF,$F0,$48      ;  .
         db      $00,$10,$B8      ;  .
         db      $FF,$08,$00      ;  .
         db      $FF,$E8,$F0      ;  .
         db      $FF,$F8,$00      ;  .
         db      $FF,$08,$00      ;  .
         db      $FF,$00,$FA      ;  .
         db      $00,$10,$06      ;  .
         db      $FF,$08,$00      ;  .
         db      $FF,$00,$10      ;  .
         db      $00,$10,$E8      ;  .
         db      $FF,$F0,$F8      ;  .
         db      $01              ;  .    PACKET TERMINATOR
;
MLAYR    db      $FF,$00,$D8      ;  MID-SECTION OF MINE-LAYER
         db      $FF,$E8,$08      ;  .
         db      $FF,$00,$40      ;  .
         db      $FF,$18,$08      ;  .
         db      $FF,$00,$D8      ;  .
         db      $00,$08,$E0      ;  .
         db      $FF,$10,$00      ;  .
         db      $FF,$00,$40      ;  .
         db      $FF,$F0,$00      ;  .
         db      $FF,$00,$C0      ;  .
         db      $01              ;  .    PACKET TERMINATOR
;
LAYER    db      $00,$18,$00      ;  LOW RESOLUTION MINE-LAYER PACKET
         db      $FF,$00,$20      ;  .
         db      $FF,$C8,$70      ;  .
         db      $FF,$10,$A0      ;  .
         db      $FF,$00,$A0      ;  .
         db      $FF,$EC,$A4      ;  .
         db      $FF,$39,$6D      ;  .
         db      $FF,$00,$20      ;  .
         db      $01              ;  .    PACKET TERMINATOR
;
;
;==========================================================================JJH
;                                                                    ======JJH
        ;SETDP   $00              ;  CODE ADDED - REV. B CHANGES     ======JJH
;        =====   ===                                                 ======JJH
;                                                                    ======JJH
REVB_0   clr     FRAME - 1        ;  .    CLEAR HOUSE FOR RESTART    ======JJH
         clr     FRAME            ;  .    .                          ======JJH
         clr     LEG              ;  .    .                          ======JJH
         jmp     COLD0            ;  .    .    RESTART VECTREX       ======JJH
;==========================================================================JJH
;
;==========================================================================JJH
        ;SETDP   $D0              ;  CODE ADDED - REV. C CHANGES     ======JJH
;        =====   ===                                                 ======JJH
;                                                                    ======JJH
REVC_1   lda     SHIPCNT          ;  .    LIMIT NUMBER OF MARKERS    ======JJH
         beq     REVC_19          ;  .    .    SKIP DISPLAY ?        ======JJH
;                                                                    ======JJH
         cmpa    #$08             ;  .    .                          ======JJH
         ble     REVC_11          ;  .    .                          ======JJH
         lda     #$08             ;  .    .                          ======JJH
REVC_11  sta     TEMP1            ;  .    .                          ======JJH
;                                                                    ======JJH
REVC_19  rts                      ;  .    RETURN TO CALLER           ======JJH
;==========================================================================JJH
;
;
         end
