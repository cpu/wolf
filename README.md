![Wolf](https://binaryparadox.net/d/906c1e6f-ab5a-4c41-b56b-4098fcf6ce31.jpg)

## Wolf

Wolf is a simple side scrolling platformer where the screen advances
automatically and the player must react.

This is a **ultra-mega-work-in-progress** homebrew platformer for the original
Gameboy. It is written entirely in GB Z80 ASM using
[rgbds](https://github.com/rednex/rgbds) for the assembler/linker toolchain.

Beyond simple experimentation Wolf is my first attempt at GB Z80 / Gameboy
development. It will probably never be finished and the code is varying degrees
of unoptimized hot trash.

Wolf is **10000%** not finished!

## Development

### Building ROM from source

To, build the ROM [rgbds](https://github.com/rednex/rgbds) must be installed
and the `rgbasm`, `rgblink`, and `rgbfix` commands must be in your `$PATH`.

1. Run `make`.
1. Load `wolf.gb` into an emulator, or [onto a ROM
   cartridge](https://krikzz.com/store/home/46-everdrive-gb.html) for use in real
   hardware.

To aid with testing you can also build the ROM with gravity and death disabled:

1. Run `make clean` to remove any previous builds.
1. Run `make GODMODE=1` to build no gravity or death.

### Development Tools

For development tools [wine](https://www.winehq.org/) must be installed and the
`wine` command must be in your `$PATH`.

By default the `Makefile` assumes all development tools are kept in the
`$HOME/wine` directory. If you place yours elsewhere be sure to update
`TOOLS_ROOT` in the `Makefile`.

#### Debugging/Emulating

1. Download [BGB](http://bgb.bircd.org/) and place `bgb.exe` in `$HOME/wine/`
1. Run `make debug`

**Pro-tip:** BGB can be configured to automatically break on many conditions
that can happen when your code is buggy. Enable **all** of the possible debugger
exceptions that can be found under the **bgp control panel** under the
**Exceptions** tab:

![BGB Exceptions
Configuration](https://binaryparadox.net/d/548a91cf-d399-4db2-8035-472a36b486c6.jpg)

For more information [see these BGB debugger
tips/tricks](https://github.com/doeg/gb-skeleton/blob/master/docs/bgb.md).

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
