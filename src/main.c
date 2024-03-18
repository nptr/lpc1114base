#ifdef __USE_CMSIS
#include "LPC11xx.h"
#endif

#if defined(NO_BOARD_LIB)
#include "chip.h"
#else
#include "board.h"
#endif

#include <gpio_11xx_2.h>

int main(void) {

    SystemCoreClockUpdate();

    // Force the counter to be placed into memory
    volatile static int i = 0 ;
    // Enter an infinite loop, just incrementing a counter
    while(1) {
        i++ ;
    }
    return 0 ;
}
