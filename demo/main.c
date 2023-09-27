#include <stdio.h>

#include <irq.h>
#include <libbase/uart.h>

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

    printf("Hello World \n");

    while(1)
    {
        if(timeup) {
            printf("Hello World %d\n", count);
            timeup = 0;
        }
    };

    return 0;
}
