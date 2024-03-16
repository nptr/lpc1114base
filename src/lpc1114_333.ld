/*
 * Linker script file for LPC1114/333
 * - Does not support C++ binaries
 */

GROUP (
  libcr_c.a
  libcr_eabihelpers.a
)


MEMORY
{
  Flash (rx) : ORIGIN = 0x0, LENGTH = 0xe000 /* 56K bytes */  
  RAM (rwx) : ORIGIN = 0x10000000, LENGTH = 0x2000 /* 8K bytes */  
}

/* Define a symbol for the top of each memory region */
__base_Flash = 0x0 ;                /* Flash */  
__top_Flash = 0x0 + 0xe000 ;        /* 56K bytes */  
__base_RAM = 0x10000000 ;           /* RAM */  
__top_RAM = 0x10000000 + 0x2000 ;   /* 8K bytes */  


ENTRY(ResetISR)

SECTIONS
{
    /* 
     * .text section for MCU startup code & data.
     */
    .text : ALIGN(4)
    {
        FILL(0xff)
        KEEP(*(.isr_vector))
        
        /* Global Section Table */
        . = ALIGN(4) ; 
        __data_section_table = .;
        LONG(LOADADDR(.data));
        LONG(    ADDR(.data));
        LONG(  SIZEOF(.data));
        __data_section_table_end = .;
        __bss_section_table = .;
        LONG(    ADDR(.bss));
        LONG(  SIZEOF(.bss));
        __bss_section_table_end = .;
	    /* End of Global Section Table */

        *(.after_vectors*)

        /* Code Read Protection */
        . = 0x2fc;
        KEEP(*(.crp))
    } > Flash

    /* .text section for application code & data */
    .text : ALIGN(4)
    {
        *(.text*)
        *(.rodata .rodata.* .constdata .constdata.*)
        . = ALIGN(4);
    } > Flash
    
    /*
     * For exception handling/unwind - some Newlib functions (in common
     * with C++ and STDC++) use this. 
     */
    .ARM.extab : ALIGN(4)
    {
        *(.ARM.extab* .gnu.linkonce.armextab.*)
    } > Flash
    __exidx_start = .;

    .ARM.exidx : ALIGN(4)
    {
        *(.ARM.exidx* .gnu.linkonce.armexidx.*)
    } > Flash
    __exidx_end = .;

    _etext = .;
        
    /* 
     * Allow reserving the first block of RAM. Some NXP MCUs have peripheral
     * drivers built into ROM that require space here we must not use.
     */
    .uninit_RESERVED : ALIGN(4)
    {
        KEEP(*(.bss.$RESERVED*))
        . = ALIGN(4) ;
        _end_uninit_RESERVED = .;
    } > RAM

    /* 
     * Statically initialized RAM (loaded from Flash)
     */
    .data : ALIGN(4)
    {
       FILL(0xff)
       _data = . ;
       *(vtable)
       *(.ramfunc*)
       *(.data*)
       . = ALIGN(4) ;
       _edata = . ;
    } > RAM AT> Flash

    /*
     * Zero initialized RAM
     */
    .bss : ALIGN(4)
    {
        _bss = .;
        *(.bss*)
        *(COMMON)
        . = ALIGN(4) ;
        _ebss = .;
        PROVIDE(end = .);
    } > RAM

    /*
     * Uninitialized RAM
     */
    .noinit (NOLOAD): ALIGN(4)
    {
        _noinit = .;
        *(.noinit*) 
         . = ALIGN(4) ;
        _end_noinit = .;
    } > RAM

    PROVIDE(_pvHeapStart = DEFINED(__user_heap_base) ? __user_heap_base : .);
    PROVIDE(_vStackTop = DEFINED(__user_stack_top) ? __user_stack_top : __top_RAM - 0);

    /* ## Create checksum value (used in startup) ## */
    PROVIDE(__valid_user_code_checksum = 0 - 
                                         (_vStackTop 
                                         + (ResetISR + 1) 
                                         + (( DEFINED(NMI_Handler) ? NMI_Handler : M0_NMI_Handler ) + 1) 
                                         + (( DEFINED(HardFault_Handler) ? HardFault_Handler : M0_HardFault_Handler ) + 1) 
                                         )
    );
}