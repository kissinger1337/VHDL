library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity UART_Rec_Top is
    port(
        i_RX_Bit  : in std_logic;
        i_Clk     : in std_logic;
        
        o_Seg_1_A : out std_logic;
        o_Seg_1_B : out std_logic;
        o_Seg_1_C : out std_logic;
        o_Seg_1_D : out std_logic;
        o_Seg_1_E : out std_logic;
        o_Seg_1_F : out std_logic;
        o_Seg_1_G : out std_logic;        
        
        o_AN_0    : out std_logic;
        o_AN_1    : out std_logic;
        o_AN_2    : out std_logic;
        o_AN_3    : out std_logic
                 
    );
end entity UART_Rec_Top;

architecture RTL of UART_Rec_Top is

    signal r_Bin_Num : std_logic_vector (7 downto 0) := (others => '0');
    signal r_Bin_Num_To_Decoder : std_logic_vector (3 downto 0) := (others => '0');  
    
    constant c_20_ms_limit : integer := 2000000; --100MHz clock cycles for 20 ms period
    signal r_Count : integer range 0 to c_20_ms_limit := 0;

begin

    UART_Rec_Inst : entity work.UART_Rec
    generic map (
        g_CLK_PER_BIT => 868          
    )
    port map(
        i_Clk => i_Clk,
        i_RX_Bit => i_RX_Bit,
        o_RX_Byte => r_Bin_Num
    );
    
    decoder_Inst : entity work.decoder
    port map(        
        i_Bin_Num => r_Bin_Num_To_Decoder,
        i_Clk     => i_Clk,
        o_Seg_A => o_Seg_1_A,
        o_Seg_B => o_Seg_1_B,
        o_Seg_C => o_Seg_1_C,
        o_Seg_D => o_Seg_1_D,
        o_Seg_E => o_Seg_1_E,
        o_Seg_F => o_Seg_1_F,
        o_Seg_G => o_Seg_1_G       
    );
    
    p_Switching_Anodes : process (i_Clk) --process that allows us to show two different characters on display
    --it will show each character for 10ms on the needed part of DISP1
    --human eye cant see that, we will switch very fast, so it will look like each character is always there
    begin

--             DISP1 
--      |-------------------|   
--      |AN3  AN2  AN1  AN0 |
--      |-------------------|

        if rising_edge(i_Clk) then
        
            if r_Count = c_20_ms_limit then
                r_Count <= 0;                
            end if;
            
            r_Count <= r_Count + 1;
            
            if r_Count < c_20_ms_limit / 2 then --switch between two anodes every 10 ms
                o_AN_1 <= '0'; --turn on            
                o_AN_0 <= '1'; --turn off
                r_Bin_Num_To_Decoder <= r_Bin_Num(7 downto 4); --Most significant 4 bits (left ones)
            else
                o_AN_1 <= '1'; --tirn off            
                o_AN_0 <= '0'; --turn on
                r_Bin_Num_To_Decoder <= r_Bin_Num(3 downto 0); --Least significant 4 bist (right ones)
            end if;
        end if;
    end process p_Switching_Anodes;

    --two left anodes stay off
    o_AN_2 <= '1';
    o_AN_3 <= '1';

end architecture RTL;