/*
 * Copyright (c) 2020-2020, YuZhaorong
 *
 * SPDX-License-Identifier: Apache-2.0
 *
 * Change Logs:
 * Date           Author       Notes
 * 2020-06-09     YuZhaorong   the first version
 */
 
#include <stdint.h>
#include <rthw.h>
#include <rtthread.h>

#include <generated/csr.h>
#include "cpuport.h"
#include <irq.h>

#define  TIMER_IRQ_VECTOR   0 
#define  ECALL_IRQ_VECTOR   1 
#define  SYSTEM_BUS_VECTOR  2 
#define  SYSTEM_CORE_CLOCK CONFIG_CLOCK_FREQUENCY   //  24 MHZ

// Holds the system core clock, which is the system clock 
// frequency supplied to the SysTick timer and the processor 
// core clock.

static uint32_t _riscv_time_config(rt_uint32_t ticks)
{
    rt_kprintf("Initialize timer %d ...\n", ticks);

    timer0_ev_enable_write(1);
	irq_setmask(irq_getmask() | (1 << TIMER0_INTERRUPT));

	timer0_en_write(0);
	timer0_load_write(0);
	timer0_reload_write(ticks);
	timer0_en_write(1);

    return 0;
}

#if defined(RT_USING_USER_MAIN) && defined(RT_USING_HEAP)
#define RT_HEAP_SIZE 1024
static uint32_t rt_heap[RT_HEAP_SIZE];     // heap default size: 4K(1024 * 4)
RT_WEAK void *rt_heap_begin_get(void)
{
    return rt_heap;
}

RT_WEAK void *rt_heap_end_get(void)
{
    return rt_heap + RT_HEAP_SIZE;
}
#endif

// void riscv_timer_handler(int vector, void *param)
// {
//     rt_kprintf("Tick ++\n");

//     rt_tick_increase();
// }

// void riscv_ecall_handler(int vector, void *param)
// {

// }

#define reg_uart_data (*(volatile rt_uint32_t*)CSR_UART_BASE)

void rt_hw_console_output(const char *str)
{
    int i=0;
    for(i=0;'\0' != str[i];i++)
    {
        if(str[i] == '\n')
        {
            reg_uart_data = '\r';
        }
        reg_uart_data = str[i];
    }
}

char rt_hw_console_getchar(void)
{
    return (char)((*(volatile int*)CSR_UART_BASE)&0xFF);
}

/**
 * This function will initial your board.
 */
void rt_hw_board_init(void)
{
    /* Call components board initial (use INIT_BOARD_EXPORT()) */
#ifdef RT_USING_COMPONENTS_INIT
    rt_kprintf("Components init\n");
    rt_components_board_init();
    rt_kprintf("Components init\n");
#endif


#if defined(RT_USING_USER_MAIN) && defined(RT_USING_HEAP)
    rt_system_heap_init(rt_heap_begin_get(), rt_heap_end_get());
#endif

    /* System time Configuration */
    rt_kprintf("Timer interrupt init\n");

    /*Register System timer interrupt function*/
    rt_hw_interrupt_init();
    // rt_hw_interrupt_install(TIMER_IRQ_VECTOR, riscv_timer_handler, RT_NULL,"riscv_timer");
    // rt_hw_interrupt_install(ECALL_IRQ_VECTOR, riscv_ecall_handler, RT_NULL,"riscv_ecall");
    // rt_hw_interrupt_umask(ECALL_IRQ_VECTOR);
    rt_kprintf("Timer config \n");
    _riscv_time_config(SYSTEM_CORE_CLOCK / RT_TICK_PER_SECOND);
    rt_kprintf("Timer config done \n");
}
