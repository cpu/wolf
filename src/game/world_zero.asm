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

world_zero_vblank::
  call fill_mapdata
  jp game_vblank_return

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
    ; The window moved should start cleared
    ld [WINDOW_MOVED], a
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

  ; Indicate the shadow OAM contents have changed
  ld a, $01
  ld [SHADOW_OAM_CHANGED], a

  ret

; update_player checks the current player state and updates the player position
; accordingly
update_player:
  push af
    ; Check if the player is on ground - this will place the player into either
    ; state standing or falling
.check_jumping:
    call continue_jump
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
    ; check if the player is standing
    ld a, [PLAYER_STATE]
    cp a, PLAYER_STATE_STANDING
    ; if they aren't, skip
    jp nz, .finish
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
    ; Indicate the shadow OAM contents have changed
    ld a, $01
    ld [SHADOW_OAM_CHANGED], a
  pop af
  ret

; continue_jump is the second frame of a jump
continue_jump:
  push af
.is_jumping:
    ; check if the player is jumping.
    ld a, [PLAYER_STATE]
    cp a, PLAYER_STATE_JUMPING
    ; if they aren't, finish, we can't continue
    jp z, .continue_jumping
.is_jumped:
    ; check if the player is jumped
    ld a, [PLAYER_STATE]
    cp a, PLAYER_STATE_JUMPED
    ; if they aren't jumped, and they aren't jumping, finish
    jp nz, .finish
    ; if they are JUMPED, then switch to falling
    ld a, PLAYER_STATE_FALLING
    ld [PLAYER_STATE], a
    ; and finish
    jp .finish
.continue_jumping:
    ; Set the player state to JUMPED
    ld a, PLAYER_STATE_JUMPED
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
    ; Indicate the shadow OAM contents have changed
    ld a, $01
    ld [SHADOW_OAM_CHANGED], a
.finish:
  pop af
  ret

; check_ground_tile puts the map tile # in the position directly below the
; player into the HL register
check_ground_tile:
  push hl
  push de
  push af
    ld a, [PLAYER_STATE]
    cp a, PLAYER_STATE_JUMPED
    jp z, .finish
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
    ld a, $01
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
    ; Indicate the shadow OAM contents have changed
    ld a, $01
    ld [SHADOW_OAM_CHANGED], a
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
    ; Increment WINDOW_MOVED
    ld a, [WINDOW_MOVED]
    inc a
    ld [WINDOW_MOVED], a
    ; Get the current window X position
    ld a, [rSCX]
    ; Increment it by $08 to move one tile forward
    add a, $08
    ; Move the window
    ld [rSCX], a
.finish
  pop af
  ret

; copy_mapdata fills a column of map data from world_one_two into the background
; map during vblank. The column is placed immediately behind the window scroll to
; hide it from the player. Each window advacement will draw one column of the
; next map
copy_mapdata:
  push hl
  push de
  push bc
  push af
.init_copy:
  ; Copy from world_one_two mapdata
  ld hl, world_one_two
  ; Copy into _SCRN0, the current BG map data
  ld de, _SCRN0
  ; The X position on the map is WINDOW_X minus one (because we just moved it
  ; forward and we want to fill the column behind).
  ld a, [WINDOW_X]
  dec a
  ; Put the X into B.
  ld b, a
  ; The Y position starts at 0
  ld a, 0
  ; Put the Y into C
  ld c, a
  ; Conditionally offset the HL and DE pointers by the X value
.process_x:
  ; Put the X position from B into A
  ld a, b
  ; If the X is zero, skip ahead to processing the Y offset
  cp a, $00
  jp z, .process_y
  ; Otherwise perform the X offset for HL and DE
.move_pointer_x:
  push bc
    ; Put X into the lower half of BC
    ld c,a
    ; Clear the upper half of BC
    ld b, $00
    ; Add X to HL
    add hl, bc
    ; Save the adjusted HL
    push hl
      ; Copy DE into HL
      ld h, d
      ld l, e
      ; Adjust HL
      add hl, bc
      ; Copy HL back to DE
      ld d, h
      ld e, l
    ; Restore the saved HL
    pop hl
  ; Restore saved X,Y
  pop bc
 ; Conditionally process the Y offset for HL and DE
.process_y:
  ; check if Y is zero - we skip the Y adjustment if so
  ld a, c
  cp a, $00
  ; if Y is zero we're in the right place to copy data
  jp z, .copy_data
.move_pointer_y:
  ; if Y is not zero, add one world width to HL and DE to account for
  ; a single Y. Save X,Y in BC before using it for addition
  push bc
    ; Save the world width into BC
    ld bc, world_one_width
    ; Adjust HL
    add hl, bc
    ; Save HL on the stack so we can adjust DE
    push hl
      ; Copy DE into HL
      ld h, d
      ld l, e
      ; Adjust HL
      add hl, bc
      ; Put the result back into DE
      ld d, h
      ld e, l
    ; Restore the saved HL
    pop hl
  ; Restore the saved X,Y
  pop bc
.copy_data:
  ; Read HL (the src map address) at the X,Y offset
  ld a, [hl]
  ; Save the HL src address on the stack
  push hl
    ; Swap DE (the dest map address) at the X,y offset into HL
    ld h, d
    ld l, e
    ; Write the src data to the dest map
    ld [hl], a
  ; Restore the src address from the stack
  pop hl
.next_row:
  ; Increment the Y position
  ld a, c
  inc a
  ld c, a
  ; Check if its equal to $12, the window height
  ; if it isn't, jump back and process more of the column
  cp a, $12
  jp nz, .process_y
  ; If it was $12, then we're all done.
  pop af
  pop bc
  pop de
  pop hl
  ret

; fill_mapdata is called during VBLANK interrupt when there was not a DMA.
; If the WINDOW_MOVED flag is set then this routine will copy a new column of
; mapdata into VRAM behind the window.
fill_mapdata:
  push af
.check_fill_needed:
    ; if the window hasn't moved there isn't any data to fill
    ld a, [WINDOW_MOVED]
    cp a, $00
    jp z, .finish
    ; If the window has moved, then copy in a new column of mapdata
    call copy_mapdata
.clear_fill_needed:
    ; Clear out the WINDOW_MOVED flag
    ld a, $00
    ld [WINDOW_MOVED], a
.finish:
  pop af
  ret

; dead_state is called when the player hits the bottom of the screen and sets up
; a transition back to the splash screen.
dead_state:
  SET_HOOK NEXT_SCREEN_INIT, splash_init
  SET_HOOK NEXT_SCREEN_TICK, splash_tick
  SET_HOOK NEXT_SCREEN_VBLANK, splash_vblank
  SET_NEXT_SCREEN 1
  ret
