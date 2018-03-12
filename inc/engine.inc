  IF      !DEF(ENGINE_INC)
ENGINE_INC  SET  1

; We put the DMA_TRAMPOLINE at _HW + $80, e.g. $FF80, the start of HMEM
DMA_TRAMPOLINE EQU _HW + $80

; OAM_WRITE writes a four byte OAM entry using the provided arguments.
; Macro arguments:
;   arg 1: \1 -> The OAM index
;   arg 2: \2 -> The X location
;   arg 3: \3 -> The Y location
;   arg 4: \4 -> The Tile #
;   arg 5: \5 -> Flags
OAM_WRITE: MACRO
  push af
  push hl
    ; Move HL to the OAM entry head for \1. Each OAM is four bytes.
    ld hl, SHADOW_OAM + \1 * 4
    ; Write the Y argument and increment HL
    ld a, \3 * 8
    ld [hl+], a
    ; Write the X argument and increment HL
    ld a, \2 * 8
    ld [hl+], a
    ; Write the tile # and increment HL
    ld a, \4
    ld [hl+], a
    ; Write the flags byte and increment HL
    ld a, \5
    ld [hl+], a
  pop hl
  pop af
  ENDM

; SET_HOOK writes a two byte hook/callback address to the provided memory
; location.
; Macro arguments:
;   arg 1: \1 -> The two byte memory location of the hook to set
;   arg 2: \2 -> The two byte hook/callback address to write
SET_HOOK: MACRO
  push hl
  push bc
    ; Put the hook variable location into HL
    ld hl, \1
    ; Put the hook callback location into BC
    ld bc, \2
    ; Write the first byte of BC to the first byte of HL's target
    ld [hl], b
    ; Increment L to point to the second byte of HL's target
    inc l
    ; Write the second byte of BC to the second byte of HL's target
    ld [hl], c
  pop bc
  pop hl
  ENDM

; NEXT_SCREEN writes a one byte value to the NEXT_SCREEN variable to indicate
; whether there is/isn't a need to change screens.
; Macro arguments:
;   arg 1: \1 -> The one byte value to write to [NEXT_SCREEN]
SET_NEXT_SCREEN: MACRO
  push af
    ld a, \1
    ld [NEXT_SCREEN], a
  pop af
  ENDM

  ENDC
