//--------------------------------------------------------------------------------
// Auto-generated by LiteX (e8689eb1) on 2023-09-30 16:58:23
//--------------------------------------------------------------------------------
#ifndef __GENERATED_MEM_H
#define __GENERATED_MEM_H

#ifndef SRAM_BASE
#define SRAM_BASE 0x00000000L
#define SRAM_SIZE 0x00010000
#endif

#ifndef SPIFLASH_BASE
#define SPIFLASH_BASE 0x00800000L
#define SPIFLASH_SIZE 0x00800000
#endif

#ifndef ROM_BASE
#define ROM_BASE 0x00840000L
#define ROM_SIZE 0x00008000
#endif

#ifndef CSR_BASE
#define CSR_BASE 0x82000000L
#define CSR_SIZE 0x00010000
#endif

#ifndef MEM_REGIONS
#define MEM_REGIONS "SRAM      0x00000000 0x10000 \nSPIFLASH  0x00800000 0x800000 \nROM       0x00840000 0x8000 \nCSR       0x82000000 0x10000 "
#endif
#endif
