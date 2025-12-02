#!/bin/sh
cmake -S . -B build \
    -DCMAKE_TOOLCHAIN_FILE="${VCPKG_ROOT}/scripts/buildsystems/vcpkg.cmake"
(cd build && cmake --build .)
./build/testmixer

# https://wiki.libsdl.org/SDL3/README-linux
# libxcb-xinput-dev libxfixes-dev libxrandr-dev libxss-dev libxi-dev libxtst-dev
# libx11-dev libxext-dev libxrandr-dev libxcursor-dev libxfixes-dev libxi-dev libxss-dev libxtst-dev libxkbcommon-dev
# X11_XIQueryVersion XIMaskIsSet XIRawEvent
# xorg-dev
