  IF      !DEF(WOLF_INC)
WOLF_INC SET  1

; Default value for the interrupt counter. It is reset to this when decremented
; to zero
DEFAULT_INTERRUPT_COUNTER EQU $02

GROUND_TILE EQU $01

DEFAULT_PLAYER_X EQU $03
DEFAULT_PLAYER_Y EQU $0C
PLAYER_OAM EQU $00
PLAYER_TILE EQU $06

PLAYER_STATE_STANDING EQU $00
PLAYER_STATE_JUMPING EQU $01
PLAYER_STATE_JUMPED EQU $02
PLAYER_STATE_FALLING EQU $03
PLAYER_STATE_DEAD EQU $04

MOON_OAM EQU $01
MOON_X EQU $11
MOON_Y EQU $04
MOON_TILE EQU $03

  ENDC