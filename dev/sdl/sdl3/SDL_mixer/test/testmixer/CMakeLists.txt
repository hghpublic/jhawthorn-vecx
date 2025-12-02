cmake_minimum_required(VERSION 3.30)

project(testmixer C)

include(FetchContent)
FetchContent_Declare(
  SDL3
  GIT_REPOSITORY https://github.com/libsdl-org/SDL.git
  GIT_TAG        main
)
FetchContent_MakeAvailable(SDL3) 

set(target testmixer)
add_executable(${target} testmixer.c)
target_compile_features(${target} PRIVATE c_std_23)
target_link_libraries(${target} PRIVATE SDL3::SDL3)
