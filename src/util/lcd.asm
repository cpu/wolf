; Standard gameboy hardware offsets & useful defines
INCLUDE "gbhw.inc"

SECTION "lcd", ROMX

; Prepare & enable the LCD
lcd_on::
  push af
    ; Turn on the LCD:
    ;  LCDCF_ON -> Bit 7 High -> LCD Display Enable
    ; Select the Window Tile Map address range:
    ;  LCDCF_WIN9C00 -> Bit 6 high -> Window Tile Map Display Select, $9C00->9FFF
    ; Enabled the Window Display
    ;  LCDCF_WINON -> Bit 5 high -> Window Display enabled
    ; Select the BG & Window Tile Data source address:
    ;  LCDCF_BG8000 -> Bit 4 High -> BG & Window Tile Data Select 1, $8000->8FFF
    ; Select the BG Tile Map Data source address:
    ;  LCDCF_BG9800 -> Bit 3 Low -> BG Tile Map Display Select Select 0, $9800->$9BFF
    ; Set the sprite size:
    ;  LCDCF_OBJ8 -> Bit 2 Low -> 8x8 Sprites
    ; Enable sprites:
    ;  LCDCF_OBJON -> Bit 1 High -> Enable sprite display
    ; Turn on the background display:
    ;  LCDCF_BGON -> Bit 0 High -> BG Display enabled
    ld a, LCDCF_ON|LCDCF_WIN9C00|LCDCF_WINON|LCDCF_BG8000|LCDCF_BG9800|LCDCF_OBJ8|LCDCF_OBJON|LCDCF_BGON
    ; Set the LCD Control register with the accumulator value
    ld [rLCDC], a
  pop af
  ret

; Turn off the LCD
; NOTE(@cpu): Caller is responsible for making sure that the CPU is in Vblank
; mode.
lcd_off::
  push af
    ; Put the LCD control register into the accumulator
    ld a, [rLCDC]
    ; Reset bit 7 of the accumulator (The LCD on/off control bit)
    res 7, a
    ; Put the accumulator back into the LCD control register
    ld [rLCDC], a
  pop af
  ret

; Loop until the CPU is executing in V-Blank state
wait_vblank::
  push af
.loop:
    ; Put the current LY into the accumulator
    ld a, [rLY]
    ; Compare with 144: "V-blank can be confirmed when the value of LY is greater
    ; than or equal to 144." per pandoc
    cp 144
    ; Jump on not-zero to keep waiting
    jr nz, .loop
  pop af
  ret
