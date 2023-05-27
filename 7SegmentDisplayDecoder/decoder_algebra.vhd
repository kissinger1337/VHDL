library IEEE;
use IEEE.std_logic_1164.all;

entity decoder_7seg is
    port(
        a   : in  std_logic;
        b   : in  std_logic;
        c   : in  std_logic;
        d   : in  std_logic;
        f_a : out std_logic;
        f_b : out std_logic;
        f_c : out std_logic;
        f_d : out std_logic;
        f_e : out std_logic;
        f_f : out std_logic;
        f_g : out std_logic
    );
end decoder_7seg;

architecture behavioral of decoder_7seg is
begin

-- 7-segment display layout
--        f_A
--        --- 
--  f_F  |   |  f_B
--        ---    <- f_G
--  f_E  |   |  f_C
--        ---
--        f_D

--  A:      B:      C:      D:      E:      F:
--    ---             ---             ---     ---
--   |   |   |       |           |   |       |
--    ---     ---             ---     ---     ---
--   |   |   |   |   |       |   |   |       |
--            ---     ---     ---     ---

-- The functions are negated here, because the display segments switch on with 0

    f_a <= (not (((not c)and(not d)and(not a)) or (b and (not d)) or (a and c and (not d)) or (d and (not a)) or (b and c) or (d and (not c) and (not b))));
    f_b <= (not (((not c) and (not d)) or ((not b) and (not c)) or ((not a)and(not d)and(not b)) or (a and b and (not d)) or (b and (not a) and (not c)) or (d and a and (not b))));
    f_c <= (not (((not d)and(not b)) or (a and (not d)) or (c and (not d)) or (a and (not b)) or (d and (not c))));
    f_d <= (not (((not d ) and (not c) and (not a)) or ((not c) and b and a) or (c and a and (not b)) or (b and c and (not a)) or (d and (not b))));
    f_e <= (not (((not a)and(not c)and(not b)) or (b and (not a)) or (d and c) or (b and d)));
    f_f <= (not (((not b)and(not a)) or (c and (not a)) or (c and (not b)and(not d)) or (d and (not c)) or (d and b)));
    f_g <= (not ((b and (not c))or(c and (not b) and (not d))or(b and (not a))or(a and d)or(d and (not c))));

end;
