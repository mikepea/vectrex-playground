Vectrex Playground
==================

Holy moly, I'm learning 6809 assembler so I can noodle with my Vectrex.

This repo is mostly:

* a Vagrant dev box based around Ubuntu Trusty and the linux assembler from
http://www.kingswood-consulting.co.uk/assemblers/
* a build env for github.com/nanoflight/vecx cli-happy emulator
* the asm files from the chrissalo tutorials, converted to work with
as09_142 (which doesn't support uppercase mnemonics anymore)



Handy Links
-----------

### Setting up a modern toolchain for Vectrex dev with CMOC

* https://vandenbran.de/2016/02/01/a-modern-toolchain-for-vectrex-development/
* CMOC - c compiler for vectrex/6809
* Includes details of using vecmulti on Mac: https://github.com/nanoflite/vecmulti
* Also own version of VecX that improves cli support: https://github.com/nanoflite/vecx

### Chris Tumber Tutorial

* http://www.playvectrex.com/designit/christumber/tutorial.txt

### Chris Salomon Tutorial

* http://www.playvectrex.com/designit/chrissalo/toc.htm
* http://malban.de/oldies/vectrex

### Frank Buss

* Bloxorz and how to isometric view: http://www.frank-buss.de/vectrex/
* https://github.com/frankbuss

### GCC on 6809

* https://github.com/bcd/gcc

6809 Assembly Quick Notes
-------------------------

### Hex values begin with $

    $D900  ; 2 byte
    $D9    ; 1 byte

6808 uses 2's compliment for signed numbers (`$FF = -1`, `$80 = -128`), as is normal. But just use decimal
notation for them.
 
### Memory locations:

    $0000 to $7FFF is ROM cart.
    $C800 to $C87F is 'special memory' - used by BIOS (128 bytes)
    $C880 to $CBFF is usable memory (128+4x256 bytes)
    $E000 to $FFFF is Vectrex ROM/BIOS

### Registers:

    A,B,D - A+B are 8-bit, D is 16-bit combination of A+B (A^8+B)
    X,Y   - 16-bit, mostly used for pointers in Indexed Mode Instructions
    U,S   - Stack pointers
    PC    - Program Counter (current address being executed)
    DP    - (8-bit) Direct Addressing page.
    CC    - Condition Code (result of comparison instructions, etc)

### Assembler-fu:

    ; comments are semicolons
    label:  ; labels are handy markers for code loops, branching.
           ORG     $0000  ; start instructions at $0000
    MyVal  EQU     $C880  ; set MyVal as a constant (value $C880)

    #3  ; literal value 3
    #$03 ; also literal value 3

### Instructions:

    LD{A,B,D,S,U,X,Y} {#val,$loc} ; LoaD val or content of loc into register
    ST{A,B,D,...} $loc            ; STore register value into memory loc
    INCA                          ; INCrease value of A by 1.
    DECA                          ; DECrease value of A by 1.
    TFR A,DP                      ; TransFeRs the contents of A into DP
    JMP {a_label,$loc}            ; JuMP to memory loc
    BRA {a_label}                 ; Same as JMP, but max 127 bytes forward/back ('short jump')
    JSR {a_label}                 ; Jump to SubRoutine
    RTS                           ; ReTurn from Subrouting

### Addressing Modes:

    DECA             - Inherent
    LDA #$00         - Immediate
    LDA $C880        - Extended
    LDA $80          - Direct (based on DP page, so with DP=#$C8, this is equiv to LDA $C880)
    LDA #$80,X       - Indexed
    LDA B,X          - Indexed
    LDA ,X++         - Indexed
    LDA [$C880]      - Indexed

### Condition Code (CC) register:

This register keeps track of
the results of previous instructions. It's composed of several pieces
(actually bits) one or more of which are checked by the conditional branches
to determine their effect:

These bits are: Half Carry (H), Negative (N), Zero (Z), Overflow (V) and
Carry (C).

    BEQ ; branch if Zero bit set (Branch Equal)
    BNE ; branch if Zero bit NOT set (Branch Equal)

There are a whole bunch of 'B' instructions (and also 'Long Branch' 'LB'
equivalents) that handle the CC bits (and some combos)

### Branch Instructions

(NB: All Branch instructions have (eg) BCC and LBCC form, for short and long
branching)

    C = Carry
    V = oVerflow
    Z = Zero
    N = Negative
    H = Half Carry

    Instruction      Description               H N Z V C
    ----------------------------------------------------
    BCC              Branch on Carry Clear     C=O
    BCS              Branch on Carry Set       C=1
    BEQ              Branch on Equal           Z=O
    BGE              Branch on >=Zero
    BGT              Branch on > Zero
    BHI              Branch if Higher
    BHS              Branch if Higher or Same
    BLE              Branch on <=Zero
    BLO              Branch on Lower
    BLS              Branch on Lower or Same
    BLT              Branch on < Zero
    BNE              Branch Not Equal
    BPL              Branch on Plus            N=0
    BMI              Branch if Minus           N=1
    BRA              Branch Alwavs
    BRN              Branch Never
    BSR              Branch to Subroutine
    BVC              Branch V=0
    BVS              Branch V=1

### Handy code snippets:

   ships_left EQU $C880
   kill_ship:
     DEC ships_left    ;Decrement the number of ships left by 1
     BEQ game_over     ;Check if that was the last ship, and branch if it was

### MAME Debugger

    See mame/README.md

// vim: number! list!
