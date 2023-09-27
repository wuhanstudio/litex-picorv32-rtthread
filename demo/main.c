#include <irq.h>
#include <stdio.h>
#include <libbase/uart.h>

// Interrupt handler
void myirq(void);

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

void myirq(void)
{
	__attribute__((unused)) unsigned int irqs;
	irqs = irq_pending() & irq_getmask();

	if(irqs & (1 << TIMER0_INTERRUPT))
    {
        timer0_ev_pending_zero_write(1);

        timeup = 1;
        count++;
    }

#ifdef CSR_UART_BASE
#ifndef UART_POLLING
	if(irqs & (1 << UART_INTERRUPT))
    	printf("UART Interrupt \n");
		uart_isr();
#endif
#endif
    return;
}
