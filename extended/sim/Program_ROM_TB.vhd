library ieee;
use ieee.std_logic_1164.all;

entity Program_ROM_TB is
end Program_ROM_TB;

-- ROM contents (addr -> instruction binary):
-- 0000 -> 00100010000011  MOVI R1,3
-- 0001 -> 00100100000010  MOVI R2,2
-- 0010 -> 10000010100000  MUL  R1,R2
-- 0011 -> 00100110001000  MOVI R3,8
-- 0100 -> 00101000000010  MOVI R4,2
-- 0101 -> 10110111000000  DIV  R3,R4
-- 0110 -> 00000010110000  ADD  R1,R3
-- 0111 -> 00101010000101  MOVI R5,5
-- 1000 -> 00101100000011  MOVI R6,3
-- 1001 -> 01011011100000  AND  R5,R6
-- 1010 -> 01000011010000  SUB  R1,R5
-- 1011 -> 00001110010000  ADD  R7,R1
-- 1100 -> 10010010010000  CMP  R1,R1
-- 1101 -> 01110100100000  XOR  R2,R2
-- 1110 -> 10100100000000  NOT  R2
-- 1111 -> 11000000001111  JMP  15

architecture sim of Program_ROM_TB is
    component program_rom_v2
        port (addr : in  std_logic_vector(3 downto 0);
              data : out std_logic_vector(13 downto 0));
    end component;

    signal addr : std_logic_vector(3 downto 0) := "0000";
    signal data : std_logic_vector(13 downto 0);
begin
    uut : program_rom_v2 port map (addr, data);

    stim : process
    begin
        -- sweep all 16 addresses
        addr <= "0000"; wait for 20 ns;
        addr <= "0001"; wait for 20 ns;
        addr <= "0010"; wait for 20 ns;
        addr <= "0011"; wait for 20 ns;
        addr <= "0100"; wait for 20 ns;
        addr <= "0101"; wait for 20 ns;
        addr <= "0110"; wait for 20 ns;
        addr <= "0111"; wait for 20 ns;
        addr <= "1000"; wait for 20 ns;
        addr <= "1001"; wait for 20 ns;
        addr <= "1010"; wait for 20 ns;
        addr <= "1011"; wait for 20 ns;
        addr <= "1100"; wait for 20 ns;
        addr <= "1101"; wait for 20 ns;
        addr <= "1110"; wait for 20 ns;
        addr <= "1111"; wait for 20 ns;

        -- 240180: addr=bits[3:0]="0100" -> MOVI R4,2
        addr <= "0100"; wait for 20 ns; -- 240180
        -- 240225: addr=bits[3:0]="0001" -> MOVI R2,2
        addr <= "0001"; wait for 20 ns; -- 240225
        -- 240497: addr=bits[3:0]="0001" -> MOVI R2,2
        addr <= "0001"; wait for 20 ns; -- 240497
        -- 240498: addr=bits[3:0]="0010" -> MUL R1,R2
        addr <= "0010"; wait for 20 ns; -- 240498

        wait;
    end process;
end sim;
