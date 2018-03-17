; Standard gameboy hardware offsets & useful defines
INCLUDE "gbhw.inc"

; Wolf include
INCLUDE "wolf.inc"

SECTION "engine", ROMX

; Wait for a timer interrupt
tick_wait::
  push af
    ; Set the TIMA starting point to 0 (-256)
    ld a, 0
    ld [rTMA], a
    ; Set the timer frequency to 4.096Khz and enable it.
    ld a, TACF_START|TACF_4KHZ
    ld [rTAC], a
  pop af
  ; Wait for an interrupt
  halt
  nop
  ; Return
  ret

; Timer interrupt handler
timer_interrupt::
  ; Save AF
  push af
.update_counter:
    ; Put the INTERRUPT_COUNTER into the accumulator
    ld a, [INTERRUPT_COUNTER]
    ; Decrement it
    dec a
    ; Write the accumulator back to the interrupt counter
    ld [INTERRUPT_COUNTER], a
.read_joypad:
    call read_joypad
.check_if_tick:
    ; If not zero, jump to .finish
    jp nz, timer_interrupt_finish
    ; reset the accumulator to the default interrupt counter value
    ld a, DEFAULT_INTERRUPT_COUNTER
    ; Write the accumulator back to the interrupt counter
    ld [INTERRUPT_COUNTER], a
.run_tick:
    ; Run the current screen tick
    call run_screen_tick
.change_screens:
    ; Check if a screen change is needed, and if so, do it
    call change_screens
timer_interrupt_finish::
  pop af
  ; And return, reenabling interrupts again
  reti

; run-screen_tick runs the current GAME_SCREEN_TICK callback
run_screen_tick::
  push hl
  push bc
    ; Put the address of the current game screen tick callback into hl
    ld hl, GAME_SCREEN_TICK
    ; Load the first byte of the address GAME_SCREEN_TICK holds into b
    ld b, [hl]
    ; Increment L to get to the second byte of the GAME_SCREEN_TICK callback address
    inc l
    ; Load the second byte of the address GAME_SCREEN_TICK holds into C
    ld c, [hl]
    ; Now copy the first byte of the callback address into H
    ld h, b
    ; And the second byte of the callback address into C
    ld l, c
    ; And jump to the callback address
    jp hl
game_tick_return::
  pop bc
  pop hl
  ret

; read_joypad does a thing
read_joypad:
  push af
  push bc
.save_oldstate:
    ; Save the current button state to prev button state before clobbering it
    ld a, [BUTTON_STATE]
    ld [PREV_BUTTON_STATE], a
.read_dpad:
    ; Start by reading the D-Pad "row" of inputs
    ld a, $20
    ; Select the input row
    ld [rP1], a
    ; Read the input row - this is done twice, seemingly everyone does this for
    ; "proper results". Some kind of primative debounce?
    ; TODO@(cpu): Resolve this mystery
    ld a, [rP1]
    ld a, [rP1]
    ; We only need the lower half of the byte for the d-pad buttons. We also
    ; want to be able to combine the dpad states with the button states into one
    ; state byte, so, do the work required to shift these lower bits into the
    ; upper half of the byte.
    cpl
    and $0F
    swap a
    ; Store the dpad inputs into B
    ld b, a 
.read_buttons:
    ; Target the button "row" of inputs
    ld a, $10
    ; Select the input row
    ld [rP1], a
    ; Read the input row - again, this is done many times but its not clear if
    ; that is required.
    ld a, [rP1]
    ld a, [rP1]
    ; We only need the lower half of the byte, so mask that out of A
    cpl
    and $0f
.combine_state:
    ; Combine the button state (in A) with the dpad state (in B)
    or b
.save_state:
    ; Set the new button state from the value in A
    ld [BUTTON_STATE], a
.clear_joypad:
    ; Reset the joypad input row
    ld a, $30
    ; Select the input row
    ld [rP1], a
.finished:
  pop bc
  pop af
  ret

; change_screens checks if a NEXT_SCREEN was requested during the current screen
; tick. It performs a screen change in this case.
change_screens:
  push hl
  push af
  push bc
    ; Check if NEXT_SCREEN was requested
    ld a, [NEXT_SCREEN]
    cp $1
    ; If it wasn't, continue
    jp nz, .continue
    ; Otherwise process a screen change
