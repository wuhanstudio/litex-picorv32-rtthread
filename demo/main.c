#include <irq.h>
#include <stdio.h>

#define reg_uart_data (*(volatile uint32_t*)CSR_UART_BASE)

void myprintf(const char *str);

void myprintf(const char *str)
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

int main(void)
{
    printf("Hello World (stdc)\n");
    myprintf("Hello World (serial)\n");

    return 0;
}
