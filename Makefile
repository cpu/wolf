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
TOOLS_ROOT = $(HOME)/wine

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

# Output ROM filename
ROM_NAME = wolf

# Includes directory
INCDIR = inc

# ASM source directory
SRCDIR = src

# Sources is populated with all of the *.asm files in SRCDIR as well as all of
# the *.asm files in any of the subdirectories of SRCDIR (recursively)
SOURCES = $(wildcard $(SRCDIR)/*.asm) $(wildcard $(SRCDIR)/**/*.asm)

# Flags for rgbfix:
#   -v = validate header and fix checksums
#   -p 0 = pad image with 0 byte
FIX_FLAGS = -v -p 0

# Objects are SOURCES with the .asm extension replaced with .o
OBJECTS = $(SOURCES:%.asm=%.o)

# Timestamp for building rom snapshots
NOW := $(shell date +"%Y%m%d.%H%M%S")

# Build the ROM
all: $(ROM_NAME)

# Build objects by assembling them from source
%.o: %.asm
# Assemble the source files, specifying the configured inc dir
	$(ASM) -i $(INCDIR)/ -o $@ $<

# Build the ROM by linking the built objects and fixing the ROM
$(ROM_NAME): $(OBJECTS)
# Link the assembled objects, outputting to ROM_NAME.gb, writing a symfile to
# ROM_NAME.sym
	$(LINK) -o $@.gb -n $@.sym $(OBJECTS)
# Fix the ROM header/checksums
	$(FIX) $(FIX_FLAGS) $@.gb

# Clean out build artifacts
.PHONY: clean
clean:
	rm $(ROM_NAME).gb $(ROM_NAME).sym $(OBJECTS)

# Run GBTD to edit tile data
.PHONY: tiles
tiles: res/wolf.gbr
	$(GBTD) $<&

# Run GBMD to edit map data
.PHONY: map
map: res/wolf.gbm
	$(GBMB) $<&

# Run BGB to emulate/debug the built game ROM
.PHONY: debug
debug: $(ROM_NAME)
	$(BGB) $<.gb&

# Build a datestamped ROM snapshot for history's sake
.PHONY: snapshot
snapshot: $(ROM_NAME)
	cp $<.gb snapshots/$(ROM_NAME).$(NOW).gb

# Record a fixed position of the screen into an MP4
.PHONY: record
record:
	ffmpeg -f x11grab -video_size 600x620 -framerate 30 -i :0.0 -b:v 3M screen.recording.mp4

# Convert a recording of the screen from MP4 to a web friendly MP4
.PHONY: record_convert
record_convert: screen.recording.mp4
	ffmpeg -i $< -vcodec libx264 -pix_fmt yuv420p -strict -2 screen.recording.web.mp4
