; ///////////////////////
; //                   //
; //  File Attributes  //
; //                   //
; ///////////////////////

; Filename: splash.png
; Pixel Width: 160px
; Pixel Height: 144px

; /////////////////
; //             //
; //  Constants  //
; //             //
; /////////////////

splash_tile_map_size EQU $0400
splash_tile_map_width EQU $20
splash_tile_map_height EQU $20

splash_tile_data_size EQU $09F0
splash_tile_count EQU $0168

; ////////////////
; //            //
; //  Map Data  //
; //            //
; ////////////////

splash_map_data:
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$01,$02,$03,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$04,$05,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$06,$07,$08,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$09,$0A,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$0B,$0C,$0D,$00,$0E,$0F,$10,$11,$12,$13,$14,$15,$00,$00,$00
DB $00,$16,$17,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$18,$19,$1A,$1B,$1C,$1D,$1E,$1F,$20,$21,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$22,$23,$24,$25,$26,$27,$28,$29,$2A,$2B,$2C,$2D
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$2E,$2F,$30,$31,$32,$33,$34,$35,$36,$37,$38,$39
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$3A,$3B,$3C,$3D,$3E,$3F,$3F,$3F,$3F,$40,$41,$42
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$43,$44,$45,$46,$3F,$3F,$3F,$3F,$47,$48,$49,$4A
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$4B,$4C,$4D,$4E,$4F,$3F,$3F,$3F,$3F,$50,$51,$52
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$53,$54,$55,$55,$55,$56,$3F,$3F,$3F,$57,$58,$59,$5A
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$5B,$5C,$5D,$55,$5E,$5F,$60,$61,$62,$63,$64,$65,$66
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$67,$68,$69,$6A,$6B,$6C,$6D,$6E,$6F,$70,$71,$72
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$73,$74,$75,$76,$77,$78,$79,$7A,$7B
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$7C,$7D,$55,$7E,$7F,$80,$81,$82,$83
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$84,$85,$00,$00,$00,$00,$00,$86,$87,$88,$89,$8A,$8B,$8C,$83
DB $00,$8D,$8E,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$8F,$90,$00,$00,$00,$00,$00,$91,$92,$93,$94,$95,$96,$97,$98
DB $00,$99,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$9A,$55,$9B,$9C,$9D,$7C,$9E,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

; /////////////////
; //             //
; //  Tile Data  //
; //             //
; /////////////////

