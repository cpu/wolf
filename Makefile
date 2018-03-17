# Wolf - by @cpu - 2018
#
# You must have RGBDS (https://github.com/rednex/rgbds) installed and on your
# path for this Makefile to work as-is. If required, update ASM, LINK, and FIX
# to point to the respective rgbds binaries
ASM = rgbasm
LINK = rgblink
FIX = rgbfix

# Several dev tools require wine (https://www.winehq.org/) to operate. Make sure
# wine is on your PATH or update the following var to point to the wine binary
WINE = wine

# Location of tools EXEs
TOOLS_ROOT = $(HOME)/wine/

# BGB (http://bgb.bircd.org/) is the best debugger/emulator available. It's
# designed for Windows but runs effortless under WINE. You must ensure wine is
# installed and on your PATH. Point the BGB var at the exe for BGB. You may also
# run `make -e` and override BGB location with an env var
BGB = $(WINE) $(TOOLS_ROOT)/bgb.exe

# GBTD (http://www.devrs.com/gb/hmgd/gbtd.html) is used to edit game tile data.
# Like BGB it is Windows software that runs well under WINE. Use `make -e` to
# override GBTD location with an env var
GBTD = $(WINE) $(TOOLS_ROOT)/gbtd.exe
# GBMB (http://www.devrs.com/gb/hmgd/gbmb.html) is used for editing game map
# data. It is companion software for GBTD. See above for details.
GBMB = $(WINE) $(TOOLS_ROOT)/gbmb.exe

ROM_NAME = wolf

INCDIR = inc
SRCDIR = src
# TODO@(cpu): Replace this with a dynamic find of *.asm in the src/ directory
SOURCES = $(SRCDIR)/memory.asm $(SRCDIR)/wolf.asm $(SRCDIR)/engine_init.asm $(SRCDIR)/lcd.asm $(SRCDIR)/engine.asm $(SRCDIR)/tiles.asm $(SRCDIR)/game.asm $(SRCDIR)/map.asm $(SRCDIR)/splash_screen.asm $(SRCDIR)/world_zero.asm

FIX_FLAGS = -v -p 0
OBJECTS = $(SOURCES:%.asm=%.o)

all: $(ROM_NAME)

$(ROM_NAME): $(OBJECTS)
	$(LINK) -o $@.gb -n $@.sym $(OBJECTS)
	$(FIX) $(FIX_FLAGS) $@.gb

%.o: %.asm
	$(ASM) -i$(INCDIR)/ -o $@ $<

clean:
	rm $(ROM_NAME).gb $(ROM_NAME).sym $(OBJECTS)

# Run GBTD to edit tile data
tiles:
	$(GBTD) res/wolf.gbr&

# Run GBMD to edit map data
map:
	$(GBMB) res/wolf.gbm&

# Run BGB to emulate/debug the built game ROM
debug:
	$(BGB) $(ROM_NAME).gb&
