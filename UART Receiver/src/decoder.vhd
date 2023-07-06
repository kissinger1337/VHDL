library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;

entity decoder is
    Port ( i_Bin_Num : in std_logic_vector (3 downto 0);
           i_Clk   : in std_logic;
           o_Seg_A : out std_logic;
           o_Seg_B : out std_logic;
           o_Seg_C : out std_logic;
           o_Seg_D : out std_logic;
           o_Seg_E : out std_logic;
           o_Seg_F : out std_logic;
           o_Seg_G : out std_logic
           
-- 7-segment display layout
--         seg_A
--          --- 
--  seg_F  |   |  seg_B
--          ---    <- seg_G
--  seg_E  |   |  seg_C
--          ---
--        seg_D
           );
end entity decoder;

architecture RTL of decoder is

--vector that contains values for each segment of a display
signal r_Encoding : std_logic_vector(7 downto 0) := (others => '0'); 
--for example if r_Encoding(6) = 1 then it tells us that we need to light up seg_A
--we only need 7 bits, but can not declare std_logic_vector(6 downto 0), because then we would get synthesis error 
--because we can not assign, for instance, X"7E" to a 7 bit array, we need all 8 bits 
  
begin

  process (i_Clk) is
  begin
    if rising_edge(i_Clk) then
      case i_Bin_Num is
        when "0000" =>  --counter is 0                   7   E 
          r_Encoding <= X"7E"; --hex value, in binary: 0111|1110 - seg_a,b,c,d,e,f are true, seg_f - false so we get 0 on display
        when "0001" =>  --counter is 1
          r_Encoding <= X"30"; --same principle ...
        when "0010" =>
          r_Encoding <= X"6D";
        when "0011" =>
          r_Encoding <= X"79";
        when "0100" =>
          r_Encoding <= X"33";          
        when "0101" =>
          r_Encoding <= X"5B";
        when "0110" =>
          r_Encoding <= X"5F";
        when "0111" =>
          r_Encoding <= X"70";
        when "1000" =>
          r_Encoding <= X"7F";
        when "1001" =>
          r_Encoding <= X"7B";
        when "1010" =>
          r_Encoding <= X"77";
        when "1011" =>
          r_Encoding <= X"1F";
        when "1100" =>
          r_Encoding <= X"4E";
        when "1101" =>
          r_Encoding <= X"3D";
        when "1110" =>
          r_Encoding <= X"4F";
        when "1111" =>
          r_Encoding <= X"47";
      end case;
    end if;
  end process;
    
  --segments lights up by 0, so we need to reverse value  
  o_Seg_A <= not r_Encoding(6);
  o_Seg_B <= not r_Encoding(5);
  o_Seg_C <= not r_Encoding(4);
  o_Seg_D <= not r_Encoding(3);
  o_Seg_E <= not r_Encoding(2);
  o_Seg_F <= not r_Encoding(1);
  o_Seg_G <= not r_Encoding(0);

end architecture RTL;