splash_tile_data:
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$0E,$0E
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$1E,$1E
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$1C,$1C
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$07,$07,$1F,$1F
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$E0,$E0,$F0,$F0
DB $0E,$0E,$0E,$0E,$0F,$0F,$07,$07,$07,$07,$07,$07,$07,$07,$03,$03
DB $1E,$1E,$1E,$1E,$3E,$3E,$3F,$3F,$37,$37,$33,$33,$B3,$B3,$F3,$F3
DB $1C,$1C,$3C,$3C,$38,$38,$38,$38,$38,$38,$38,$38,$78,$78,$F0,$F0
DB $3C,$3C,$78,$78,$78,$78,$78,$78,$70,$70,$78,$78,$78,$78,$78,$78
DB $78,$78,$3C,$3C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$3C,$3C
DB $03,$03,$03,$03,$03,$03,$01,$01,$00,$00,$00,$00,$00,$00,$00,$00
DB $E3,$E3,$E1,$E1,$E1,$E1,$E1,$E1,$00,$00,$00,$00,$00,$00,$00,$00
DB $F0,$F0,$F0,$F0,$F0,$F0,$E0,$E0,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$0F,$00,$00,$1F,$20,$1F
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$80,$00,$40,$80
DB $00,$00,$00,$00,$00,$00,$00,$00,$10,$00,$3E,$01,$45,$3B,$93,$7F
DB $00,$00,$00,$00,$00,$01,$00,$01,$00,$3B,$78,$FF,$F9,$FE,$F1,$FE
DB $00,$00,$01,$00,$40,$BF,$77,$FF,$7F,$FF,$7F,$FF,$7F,$FF,$1C,$FF
DB $00,$00,$00,$00,$40,$80,$C0,$FF,$F7,$FF,$C1,$FF,$C0,$FF,$00,$FF
DB $00,$00,$00,$00,$00,$00,$40,$00,$40,$FE,$E0,$FF,$68,$FF,$00,$FF
DB $00,$00,$00,$00,$00,$00,$00,$00,$80,$00,$10,$E0,$10,$F8,$02,$FC
DB $3C,$3C,$1F,$1F,$07,$07,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $78,$78,$F0,$F0,$E0,$E0,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $28,$1F,$2F,$1F,$2F,$1F,$2B,$1F,$29,$1F,$2D,$1F,$3A,$1F,$38,$1F
DB $07,$C0,$0D,$E3,$20,$FF,$E0,$FF,$80,$FF,$00,$FF,$00,$FF,$03,$FF
DB $7F,$FF,$FF,$FF,$3F,$FF,$05,$FF,$0D,$FF,$2F,$FF,$3F,$FF,$FE,$FF
DB $93,$FC,$A3,$FC,$67,$F8,$E7,$F8,$CF,$F0,$8F,$F0,$1D,$E2,$7D,$82
DB $04,$FF,$E4,$7F,$C0,$7F,$C0,$7F,$84,$7F,$8E,$7F,$86,$7F,$B0,$7F
DB $00,$FF,$AC,$FF,$FC,$FF,$40,$FF,$00,$FF,$00,$FF,$30,$FF,$3D,$FF
DB $40,$BF,$08,$FF,$00,$FF,$00,$FF,$00,$FF,$01,$FF,$B1,$FF,$B1,$FF
DB $08,$F7,$00,$FF,$01,$FE,$0B,$F4,$02,$FD,$88,$FF,$88,$FF,$0E,$FF
DB $40,$80,$DE,$E0,$71,$FE,$1C,$FF,$1C,$FF,$0E,$FF,$E7,$1F,$7B,$87
DB $00,$00,$00,$00,$00,$00,$80,$00,$40,$80,$20,$C0,$18,$E0,$8C,$F0
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$00,$00,$01,$02,$01
DB $10,$3F,$40,$3F,$02,$7F,$84,$7F,$04,$FF,$08,$FF,$19,$FF,$13,$FF
DB $87,$FF,$0F,$FF,$08,$FF,$14,$FF,$74,$FF,$FC,$FF,$FE,$FF,$FF,$FF
DB $F4,$FF,$89,$FE,$18,$FF,$38,$FF,$70,$FF,$60,$FF,$F0,$FF,$F4,$FF
DB $FD,$02,$FF,$00,$FF,$00,$FF,$00,$7F,$80,$7C,$83,$76,$89,$E0,$1F
DB $80,$7F,$82,$7F,$02,$FF,$02,$FF,$80,$FF,$80,$FF,$80,$FF,$80,$FF
DB $3C,$FF,$08,$FF,$00,$FF,$09,$FF,$09,$FF,$09,$FF,$11,$FF,$01,$FF
DB $60,$FF,$00,$FF,$01,$FF,$80,$FF,$80,$FF,$08,$FF,$38,$FF,$40,$FF
DB $37,$FF,$B3,$FF,$E1,$FF,$C1,$FF,$E0,$FF,$E1,$FF,$E4,$FF,$04,$FF
DB $39,$C7,$9D,$E3,$9E,$E1,$CE,$F1,$C6,$F9,$C2,$FD,$C7,$F8,$EF,$F0
DB $84,$F8,$80,$FC,$E2,$FC,$E0,$FE,$71,$FE,$70,$FF,$78,$FF,$B8,$7F
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$80,$00,$80,$00
DB $02,$01,$00,$03,$04,$03,$04,$03,$04,$03,$00,$07,$09,$07,$09,$07
DB $27,$FF,$67,$FF,$4F,$FF,$4F,$FF,$9F,$FF,$9F,$FF,$9F,$FF,$3E,$FF
DB $FF,$FF,$FC,$FF,$E0,$FF,$C0,$FF,$C0,$FF,$00,$FF,$40,$FF,$00,$FF
DB $08,$FF,$18,$FF,$10,$FF,$80,$7F,$00,$FF,$00,$FF,$00,$FF,$00,$FF
DB $E0,$1F,$E0,$1F,$E0,$1F,$F1,$0F,$E1,$1F,$12,$EF,$06,$FF,$04,$FF
DB $80,$FF,$80,$FF,$80,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF
DB $01,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF
DB $10,$FF,$10,$FF,$30,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF
DB $34,$FF,$F0,$FF,$70,$FF,$70,$FF,$00,$FF,$00,$FF,$00,$FF,$01,$FF
DB $C7,$F8,$27,$F8,$23,$FC,$27,$F8,$23,$FC,$71,$FE,$F9,$FE,$1D,$FE
DB $B8,$7F,$BC,$7F,$DC,$3F,$C2,$3F,$E8,$1F,$E8,$1F,$E8,$1F,$E0,$1F
DB $40,$80,$40,$80,$40,$80,$40,$80,$00,$C0,$00,$C0,$00,$C0,$00,$C0
DB $0B,$07,$02,$0F,$02,$0F,$00,$0F,$10,$0F,$10,$0F,$04,$1F,$24,$1F
DB $7E,$FF,$7A,$FF,$78,$FF,$78,$FF,$F8,$FF,$64,$FF,$40,$FF,$04,$FF
DB $00,$FF,$00,$FF,$02,$FF,$00,$FF,$00,$FF,$00,$FF,$01,$FF,$00,$FF
DB $00,$FF,$00,$FF,$00,$FF,$00,$FF,$40,$FF,$20,$FF,$30,$FF,$30,$FF
DB $08,$FF,$08,$FF,$18,$FF,$08,$FF,$08,$FF,$04,$FF,$00,$FF,$00,$FF
DB $00,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF
DB $76,$FF,$30,$FF,$39,$FE,$39,$FE,$79,$FE,$79,$FE,$79,$FE,$F9,$FE
DB $E8,$1F,$E4,$1F,$EF,$1F,$EF,$1F,$CF,$3F,$E7,$1F,$C2,$3F,$EC,$1F
DB $00,$C0,$20,$C0,$00,$C0,$20,$C0,$20,$C0,$A0,$C0,$A0,$C0,$A0,$C0
DB $24,$1F,$08,$1F,$28,$1F,$08,$1F,$00,$1F,$00,$1F,$10,$0F,$10,$0F
DB $58,$FF,$24,$FF,$10,$FF,$3C,$FF,$1B,$FF,$42,$BF,$F0,$3F,$BA,$7D
DB $00,$FF,$41,$BF,$00,$FF,$00,$FF,$00,$FF,$80,$FF,$10,$FF,$01,$FE
DB $D8,$FF,$D8,$FF,$C2,$FF,$E0,$FF,$00,$FF,$00,$FF,$70,$8F,$F8,$07
DB $00,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$01,$FF,$00,$FF,$00,$FF
DB $60,$FF,$30,$FF,$30,$FF,$10,$FF,$01,$FE,$41,$FE,$C0,$FF,$E3,$FC
DB $C7,$3F,$DF,$3F,$0F,$FF,$1C,$FF,$9E,$7F,$C2,$3F,$83,$7F,$30,$FF
DB $A0,$C0,$A0,$C0,$A0,$C0,$20,$C0,$20,$C0,$A0,$C0,$A0,$C0,$A0,$C0
DB $00,$0F,$00,$0F,$10,$0F,$01,$1F,$23,$1F,$02,$3F,$40,$3F,$40,$3F
DB $77,$F8,$6D,$F2,$19,$E6,$00,$FF,$80,$FF,$20,$FF,$20,$FF,$DF,$20
DB $23,$DC,$BF,$40,$EF,$10,$7F,$80,$1F,$E0,$3F,$C0,$7F,$80,$FF,$00
DB $F8,$07,$FC,$03,$FC,$03,$F8,$07,$F8,$07,$F8,$07,$F8,$07,$FF,$00
DB $00,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$60,$9F,$F0,$0F
DB $21,$FE,$01,$FE,$30,$FF,$30,$FF,$20,$FF,$33,$FC,$3B,$FC,$31,$FE
DB $9C,$7F,$98,$7F,$DD,$3F,$1E,$FF,$1C,$FF,$30,$FF,$80,$7F,$80,$7F
DB $A0,$C0,$20,$C0,$20,$C0,$20,$C0,$00,$E0,$40,$A0,$40,$A0,$40,$A0
DB $00,$00,$00,$00,$01,$00,$01,$00,$00,$01,$02,$01,$05,$03,$07,$0F
DB $87,$78,$9B,$64,$B1,$4E,$20,$DF,$22,$DD,$83,$FC,$A7,$D8,$AB,$D4
DB $FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00
DB $F0,$0F,$F0,$0F,$F0,$0F,$F0,$0F,$E0,$1F,$C0,$3F,$C0,$3F,$80,$7F
DB $00,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$01,$FF,$01,$FF
DB $61,$FE,$F1,$FE,$F8,$FF,$FA,$FD,$F3,$FC,$F3,$FC,$E3,$FC,$F3,$FC
DB $C0,$3F,$C0,$3F,$80,$7F,$C0,$3F,$80,$7F,$C0,$3F,$C0,$3F,$C0,$3F
DB $80,$60,$C0,$20,$C0,$20,$00,$E0,$80,$60,$80,$60,$80,$60,$00,$E0
DB $17,$0F,$07,$1F,$17,$0F,$07,$0F,$03,$07,$02,$01,$00,$00,$00,$00
DB $83,$FC,$8F,$F0,$8E,$F1,$84,$FB,$81,$FF,$02,$FF,$85,$7E,$47,$38
DB $CF,$30,$99,$7E,$3B,$FC,$F9,$FE,$F9,$FE,$79,$FE,$FF,$7C,$B3,$7C
DB $FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$BF,$00,$3F,$00,$0F,$00
DB $80,$7F,$B0,$4F,$F2,$0D,$F2,$0D,$FE,$01,$FF,$00,$FE,$01,$FF,$00
DB $00,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$40,$BF,$80,$7F
DB $00,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$01,$FF
DB $00,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$A0,$FF,$B0,$FF
DB $00,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$04,$FB
DB $77,$F8,$A3,$FC,$E3,$FC,$E3,$FC,$63,$FC,$67,$F8,$27,$F8,$4F,$F0
DB $C0,$3F,$C0,$3F,$80,$7F,$80,$7F,$80,$7F,$80,$7F,$C0,$3F,$C3,$3C
DB $40,$A0,$E0,$00,$E0,$00,$E0,$00,$E0,$00,$E0,$00,$A0,$40,$E0,$00
DB $36,$19,$2E,$11,$08,$07,$09,$07,$03,$0F,$08,$07,$07,$00,$00,$00
DB $F7,$38,$4E,$B0,$EE,$F0,$9C,$E0,$38,$C0,$E0,$00,$C0,$00,$00,$00
DB $40,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $0F,$00,$7F,$00,$7F,$00,$3F,$00,$2F,$10,$3F,$00,$1F,$00,$0E,$01
DB $FF,$00,$FF,$00,$FE,$01,$FF,$00,$FF,$00,$FE,$01,$F8,$07,$60,$9F
DB $80,$7F,$80,$7F,$80,$7F,$80,$7F,$80,$7F,$80,$7F,$00,$FF,$02,$FD
DB $01,$FF,$00,$FF,$04,$FF,$00,$FF,$80,$7F,$40,$BF,$00,$FF,$00,$FF
DB $1C,$FF,$9D,$FF,$E0,$FF,$60,$FF,$00,$FF,$07,$F8,$27,$D8,$3F,$C0
DB $4C,$B3,$0C,$F3,$0C,$F3,$44,$BB,$E0,$1F,$E0,$1F,$E0,$1F,$E0,$1F
DB $0F,$F0,$0E,$F1,$1E,$E1,$1F,$E0,$1F,$E0,$3E,$C1,$3F,$C0,$3F,$C0
DB $87,$78,$87,$78,$07,$F8,$07,$F8,$0F,$F0,$1F,$E0,$BC,$43,$3D,$C2
DB $C0,$00,$E0,$00,$20,$C0,$60,$80,$40,$80,$40,$80,$40,$80,$40,$80
DB $0F,$00,$07,$00,$07,$00,$03,$00,$03,$00,$03,$00,$01,$00,$01,$00
DB $00,$FF,$C0,$3F,$F9,$06,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00
DB $3A,$C5,$E0,$1F,$E8,$17,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00
DB $08,$F7,$0F,$F0,$7F,$80,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00
DB $7F,$80,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00
DB $E0,$1F,$E0,$1F,$E0,$1F,$E0,$1F,$E0,$1F,$C0,$3F,$C0,$3F,$C0,$3F
DB $7F,$80,$7F,$80,$7F,$80,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00
DB $3C,$C3,$F8,$07,$F8,$07,$F0,$0F,$E0,$1F,$E0,$1F,$F0,$0F,$F1,$0E
DB $40,$80,$40,$80,$40,$80,$40,$80,$40,$80,$40,$80,$40,$80,$C0,$00
DB $01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $FF,$00,$FF,$00,$FF,$00,$BF,$40,$BF,$40,$BF,$40,$7F,$00,$1F,$60
DB $FF,$00,$FF,$00,$FF,$00,$FF,$00,$FE,$01,$FF,$00,$FF,$00,$B7,$48
DB $FF,$00,$FF,$00,$FE,$01,$FC,$03,$08,$F7,$18,$E7,$0C,$F3,$8C,$73
DB $80,$7F,$00,$FF,$00,$FF,$01,$FE,$00,$FF,$00,$FF,$00,$FF,$D1,$2E
DB $FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$7F,$80,$0F,$F0
DB $F1,$0E,$F0,$0F,$F0,$0F,$F0,$0F,$F0,$0F,$F8,$07,$F0,$0F,$F0,$0F
DB $80,$00,$80,$00,$80,$00,$80,$00,$80,$00,$80,$00,$80,$00,$80,$00
DB $00,$00,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
DB $00,$00,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0
DB $13,$6C,$49,$36,$78,$07,$78,$07,$58,$27,$7C,$03,$7C,$03,$7A,$05
DB $FF,$00,$C3,$3C,$01,$FE,$01,$FE,$01,$FE,$01,$FE,$03,$FC,$03,$FC
DB $81,$7E,$80,$7F,$84,$7F,$80,$7F,$00,$FF,$07,$F8,$07,$F8,$0D,$F0
DB $C0,$3F,$00,$FF,$01,$FE,$51,$AE,$F9,$06,$AB,$54,$BB,$44,$9F,$60
DB $C1,$3E,$C3,$3C,$C3,$3C,$C3,$3C,$E3,$1C,$C7,$38,$CF,$30,$E3,$1C
DB $4F,$F0,$6F,$F0,$6F,$F0,$6F,$F0,$6F,$F0,$4F,$F0,$5F,$E0,$3F,$C0
DB $F1,$0E,$F9,$06,$FB,$04,$FB,$04,$F9,$06,$FF,$00,$FF,$00,$FF,$00
DB $07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07
DB $FC,$FC,$FC,$FC,$00,$00,$00,$00,$00,$00,$F8,$F8,$F8,$F8,$00,$00
DB $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$00,$00,$00,$00
DB $C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$FF,$FF,$FF,$FF,$00,$00,$00,$00
DB $4F,$30,$7F,$00,$7F,$00,$7F,$00,$7F,$00,$3F,$00,$3F,$00,$3F,$00
DB $1F,$E0,$9F,$60,$BF,$40,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00
DB $B9,$40,$F0,$00,$F1,$00,$F1,$00,$F0,$00,$F0,$00,$F0,$00,$F0,$00
DB $BF,$40,$BF,$40,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$3F,$00,$3F,$00
DB $E7,$18,$E7,$18,$E7,$18,$E7,$18,$E7,$18,$FF,$00,$FF,$00,$FF,$00
DB $67,$80,$E7,$00,$83,$00,$03,$00,$03,$00,$01,$00,$01,$00,$01,$00
DB $FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FE,$00
DB $80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$00,$00,$00,$00,$00,$00
DB $3F,$00,$3F,$00,$3F,$00,$3F,$00,$3F,$00,$3F,$00,$1F,$00,$1F,$00
DB $F8,$00,$F8,$00,$F8,$00,$F8,$00,$F8,$00,$F4,$08,$F4,$08,$F4,$08
DB $3F,$00,$1F,$00,$07,$00,$07,$00,$07,$00,$07,$00,$03,$00,$03,$00
DB $FF,$00,$FE,$00,$FE,$00,$FE,$00,$EE,$10,$EE,$10,$FE,$00,$EE,$10
DB $FE,$00,$FE,$00,$FE,$00,$FE,$00,$FE,$00,$FE,$00,$7E,$00,$7E,$00
