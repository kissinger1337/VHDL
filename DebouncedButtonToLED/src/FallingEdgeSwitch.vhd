library IEEE;
use IEEE.std_logic_1164.ALL;

entity Butt_logic is
    Port (  i_Clk : in std_logic ;
            i_Butt_1 : in std_logic;
            o_LED_1 : out std_logic );
end Butt_logic;
    
architecture RTL of Butt_logic is

    signal r_Butt_1 : std_logic := '0';
    signal w_Butt_1 : std_logic := '0'; --w stays for wire, whis means that this is not a clocked logic, this is
                                        --only a connector between two variables
    signal r_LED_1  : std_logic := '0';

begin

    Debounce_inst : entity work.Debounce
        port map (  i_Clk => i_Clk,
                    i_Butt => i_Butt_1,
                    o_Butt => w_Butt_1--w_Butt_1 keeps value of debounced switch in that moment of time
                 );

    p_Butt : process (i_Clk) is
    begin
        if rising_edge (i_Clk) then --process is triggered by rising and falling edges, but we need to change the state only on the rising edge
        
            r_Butt_1 <= w_Butt_1; --read the input on every rising edge
        
            if r_Butt_1 = '1' and w_Butt_1 = '0' then --switch was pressed and then released 
                r_LED_1 <= not r_LED_1;
            end if;
       
        end if;
    
    end process p_Butt;
    
    o_LED_1 <= r_LED_1;


end architecture RTL;