cmake_minimum_required(VERSION 3.28)
project(lpc_chip_11cxx_lib)

add_compile_definitions(${PROJECT_NAME}
)

add_library(${PROJECT_NAME} STATIC
    src/adc_11xx.c
    src/adc_1125.c
    src/chip_11xx.c
    src/clock_11xx.c
    src/gpio_11xx_1.c
    src/gpio_11xx_2.c
    src/gpiogroup_11xx.c
    src/i2c_11xx.c
    src/iocon_11xx.c
    src/pinint_11xx.c
    src/pmu_11xx.c
    src/ring_buffer.c
    src/ssp_11xx.c
    src/sysctl_11xx.c
    src/sysinit_11xx.c
    src/timer_11xx.c
    src/uart_11xx.c
    src/wwdt_11xx.c
)

target_compile_definitions(${PROJECT_NAME} PUBLIC
    CORE_M0
)

target_include_directories(${PROJECT_NAME} PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}/inc
)