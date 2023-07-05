library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Blink_LED_Top is
  Port ( i_Clk : in std_logic;
        o_LED_1 : out std_logic;        
        o_LED_2 : out std_logic;
        o_LED_3 : out std_logic;
        o_LED_4 : out std_logic;
        o_LED_5 : out std_logic   
  );
end Blink_LED_Top;

architecture RTL of Blink_LED_Top is

begin

    Blink_LED_inst : entity work.Blink_LED 
    
        generic map (
        -- we have clock that runs 25 MHz, so we need to divide 25 * 10^6 
        -- by amount of times per second, to get the limit for that frequency  
            g_2Hz_limit => 12500000, --25 * 10^6 / 2 get LED that turns on 2 times per second
            g_4Hz_limit => 6250000,   --25 * 10^6 / 4 get LED that turns on 4 times per second
            g_8Hz_limit => 3125000,   -- and so on...
            g_10Hz_limit => 2500000,
            g_100Hz_limit => 250000
        )
        port map(
            i_Clk => i_Clk,
            o_LED_1 => o_LED_1,
            o_LED_2 => o_LED_2,
            o_LED_3 => o_LED_3,
            o_LED_4 => o_LED_4,
            o_LED_5 => o_LED_5
        );


end RTL;
