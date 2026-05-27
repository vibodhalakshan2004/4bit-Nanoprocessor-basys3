library ieee;
use ieee.std_logic_1164.all;

entity Program_Counter_TB is
end Program_Counter_TB;

architecture sim of Program_Counter_TB is
    component program_counter
        port (clk   : in  std_logic;
              reset : in  std_logic;
              d     : in  std_logic_vector(2 downto 0);
              q     : out std_logic_vector(2 downto 0));
    end component;

    signal clk, reset : std_logic := '0';
    signal d, q       : std_logic_vector(2 downto 0) := (others => '0');
    constant T : time := 10 ns;
begin
    uut : program_counter port map (clk, reset, d, q);

    clk_gen : process
    begin
        clk <= '0'; wait for T/2;
        clk <= '1'; wait for T/2;
    end process;

    stim : process
    begin
        reset <= '1'; wait for 2*T;
        reset <= '0';

        -- load sequential addresses
        d <= "001"; wait for T; -- q="001"
        d <= "010"; wait for T; -- q="010"
        d <= "011"; wait for T; -- q="011"

        -- 240180: d=bits[2:0]="100"
        d <= "100"; wait for T; -- 240180, q="100"
        -- 240225: d=bits[2:0]="001"
        d <= "001"; wait for T; -- 240225, q="001"
        -- 240497: d=bits[2:0]="001"
        d <= "001"; wait for T; -- 240497, q="001"
        -- 240498: d=bits[2:0]="010"
        d <= "010"; wait for T; -- 240498, q="010"

        -- verify reset clears to 0
        reset <= '1'; wait for 2*T;
        reset <= '0';

        wait;
    end process;
end sim;
