library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Clocked_Logic is
    Port ( i_Clk      : in STD_LOGIC;
           i_Switch_1 : in STD_LOGIC;
           o_LED_1    : out STD_LOGIC);
end Clocked_Logic;

architecture RTL of Clocked_Logic is
    
    signal r_LED_1    : std_logic := '0'; --r_ means register (using clocked_logic)
    signal r_Switch_1 : std_logic := '0';
    
begin
    p_Register : process (i_Clk) is --declaration of the process, p_Register - name;
    begin
        if rising_edge (i_Clk) then --function that detects rising edge of CLK;
            r_Switch_1 <= i_Switch_1;  --Register;
                
            if i_Switch_1 = '0' and r_Switch_1 = '1' then --switch was pressed and then released (falling edge);
                r_LED_1 <= not r_LED_1; --inverts state of the LED;
            end if;
        end if;        
    end process p_Register;
    
    o_LED_1 <= r_LED_1;
    
end architecture RTL;
