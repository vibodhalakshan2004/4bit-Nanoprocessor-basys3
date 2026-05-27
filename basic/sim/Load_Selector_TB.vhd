library ieee;
use ieee.std_logic_1164.all;

entity Load_Selector_TB is
end Load_Selector_TB;

architecture sim of Load_Selector_TB is
    component mux_2way_4bit
        port (sel : in  std_logic;
              i0  : in  std_logic_vector(3 downto 0);
              i1  : in  std_logic_vector(3 downto 0);
              y   : out std_logic_vector(3 downto 0));
    end component;

    signal sel     : std_logic := '0';
    signal i0, i1, y : std_logic_vector(3 downto 0) := (others => '0');
begin
    uut : mux_2way_4bit port map (sel, i0, i1, y);

    stim : process
    begin
        -- sel=0 -> y=i0 (ALU result)
        i0 <= "0101"; i1 <= "1010"; sel <= '0'; wait for 20 ns;
        -- sel=1 -> y=i1 (immediate)
        sel <= '1'; wait for 20 ns;

        -- 240180: i0=bits[3:0]="0100", i1=bits[7:4]="0011"
        i0 <= "0100"; i1 <= "0011"; sel <= '0'; wait for 20 ns; -- y="0100"
        sel <= '1'; wait for 20 ns;                              -- y="0011"

        -- 240225: i0=bits[3:0]="0001", i1=bits[7:4]="0110"
        i0 <= "0001"; i1 <= "0110"; sel <= '0'; wait for 20 ns;
        sel <= '1'; wait for 20 ns;

        -- 240497: i0=bits[3:0]="0001", i1=bits[7:4]="0111"
        i0 <= "0001"; i1 <= "0111"; sel <= '0'; wait for 20 ns;
        sel <= '1'; wait for 20 ns;

        -- 240498: i0=bits[3:0]="0010", i1=bits[7:4]="0111"
        i0 <= "0010"; i1 <= "0111"; sel <= '0'; wait for 20 ns;
        sel <= '1'; wait for 20 ns;

        wait;
    end process;
end sim;
