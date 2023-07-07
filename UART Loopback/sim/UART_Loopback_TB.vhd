library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity UART_Loopback_TB is
end UART_Loopback_TB;

architecture Behavioral of UART_Loopback_TB is

    --1 clk period for 100MHz means 10ns clock cycle
    constant c_CLK_PERIOD : time := 10 ns;
    signal r_Clk : std_logic := '0';
    
    --baud rate represents number of bits per second
    constant c_Baud : integer := 115200;
    
    -- Clk freq/Baud = 100000000/115200=868
    --this says that for transmiting 868 bits per second using 100MHz clock (we have 100000000 clock cycles each second), 
    --we have 868 clock cycles to transmit each bit
    constant c_CLK_PER_BIT : integer := 868;
    
    --Clk per bit * Clk period = 10 * 868
    constant c_Bit_Send_Time : time := 8680 ns;
    
    --in UART we chould keep 1 untill we start to transmit, as 0 indicates start of transmission 
    signal r_RX_Bit  : std_logic := '1';
    signal o_RX_Byte : std_logic_vector (7 downto 0) := (others => '0');
    signal w_RX_TX_DV : std_logic := '0';   
    signal r_Test_Byte : std_logic_vector(7 downto 0) := (others => '0');    

begin

    r_Clk <= not r_Clk after c_CLK_PERIOD/2;

    --instantiate module that sends UART data
    --output of module will be seen in o_RX_Byte
    UART_Rec_Inst : entity work.UART_Rec
        generic map( g_CLK_PER_BIT => c_CLK_PER_BIT)
        port map( i_Clk => r_Clk,
                    i_RX_Bit => r_RX_Bit,
                    o_RX_Byte => o_RX_Byte);
                    
    UART_Send_Inst : entity work.UART_Send
        generic map( g_CLK_PER_BIT => c_CLK_PER_BIT)
        port map (
            i_Clk => r_Clk,
            i_TX_Byte => r_Test_Byte,
            i_TX_DV => w_RX_TX_DV,
            o_TX_Bit => r_RX_Bit
        );                
                    
    p_Test : process
    begin
        wait until rising_edge(r_Clk);
        --try to send "FF" byte
        --UART_Send_Byte sends 8 bits to r_RX_Bit 1 bit at a time, r_RX_Bit is connected to the UART_Rec_Inst which collects bits
        --then sends whole byte to o_RX_Byte for us to test
        w_RX_TX_DV <= '1';
        r_TEST_Byte <= X"FF";
        wait for c_Bit_Send_Time * 10;
        if o_RX_Byte = X"FF" then
            report "TEST 1 PASSED";
        else
            report "TEST 1 FAILED";
        end if;
        
        w_RX_TX_DV <= '1';
        r_TEST_Byte <= X"00";
        wait for c_Bit_Send_Time * 10;
        w_RX_TX_DV <= '0';
        if o_RX_Byte = X"00" then            
            report "TEST 2 PASSED";
        else
            report "TEST 2 FAILED";
        end if;
            
        w_RX_TX_DV <= '1';            
        r_TEST_Byte <= X"78";
        wait for c_Bit_Send_Time * 10;
        w_RX_TX_DV <= '0';
        if o_RX_Byte = X"78" then
            report "TEST 3 PASSED";
        else
            report "TEST 3 FAILED";
        end if;
              
        w_RX_TX_DV <= '1';
        r_TEST_Byte <= X"65";
        wait for c_Bit_Send_Time * 10;
        w_RX_TX_DV <= '0';
        if o_RX_Byte = X"65" then
            report "TEST 4 PASSED";
        else
            report "TEST 4 FAILED";
        end if;
        
        w_RX_TX_DV <= '1';
        r_TEST_Byte <= X"65";
        wait for c_Bit_Send_Time * 10;
        w_RX_TX_DV <= '0';
        if o_RX_Byte = X"64" then
            report "TEST 5 FAILED";
        else
            report "TEST 5 PASSED";
        end if;
              
        assert false report "Tests complete" severity failure;     
    end process p_Test;                                          

end architecture Behavioral;
