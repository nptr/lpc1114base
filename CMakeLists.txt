cmake_minimum_required(VERSION 3.28)
project(lpc1114base)

add_subdirectory(lib/lpc_chip_11cxx_lib)

add_executable(${PROJECT_NAME}
    src/cr_startup_lpc11xx.c
    src/lpc11xx_crp.c
    src/main.c
    src/sysinit.c
)

target_compile_definitions(${PROJECT_NAME} PRIVATE
    NO_BOARD_LIB
    __USE_LPCOPEN
)

target_link_libraries(${PROJECT_NAME} PRIVATE
    gcc
    lpc_chip_11cxx_lib
)

# use the .elf extension for the output file, to not mistake it to be flashable.
set_target_properties(${PROJECT_NAME} PROPERTIES OUTPUT_NAME ${PROJECT_NAME}.elf)

# postbuild step to make a flashable, raw, binary file.
add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD
    COMMAND ${CMAKE_OBJCOPY} -v -O binary ${PROJECT_NAME}.elf ${PROJECT_NAME}.bin
)