library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity buttonToDecoder is
    Port ( i_Butt_1 : in std_logic; --input button
            i_Clk   : in std_logic;            
            
            --segments on the display
           o_Seg_A : out std_logic;
           o_Seg_B : out std_logic;
           o_Seg_C : out std_logic;
           o_Seg_D : out std_logic;
           o_Seg_E : out std_logic;
           o_Seg_F : out std_logic;
           o_Seg_G : out std_logic
    );
    
    
-- 7-segment display layout
--         seg_A
--          --- 
--  seg_F  |   |  seg_B
--          ---    <- seg_G
--  seg_E  |   |  seg_C
--          ---
--        seg_D

    
end buttonToDecoder;

architecture RTL of buttonToDecoder is

signal w_Butt_1 : std_logic := '0';
signal r_Butt_1 : std_logic := '0';
signal r_Count  : integer range 0 to 9 := 0;

signal w_Seg_A : std_logic := '1';
signal w_Seg_B : std_logic := '1';
signal w_Seg_C : std_logic := '1';
signal w_Seg_D : std_logic := '1';
signal w_Seg_E : std_logic := '1';
signal w_Seg_F : std_logic := '1';
signal w_Seg_G : std_logic := '1';

signal r_Bin_Num : std_logic_vector(3 downto 0) := (others => '0'); --vector that represents counter in bunary form

begin

    Butt_logic_inst : entity work.Butt_logic --button debouncer
        port map (
            i_Clk => i_Clk,
            i_Butt_1 => i_Butt_1,
            o_Butt_1 => w_Butt_1
        );
        
    p_Counter : process (i_Clk) is --increment p_Counter after pressing the button
    begin
    
        if rising_edge(i_Clk) then
            r_Butt_1 <= w_Butt_1; --read debounced button
            if r_Butt_1 = '0' and w_Butt_1 = '1' then --button was pressed
            
                if (r_Count = 9) then --counter overflew 
                    r_Count <= 0;
                else
                    r_Count <= r_Count + 1;
                end if;
                
            end if;
            
            r_Bin_Num <= std_logic_vector(to_unsigned(r_Count, 4)); --cast integer to binary vector
            
        end if;
    end process p_Counter;
 

    
    Decoder_inst : entity work.decoder --decode binary vector and get values for all segments
        port map (     
            i_Bin_Num => r_Bin_Num,
            i_Clk => i_Clk,
            o_Seg_A => w_Seg_A,
            o_Seg_B => w_Seg_B,
            o_Seg_C => w_Seg_C,
            o_Seg_D => w_Seg_D,
            o_Seg_E => w_Seg_E,
            o_Seg_F => w_Seg_F,
            o_Seg_G => w_Seg_G
        );
        
  --segment lights up by a 0, not 1, so we need to reverse each value        
  o_Seg_A <= not w_Seg_A;
  o_Seg_B <= not w_Seg_B;
  o_Seg_C <= not w_Seg_C;
  o_Seg_D <= not w_Seg_D;
  o_Seg_E <= not w_Seg_E;
  o_Seg_F <= not w_Seg_F;
  o_Seg_G <= not w_Seg_G;        

end RTL;
