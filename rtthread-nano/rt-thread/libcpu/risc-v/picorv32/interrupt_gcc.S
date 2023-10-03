#include "custom_ops.S"

#define REGBYTES 4

/*
 * IRQ handler, branched to from the vector.
 */
 .global _irq

_irq:
    /* save registers */
    addi sp, sp, -32 * REGBYTES
    
    picorv32_setq_insn(q2, x1)

    picorv32_getq_insn(x1, q0)
    
    sw x1,   0*REGBYTES(sp)             /* save epc pointer */
    
    picorv32_getq_insn(x1, q2)          /* save return address */ 
    sw x1,   1 * REGBYTES(sp)
    
    sw x5,   5 * REGBYTES(sp)
    sw x6,   6 * REGBYTES(sp)
    sw x7,   7 * REGBYTES(sp)
    sw x8,   8 * REGBYTES(sp)
    sw x9,   9 * REGBYTES(sp)
    sw x10, 10 * REGBYTES(sp)
    sw x11, 11 * REGBYTES(sp)
    sw x12, 12 * REGBYTES(sp)
    sw x13, 13 * REGBYTES(sp)
    sw x14, 14 * REGBYTES(sp)
    sw x15, 15 * REGBYTES(sp)
    sw x16, 16 * REGBYTES(sp)
    sw x17, 17 * REGBYTES(sp)
    sw x18, 18 * REGBYTES(sp)
    sw x19, 19 * REGBYTES(sp)
    sw x20, 20 * REGBYTES(sp)
    sw x21, 21 * REGBYTES(sp)
    sw x22, 22 * REGBYTES(sp)
    sw x23, 23 * REGBYTES(sp)
    sw x24, 24 * REGBYTES(sp)
    sw x25, 25 * REGBYTES(sp)
    sw x26, 26 * REGBYTES(sp)
    sw x27, 27 * REGBYTES(sp)
    sw x28, 28 * REGBYTES(sp)
    sw x29, 29 * REGBYTES(sp)
    sw x30, 30 * REGBYTES(sp)
    sw x31, 31 * REGBYTES(sp)

    picorv32_setq_insn(q3, x2)          /* save sp to q3 register */
    
    /* switch to interrupt stack */
    la sp , _irq_stack                   /* load irq stack */

    /* interrupt handle */
    call  rt_interrupt_enter
  
  	// arg0 = address of regs
  	lui a0, %hi(irq_regs)
	  addi a0, a0, %lo(irq_regs)

	  // arg1 = interrupt type
	  picorv32_getq_insn(a1, q1)

    /* call to C function */
    jal ra, irq

    // new irq_regs address returned from C code in a0
	  addi x1, a0, 0  /* use x1 to index into irq_regs */

    call  rt_interrupt_leave

    /* switch to from thread stack */
    picorv32_getq_insn(sp, q3)
  
    /* need to switch new thread */
    la    s0, rt_thread_switch_interrupt_flag
    lw    s2, 0(s0)
    beqz  s2, rt_hw_context_switch_interrupt_exit
  
    /* clear switch interrupt flag */
    sw    zero, 0(s0)

    la    s0, rt_interrupt_from_thread
    lw  s1, 0(s0)
    sw sp, 0(s1)

    la    s0, rt_interrupt_to_thread
    lw  s1, 0(s0)
    lw  sp, 0(s1)

    lw  a0,  0 * REGBYTES(sp)
    picorv32_setq_insn(q0, a0)

    /* restore registers */
    rt_hw_context_switch_interrupt_exit:

    lw x1,   0 * REGBYTES(sp)
    picorv32_setq_insn(q0, x1)

    lw x1,   1 * REGBYTES(sp)
    picorv32_setq_insn(q2, x1)

    lw x5,   5 * REGBYTES(sp)
    lw x6,   6 * REGBYTES(sp)
    lw x7,   7 * REGBYTES(sp)
    lw x8,   8 * REGBYTES(sp)
    lw x9,   9 * REGBYTES(sp)
    lw x10, 10 * REGBYTES(sp)
    lw x11, 11 * REGBYTES(sp)
    lw x12, 12 * REGBYTES(sp)
    lw x13, 13 * REGBYTES(sp)
    lw x14, 14 * REGBYTES(sp)
    lw x15, 15 * REGBYTES(sp)
    lw x16, 16 * REGBYTES(sp)
    lw x17, 17 * REGBYTES(sp)
    lw x18, 18 * REGBYTES(sp)
    lw x19, 19 * REGBYTES(sp)
    lw x20, 20 * REGBYTES(sp)
    lw x21, 21 * REGBYTES(sp)
    lw x22, 22 * REGBYTES(sp)
    lw x23, 23 * REGBYTES(sp)
    lw x24, 24 * REGBYTES(sp)
    lw x25, 25 * REGBYTES(sp)
    lw x26, 26 * REGBYTES(sp)
    lw x27, 27 * REGBYTES(sp)
    lw x28, 28 * REGBYTES(sp)
    lw x29, 29 * REGBYTES(sp)
    lw x30, 30 * REGBYTES(sp)
    lw x31, 31 * REGBYTES(sp)
    
    picorv32_getq_insn(x1, q2)

    addi  sp, sp, 32 * REGBYTES

  ret

/*
 * Enable interrupts by copying the software mask to the hardware mask
 */
.global _irq_enable
_irq_enable:
  /* Set _irq_enabled to true */
  la t0, _irq_enabled
  addi t1, zero, 1
  sw t1, 0(t0)
  /* Set the HW IRQ mask to _irq_mask */
  la t0, _irq_mask
  lw t0, 0(t0)
  picorv32_maskirq_insn(zero, t0)
  ret

/*
 * Disable interrupts by masking all interrupts (the mask should already be
 * up to date)
 */
.global _irq_disable
_irq_disable:
  /* Mask all IRQs */
  li t0, 0xffffffff
  picorv32_maskirq_insn(zero, t0)
  /* Set _irq_enabled to false */
  la t0, _irq_enabled
  sw zero, (t0)
  ret

/*
 * Set interrrupt mask.
 * This updates the software mask (for readback and interrupt inable/disable)
 * and the hardware mask.
 * 1 means interrupt is masked (disabled).
 */
.global _irq_setmask
_irq_setmask:
  /* Update _irq_mask */
  la t0, _irq_mask
  sw a0, (t0)
  /* Are interrupts enabled? */
  la t0, _irq_enabled
  lw t0, 0(t0)
  beq t0, zero, 1f
  /* If so, update the HW IRQ mask */
  picorv32_maskirq_insn(zero, a0)
1:
  ret


.section .bss
irq_regs:
  /* saved interrupt registers, x0 - x31 */
  .fill 32, 4

  /* interrupt stack */
  .fill 256, 4

_irq_stack:
  /*
  * Bitfield of pending interrupts, updated on ISR entry.
  */
  .global _irq_pending
  _irq_pending:
    .word 0

  /*
  * Software copy of enabled interrupts. Do not write directly, use
  * _irq_set_mask instead.
  */
  .global _irq_mask
  _irq_mask:
    .word 0

  /*
  * Software state of global interrupts being enabled or disabled. Do not write
  * directly, use _irq_disable / _irq_enable instead.
  */
  .global _irq_enabled
  _irq_enabled:
    .word 0
