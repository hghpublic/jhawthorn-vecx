cmake_minimum_required(VERSION 3.30)


project(vecx
    VERSION 0.1.0
    LANGUAGES C
)

# if using valgrind, set BUILD_WITH_ASAN to OFF
option(BUILD_WITH_ASAN "Build with ASAN" ON)

# SDL does not seem not to find a 'pulseaudio' driver in a devcontainer
# FIXME: setting environment variable SDL_AUDIODRIVER to 'dummy' does not help
# https://wiki.libsdl.org/SDL2/FAQUsingSDL#how_do_i_choose_a_specific_audio_driver
option(BUILD_WITH_AUDIO "Build with audio support" OFF)

find_package(SDL2 REQUIRED)
find_package(SDL2_image CONFIG REQUIRED)
find_package(sdl2-gfx CONFIG REQUIRED)

set(target vecx)

add_executable(${target})
if(BUILD_WITH_AUDIO)
    target_compile_definitions(${target} PRIVATE HAS_AUDIO)
endif()
target_compile_features(${target} PRIVATE c_std_23)
target_sources(${target} PRIVATE
    osint.c

    vecx.c

    e6809.c
    e8910.c
)

if(BUILD_WITH_ASAN)
    target_compile_options(${target} PRIVATE -fsanitize=address)
    target_link_options(${target} PRIVATE -fsanitize=address)
endif()

target_link_libraries(${target} PRIVATE
    $<TARGET_NAME_IF_EXISTS:SDL2::SDL2main>
    $<IF:$<TARGET_EXISTS:SDL2::SDL2>,
        SDL2::SDL2,
        SDL2::SDL2-static>
)
target_link_libraries(${target} PRIVATE SDL2::SDL2_gfx)
target_link_libraries(${target} PRIVATE
    $<IF:$<TARGET_EXISTS:SDL2_image::SDL2_image>,
        SDL2_image::SDL2_image,
        SDL2_image::SDL2_image-static>
)

# copy rom.dat

add_custom_command(TARGET ${target} POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy
        ${CMAKE_SOURCE_DIR}/rom.dat
        $<TARGET_FILE_DIR:${target}>/)

# valgrind target

add_custom_target(valgrind
    COMMAND valgrind
        --leak-check=full
        --show-leak-kinds=all
        --track-origins=yes
        -s --suppressions=${CMAKE_SOURCE_DIR}/vecx.valgrind.supp
        --gen-suppressions=all
        --log-file=${CMAKE_SOURCE_DIR}/dev/vecx/logs/memcheck.log
        $<TARGET_FILE:${target}>
    DEPENDS ${target}
    WORKING_DIRECTORY $<TARGET_FILE_DIR:${target}>
    COMMENT "Running Maelstrom with valgrind"
)
