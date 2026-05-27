
library ieee;
use ieee.std_logic_1164.all;

entity program_rom_v2 is
    port (
        addr : in  std_logic_vector(3 downto 0);
        data : out std_logic_vector(13 downto 0)
    );
end program_rom_v2;

architecture rtl of program_rom_v2 is
begin
    process (addr)
    begin
        case addr is
            
            when "0000" => data <= "00100010000011"; -- 0  MOVI R1, 3   -> R1=3
            when "0001" => data <= "00100100000010"; -- 1  MOVI R2, 2   -> R2=2
            when "0010" => data <= "10000010100000"; -- 2  MUL  R1, R2  -> R1=6
            when "0011" => data <= "01111111110000"; -- 3  XOR  R7, R7  -> R7=0  (clear)
            when "0100" => data <= "00001110010000"; -- 4  ADD  R7, R1  -> R7=6  (intermediate 1)
            when "0101" => data <= "00100110001000"; -- 5  MOVI R3, 8   -> R3=8
            when "0110" => data <= "00101000000010"; -- 6  MOVI R4, 2   -> R4=2
            when "0111" => data <= "10110111000000"; -- 7  DIV  R3, R4  -> R3=4
            when "1000" => data <= "00001110110000"; -- 8  ADD  R7, R3  -> R7=10 (intermediate 2)
            when "1001" => data <= "00101010000101"; -- 9  MOVI R5, 5   -> R5=5
            when "1010" => data <= "00101100000011"; -- 10 MOVI R6, 3   -> R6=3
            when "1011" => data <= "01011011100000"; -- 11 AND  R5, R6  -> R5=1
            when "1100" => data <= "01001111010000"; -- 12 SUB  R7, R5  -> R7=9  (final)
            when "1101" => data <= "11000000001101"; -- 13 JMP  13      -> halt loop
            when "1110" => data <= "11000000001111"; -- 14 JMP  15      -> safety halt
            when "1111" => data <= "11000000001111"; -- 15 JMP  15      -> safety halt
            when others => data <= (others => '0');
        end case;
    end process;
end rtl;
