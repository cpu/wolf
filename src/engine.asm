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
    ; Put the INTERRUPT_COUNTER into the accumulator
    ld a, [INTERRUPT_COUNTER]
    ; Decrement it
    dec a
    ; Write the accumulator back to the interrupt counter
    ld [INTERRUPT_COUNTER], a
    ; If not zero, jump to .finish
    jp nz, timer_interrupt_finish
    ; reset the accumulator to the default interrupt counter value
    ld a, DEFAULT_INTERRUPT_COUNTER
    ; Write the accumulator back to the interrupt counter
    ld [INTERRUPT_COUNTER], a

    ; Run the current screen tick
    call run_screen_tick

    call change_screens
timer_interrupt_finish::
  pop af
  ; And return, reenabling interrupts again
  reti

change_screens:
  push hl
  push af
  push bc
    ld a, [NEXT_SCREEN]
    cp $1
    jp nz, .continue
.change_the_screen:
    ; Put the address of the splash screen init handler into BC
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

    ld hl, NEXT_SCREEN_TICK
    ld b, [hl]
    inc l
    ld c, [hl]

    ld hl, GAME_SCREEN_TICK
    ld [hl], b
    inc l
    ld [hl], c

    call screen_change
.continue:
  pop bc
  pop af
  pop hl
  ret

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

; dma_trampoline is a small bit of code used to invoke a DMA transfer from the
; shadow OAM memory to the real OAM memory. This code is copied to DMA_TRAMPOLINE
; by init_dma where it is invoked during VBlank interrupts.
; This function needs to live in high mem because when the CPU is doing a DMA
; that's the only place that is accessible and we need to access code to busyloop
; for DMA to finish.
dma_trampoline::
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
  ; Return and re-enable interrupts
  reti
dma_trampoline_end::
