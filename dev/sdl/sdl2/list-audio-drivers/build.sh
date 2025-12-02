#!/bin/sh
cmake -S . -B build -DCMAKE_TOOLCHAIN_FILE="${VCPKG_ROOT}/scripts/buildsystems/vcpkg.cmake"
(cd build && cmake --build .)
./build/list-audio-drivers
