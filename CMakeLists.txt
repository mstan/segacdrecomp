cmake_minimum_required(VERSION 3.21)
project(segacdrecomp LANGUAGES C)

set(genesis_root "${CMAKE_CURRENT_SOURCE_DIR}/external/segagenesisrecomp")
if(NOT EXISTS "${genesis_root}/runner/video/genesis_bus.h" OR
   NOT EXISTS "${genesis_root}/external/m68k-recomp-core/cmake/M68kRecompCore.cmake" OR
   NOT EXISTS "${genesis_root}/external/z80-recomp-core/include/sms_runtime.h")
  message(FATAL_ERROR "Initialize the Genesis dependency and its M68K and Z80 core submodules. See the segacdrecomp README.")
endif()

option(SEGACD_BUILD_TOOLS "Build the host generators and Sega CD diagnostic probes" ON)
option(SEGACD_BUILD_NATIVE_RUNNER "Build the consumer's strict native SDL runner" OFF)
include(CTest)
# Keep the original output layout when embedded in the game build.
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}")
add_subdirectory(tests/segacd hardware)
