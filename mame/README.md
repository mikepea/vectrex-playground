MAME Debugger Env
=================

ZOMG! MAME has a debugger!

It's really great for figuring out what the hell is going on in your Vectrex assembly.

Installing
----------

Go to http://www.mame.net/ and find the respective SDL version for
your platform. Or for the lazy MacOS users like me:

    wget http://sdlmame.lngn.net/mame0182-64bit.zip
    unzip mame0182-64bin.zip
    cd mame0182-64bin/roms
    ln -s ../../../noodles vectrex
    cp vectrex.xml mame0182-64bin/hash/

Running
-------

    cd mame0182-64bin
    ./mame64 vectrex yelp_logo_bounce --debug

    # set a 'watchpoint' on r/w on memory location c880
    wpset c880,1,rw
    # list watchpoints
    wplist
    # clear watchpoint 1
    wpclear 1

    # Help text!
    help

    # quit out
    quit

    # can be abbreviated to 'g' and 's'
    go
    step

// vim: number! list!
