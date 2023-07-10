library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity VGA_Patterns_Top is
port (
    i_Clk : in std_logic;
    i_RX_Bit : in std_logic
);
end entity;

architecture RTL of VGA_Patterns_Top is

    constant c_Test_Patterns_Count : integer := 4;
    signal w_RX_Byte : std_logic_vector (7 downto 0) := (others => '0');
    signal r_TP_Index : integer range 0 to c_Test_Patterns_Count := 0;

begin
    
    UART_Rec_Inst : entity work.UART_Rec
    port map (
        i_Clk => i_Clk,
        i_RX_Bit => i_RX_Bit,
        o_RX_DV => open,
        o_RX_Byte => w_RX_Byte      
    );
    
    --in ASCII 0 is X"30", 1 is X"31", 2 is X"32" ....    
    r_TP_Index <= to_integer(unsigned(w_RX_Byte(3 downto 0))); --turn 3 least significant bits into integer 
    
end architecture RTL;