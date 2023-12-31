/*
 * Copyright (c) 2006-2020, YuZhaorong 
 *
 * SPDX-License-Identifier: Apache-2.0
 *
 * Change Logs:
 * Date           Author       Notes
 * 2020-06-06     YuZhaorong      
 * 2020-11-25     Wu Han       Add msh support
 */

#include <rtthread.h>
#include <rthw.h>
#include <msh.h>

#define TASK1_STACK_SIZE 512
struct rt_thread task1={0};
unsigned char task1_stack[TASK1_STACK_SIZE]={0};

#define TASK2_STACK_SIZE 512
struct rt_thread task2={0};
unsigned char task2_stack[TASK2_STACK_SIZE]={0};

void thread_task1_entry(void* paramenter)
{
    while (1)
    { 
        rt_kprintf("\r\n task1 runing...out A \r\n");
        rt_thread_mdelay(2000);
    }
}

void thread_task2_entry(void* paramenter)
{
    while (1)
    { 
        rt_kprintf("\r\n task2 runing... out B \r\n");
        rt_thread_mdelay(3000);
    }
}

void demo(int argc, char* argv[])
{
    rt_thread_init(&task1, "task1",thread_task1_entry, 0,(void*)task1_stack,TASK1_STACK_SIZE,4, 100);
    rt_thread_startup(&task1);

    rt_thread_init(&task2, "task2",thread_task2_entry, 0,(void*)task2_stack,TASK2_STACK_SIZE,4, 100);
    rt_thread_startup(&task2);
}
MSH_CMD_EXPORT(demo, thread demo)

// extern int finsh_system_init(void);

// extern long list_thread(void);
// extern int cmd_free(int argc, char **argv);

int main(void)
{
    // finsh_system_init();

    rt_hw_interrupt_umask(0);               // Register timer interrupt

    rt_kprintf("Hello picorv32 world 1\r\n");
    rt_thread_mdelay(3000);
    rt_kprintf("Hello picorv32 world 2\r\n");

    // cmd_free(0, 0);

    rt_thread_init(&task1, "task1",thread_task1_entry, 0,(void*)task1_stack,TASK1_STACK_SIZE,4, 100);
    rt_thread_startup(&task1);
    
    rt_thread_init(&task2, "task2",thread_task2_entry, 0,(void*)task2_stack,TASK2_STACK_SIZE,4, 100);
    rt_thread_startup(&task2);

    while (1)
    {
        rt_kprintf("Hello main \r\n");
        rt_thread_mdelay(1000);
    }

    return 0;
}
