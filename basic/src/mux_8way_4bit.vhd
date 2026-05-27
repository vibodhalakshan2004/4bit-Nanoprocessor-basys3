library ieee;
use ieee.std_logic_1164.all;

entity mux_8way_4bit is
    port (
        sel : in  std_logic_vector(2 downto 0);
        i0, i1, i2, i3 : in std_logic_vector(3 downto 0);
        i4, i5, i6, i7 : in std_logic_vector(3 downto 0);
        y   : out std_logic_vector(3 downto 0)
    );
end mux_8way_4bit;

architecture behavioral of mux_8way_4bit is
begin
    process(sel, i0, i1, i2, i3, i4, i5, i6, i7)
    begin
        case sel is
            when "000" => y <= i0;
            when "001" => y <= i1;
            when "010" => y <= i2;
            when "011" => y <= i3;
            when "100" => y <= i4;
            when "101" => y <= i5;
            when "110" => y <= i6;
            when "111" => y <= i7;
            when others => y <= (others => '0');
        end case;
    end process;
end behavioral;
