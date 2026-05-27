library ieee;
use ieee.std_logic_1164.all;

entity Add_Sub_4_TB is
end Add_Sub_4_TB;

architecture sim of Add_Sub_4_TB is
    component add_sub_4bit
        port (a, b   : in  std_logic_vector(3 downto 0);
              sub    : in  std_logic;
              result : out std_logic_vector(3 downto 0);
              overflow, zero : out std_logic);
    end component;

    signal a, b, result : std_logic_vector(3 downto 0) := (others => '0');
    signal sub          : std_logic := '0';
    signal overflow, zero : std_logic;
begin
    uut : add_sub_4bit port map (a, b, sub, result, overflow, zero);

    stim : process
    begin
        -- 3 + 5 = 8 (overflow)
        a <= "0011"; b <= "0101"; sub <= '0'; wait for 20 ns;
        -- 5 - 3 = 2
        a <= "0101"; b <= "0011"; sub <= '1'; wait for 20 ns;
        -- 3 - 3 = 0 (zero=1)
        a <= "0011"; b <= "0011"; sub <= '1'; wait for 20 ns;
        -- 0 - 1 = -1
        a <= "0000"; b <= "0001"; sub <= '1'; wait for 20 ns;

        -- 240180: a=bits[3:0]="0100", b=bits[7:4]="0011"
        a <= "0100"; b <= "0011"; sub <= '0'; wait for 20 ns; -- 4+3=7
        a <= "0100"; b <= "0011"; sub <= '1'; wait for 20 ns; -- 4-3=1

        -- 240225: a=bits[3:0]="0001", b=bits[7:4]="0110"
        a <= "0001"; b <= "0110"; sub <= '0'; wait for 20 ns; -- 1+6=7
        a <= "0001"; b <= "0110"; sub <= '1'; wait for 20 ns; -- 1-6=-5

        -- 240497: a=bits[3:0]="0001", b=bits[7:4]="0111"
        a <= "0001"; b <= "0111"; sub <= '0'; wait for 20 ns; -- 1+7=8 overflow
        a <= "0001"; b <= "0111"; sub <= '1'; wait for 20 ns; -- 1-7=-6

        -- 240498: a=bits[3:0]="0010", b=bits[7:4]="0111"
        a <= "0010"; b <= "0111"; sub <= '0'; wait for 20 ns; -- 2+7=9 overflow
        a <= "0010"; b <= "0111"; sub <= '1'; wait for 20 ns; -- 2-7=-5

        wait;
    end process;
end sim;
