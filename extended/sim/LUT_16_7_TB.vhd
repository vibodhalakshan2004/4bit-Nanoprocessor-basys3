library ieee;
use ieee.std_logic_1164.all;

entity LUT_16_7_TB is
end LUT_16_7_TB;

architecture sim of LUT_16_7_TB is
    component seven_seg_display
        port (value : in  std_logic_vector(3 downto 0);
              seg   : out std_logic_vector(6 downto 0);
              an    : out std_logic_vector(3 downto 0));
    end component;

    signal value : std_logic_vector(3 downto 0) := (others => '0');
    signal seg   : std_logic_vector(6 downto 0);
    signal an    : std_logic_vector(3 downto 0);
begin
    uut : seven_seg_display port map (value, seg, an);

    stim : process
    begin
        value <= "0000"; wait for 20 ns;
        value <= "0001"; wait for 20 ns;
        value <= "0010"; wait for 20 ns;
        value <= "0011"; wait for 20 ns;
        value <= "0100"; wait for 20 ns;
        value <= "0101"; wait for 20 ns;
        value <= "0110"; wait for 20 ns;
        value <= "0111"; wait for 20 ns;
        value <= "1000"; wait for 20 ns;
        value <= "1001"; wait for 20 ns;
        value <= "1010"; wait for 20 ns;
        value <= "1011"; wait for 20 ns;
        value <= "1100"; wait for 20 ns;
        value <= "1101"; wait for 20 ns;
        value <= "1110"; wait for 20 ns;
        value <= "1111"; wait for 20 ns;

        -- 240180: bits[3:0]="0100"
        value <= "0100"; wait for 20 ns; -- 240180
        -- 240225: bits[3:0]="0001"
        value <= "0001"; wait for 20 ns; -- 240225
        -- 240497: bits[3:0]="0001"
        value <= "0001"; wait for 20 ns; -- 240497
        -- 240498: bits[3:0]="0010"
        value <= "0010"; wait for 20 ns; -- 240498

        wait;
    end process;
end sim;
