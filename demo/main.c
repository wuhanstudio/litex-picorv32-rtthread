#include <irq.h>
#include <stdio.h>
#include <libbase/uart.h>

// Interrupt handler
void irq(void);

int volatile timeup = 0;
int volatile count = 0;

int main(void)
{
	irq_setmask(0);
	irq_setie(1);

	uart_init();

    timer0_ev_enable_write(1);
	irq_setmask(irq_getmask() | (1 << TIMER0_INTERRUPT));

    timer0_en_write(0);
    timer0_load_write(0);
    timer0_reload_write(CONFIG_CLOCK_FREQUENCY);
    timer0_en_write(1);

    while(1)
    {
        if(timeup) {
            printf("Hello World %d\n", count);
            timeup = 0;
        }
    };

    return 0;
}

void irq(void)
{
	__attribute__((unused)) unsigned int irqs;
	irqs = irq_pending() & irq_getmask();

    // Dont't use irqs to decide which interrupt is pending
    // Because irq() will be called twice and irqs is not up-to-date
	// if(irqs & (1 << TIMER0_INTERRUPT))

    if(timer0_ev_pending_zero_read())
    {
        timer0_ev_pending_zero_write(1);

        timeup = 1;
        count++;
    }

#ifdef CSR_UART_BASE
#ifndef UART_POLLING
	if(uart_ev_pending_rx_read() || uart_ev_pending_tx_read())
    	printf("UART Interrupt \n");
		uart_isr();
#endif
#endif
    return;
}
