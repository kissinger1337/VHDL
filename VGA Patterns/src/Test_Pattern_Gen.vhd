library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Test_Pattern_Gen is
generic(
    g_All_Rows    : integer;
    g_Active_Rows : integer;    
    g_All_Cols    : integer;
    g_Active_Cols : integer;
    g_Test_Patterns_Count : integer := 4    
    );
port (
    i_Clk      : in std_logic;
    i_TP_Index : in integer range 0 to g_Test_Patterns_Count-1; 
    o_Red      : out std_logic_vector (3 downto 0) := (others => '0');
    o_Green    : out std_logic_vector (3 downto 0) := (others => '0');
    o_Blue     : out std_logic_vector (3 downto 0) := (others => '0') 
    );
end entity Test_Pattern_Gen;

architecture RTL of Test_Pattern_Gen is
             
begin

    process (i_TP_Index) is
    begin
        case i_TP_Index is
            when 0 =>
                o_Red <= (others => '0');
                o_Green <= (others => '0');
                o_Blue <= (others => '0');
            when 1 =>
                o_Red <= (others => '1');
                o_Green <= (others => '0');
                o_Blue <= (others => '0');
            when 2 =>
                o_Red <= (others => '0');
                o_Green <= (others => '1');
                o_Blue <= (others => '0');
            when 3 =>
                o_Red <= (others => '0');
                o_Green <= (others => '0');
                o_Blue <= (others => '1');                                       
            when others =>
                o_Red <= (others => '0');
                o_Green <= (others => '0');
                o_Blue <= (others => '0');               
        end case;
    end process;                 

end architecture RTL;