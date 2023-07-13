# WORK IN PROGRESS

#### Timings from Acer V193 Manual for 1280x1024 60Hz

| Pixels:                        | Total | Active   | Sync | F.porch | B.porch | CLK (MHZ) |
| ------------------------------ | ----- | -------- | ---- | ------- |:------- | --------- |
| Horizontal (amount of columns) | 1688  | **1280** | 144  | 16      | 248     | 108       |
| Vertical (amount of rows)      | 1066  | **1024** | 3    | 1       | 38      |           |

I`ve used Vivado built-in clocking wizard MMCM to generate 108MHz clock in my design.
