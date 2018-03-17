; Standard gameboy hardware offsets & useful defines
INCLUDE "gbhw.inc"

; Engine include
INCLUDE "engine.inc"

; Wolf include
INCLUDE "wolf.inc"

; Place engine init after memory.asm
SECTION "engine_init", ROM0[$0400]

engine_init::
  ; Disable interrupts
  di

  ; Wait for vblank state
  call wait_vblank

  ; Disable the LCD so we can mutate/access VRAM
  call lcd_off

  ; Clear and initialize various engine components
  call dma_init
  call variables_init
  call screen_init
  call palette_init
  call bg_init
  call tiles_init
  call oam_init

  ; Let the game initialize before we leave vblank/lcd off state so that it can
  ; do things like load initial tile and background data
  ;call game_init
  call game_init

  ; let the first screen init
  call run_screen_init

  ; Turn on the LCD
  call lcd_on
  ; Configure & enable interrupts
  call interrupts_init
  ret

run_screen_init::
  ; Let the current game screen initialize
  ; Put the address of the current game screen init callback into hl
  push hl
  push bc
    ld hl, GAME_SCREEN_INIT
    ; Load the first byte of the address GAME_SCREEN_INIT holds into b
    ld b, [hl]
    ; Increment L to get to the second byte of the GAME_SCREEN_INIT callback address
    inc l
    ; Load the second byte of the address GAME_SCREEN_INIT holds into C
    ld c, [hl]
    ; Now copy the first byte of the callback address into H
    ld h, b
    ; And the second byte of the callback address into C
    ld l, c
    ; And jump to the callback address
    jp hl
game_init_return::
  pop bc
  pop hl
  ret

dma_init:
  push hl
  push de
  push bc
    ; HL -> Source Address -> dma_trampoline label
    ld hl, dma_trampoline
    ; DE -> Dest Address -> DMA_TRAMPOLINE location in HMEM
    ld de, DMA_TRAMPOLINE
    ; BC -> Data Length -> Size of dma_trampoline
    ld bc, dma_trampoline_end - dma_trampoline
    ; Copy the DMA trampoline to HMEM
    call mem_Copy
  pop bc
  pop de
  pop hl
  ret

screen_init::
  push af
    ; Set the X/Y scroll registers to the upper left of the tile map
    ld a, 0
    ld [rSCX], a
    ld [rSCY], a

    ; Set the window position off screen
    ld a, 0
    ld [rWX], a
    ld a, 255
    ld [rWY], a
  pop af
  ret

; Set up the Window palette colors
palette_init::
  push af
    ; Bit 7-6 - Shade val for Colour Number 3
    ; Bit 5-4 - Shade val for Colour Number 2
    ; Bit 3-2 - Shade val for Colour Number 1
    ; Bit 1-0 - Shade val for Colour Number 0
    ;
    ; Shade Values:
    ; 0  White
    ; 1  Light gray
    ; 2  Dark gray
    ; 3  Black
    ;
    ; So:
    ; %11100100:
    ;    11       10          01        00
    ;     3        2           1         0
    ;   Black  Dark Gray  Light Gray  White
    ld a, %00100111
    ; Write the palette to rBGP , the BG palete data register
    ld [rBGP], a;
    ; Use the same palette for sprite palette 0 and 1
    ldh [rOBP0], a
    ldh [rOBP1], a
  pop af
  ret

; Clear the initial variable space out
variables_init::
  push af
  push bc
  push hl
    ; Set the accumulator to zero
    ld a, 0
    ; HL -> Dest Address
    ld hl, variables_start
    ; BC -> Data Length
    ld bc, variables_end-variables_start
    ; Invoke mem_Set to blast the accumulator across the variable space
    call mem_Set
    ; Set the INTERRUPT_COUNTER to the initial default value
    ld a, DEFAULT_INTERRUPT_COUNTER
    ld [INTERRUPT_COUNTER], a
    ; Set the PLAYER_X and PLAYER_Y to the default position 
    ld a, DEFAULT_PLAYER_X
    ld [PLAYER_X], a
    ld a, DEFAULT_PLAYER_Y
    ld [PLAYER_Y], a
  pop hl
  pop bc
  pop af
  ret

; Initialize the real OAM with the Shadow OAM. We could wait for the first
; VBLANK interrupt to fire once we reenable interrupts but since we've already
; turned off the LCD we might as well do this now too :-)
oam_init::
  push bc
  push de
  push hl
    ; Write over the OAM space - the shadow OAM space has already been cleared in
    ; init_variables
    ; HL -> Source Address -> Shadow OAM workspace
    ld hl, SHADOW_OAM
    ; DE -> Dest Address -> OAMRAM -> $FE00
    ld de, _OAMRAM
    ; BC -> Data Length -> $A0 -> 160 -> 40 sprites * 4 bytes per sprite
    ld bc, $A0
    ; Copy the shadow OAM workspace over the real OAM space
    call mem_Copy
  pop hl
  pop de
  pop bc
  ret

; Clear the _SCRN0 data for the background map
bg_init::
  push af
  push bc
  push hl
    ld a, 0
    ; HL -> Dest Address -> _SCRN0 -> $9800
    ld hl, _SCRN0
    ; BC -> Data Length -> _SCRN1 - _SCRN0 -> $9C00 - $9800
    ld bc, _SCRN1 - _SCRN0
    ; Clear bg memory
    call mem_Set
  pop hl
  pop bc
  pop af
  ret

; Clear the _VRAM character data for the tiles
tiles_init::
  push af
  push bc
  push hl
    ; Put zero in the accumulator
    ld a, 0
    ; HL -> Dest Address -> _VRAM -> $8000
    ld hl, _VRAM
    ; BC -> Data Length -> _SCRN0 - _VRAM -> $9800 - $8000
    ld bc, _SCRN0 - _VRAM
    ; Clear tile memory
    call mem_Set
  pop hl
  pop bc
  pop af
  ret

; Initialize Interrupts
interrupts_init::
  push af
    ; Set accumulator with VBlank and Timer enabled bitmask:
    ;  IEF_VBLANK -> Bit 0 high -> VBlank Interrupt Enabled
    ;  IEF_TIMER -> Bit 2 high -> Timer Interrupt Enabled
    ld a, IEF_VBLANK | IEF_TIMER
    ; Write the accumulator bitmask to the Interrupt Enable register
    ld [rIE], a
    ; Enable interrupts
    ei
  pop af
  ret
