library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Debounce is 
    
    port (
        i_Clk  : in std_logic;
        i_Butt : in std_logic; --button value
        o_Butt : out std_logic --debounced button value
        );
        
end entity;

architecture RTL of Debounce is

constant c_DEBOUNCE_LIMIT : integer := 250000; --if the frequency is 25 MHz, 250000 clock cycles is 10 ms (40ns/cycle in constraint file)
signal r_Count : integer range 0 to c_DEBOUNCE_LIMIT := 0; -- 18-bit integer initialization
signal r_State : std_logic := '0'; --memory block containing previous debounced state of button
    
begin

    p_Debounce : process (i_Clk) is
    begin
        if rising_edge(i_Clk) then
            
            if r_State /= i_Butt and r_Count < c_DEBOUNCE_LIMIT then --button changed its state, need to count 10ms before applying that change
                r_Count <= r_Count + 1;
                
            elsif r_Count = c_DEBOUNCE_LIMIT then --10ms passed, button is still stable, apply the change
                r_State <= i_Butt;
                r_Count <= 0;
                
            elsif r_State = i_Butt then --if the button has the same value again, that means it is stable or bouncing, no need to count time to change
                r_Count <= 0;
            
            end if;
            
        end if;
    end process p_Debounce;
    
    o_Butt <= r_State;
    
end architecture RTL;
        
