cmake_minimum_required(VERSION 3.28)
project(lpc1114base)

add_subdirectory(lib/lpc_chip_11cxx_lib)

add_executable(${PROJECT_NAME}
    src/cr_startup_lpc11xx.c
    src/crp.c
    src/main.c
    src/sysinit.c
)

target_compile_definitions(${PROJECT_NAME} PRIVATE
    NO_BOARD_LIB
    __USE_LPCOPEN
)

target_link_libraries(${PROJECT_NAME} PRIVATE
    lpc_chip_11cxx_lib
)