.change_the_screen:
    ; Put the address of the next screen init handler into BC
    ld hl, NEXT_SCREEN_INIT
    ld b, [hl]
    inc l
    ld c, [hl]
    ; Put the address of the GAME_SCREEN_INIT handler into HL
    ld hl, GAME_SCREEN_INIT
    ; Set the first byte of the GAME_SCREEN_INIT handler address to B, the first
    ; byte of the splash_init address
    ld [hl], b
    ; Increment l to move to the second byte of the GAME_SCREEN_INIT handler
    ; address
    inc l
    ; Set the second byte of the GAME_SCREEN_INIT handler address to C, the
    ; second byte of the splash_init address
    ld [hl], c

    ; Do the same trick, writing the NEXT_SCREEN_TICK into BC
    ld hl, NEXT_SCREEN_TICK
    ld b, [hl]
    inc l
    ld c, [hl]
    ; And then juggling it into GAME_SCREEN_TICK
    ld hl, GAME_SCREEN_TICK
    ld [hl], b
    inc l
    ld [hl], c

    ; Do the same trick, writing the NEXT_SCREEN_VBLANK into BC
    ld hl, NEXT_SCREEN_VBLANK
    ld b, [hl]
    inc l
    ld c, [hl]
    ; And then juggling it into GAME_SCREEN_VBLANK
    ld hl, GAME_SCREEN_VBLANK
    ld [hl], b
    inc l
    ld [hl], c

    ; Invoke the screen change
    call screen_change
.continue:
  pop bc
  pop af
  pop hl
  ret

; screen_change transitions to vblank, disables the LCD, performs some
; initialization (including calling the new screen's init callback), clears the
; NEXT_SCREEN flag, and turns the LCD back on
screen_change::
  ; Wait for vblank state
  call wait_vblank

  ; Disable the LCD so we can mutate/access VRAM
  call lcd_off

  ; Put things back to a default state for the new screen
  call palette_init
  call bg_init
  call tiles_init
  call oam_init

  ; let the new screen init
  call run_screen_init

  ; Clear the next screen flag
  push af
    ld a, 0
    ld [NEXT_SCREEN], a
  pop af

  ; Turn on the LCD
  call lcd_on
  ret

; dma_trampoline is a small bit of code used to invoke a DMA transfer from the
; shadow OAM memory to the real OAM memory. This code is copied to DMA_TRAMPOLINE
; by init_dma where it is invoked during VBlank interrupts.
; This function needs to live in high mem because when the CPU is doing a DMA
; that's the only place that is accessible and we need to access code to busyloop
; for DMA to finish.
dma_trampoline::
  ; Check if the SHADOW_OAM_CHANGED flag is true
  ld a, [SHADOW_OAM_CHANGED]
  cp a, $01
  ; If it isn't, jump to no_dma
  jp nz, .no_dma
.dma:
  ; save AF
  push af
    ; Put the most significant byte of the source address into the accumulator
    ;  _RAM = $C000 -> $C000 / $100 == $C0
    ld a, _RAM / $100
    ; Invoke DMA
    ldh [rDMA], a
    ; Delay for $28 -> 5 x 40 cycles, aprox 200ms
    ld a, $28
.dma_wait:
    dec a
    jr nz, .dma_wait
  ; restore AF
  pop af
  ; Clear the SHADOW_OAM_CHANGED flag
  ld a, $00
  ld [SHADOW_OAM_CHANGED], a
  ; Finish by re-enabling interrupts
  jp .finish
.no_dma
  ; If there was no DMA, call the screen vblank
  call run_screen_vblank
.finish:
  ; Return and re-enable interrupts
  reti
dma_trampoline_end::

; run_screen_vblank runs the current GAME_SCREEN_VBLANK callback
run_screen_vblank::
  push hl
  push bc
    ; Put the address of the current game screen vblank callback into hl
    ld hl, GAME_SCREEN_VBLANK
    ; Load the first byte of the address GAME_SCREEN_VBLANK holds into b
    ld b, [hl]
    ; Increment L to get to the second byte of the GAME_SCREEN_VBLANK callback address
    inc l
    ; Load the second byte of the address GAME_SCREEN_VBLANK holds into C
    ld c, [hl]
    ; Now copy the first byte of the callback address into H
    ld h, b
    ; And the second byte of the callback address into C
    ld l, c
    ; And jump to the callback address
    jp hl
game_vblank_return::
  pop bc
  pop hl
  ret
