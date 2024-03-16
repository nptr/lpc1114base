/* 26.3.8 Code Read Protection (CRP), UM10398.pdf
 * Code Read Protection is a mechanism that allows the user to enable 
 * different levels of security in the system so that access to the on-chip
 * flash and use of the ISP can be restricted.
 */

#define CRP_NONE    0xFFFFFFFF

/* Prevents sampling of pin PIO0_1 for entering ISP mode. PIO0_1 is
 * available for other uses.
 */
#define CRP_NO_ISP  0x4E697370

/* Access to chip via the SWD pins is disabled. This mode allows partial
 * flash update using the following ISP commands and restrictions:
    - Write to RAM command should not access RAM below 0x1000
     0300. Access to addresses below 0x1000 0200 is disabled.
    - Copy RAM to flash command can not write to Sector 0.
    - Erase command can erase Sector 0 only when all sectors are
     selected for erase.
    - Compare command is disabled.
    - Read Memory command is disabled.
 * This mode is useful when CRP is required and flash field updates are
 * needed but all sectors can not be erased. Since compare command
 * is disabled in case of partial updates the secondary loader should
 * implement checksum mechanism to verify the integrity of the flash.
 */
#define CRP_CRP1    0x12345678

/* Access to chip via the SWD pins is disabled. The following ISP
 * commands are disabled:
 * - Read Memory
 * - Write to RAM
 * - Go
 * - Copy RAM to flash
 * - Compare
 * When CRP2 is enabled the ISP erase command only allows erasure
 * of all user sectors.
 */
#define CRP_CRP2    0x87654321

/* Access to chip via the SWD pins is disabled. ISP entry by pulling
 * PIO0_1 LOW is disabled if a valid user code is present in flash sector 0.
 * This mode effectively disables ISP override using PIO0_1 pin. It is up
 * to the user’s application to provide a flash update mechanism using
 * IAP calls or call reinvoke ISP command to enable flash update via UART.
 * 
 * CAUTION: IF CRP3 IS SELECTED, NO FUTURE FACTORY TESTING CAN BE
 * PERFORMED ON THE DEVICE.
 */
#define CRP_CRP3    0x43218765

/* Compile time configuration */
#ifndef CURRENT_CRP_SETTING
    #define CURRENT_CRP_SETTING CRP_NONE
#endif

__attribute__ ((used,section(".crp"))) const unsigned int CRP_WORD = CURRENT_CRP_SETTING;