## Wolf

Wolf is a simple side scrolling platformer where the screen advances
automatically and the player must react.

This is a **ultra-mega-work-in-progress** homebrew platformer for the original
Gameboy. It is written entirely in GB Z80 ASM using
[rgbds](https://github.com/rednex/rgbds) for the assembler/linker toolchain.

Beyond simple experimentation Wolf is my first attempt at GB Z80 / Gameboy
development. It will probably never be finished and the code is varying degrees
of unoptimized hot trash.

## Development

### Building ROM from source

To, build the room [rgbds](https://github.com/rednex/rgbds) must be installed
and the `rgbasm`, `rgblink`, and `rgbfix` commands must be in your `$PATH`.

1. Run `make`
1. Load `wolf.gb` into an emulator, or [onto a ROM
   cartridge](https://krikzz.com/store/home/46-everdrive-gb.html) for use in real
   hardware.

### Development Tools

For development tools [wine](https://www.winehq.org/) must be installed and the
`wine` command must be in your `$PATH`.

By default the `Makefile` assumes all development tools are kept in the
`$HOME/wine` directory. If you place yours elsewhere be sure to update
`TOOLS_ROOT` in the `Makefile`.

#### Debugging/Emulating

1. Download [BGB](http://bgb.bircd.org/) and place `bgb.exe` in `$HOME/wine/`
1. Run `make debug`

#### Tile Editing

1. Download [GBTD](http://www.devrs.com/gb/hmgd/gbtd.html) and place `GBTD.EXE`
   in `$HOME/wine/gbtd.exe` (Note the case change, all caps `.exe`'s are
   silly...)
1. Run `make tiles`

#### Map Editing

1. Download [GBMD](http://www.devrs.com/gb/hmgd/gbmb.html) and place `GBMD.EXE`
   in `$HOME/wine/gbmd.exe` (Note the case change, all caps `.exe`'s are
   silly...)
1. Run `make map`
