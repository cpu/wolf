SECTION "game", ROMX

INCLUDE "gbhw.inc"

INCLUDE "engine.inc"

INCLUDE "wolf.inc"

game_init::
.first_screen_init:
    SET_HOOK GAME_SCREEN_INIT, splash_init
.first_screen_tick:
    SET_HOOK GAME_SCREEN_TICK, splash_tick
.first_screen_vblank:
    SET_HOOK GAME_SCREEN_VBLANK, splash_vblank
  ret
