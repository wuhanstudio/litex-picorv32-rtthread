Interrupt Controller
====================

This device has an ``EventManager``-based interrupt system.  Individual modules
generate `events` which are wired into a central interrupt controller.

When an interrupt occurs, you should look the interrupt number up in the CPU-
specific interrupt table and then call the relevant module.

Assigned Interrupts
-------------------

The following interrupts are assigned on this system:

+-----------+----------------------------------------------------+
| Interrupt | Module                                             |
+===========+====================================================+
| 2         | :doc:`BUS_ERROR <bus_error>`                       |
+-----------+----------------------------------------------------+
| 1         | :doc:`EBREAK_ECALL_ILLEGAL <ebreak_ecall_illegal>` |
+-----------+----------------------------------------------------+
| 0         | :doc:`TIMER <timer>`                               |
+-----------+----------------------------------------------------+
| 4         | :doc:`TIMER0 <timer0>`                             |
+-----------+----------------------------------------------------+
| 3         | :doc:`UART <uart>`                                 |
+-----------+----------------------------------------------------+

