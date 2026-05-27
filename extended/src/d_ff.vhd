
library ieee;
use ieee.std_logic_1164.all;

entity d_ff is
    port (
        clk   : in  std_logic;
        reset : in  std_logic;       -- async reset (active high)
        en    : in  std_logic;       -- sync enable
        d     : in  std_logic;
        q     : out std_logic
    );
end d_ff;

architecture behavioral of d_ff is
begin
    process(clk, reset)
    begin
        if reset = '1' then
            q <= '0';
        elsif rising_edge(clk) then
            if en = '1' then
                q <= d;
            end if;
        end if;
    end process;
end behavioral;
