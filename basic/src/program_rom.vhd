
library ieee;
use ieee.std_logic_1164.all;

entity program_rom is
    port (
        addr : in  std_logic_vector(2 downto 0);
        data : out std_logic_vector(11 downto 0)
    );
end program_rom;

architecture behavioral of program_rom is
begin
    process(addr)
    begin
        case addr is
            when "000" => data <= x"881";  -- MOVI R1, 1       (load 1)
            when "001" => data <= x"390";  -- ADD  R7, R1      (R7 = 0+1 = 1)
            when "010" => data <= x"882";  -- MOVI R1, 2       (load 2)
            when "011" => data <= x"390";  -- ADD  R7, R1      (R7 = 1+2 = 3)
            when "100" => data <= x"883";  -- MOVI R1, 3       (load 3)
            when "101" => data <= x"390";  -- ADD  R7, R1      (R7 = 3+3 = 6)
            when "110" => data <= x"C06";  -- JZR  R0, 6       (halt loop)
            when "111" => data <= x"C07";  -- JZR  R0, 7       (safety halt)
            when others => data <= (others => '0');
        end case;
    end process;
end behavioral;