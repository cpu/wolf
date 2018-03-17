SECTION "splash", ROMX

INCLUDE "gbhw.inc"

INCLUDE "engine.inc"

INCLUDE "wolf.inc"

INCLUDE "splash.inc"

; splash_init is called during a period when VRAM is accessible and screen setup
; can occur. Tile, background, and OAM memory is initialized for the splash
; screen.
splash_init::
  call tiles_load
  call bg_load
  call oam_clear
  call window_reset
  ; Allow global initialization to continue
  jp game_init_return

; splash_tick is called during timer interrupts when the splash screen is the
; active screen.
splash_tick::
  ; TODO(@cpu): Rather than changing to world_zero after a certain # of ticks we
  ; should show a window that has the ASCII tiles for "Press A to Start" or
  ; something equiv and then poll joypad to decide when to do the screen
  ; transition.
.increment_splash_counter
  push hl
    ld hl, SPLASH_COUNTER
    ld a, [hl]
    inc a
    ld [SPLASH_COUNTER], a
  pop hl
.check_splash_counter
  cp SPLASH_SCREEN_WAIT
  jp nz, .continue
.next_screen_init:
  SET_HOOK NEXT_SCREEN_INIT, world_zero_init
  SET_HOOK NEXT_SCREEN_TICK, world_zero_tick
  SET_NEXT_SCREEN 1
  ld a, 0
  ld [SPLASH_COUNTER], a
.continue:
  jp game_tick_return

; tiles_load copies initial game tile data to VRAM
tiles_load:
  push hl
  push de
  push bc
    ; Load splash tile data
    ld hl, splash_tile_data
    ld de, _VRAM
    ld bc, splash_tile_data_size
    call mem_Copy
  pop bc
  pop de
  pop hl
  ret

; bg_load copies background data to the screen in VRAM
bg_load:
  push hl
  push de
  push bc
    ld hl, splash_map_data
    ld de, _SCRN0
    ld bc, splash_tile_map_size
    call mem_Copy
  pop bc
  pop de
  pop hl
  ret

; oam_clear zeroes the shadow OAM memory
oam_clear:
  push af
  push bc
  push hl
    ; Set the accumulator to zero
    ld a, 0
    ; HL -> Dest Address
    ld hl, SHADOW_OAM
    ; BC -> Data Length
    ld bc, INTERRUPT_COUNTER - SHADOW_OAM
    ; Invoke mem_Set to blast the accumulator across the variable space
    call mem_Set
  pop hl
  pop bc
  pop af
  ret

; window reset ... does that
window_reset:
  push af
    ld a, 0
    ld [WINDOW_X], a
    ld [rSCX],a
  pop af
  ret
