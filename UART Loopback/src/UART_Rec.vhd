library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity UART_Rec is

    generic(
        --clk per bit is : (clk frequency)/(baud rate)
        --we have 100MHz clock and basys 3 supports wide range of baud rates, including 115200
        g_CLK_PER_BIT : integer := 868
    );
    port(
        i_Clk      : in std_logic;
        i_RX_Bit   : in std_logic;
        o_RX_DV    : out std_logic;
        o_RX_Byte  : out std_logic_vector(7 downto 0)
    );
    
end entity UART_Rec;

architecture RTL of UART_Rec is

    --declaring our own type
    type t_SM_State is (s_Idle, s_Start_Bit, s_Data, s_Stop_Bit); --all states of our state machine
    signal r_State   : t_SM_State := s_Idle; --initialize starting state as idle using our type
    signal r_Clk     : integer range 0 to g_CLK_PER_BIT := 0;
    signal r_Index   : integer range 0 to 7 := 0;
    signal r_RX_Byte : std_logic_vector(7 downto 0) := (others => '0');
    signal r_RX_DV   : std_logic := '0';

begin

    p_UART_Rec : process (i_Clk)
    begin
        
        if rising_edge(i_Clk) then
            
            case r_State is 
            
                --wait for the start bit (0)           
                when s_Idle =>
                    r_RX_DV <= '0';
                    r_Clk <= 0;
                    r_Index <= 0;
                    
                    if i_RX_Bit = '0' then 
                        r_State <= s_Start_Bit;
                    else
                        r_State <= s_Idle;                   
                    end if;
                    
                when s_Start_Bit =>
                    r_RX_DV <= '0'; 
                    --sampling middle of starting bit transmission             
                    if r_Clk = (g_CLK_PER_BIT) / 2 then 
                        if i_RX_Bit = '0' then 
                            --starting bit confirmed, next state
                            r_Clk <= 0;
                            r_State <= s_Data;
                        else
                            --starting bit was not confirmed, return to idle
                            r_State <= s_Idle;
                        end if;
                    else                         
                        r_Clk <= r_Clk + 1;
                        r_State <= s_Start_Bit;                                          
                    end if;
                    
                when s_Data =>
                    r_RX_DV <= '0';
                    --wait for as long as 1 bit is transmitting, that will allow us to sample bit
                    --in the middle of transmission (so we do not sample data when it can be unstable)
                    if r_Clk < g_CLK_PER_BIT then
                        r_Clk <= r_Clk + 1;
                        r_State <= s_Data;
                    else
                        r_RX_Byte(r_Index) <= i_RX_Bit;                        
                        if r_Index < 7 then
                            r_Clk <= 0;
                            r_Index <= r_Index + 1;
                            r_State <= s_Data;
                        else
                            r_Clk <= 0;
                            r_Index <= 0;
                            r_State <= s_Stop_Bit;   
                        end if;                     
                    end if;
                    
                when s_Stop_Bit =>
                    --waiting for stop bit to transmit
                    if r_Clk < g_CLK_PER_BIT then
                        r_Clk <= r_Clk + 1;
                        r_State <= s_Stop_Bit;
                    else
                        r_RX_DV <= '1'; --indicator of completed receiving of 8 bits
                        r_Clk <= 0; 
                        r_State <= s_Idle;
                    end if;
                
            end case;
            
        end if;
            
    end process p_UART_Rec;
    
    o_RX_Byte <= r_RX_Byte;
    o_RX_DV   <= r_RX_DV;
    
end architecture RTL;