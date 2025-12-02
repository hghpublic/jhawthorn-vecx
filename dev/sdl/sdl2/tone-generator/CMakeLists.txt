cmake_minimum_required(VERSION 3.30)

project(tone-generator C)

find_package(SDL2 REQUIRED)

set(target tone-generator)
add_executable(${target} main.c)
target_compile_features(${target} PRIVATE c_std_23)
target_link_libraries(${target} PRIVATE
    $<TARGET_NAME_IF_EXISTS:SDL2::SDL2main>
    $<IF:$<TARGET_EXISTS:SDL2::SDL2>,
        SDL2::SDL2,
        SDL2::SDL2-static>
)
