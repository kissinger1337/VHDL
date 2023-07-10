library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


--UART_Send module will loopback data, that we got from UART_Rec (i_TX_Byte)
entity UART_Send is
generic(
    --100,000,000 HZ / 115200 Baud = 868
    g_CLK_PER_BIT : integer := 868
    ); 
port (
    i_Clk     : in std_logic;
    i_TX_Byte : in std_logic_vector(7 downto 0);     
    i_TX_DV   : in std_logic; --i_TX_DV is bit that UART_Rec sends after receiving all 8 bits
    o_TX_Bit  : out std_logic          
);
end entity UART_Send;

architecture RTL of UART_Send is

type t_SM_State is (s_Idle, s_Start_Bit, s_Data, s_Stop_Bit);
signal r_State : t_SM_State := s_Idle;
signal r_Clk : integer range 0 to g_CLK_PER_BIT := 0;
signal r_Index : integer range 0 to 7 := 0;

begin
    p_UART_Send : process (i_Clk)
    begin
        if rising_edge(i_Clk) then
        
            case r_State is
                when s_Idle =>
                    r_Clk <= 0;
                    o_TX_Bit <= '1';
                    
                    if i_TX_DV = '1' then
                        r_State <= s_Start_Bit;                        
                    end if;
                when s_Start_Bit =>
                    o_TX_Bit <= '0';
                    
                    if r_Clk < g_CLK_PER_BIT then
                        r_Clk <= r_Clk + 1;
                        r_State <= s_Start_Bit; 
                    else 
                        r_Clk <= 0;
                        r_State <= s_Data;                        
                    end if;
                    
                 when s_Data =>
                    o_TX_Bit <= i_TX_Byte(r_Index);
                    
                    if r_Clk < g_CLK_PER_BIT then
                        r_Clk <= r_Clk + 1;
                        r_State <= s_Data;                        
                    else
                        r_Clk <= 0;
                        if r_Index < 7 then
                            r_Index <= r_Index + 1;
                            r_State <= s_Data;
                        else 
                            r_Index <= 0;                            
                            r_State <= s_Stop_Bit;
                        end if;
                    end if;
                                        
                  when s_Stop_Bit =>
                    o_TX_Bit <= '1';
                    if r_Clk < g_CLK_PER_BIT then
                        r_Clk <= r_Clk + 1;
                        r_State <= s_Stop_Bit;
                    else
                        r_Clk <= 0;
                        r_State <= s_Idle;
                    end if;
                    
            end case;        
       end if;
    end process p_UART_Send;
end architecture RTL;