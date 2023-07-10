library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Sync_Pulses is
generic(
    g_All_Rows    : integer;
    g_Active_Rows : integer;    
    g_All_Cols    : integer;
    g_Active_Cols : integer    
    );
port (
    i_Clk   : in std_logic;
    o_HSync : out std_logic;
    o_VSync : out std_logic  
);
end entity Sync_Pulses;

architecture RTL of Sync_Pulses is

    signal r_Row : integer range 0 to g_All_Rows-1 := 0;
    signal r_Col : integer range 0 to g_All_Cols-1 := 0;

begin
    
    p_Sync : process (i_Clk) is
    begin
        if rising_edge(i_Clk) then
            if r_Col = g_All_Cols-1 then --reached end of one row
                if r_Row = g_All_Rows - 1 then --reached end both of row and col, reset
                    r_Col <= 0;
                    r_Row <= 0;
                else
                    r_Col <= 0; --reached end of one row only
                    r_Row <= r_Row + 1;
                end if;
            else
                r_Col <= r_Col + 1; --iterate through all columns
            end if;
        end if;
    end process p_Sync;
    
    --when in active area - pulse is 1, if not - 0
    o_HSync <= '1' when r_Col < g_Active_Cols-1 else '0'; 
    o_VSync <= '1' when r_Row < g_Active_Rows-1 else '0';
        
end architecture RTL;