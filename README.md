# segacdrecomp

The Sega CD engine owns the main and sub-68000 timeline, CD drive and controller,
PCM and CD audio, stamp graphics, DMA, disc images, backup RAM and native catalog
support. It uses the Genesis bus, VDP, audio and host code from a pinned
`external/segagenesisrecomp` checkout. The Genesis pin also selects the shared
M68K and Z80 cores. Sega CD is compiled from this repository's `runner/cd`.

Sonic CD is a separate consumer. Its repository owns the game catalog recipe,
media verification, rendering, loading service, launcher and packaging. The
engine accepts the consumer's `SEGACD_GAME_TARGET` and `SEGACD_GAME_SOURCES` for
the strict native SDL build. The `segacd::devices`, `segacd::disc_image` and
`segacd::machine` CMake targets can be used without the game or its media.

## Build and test

```sh
git submodule update --init external/segagenesisrecomp
git -C external/segagenesisrecomp submodule update --init external/m68k-recomp-core external/z80-recomp-core
cmake -S . -B build
cmake --build build --config Release --parallel 4
ctest --test-dir build -C Release --output-on-failure --timeout 0
```

Synthetic tests use C11 and Python 3. The game also needs C++17 and SDL2. With
`BUILD_TESTING=OFF`, `SEGACD_BUILD_TOOLS=ON` retains the host generators and BIOS
discovery probe. The probe is separate from the strict native runner. Follow the
consumer's build instructions to generate catalogs from owned media.

The first standalone revision uses the qualified Genesis pin from the Sonic CD
0.0.5 build. The shared [license](LICENSE.md), recompiler [license](LICENSE-recompiler),
and [ares notice](runner/cd/ARES-LICENSE.txt) accompany the extracted code.
