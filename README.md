# segacdrecomp

`segacdrecomp` is a shared engine for native recompilation of Sega CD games.
It coordinates the main and sub 68000 CPUs and implements the CD drive and
controller, CD audio and PCM, stamp graphics, DMA, disc images and backup RAM.
It builds as libraries and host tools that a game repository can pin as a Git
submodule.

## Sonic CD

[SonicCDRecomp](https://github.com/mstan/SonicCDRecomp) is the first consumer.
Its [standalone engine build guide](https://github.com/mstan/SonicCDRecomp/blob/main/docs/BUILDING.md)
shows how to generate native catalogs from an owned BIOS and disc image and
build the playable game. The game repository supplies the input checks, catalog
recipe, title-specific rendering and loading code, launcher and packaging.
BIOS images, game media and generated catalogs stay in local build directories.

## Dependencies

- [segagenesisrecomp](https://github.com/mstan/segagenesisrecomp) provides the
  shared Genesis bus, VDP, audio and host code. Its submodule pins select the
  [68000 core](https://github.com/mstan/m68k-recomp-core) and
  [Z80 core](https://github.com/mstan/z80-recomp-core).
- The engine builds with CMake 3.21+ and a C11 compiler. The host catalog tools
  and Python tests use Python 3.10+.
- A native SDL runner also uses a C++17 compiler, [SDL2](https://github.com/libsdl-org/SDL)
  and a pinned [recomp-ui](https://github.com/mstan/recomp-ui) runtime. Sonic CD
  pins the [Z80 generation frontend](https://github.com/mstan/smsggrecomp)
  alongside the engine.

## Build and use

```sh
git clone https://github.com/mstan/segacdrecomp.git
cd segacdrecomp
git submodule update --init external/segagenesisrecomp
git -C external/segagenesisrecomp submodule update --init external/m68k-recomp-core external/z80-recomp-core
cmake -S . -B build
cmake --build build --config Release --parallel 4
ctest --test-dir build -C Release --output-on-failure --timeout 0
```

Consumers can link `segacd::devices`, `segacd::disc_image` and `segacd::machine`
through CMake. To build a title's native SDL executable, the consumer sets
`SEGACD_GAME_TARGET` and `SEGACD_GAME_SOURCES` and supplies the generated
catalogs. `SEGACD_BUILD_TOOLS` makes the host generators and BIOS discovery
probe available independently. The probe runs the original program for catalog
discovery. The game executes the compiled native catalogs.

The shared [license](LICENSE.md), [recompiler license](LICENSE-recompiler) and
[ares notice](runner/cd/ARES-LICENSE.txt) accompany the extracted code.

## Release tools

`tools/segacd/stage_release_runtime.ps1 -StageDir PATH [-RuntimeDir PATH]`
uses the pinned Genesis release provider to copy and verify the transitive
Windows DLL closure. Every staged executable and DLL must be x64. Runtime
lookup is limited to the stage and the caller's approved redistributable
directory. Consumers retain their payload allowlists, license/provenance
checks, native-save policy and archive layout.

Linux consumers can source
`external/segagenesisrecomp/tools/release/appimage.sh` for verified pinned
tool acquisition. A consumer with a separately qualified AppImage runtime
retains its explicit runtime selection and corresponding license checks.
