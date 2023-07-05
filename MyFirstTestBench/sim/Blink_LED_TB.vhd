library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Blink_LED_TB is

end entity Blink_LED_TB;

architecture Behavioural of Blink_LED_TB is

--simulate clock
constant c_Clk_Cycle : time := 1 ns;
signal r_Clk : std_logic := '0'; 

begin

    --simulate behaviour of clk by changing the state of the register 2 times per ns
    r_Clk <= not r_Clk after c_Clk_Cycle/2;
    --half ns clk is true, half ns clk is false - so we have a clk with period of 1 ns
    
    Blink_LED_inst : entity work.Blink_LED
        generic map (
            g_2Hz_limit => 100,
            g_4Hz_limit => 50,
            g_8Hz_limit => 25,
            g_10Hz_limit => 20,
            g_100Hz_limit => 2
        )
        port map (
            i_Clk => r_Clk,
            o_LED_1 => open,
            o_LED_2 => open,
            o_LED_3 => open,
            o_LED_4 => open,
            o_LED_5 => open
        );
        
  process is
  begin
  report "Starting Testbench...";
  wait for 10 ms;
  assert false report "Test Complete" severity failure;
  end process;
  

end architecture Behavioural;