; Wolf
; @cpu

; Standard gameboy hardware offsets & useful defines
INCLUDE "gbhw.inc"

; Engine include
INCLUDE "engine.inc"

; Wolf include
INCLUDE "wolf.inc"

; Set up interrupt handlers
SECTION "Vblank", ROM0[$0040]
  ; Invoke an OAM DMA via the DMA_TRAMPOLINE in HMEM
  jp DMA_TRAMPOLINE
SECTION "LCDC", ROM0[$0048]
  reti
SECTION "Timer_Overflow", ROM0[$0050]
  ; Jump to the timer interrupt handler
  jp timer_interrupt
SECTION "Serial", ROM0[$0058]
  reti
SECTION "p1thru4", ROM0[$0060]
  reti

; TODO(@cpu): It would be better to define these variables closer to where they
; are referenced instead of all in wolf.asm
SECTION "variables", WRAM0
variables_start::
; SHADOW_OAM is a working area for OAM data that gets DMA'd to the real OAM
; memory during the vblank interrupt
SHADOW_OAM:: ds 40 * 4

; SHADOW_OAM_CHANGED is a flag indicating whether the SHADOW_OAM is dirty and
; needs to be written to the real OAM during the vblank interrupt
SHADOW_OAM_CHANGED:: ds 1

; INTERRUPT_COUNTER is a one byte counter that gets decremented in a timer
; interrup handler
INTERRUPT_COUNTER:: ds 1

; GAME_SCREEN INIT holds the callback address for the current game screen's init
; handler
GAME_SCREEN_INIT:: ds 2
; GAME_SCREEN_TICK holds the callback address for the current game screen's tick
; handler
GAME_SCREEN_TICK:: ds 2
; GAME_SCREEN_VBLANK holds the callback address for the current game screen's
; vblank handler
GAME_SCREEN_VBLANK:: ds 2

; NEXT_SCREEN indicates whether there should be a screen change done before the
; next tick.
NEXT_SCREEN:: ds 1
; NEXT_SCREEN_INIT holds the callback address that will replace GAME_SCREEN_INIT
; if NEXT_SCREEN is set
NEXT_SCREEN_INIT:: ds 2
; NEXT_SCREEN_TICK holds the callback address that will replace GAME_SCREEN_TICK
; if NEXT_SCREEN is set
NEXT_SCREEN_TICK:: ds 2
; NEXT_SCREEN_VBLANK holds the callback address that will replace
; GAME_SCREEN_VBLANK if NEXT_SCREEN is set
NEXT_SCREEN_VBLANK:: ds 2

; BUTTON_STATE holds the buttons that are currently pressed
BUTTON_STATE:: ds 1
; PREV_BUTTON_STATE holds the buttons that were pressed last joypad read
PREV_BUTTON_STATE:: ds 1

; SPLASH_COUNTER is a counter incremented when the splash screen is visible
SPLASH_COUNTER:: ds 1

; Current player X and Y Tile number **not pixel** e.g. (not the *8 stored in
; the OAM entry)
PLAYER_X:: ds 1
PLAYER_Y:: ds 1

; Current player state
PLAYER_STATE:: ds 1

; Current Window X (Tile number)
WINDOW_X:: ds 1

; How far the window moved since last vblank
WINDOW_MOVED:: ds 1

; Is the Window supposed to be moving?
WINDOW_MOVING:: ds 1
variables_end::

; ROM entrypoint, jump to begin
SECTION "start",ROM0[$0100]
    nop
    jp begin

; Define standard ROM header using the ROM_HEADER macro from gbhw.inc
; No Memory Bank Controller, 32kb ROM, no RAM
  ROM_HEADER  ROM_NOMBC, ROM_SIZE_32KBYTE, RAM_SIZE_0KBYTE

; Main ROM start function
begin:
  ; Initialize the stack pointer to the top of HRAM
  ld sp, $FFFE

  call engine_init

; At this point setup is complete and interrupts are configured & enabled. Time
; to do as little as possible waiting for the interrupts :-)
main_loop:
  ; Wait for an engine tick to happen
  call tick_wait
  ; Repeat forever
  jr main_loop
