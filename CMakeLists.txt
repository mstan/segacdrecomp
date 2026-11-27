cmake_minimum_required(VERSION 3.21)
project(segacdrecomp LANGUAGES C CXX)

set(RECOMP_SHARED_CORE_ROOT "" CACHE PATH "Optional shared core checkout root")
if(RECOMP_SHARED_CORE_ROOT AND
   EXISTS "${RECOMP_SHARED_CORE_ROOT}/recomp-image-core/CMakeLists.txt")
  set(_segacd_image_root "${RECOMP_SHARED_CORE_ROOT}/recomp-image-core")
else()
  set(_segacd_image_root "${CMAKE_CURRENT_SOURCE_DIR}/external/recomp-image-core")
endif()
if(NOT TARGET recomp-image-core::archive)
  set(BUILD_TESTING_SAVED "${BUILD_TESTING}")
  set(BUILD_TESTING OFF)
  add_subdirectory("${_segacd_image_root}" "${CMAKE_BINARY_DIR}/shared-cores/recomp-image-core" EXCLUDE_FROM_ALL)
  set(BUILD_TESTING "${BUILD_TESTING_SAVED}")
endif()
include_directories("${_segacd_image_root}/include")

set(GENESIS_RECOMP_ROOT "" CACHE PATH "Optional shared Genesis engine checkout")
if(GENESIS_RECOMP_ROOT)
  set(genesis_root "${GENESIS_RECOMP_ROOT}")
else()
  set(genesis_root "${CMAKE_CURRENT_SOURCE_DIR}/external/segagenesisrecomp")
endif()
if(NOT EXISTS "${genesis_root}/runner/video/genesis_bus.h" OR
   NOT EXISTS "${genesis_root}/external/m68k-recomp-core/cmake/M68kRecompCore.cmake" OR
   NOT EXISTS "${genesis_root}/external/z80-recomp-core/include/sms_runtime.h")
  message(FATAL_ERROR "Initialize the Genesis dependency and its M68K and Z80 core submodules. See the segacdrecomp README.")
endif()

include("${genesis_root}/cmake/SharedCoreIntegration.cmake")

option(SEGACD_BUILD_TOOLS "Build the host generators and Sega CD diagnostic probes" ON)
option(SEGACD_BUILD_NATIVE_RUNNER "Build the consumer's strict native SDL runner" OFF)
include(CTest)
# Keep the original output layout when embedded in the game build.
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}")
add_subdirectory(tests/segacd hardware)
