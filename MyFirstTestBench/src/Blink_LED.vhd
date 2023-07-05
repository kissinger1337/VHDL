library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity Blink_LED is
--generic allows us to have constants that we can pass as a values on each new instantiation
generic(
    g_2Hz_limit : integer; --amount of clock cycles before changing state (on->off, off->on)
    g_4Hz_limit : integer;
    g_8Hz_limit : integer;
    g_10Hz_limit : integer;
    g_100Hz_limit : integer
);

Port ( 
    i_Clk   : in std_logic;
    o_LED_1 : out std_logic;
    o_LED_2 : out std_logic;
    o_LED_3 : out std_logic;
    o_LED_4 : out std_logic;
    o_LED_5 : out std_logic
);
end Blink_LED;

architecture RTL of Blink_LED is

--store actual state of the LED (on/off)
signal r_2Hz_state : std_logic := '0';
signal r_4Hz_state : std_logic := '0';
signal r_8Hz_state : std_logic := '0';
signal r_10Hz_state : std_logic := '0';
signal r_100Hz_state : std_logic := '0';

--time counters
signal r_2Hz_count   : integer range 0 to  g_2Hz_limit;
signal r_4Hz_count   : integer range 0 to  g_4Hz_limit;
signal r_8Hz_count   : integer range 0 to  g_8Hz_limit;
signal r_10Hz_count  : integer range 0 to g_10Hz_limit;
signal r_100Hz_count : integer range 0 to g_100Hz_limit;

begin

    --read LED state
    --code outside of a process is of combinatorial behaviour
    --all of this will be exucuted not sequentialy, but concurrently (in parallel)
    o_LED_1 <= r_2Hz_state;
    o_LED_2 <= r_4Hz_state;
    o_LED_3 <= r_8Hz_state;
    o_LED_4 <= r_10Hz_state;
    o_LED_5 <= r_100Hz_state;

    --processes are executed concurrently, but code inside of a process is executed sequentialy
    p_2Hz_Blink : process (i_Clk) is
    begin
        if rising_edge(i_Clk) then
            if r_2Hz_count = g_2Hz_limit then --needed amount of clock cycles passed -> change state
                r_2Hz_state <= not r_2Hz_state;
                r_2Hz_count <= 0;
            else
                r_2Hz_count <= r_2Hz_count + 1;
            end if;
        end if;
    end process p_2Hz_Blink;

    p_4Hz_Blink : process (i_Clk) is
    begin
        if rising_edge(i_Clk) then
            if r_4Hz_count = g_4Hz_limit then
                r_4Hz_state <= not r_4Hz_state;
                r_4Hz_count <= 0;
            else
                r_4Hz_count <= r_4Hz_count + 1;
            end if;
        end if;
    end process p_4Hz_Blink;
    
    p_8Hz_Blink : process (i_Clk) is
    begin
        if rising_edge(i_Clk) then
            if r_8Hz_count = g_8Hz_limit then
                r_8Hz_state <= not r_8Hz_state;
                r_8Hz_count <= 0;
            else
                r_8Hz_count <= r_8Hz_count + 1;
            end if;
        end if;
    end process p_8Hz_Blink;
    
    p_10Hz_Blink : process (i_Clk) is
    begin
        if rising_edge(i_Clk) then
            if r_10Hz_count = g_10Hz_limit then
                r_10Hz_state <= not r_10Hz_state;
                r_10Hz_count <= 0;
            else
                r_10Hz_count <= r_10Hz_count + 1;
            end if;
        end if;
    end process p_10Hz_Blink;
    
    p_100Hz_Blink : process (i_Clk) is
    begin
        if rising_edge(i_Clk) then
            if r_100Hz_count = g_100Hz_limit then
                r_100Hz_state <= not r_100Hz_state;
                r_100Hz_count <= 0;
            else
                r_100Hz_count <= r_100Hz_count + 1;
            end if;
        end if;
    end process p_100Hz_Blink;

end RTL;
