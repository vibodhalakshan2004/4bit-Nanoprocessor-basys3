library ieee;
use ieee.std_logic_1164.all;

entity PC_Adder_TB is
end PC_Adder_TB;

architecture sim of PC_Adder_TB is
    component adder_4bit
        port (a, b : in  std_logic_vector(3 downto 0);
              cin  : in  std_logic;
              sum  : out std_logic_vector(3 downto 0);
              cout : out std_logic);
    end component;

    signal a, b, sum : std_logic_vector(3 downto 0) := (others => '0');
    signal cin, cout : std_logic := '0';
begin
    uut : adder_4bit port map (a, b, cin, sum, cout);

    stim : process
    begin
        -- PC+1 behaviour (b="0000", cin='1')
        a <= "0000"; b <= "0000"; cin <= '1'; wait for 20 ns; -- 0+1=1
        a <= "0101"; b <= "0000"; cin <= '1'; wait for 20 ns; -- 5+1=6
        a <= "1110"; b <= "0000"; cin <= '1'; wait for 20 ns; -- 14+1=15
        a <= "1111"; b <= "0000"; cin <= '1'; wait for 20 ns; -- 15+1=0 wrap cout=1

        -- 240180: a=bits[3:0]="0100", b="0000", cin='1' -> sum="0101"
        a <= "0100"; b <= "0000"; cin <= '1'; wait for 20 ns; -- 240180
        -- 240225: a=bits[3:0]="0001", cin='1'           -> sum="0010"
        a <= "0001"; b <= "0000"; cin <= '1'; wait for 20 ns; -- 240225
        -- 240497: a=bits[3:0]="0001", cin='1'           -> sum="0010"
        a <= "0001"; b <= "0000"; cin <= '1'; wait for 20 ns; -- 240497
        -- 240498: a=bits[3:0]="0010", cin='1'           -> sum="0011"
        a <= "0010"; b <= "0000"; cin <= '1'; wait for 20 ns; -- 240498

        wait;
    end process;
end sim;
