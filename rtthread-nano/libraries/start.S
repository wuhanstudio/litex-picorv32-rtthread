/*
 * Copyright (c) 2020-2020, YuZhaorong 
 *
 * SPDX-License-Identifier: Apache-2.0
 *
 * Change Logs:
 * Date           Author       Notes
 * 2020-06-06     YuZhaorong      
 */
 
#include <custom_ops.S>

/*
 * Interrupt vector.
 */
.global _irq

.global _start
_start:

.org 0x00000000 # Reset
  j _pvstart

.org 0x00000010 # IRQ
_irq_vector:
  addi sp, sp, -16
  sw t0, 4(sp)
  sw ra, 8(sp)

  /* By convention, q2 holds true IRQ vector, but remains caller-save.
  We rely on the assumption that compiler-generated code will never touch
  the QREGs. q3 is truly scratch/caller-save. */
  picorv32_getq_insn(t0, q2)
  sw t0, 12(sp)

  jalr t0 // Call the true IRQ vector.

  lw t0, 12(sp)
  picorv32_setq_insn(q2, t0) // Restore the true IRQ vector.
  lw ra, 8(sp)
  lw t0, 4(sp)
  addi sp, sp, 16
  picorv32_retirq_insn() // return from interrupt

.global _pvstart

_pvstart: 
  /* zero-initialize all registers */
  addi x1, zero, 0
  addi x2, zero, 0
  addi x3, zero, 0
  addi x4, zero, 0
  addi x5, zero, 0
  addi x6, zero, 0
  addi x7, zero, 0
  addi x8, zero, 0
  addi x9, zero, 0
  addi x10, zero, 0
  addi x11, zero, 0
  addi x12, zero, 0
  addi x13, zero, 0
  addi x14, zero, 0
  addi x15, zero, 0
  addi x16, zero, 0
  addi x17, zero, 0
  addi x18, zero, 0
  addi x19, zero, 0
  addi x20, zero, 0
  addi x21, zero, 0
  addi x22, zero, 0
  addi x23, zero, 0
  addi x24, zero, 0
  addi x25, zero, 0
  addi x26, zero, 0
  addi x27, zero, 0
  addi x28, zero, 0
  addi x29, zero, 0
  addi x30, zero, 0
  addi x31, zero, 0

  /* mask all interrupts */
  li t0, 0xffffffff
  picorv32_maskirq_insn(zero, t0)
  /* reflect that in _irq_mask */
  la t1, _irq_mask
  sw t0, 0(t1)

  /* Load DATA */
  la t0, _fdata_rom
  la t1, _fdata
  la t2, _edata
3:
  lw t3, 0(t0)
  sw t3, 0(t1)
  /* _edata is aligned to 16 bytes. Use word-xfers. */
  addi t0, t0, 4
  addi t1, t1, 4
  bltu t1, t2, 3b

  /* Clear BSS */
  la t0, _fbss
  la t1, _ebss
2:
  sw zero, 0(t0)
  addi t0, t0, 4
  bltu t0, t1, 2b

  /* set main stack */
  la sp, _fstack

  /* Set up address to IRQ handler since vector is hardcoded.
  By convention, q2 keeps the pointer to the true IRQ handler,
  to emulate relocatable interrupts. */
  la t0, _irq
  picorv32_setq_insn(q2, t0)

  /* jump to entry */
  jal ra, entry

1:
  /* loop forever */
  j 1b
