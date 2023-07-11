library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity VGA_Patterns_Top is
port (
    i_Clk    : in std_logic;
    i_RX_Bit : in std_logic;
    
    o_VSync : out std_logic;
    o_HSync : out std_logic;
    
    o_Seg_A : out std_logic;
    o_Seg_B : out std_logic;
    o_Seg_C : out std_logic;
    o_Seg_D : out std_logic;
    o_Seg_E : out std_logic;
    o_Seg_F : out std_logic;
    o_Seg_G : out std_logic; 
    
    o_RED_0 : out std_logic;
    o_RED_1 : out std_logic;
    o_RED_2 : out std_logic;
    o_RED_3 : out std_logic;    
    o_GRN_0 : out std_logic;
    o_GRN_1 : out std_logic;
    o_GRN_2 : out std_logic;
    o_GRN_3 : out std_logic;
    o_BLU_0 : out std_logic;
    o_BLU_1 : out std_logic;
    o_BLU_2 : out std_logic;
    o_BLU_3 : out std_logic
);
end entity;

architecture RTL of VGA_Patterns_Top is

    constant c_Test_Patterns_Count : integer := 4;
    constant c_Active_Cols : integer := 1280;
    constant c_Active_Rows : integer := 960;
    constant c_All_Rows : integer := 1800;
    constant c_All_Cols : integer := 1000;
    
    signal w_RX_Byte               : std_logic_vector (7 downto 0) := (others => '0');
    signal r_TP_Index              : integer range 0 to c_Test_Patterns_Count := 0;
    signal w_RED                   : std_logic_vector (3 downto 0) := (others => '0');
    signal w_GRN                   : std_logic_vector (3 downto 0) := (others => '0');
    signal w_BLU                   : std_logic_vector (3 downto 0) := (others => '0');

begin
    
    --receives UART data
    UART_Rec_Inst : entity work.UART_Rec
    port map (
        i_Clk => i_Clk,
        i_RX_Bit => i_RX_Bit,
        o_RX_DV => open,
        o_RX_Byte => w_RX_Byte      
    );
    
    --translates UART hex data to an integer index of needed test pattern
    Get_TP_Index_Inst : entity work.Get_TP_Index
    generic map (
       g_Test_Patterns_Count => c_Test_Patterns_Count
    )
    port map (
        i_Clk => i_Clk,
        i_RX_Byte => w_RX_Byte,
        o_TP_Index => r_TP_Index
    );
    
    --show 4 least significant bits that we got
    Decoder_Inst : entity work.Decoder
    port map (
        i_Bin_Num => w_RX_Byte(3 downto 0),
        i_Clk => i_Clk,
        o_Seg_A => o_Seg_A,
        o_Seg_B => o_Seg_B,
        o_Seg_C => o_Seg_C,
        o_Seg_D => o_Seg_D,
        o_Seg_E => o_Seg_E,
        o_Seg_F => o_Seg_F,
        o_Seg_G => o_Seg_G
    );
            
    --sets up values for each color
    Test_Pattern_Gen_Inst : entity work.Test_Pattern_Gen
    generic map(        
        g_Active_Cols => c_Active_Cols,
        g_Active_Rows => c_Active_Rows,
        g_All_Cols => c_All_Cols,
        g_All_Rows => c_All_Rows,        
        g_Test_Patterns_Count => c_Test_Patterns_Count
    )
    port map (
        i_Clk => i_Clk,
        i_TP_Index => r_TP_Index,
        o_RED => w_RED,
        o_GRN => w_GRN,
        o_BLU => w_BLU       
    );
    
    o_RED_0 <= w_RED(0);
    o_RED_1 <= w_RED(1);
    o_RED_2 <= w_RED(2);
    o_RED_3 <= w_RED(3);
    
    o_GRN_0 <= w_GRN(0);
    o_GRN_1 <= w_GRN(1);
    o_GRN_2 <= w_GRN(2);
    o_GRN_3 <= w_GRN(3);
    
    o_BLU_0 <= w_BLU(0);
    o_BLU_1 <= w_BLU(1);
    o_BLU_2 <= w_BLU(2);
    o_BLU_3 <= w_BLU(3);

    --sets up VSync and HSync pulses
    Sync_Pulses_Inst : entity work.Sync_Pulses
    generic map (
        g_Active_Cols => c_Active_Cols,
        g_Active_Rows => c_Active_Rows,
        g_All_Cols => c_All_Cols,
        g_All_Rows => c_All_Rows
    )
    port map(
        i_Clk => i_Clk,
        o_HSync => o_HSync,
        o_VSync => o_VSync
    );
    
end architecture RTL;