library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Get_TP_Index is
generic(
    g_Test_Patterns_Count : integer := 4
);
port(
    i_Clk : in std_logic;
    i_RX_Byte : in std_logic_vector (7 downto 0);
    o_TP_Index : out integer range 0 to 9 := 0
);    
end entity Get_TP_Index;

architecture RTL of Get_TP_Index is 

    signal r_First_4_Bits : integer range 0 to 15 := 0;
    signal r_Second_4_Bits : integer range 0 to 15 := 0;

begin 

    process (i_Clk) 
    begin
    if rising_edge(i_Clk) then
        --in ASCII 0 is X"30", 1 is X"31", 2 is X"32" ....
        r_First_4_Bits <= TO_INTEGER(unsigned(i_RX_Byte(7 downto 4))); --gets first number
        if r_First_4_Bits = 3 then --if we get ascii value of 0-9 from keyboard - input is correct and we can use it        
            r_Second_4_Bits <= TO_INTEGER(unsigned(i_RX_Byte(7 downto 4)));
            if r_Second_4_Bits < g_Test_Patterns_Count then --got correct input - send it to other modules
                o_TP_Index <= r_Second_4_Bits;
            end if;         
        end if;
    end if;
    end process;


end architecture RTL;