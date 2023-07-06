## UART Receiver using Basys 3 and Vivado  

I`ve implemented UART receiver with finite-state machine  
![alt text](https://github.com/kissinger1337/VHDL/blob/main/UART%20Receiver/diagram/FSM.png)  

This code allows Basys 3 board to read 1 byte of data and show it`s ASCII HEX value on the 7-segment display.  
I`ve tested this code using simulation testbench and then tested it on the board using picocom in terminal.  

baudrate: 115200  
Clk: 100 MHz
