library ieee;
use ieee.std_logic_1164.all;

entity PC_Adder_TB is
end PC_Adder_TB;

architecture sim of PC_Adder_TB is
    component adder_3bit
        port (a    : in  std_logic_vector(2 downto 0);
              b    : in  std_logic_vector(2 downto 0);
              cin  : in  std_logic;
              sum  : out std_logic_vector(2 downto 0);
              cout : out std_logic);
    end component;

    signal a, b, sum : std_logic_vector(2 downto 0) := (others => '0');
    signal cin, cout : std_logic := '0';
begin
    uut : adder_3bit port map (a, b, cin, sum, cout);

    stim : process
    begin
        -- PC+1 behaviour (b="000", cin='1')
        a <= "000"; b <= "000"; cin <= '1'; wait for 20 ns; -- 0+1=1
        a <= "011"; b <= "000"; cin <= '1'; wait for 20 ns; -- 3+1=4
        a <= "110"; b <= "000"; cin <= '1'; wait for 20 ns; -- 6+1=7
        a <= "111"; b <= "000"; cin <= '1'; wait for 20 ns; -- 7+1=0 (wrap)

        -- 240180: a=bits[2:0]="100", b="000", cin='1'  -> sum="101"
        a <= "100"; b <= "000"; cin <= '1'; wait for 20 ns; -- 240180
        -- 240225: a=bits[2:0]="001", cin='1'            -> sum="010"
        a <= "001"; b <= "000"; cin <= '1'; wait for 20 ns; -- 240225
        -- 240497: a=bits[2:0]="001", cin='1'            -> sum="010"
        a <= "001"; b <= "000"; cin <= '1'; wait for 20 ns; -- 240497
        -- 240498: a=bits[2:0]="010", cin='1'            -> sum="011"
        a <= "010"; b <= "000"; cin <= '1'; wait for 20 ns; -- 240498

        wait;
    end process;
end sim;
