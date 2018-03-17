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
  call update_player
  call move_window
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
    ; Start the player in standing state
    ld a, PLAYER_STATE_STANDING
    ld [PLAYER_STATE], a
    ; The window should be moving when world zero starts
    ld a, $01
    ld [WINDOW_MOVING], a
    ; The current and prev button state should be cleared
    ld a, $00
    ld [BUTTON_STATE], a
    ld [PREV_BUTTON_STATE], a
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

; update_player checks the current player state and updates the player position
; accordingly
update_player:
  push af
    ; Check if the player is on ground - this will place the player into either
    ; state standing or falling
.check_falling:
    ; Update the player state to falling or standing based on the ground tile
    call check_ground_tile
.check_input:
    call check_input
    ; Apply gravity
    call apply_gravity
.check_death:
    ; Check if the player should be dead
    call check_death
    ld a, [PLAYER_STATE]
    cp a, PLAYER_STATE_DEAD
    ; If they aren't dead, finish the update
    jp nz, .finish_update
    ; If they are dead, call the dead_state
    call dead_state
.finish_update:
  pop af
  ret

; check_input checks for button presses
check_input:
  push af
.check_a_button:
    ; Put the current button state into the accumulator
    ld a, [BUTTON_STATE]
    ; Check if the A button is pressed
    ; TODO(@cpu): Const this
    and $1
    jp z, .finish
.a_pressed:
    ; check if the player is already jumping
    ld a, [PLAYER_STATE]
    cp a, PLAYER_STATE_JUMPING
    ; if they are, skip
    jp z, .finish
    call player_jump
.finish:
  pop af
  ret

; player_jump is called when the A button is pressed to start a jump
player_jump:
  push af
    ; Set the player state to jumping
    ld a, PLAYER_STATE_JUMPING
    ld [PLAYER_STATE], a
    ; Set the window to moving
    ld a, $01
    ld [WINDOW_MOVING], a
    ; Move the player's Y up by 1
    ld a, [PLAYER_Y]
    dec a
    ld [PLAYER_Y], a
    ; Update the sprite's Y by 8
    ; Put the start address of the SHADOW_OAM into HL. The player sprite is the
    ; first entry of the SHADOW_OAM by convention.
    ld hl, SHADOW_OAM
    ; Load the Y position of the first sprite into the accumulator
    ld a, [hl]
    ; Add -8 to the accumulator
    add a, -$08
    ; Put the new Y position into the sprite Y location
    ld [hl], a
  pop af
  ret

; check_ground_tile puts the map tile # in the position directly below the
; player into the HL register
check_ground_tile:
  push hl
  push de
  push af
.find_ground_tile:
    ; Put the player's map tile into HL
    call find_player_map_tile
    ; Move down one row by adding $20 to HL
    ld de, $20
    add hl, de
    ; HL now points at the tile the player is standing above
    ; Check the tile # for this position
    ld a, [hl]
.check_ground_tile:
    ; If on the ground, state is standing
    cp a, GROUND_TILE
    jp z, .standing
    ; If not on the ground, falling begins
.falling:
    ld a, PLAYER_STATE_FALLING
    ld [PLAYER_STATE], a
    jp .finish
.standing:
    ; Set the player to be standing
    ld a, PLAYER_STATE_STANDING
    ld [PLAYER_STATE], a
    ; Set the window to moving
    ld a, $01
    ld [WINDOW_MOVING], a
.finish
  pop af
  pop de
  pop hl
  ret

; find_player_map_tile puts a pointer to the player's position in the map data
; into HL. This can be used to check what tile a player is standing on (or by
; adjusting it further, above/below/etc)
;
; TODO(@cpu): This should be generalized into an engine function that can be
; referenced here.
find_player_map_tile:
  push af
  push bc
  push de
.init_tile_search:
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
.move_pointer_y:
    ; Move the pointer ahead by 1 row ($1F)
    ld de, $20
    add hl, de
    ; Subtract from A, loop while != 0
    dec a
    jp nz, .move_pointer_y
.move_pointer_x:
    ld c,b
    ld b,0
    add hl, bc
   ; TODO(@cpu): Why is this -1 offset needed??
    dec l
    ; HL now points at the player tile
    ld a, [hl]
.tile_found:
  pop de
  pop bc
  pop af
  ret

; apply_gravity is called when the PLAYER_STATE is equal to
; PLAYER_STATE_FALLING. It updates the player's Y
apply_gravity:
  push af
    ; Check if the player is in the falling state. If they aren't finish the update.
    ld a, [PLAYER_STATE]
    cp a, PLAYER_STATE_FALLING
    jp nz, .finish
.stop_window_move:
    ld a, $00
    ld [WINDOW_MOVING], a
.change_player_y:
    ; Put the Player Y into A
    ld a, [PLAYER_Y]
    ; Increment the accumulator
    inc a
    ; Write the new Y back to PLAYER_Y
    ld [PLAYER_Y], a
.change_sprite_y:
    ; Increment the sprite Y location to match
    ; Put the start address of the SHADOW_OAM into HL. The player sprite is the
    ; first entry of the SHADOW_OAM by convention.
    ld hl, SHADOW_OAM
    ; Load the Y position of the first sprite into the accumulator
    ld a, [hl]
    ; Add 8 to the accumulator
    add a, $08
    ; Put the new Y position into the sprite Y location
    ld [hl], a
.finish:
  pop af
  ret

; check_death is called to see if the player's Y is equal to the PLAYER_DEATH_Y.
; If it is, the player state is set to dead.
check_death:
  push af
    ; Check the new player Y to see if its the maximum
    ld a, [PLAYER_Y]
    cp a, PLAYER_DEATH_Y
    ; If the player is alive do nothing
    jp nz, .finish
    ; Otherwise, player state is dead :-(
    ld a, PLAYER_STATE_DEAD
    ld [PLAYER_STATE], a
.finish:
  pop af
  ret

; move_window checks if the window should be moved and if required updates its
; position
move_window:
  push af
    ; Check the WINDOW_MOVING flag
    ld a, [WINDOW_MOVING]
    cp $01
    ; If it isn't $01, finish without doing anything, the window isn't moving.
    jp nz, .finish
    ; Otherwise, proceed with window movement
.increment_window_position:
    ; TODO(@cpu): Should probably check that the tile ahead is not solid here and
    ; act accordingly?
    ;
    ; Advance the window position by loading the current WINDOW_X into the
    ; accumulator, incrementing it, and then writing it back to the WINDOW_X
    ; register.
    ld a, [WINDOW_X]
    inc a
    ld [WINDOW_X], a
    ; If the new WINDOW_X (still in the accumulator) is < 32, move the window
    cp 32
    jp nz, .update_window
    ; Otherwise wrap the WINDOW_X to 0 and then move the window
    ld a, 0
    ld [WINDOW_X], a
.update_window:
    ; Get the current window X position
    ld a, [rSCX]
    ; Increment it by $08 to move one tile forward
    add a, $08
    ; Move the window
    ld [rSCX], a
.finish
  pop af
  ret

; dead_state is called when the player hits the bottom of the screen and sets up
; a transition back to the splash screen.
dead_state:
  SET_HOOK NEXT_SCREEN_INIT, splash_init
  SET_HOOK NEXT_SCREEN_TICK, splash_tick
  SET_NEXT_SCREEN 1
  ret
