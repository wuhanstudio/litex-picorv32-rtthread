LEDS
====

Register Listing for LEDS
-------------------------

+----------------------------+------------------------------+
| Register                   | Address                      |
+============================+==============================+
| :ref:`LEDS_OUT <LEDS_OUT>` | :ref:`0x82001000 <LEDS_OUT>` |
+----------------------------+------------------------------+

LEDS_OUT
^^^^^^^^

`Address: 0x82001000 + 0x0 = 0x82001000`

    Led Output(s) Control.

    .. wavedrom::
        :caption: LEDS_OUT

        {
            "reg": [
                {"name": "out[2:0]", "bits": 3},
                {"bits": 29},
            ], "config": {"hspace": 400, "bits": 32, "lanes": 4 }, "options": {"hspace": 400, "bits": 32, "lanes": 4}
        }


