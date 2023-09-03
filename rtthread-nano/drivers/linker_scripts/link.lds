/*
This is free and unencumbered software released into the public domain.

Anyone is free to copy, modify, publish, use, compile, sell, or
distribute this software, either in source code form or as a compiled
binary, for any purpose, commercial or non-commercial, and by any
means.
*/

/* starting address needs to be > 0 due to known bug in RISCV/GNU linker */
MEMORY {
	sram : ORIGIN = 0x00000000, LENGTH = 0x00010000
	rom : ORIGIN = 0x00840000, LENGTH = 0x00008000
	csr : ORIGIN = 0x82000000, LENGTH = 0x00010000
}

ENTRY(_pvstart);

SECTIONS 
{
  .init :
  {
    . = ALIGN(4);
    *(.text.entry);
  } > rom

  .interrupt ORIGIN(rom) + 0x400: 
  {
    . = ALIGN(4);
    KEEP(*(.text.interrupt));
  } > rom

  .data :
  {
    _data_lma = LOADADDR(.data);
    _data = .;
    __global_pointer$ = . ;
    *(.data .data.* )
    *(.sdata .sdata.*)
    *(COMMON)
      . = ALIGN(4);
    _edata = .;
  } >sram AT > rom
  
  .bss :
  {
    _bss_start = .;
    *(.bss .bss.*)
    *(.sbss .sbss.*)
      . = ALIGN(4);
    _bss_end = .;
    _end = .;
  } > sram
  
  .rom :
  {
    . = ALIGN(4);
    *(.text);

    /* section information for finsh shell */
    . = ALIGN(4);
    __fsymtab_start = .;
    KEEP(*(FSymTab))
    __fsymtab_end = .;
    . = ALIGN(4);
    __vsymtab_start = .;
    KEEP(*(VSymTab))
    __vsymtab_end = .;
    . = ALIGN(4);	
    *(.stub .text.* .gnu.linkonce.t.*);
    *(.rodata  .rodata.*);
    *(.*);
  } > rom

  .stack ORIGIN(sram) + LENGTH(sram) :
  {
    _riscv_sp = . ; 
  } > sram 
}


