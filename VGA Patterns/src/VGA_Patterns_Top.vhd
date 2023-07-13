library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity VGA_Patterns_Top is
port (
    i_Clk_100MHZ : in std_logic;
    --UART input
    i_RX_Bit : in std_logic;
    --7-segment display for showing 4 UART bits     
    o_Seg_A : out std_logic;
    o_Seg_B : out std_logic;
    o_Seg_C : out std_logic;
    o_Seg_D : out std_logic;
    o_Seg_E : out std_logic;
    o_Seg_F : out std_logic;
    o_Seg_G : out std_logic;
    o_AN    : out std_logic_vector(3 downto 0); 
    --vga data
    o_VSync : out std_logic;
    o_HSync : out std_logic;
    o_RED : out std_logic_vector(3 downto 0);
    o_GRN : out std_logic_vector(3 downto 0);
    o_BLU : out std_logic_vector(3 downto 0)
);
end entity;

architecture RTL of VGA_Patterns_Top is

    --number of cols is a number of horizontal pixels!
    --number of rows is a number of vertical pixels! 
    constant c_Test_Patterns_Count : integer := 4;
    constant c_Active_Cols : integer := 1280;
    constant c_Active_Rows : integer := 1024;
    constant c_All_Cols : integer := 1688;
    constant c_All_Rows : integer := 1066;    
    
    --received UART byte
    signal w_RX_Byte  : std_logic_vector (7 downto 0) := (others => '0');
    
    --index of test pattern
    signal r_TP_Index : integer range 0 to c_Test_Patterns_Count := 0;
    
    --clock pulses from clk_wiz_0 will be stored here
    signal w_CLK_108MHZ : std_logic;
    
    component clk_wiz_0
    port
    ( 
        Clk_108MHZ : out    std_logic;
        Clk_100MHZ : in     std_logic
    );
    end component;
    

begin
    
   your_instance_name : clk_wiz_0
   port map (     
        Clk_108MHZ => w_CLK_108MHZ,
        Clk_100MHZ => i_Clk_100MHZ
    );
    
    --receives UART data
    UART_Rec_Inst : entity work.UART_Rec
    port map (
        i_Clk => i_Clk_100MHZ,
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
        i_Clk => i_Clk_100MHZ,
        i_RX_Byte => w_RX_Byte,
        o_TP_Index => r_TP_Index
    );
    
    --show 4 least significant bits (which are index of test pattern) that we get from UART 
    Decoder_Inst : entity work.Decoder
    port map (
        i_Bin_Num => w_RX_Byte(3 downto 0),
        i_Clk => i_Clk_100MHZ,
        o_Seg_A => o_Seg_A,
        o_Seg_B => o_Seg_B,
        o_Seg_C => o_Seg_C,
        o_Seg_D => o_Seg_D,
        o_Seg_E => o_Seg_E,
        o_Seg_F => o_Seg_F,
        o_Seg_G => o_Seg_G
    );
    --turn off all but one 7-segment display sectors
    o_AN(0) <= '0';
    o_AN(1) <= '1';
    o_AN(2) <= '1';
    o_AN(3) <= '1';        
            
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
        i_Clk => w_CLK_108MHZ,
        i_TP_Index => r_TP_Index,
        o_RED => o_RED,
        o_GRN => o_GRN,
        o_BLU => o_BLU       
    );   

    --sets up VSync and HSync pulses
    Sync_Pulses_Inst : entity work.Sync_Pulses
    generic map (
        g_Active_Cols => c_Active_Cols,
        g_Active_Rows => c_Active_Rows,
        g_All_Cols => c_All_Cols,
        g_All_Rows => c_All_Rows
    )
    port map(
        i_Clk => w_CLK_108MHZ,
        o_HSync => o_HSync,
        o_VSync => o_VSync
    );
    
end architecture RTL;