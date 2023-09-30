/*
 * Copyright (c) 2020-2020, YuZhaorong
 *
 * SPDX-License-Identifier: Apache-2.0
 *
 * Change Logs:
 * Date           Author       Notes
 * 2020/06/13     YuZhaorong
 * 2020/11/25     Wu Han
 */


#include <custom_ops.S>

#define REGBYTES 4

/*
 * void rt_hw_context_switch_to(rt_ubase_t to);
 * a0 --> to
 */
.globl rt_hw_context_switch_to
rt_hw_context_switch_to:
    lw sp, (a0)
    /* resw ra to mepc */
    lw tp,   0 * 4(sp)                /* Add PC to thread poiner */
    lw x1,   1 * REGBYTES(sp)         /* x1 - ra - return address for jumps */

    /* lw x4,   4 * REGBYTES(sp) */
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

    addi sp,  sp, 32 * REGBYTES
    jr tp                               /* jump to thread pointer */
