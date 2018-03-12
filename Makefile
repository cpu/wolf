ASM = rgbasm
LINK = rgblink
FIX = rgbfix
BGB = wine ../../bgb/bgb.exe
GBTD = wine ../../gbtd/GBTD.EXE
GBMB = wine ../../gbmb/GBMB.EXE

ROM_NAME = wolf
SOURCES = src/memory.asm src/wolf.asm src/engine_init.asm src/lcd.asm src/engine.asm src/tiles.asm src/game.asm src/map.asm src/splash_screen.asm src/world_zero.asm
FIX_FLAGS = -v -p 0

INCDIR = inc
OBJECTS = $(SOURCES:%.asm=%.o)

all: $(ROM_NAME)

$(ROM_NAME): $(OBJECTS)
	$(LINK) -o $@.gb -n $@.sym $(OBJECTS)
	$(FIX) $(FIX_FLAGS) $@.gb

%.o: %.asm
	$(ASM) -i$(INCDIR)/ -o $@ $<

clean:
	rm $(ROM_NAME).gb $(ROM_NAME).sym $(OBJECTS)

tiles:
	$(GBTD)

map:
	$(GBMD)

debug:
	$(BGB) $(ROM_NAME).gb&
