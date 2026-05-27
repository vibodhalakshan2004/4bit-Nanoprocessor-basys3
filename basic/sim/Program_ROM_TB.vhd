library ieee;
use ieee.std_logic_1164.all;

entity Program_ROM_TB is
end Program_ROM_TB;

architecture sim of Program_ROM_TB is
    component program_rom
        port (addr : in  std_logic_vector(2 downto 0);
              data : out std_logic_vector(11 downto 0));
    end component;

    signal addr : std_logic_vector(2 downto 0) := "000";
    signal data : std_logic_vector(11 downto 0);
begin
    uut : program_rom port map (addr, data);

    stim : process
    begin
        -- sweep all 8 addresses
        addr <= "000"; wait for 20 ns; -- MOVI R1,3  -> "100001000011"
        addr <= "001"; wait for 20 ns; -- MOVI R2,1  -> "100010000001"
        addr <= "010"; wait for 20 ns; -- NEG  R2    -> "010010000000"
        addr <= "011"; wait for 20 ns; -- ADD  R7,R1 -> "001110010000"
        addr <= "100"; wait for 20 ns; -- ADD  R1,R2 -> "000010100000"
        addr <= "101"; wait for 20 ns; -- JZR  R1,7  -> "110010000111"
        addr <= "110"; wait for 20 ns; -- JZR  R0,3  -> "110000000011"
        addr <= "111"; wait for 20 ns; -- JZR  R0,7  -> "110000000111"

        -- 240180: addr=bits[2:0]="100" -> "000010100000" (ADD R1,R2)
        addr <= "100"; wait for 20 ns; -- 240180

        -- 240225: addr=bits[2:0]="001" -> "100010000001" (MOVI R2,1)
        addr <= "001"; wait for 20 ns; -- 240225

        -- 240497: addr=bits[2:0]="001" -> "100010000001" (MOVI R2,1)
        addr <= "001"; wait for 20 ns; -- 240497

        -- 240498: addr=bits[2:0]="010" -> "010010000000" (NEG R2)
        addr <= "010"; wait for 20 ns; -- 240498

        wait;
    end process;
end sim;
