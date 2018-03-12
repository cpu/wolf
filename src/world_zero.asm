SECTION "world_zero", ROMX

INCLUDE "gbhw.inc"

INCLUDE "engine.inc"

INCLUDE "wolf.inc"

INCLUDE "tiles.inc"

INCLUDE "map.inc"

; world_zero_init is called while VRAM is accesible to setup tile, background
; and OAM memory.
world_zero_init::
  call tiles_load
  call bg_load
  call sprite_init
  call variables_init
  ; Finish global initialization
  jp game_init_return

; world_zero_tick is called every DEFAULT_INTERRUPT_COUNTER timer interrupts
; when world zero is the active screen. It is
; responsible for mutating the world by updating variables and shadow_oam
; contents
world_zero_tick::
  push af
.player_state_update:
    ; Put the current player state into the accumulator
    ld a, [PLAYER_STATE]
    ; Check if the player is in the falling state. If they are we don't change the
    ; window state
    cp a, PLAYER_STATE_FALLING
    jp z, .gravity
.window_state_update:
    ; TODO(@cpu): Should probably check that the tile ahead is not solid here and
    ; act accordingly?

    ; Advance the window position by loading the current WINDOW_X into the
    ; accumulator, incrementing it, and then writing it back to the WINDOW_X
    ; register.
    ld a, [WINDOW_X]
    inc a
    ld [WINDOW_X], a
    ; If the new WINDOW_X (still in the accumulator) is < 32, move the window
    cp 32
    jp nz, .move_window
    ; Otherwise wrap the WINDOW_X to 0 and then move the window
    ld a, 0
    ld [WINDOW_X], a
.move_window:
    ; Get the current window X position
    ld a, [rSCX]
    ; Increment it by $08 to move one tile forward
    add a, $08
    ; Move the window
    ld [rSCX], a
.gravity:
    ; Apply gravity to the player, changing their state to falling if needed
    call apply_gravity
    ; End the tick
.end_tick
  pop af
  jp game_tick_return

; variables_init clears variables for a fresh start
variables_init:
  push af
    ; Set the INTERRUPT_COUNTER to the initial default value
    ld a, DEFAULT_INTERRUPT_COUNTER
    ld [INTERRUPT_COUNTER], a
    ; Set the PLAYER_X and PLAYER_Y to the default position 
    ld a, DEFAULT_PLAYER_X
    ld [PLAYER_X], a
    ld a, DEFAULT_PLAYER_Y
    ld [PLAYER_Y], a
  pop af
  ret

; tiles_load copies initial game tile data to VRAM
tiles_load:
  push hl
  push de
  push bc
    ; HL -> Source Address -> tile data
    ld hl, tile_data
    ; DE -> Destination Address -> _VRAM -> $8000
    ld de, _VRAM
    ; BC -> Data Length -> Size of the tile data
    ld bc, tile_data_len
    ; Copy the tile data to VRAM
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
    ; HL -> Source Address -> map data
    ld hl, world_one
    ; DE -> Destination Address -> _SCRN0 -> $9800
    ld de, _SCRN0
    ; BC -> Data Length -> _SCRN1 - _SCRN0 -> $9C00 - $9800
    ld bc, _SCRN1 - _SCRN0
    ; Copy the map data to VRAM
    call mem_Copy
    ;ld hl, splash_map_data
    ;ld de, _SCRN0
    ;ld bc, splash_tile_map_size
    ;call mem_Copy
  pop bc
  pop de
  pop hl
  ret

; sprite_init sets up sprites in the shadow OAM with initial data
sprite_init:
  ; OAM_WRITE writes a four byte OAM entry using the provided arguments.
  ; Macro arguments:
  ;   arg 1: \1 -> The OAM index
  ;   arg 2: \2 -> The X location
  ;   arg 3: \3 -> The Y location
  ;   arg 4: \4 -> The Tile #
  ;   arg 5: \5 -> Flags

  ; Write Sprite $00 - the player character
  OAM_WRITE PLAYER_OAM, DEFAULT_PLAYER_X, DEFAULT_PLAYER_Y, PLAYER_TILE, $00

  ; Write Sprite $01 - the moon sprite
  OAM_WRITE MOON_OAM, MOON_X, MOON_Y, MOON_TILE, $00

  ret

; apply_gravity is called when the PLAYER_STATE is equal to PLAYER_STATE_FALLING
; TODO(@cpu): Break out the parts that update the state from the parts that do
;             movement. This function is tooooooo long
apply_gravity:
  push af
  push bc
  push de
  push hl
.are_you_falling:
    ; Load the current player state into the accumulator
    ld a, [PLAYER_STATE]
    ; Check if the player is falling. If they aren't falling, check the tile
    ; under them to see if they should start!
    cp a, PLAYER_STATE_FALLING
    jp nz, .check_tile
.currently_falling:
    ; Put the Player Y into A
    ld a, [PLAYER_Y]
    ; Increment the accumulator
    inc a
    ; Write the new Y back to PLAYER_Y
    ld [PLAYER_Y], a
.check_death:
    ; Check the new player Y (still in the accumulator) to see if its 20
    ; TODO(@cpu): Change 20 to a EQU
    cp a, 20
    ; If the player is alive, move them
    jp nz, .move_player
    ; Otherwise, player is dead :-(
    ld a, PLAYER_STATE_DEAD
    ld [PLAYER_STATE], a
    call dead_state
    jp .finish
.move_player:
    ; Put the start address of the SHADOW_OAM into HL
    ld hl, SHADOW_OAM
    ; Load the Y position of the first sprite into the accumulator
    ld a, [hl]
    ; Add 8 to the accumulator?
    add a, $08
    ; Put the new Y position into the sprite Y location
    ld [hl], a
.check_tile:
    ; Put the Player X into B
    ld a, [PLAYER_X]
    ld b, a
    ; Put the window X into A
    ld a, [WINDOW_X]
    ; Add A to B to get the true player X on the map
    add a, b
    ; Store that map X in B
    ld b, a
    ; Put the player Y into a
    ld a, [PLAYER_Y]
    ; TODO(@cpu): Determine why this -2 offset on Y is needed
    dec a
    dec a
    ; Move HL to the first map byte
    ld hl, world_one
.move_pointer_y
    ; Move the pointer ahead by 1 row ($1F)
    ld de, $20
    add hl, de
    ; Subtract from A, loop while != 0
    dec a
    jp nz, .move_pointer_y
.move_pointer_x
    ld c,b
    ld b,0
    add hl, bc
   ; TODO(@cpu): Why is this -1 offset needed??
    dec l
    ; HL now points at the player tile
    ld a, [hl]
.check_falling
    ; Move down one row
    ld de, $20
    add hl, de
    ; Check the tile # for the tile underneath the player's position on the map
    ld a, [hl]
    ; If on the ground, state is standing
    cp a, GROUND_TILE
    jp z, .standing
    ; If not on the ground, falling begins
    ld a, PLAYER_STATE_FALLING
    ld [PLAYER_STATE], a
    jp .finish
.standing
    ; Set the player to be standing
    ld a, PLAYER_STATE_STANDING
    ld [PLAYER_STATE], a
.finish
  pop hl
  pop de
  pop bc
  pop af
  ret

; dead_state is called when the player hits the bottom of the screen and sets up
; a transition back to the splash screen.
dead_state:
  SET_HOOK NEXT_SCREEN_INIT, splash_init
  SET_HOOK NEXT_SCREEN_TICK, splash_tick
  SET_NEXT_SCREEN 1
  ret
