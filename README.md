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
