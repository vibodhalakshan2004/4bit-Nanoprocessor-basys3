library ieee;
use ieee.std_logic_1164.all;

entity Program_Counter_TB is
end Program_Counter_TB;

architecture sim of Program_Counter_TB is
    component program_counter_v2
        port (clk, reset : in  std_logic;
              d          : in  std_logic_vector(3 downto 0);
              q          : out std_logic_vector(3 downto 0));
    end component;

    signal clk, reset : std_logic := '0';
    signal d, q       : std_logic_vector(3 downto 0) := (others => '0');
    constant T : time := 10 ns;
begin
    uut : program_counter_v2 port map (clk, reset, d, q);

    clk_gen : process
    begin
        clk <= '0'; wait for T/2;
        clk <= '1'; wait for T/2;
    end process;

    stim : process
    begin
        reset <= '1'; wait for 2*T;
        reset <= '0';

        d <= "0001"; wait for T; -- q="0001"
        d <= "0010"; wait for T; -- q="0010"
        d <= "0101"; wait for T; -- q="0101"
        d <= "1010"; wait for T; -- q="1010"
        d <= "1111"; wait for T; -- q="1111"

        -- 240180: d=bits[3:0]="0100"
        d <= "0100"; wait for T; -- 240180 q="0100"
        -- 240225: d=bits[3:0]="0001"
        d <= "0001"; wait for T; -- 240225 q="0001"
        -- 240497: d=bits[3:0]="0001"
        d <= "0001"; wait for T; -- 240497 q="0001"
        -- 240498: d=bits[3:0]="0010"
        d <= "0010"; wait for T; -- 240498 q="0010"

        -- reset clears to 0000
        reset <= '1'; wait for 2*T;
        reset <= '0';

        wait;
    end process;
end sim;
