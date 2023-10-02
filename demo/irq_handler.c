#include <stdio.h>

#include <irq.h>
#include <libbase/uart.h>

#include "irq_handler.h"

extern int volatile timeup;
extern int volatile count;

unsigned int* irq(unsigned int *regs, unsigned int irqs)
// void irq(void)
{
    // __attribute__((unused)) unsigned int irqs;
    // irqs = irq_pending() & irq_getmask();

    // Dont't use irqs to decide which interrupt is pending
    // Because irq() will be called twice and irqs is not up-to-date
    // if(irqs & (1 << TIMER0_INTERRUPT))

    if(timer0_ev_pending_zero_read())
    {
        printf("Timer Interrupt 0x%08x\n", irqs);
        timer0_ev_pending_zero_write(1);

        timeup = 1;
        count++;
    }

#ifdef CSR_UART_BASE
#ifndef UART_POLLING
    if(uart_ev_pending_rx_read() || uart_ev_pending_tx_read())
    {
        printf("UART Interrupt 0x%08x\n", irqs);
        uart_isr();
    }
#endif
#endif
    return regs;
}
