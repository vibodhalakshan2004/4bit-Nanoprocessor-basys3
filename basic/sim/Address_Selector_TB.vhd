library ieee;
use ieee.std_logic_1164.all;

entity Address_Selector_TB is
end Address_Selector_TB;

architecture sim of Address_Selector_TB is
    component mux_2way_3bit
        port (sel : in  std_logic;
              i0  : in  std_logic_vector(2 downto 0);
              i1  : in  std_logic_vector(2 downto 0);
              y   : out std_logic_vector(2 downto 0));
    end component;

    signal sel     : std_logic := '0';
    signal i0, i1, y : std_logic_vector(2 downto 0) := (others => '0');
begin
    uut : mux_2way_3bit port map (sel, i0, i1, y);

    stim : process
    begin
        -- sel=0 -> y=i0 (PC+1 path)
        i0 <= "001"; i1 <= "110"; sel <= '0'; wait for 20 ns;
        -- sel=1 -> y=i1 (jump path)
        sel <= '1'; wait for 20 ns;

        -- 240180: i0=bits[2:0]="100", i1="011" (bits[6:4])
        i0 <= "100"; i1 <= "011"; sel <= '0'; wait for 20 ns; -- y="100"
        sel <= '1'; wait for 20 ns;                            -- y="011"

        -- 240225: i0=bits[2:0]="001", i1="110" (bits[6:4])
        i0 <= "001"; i1 <= "110"; sel <= '0'; wait for 20 ns;
        sel <= '1'; wait for 20 ns;

        -- 240497: i0=bits[2:0]="001", i1="111" (bits[6:4])
        i0 <= "001"; i1 <= "111"; sel <= '0'; wait for 20 ns;
        sel <= '1'; wait for 20 ns;

        -- 240498: i0=bits[2:0]="010", i1="111" (bits[6:4])
        i0 <= "010"; i1 <= "111"; sel <= '0'; wait for 20 ns;
        sel <= '1'; wait for 20 ns;

        wait;
    end process;
end sim;
