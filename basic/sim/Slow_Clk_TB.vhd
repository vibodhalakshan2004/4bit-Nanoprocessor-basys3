library ieee;
use ieee.std_logic_1164.all;

entity Slow_Clk_TB is
end Slow_Clk_TB;

architecture sim of Slow_Clk_TB is
    component clock_divider
        generic (DIVISOR : integer := 100_000_000);
        port (clk_in  : in  std_logic;
              reset   : in  std_logic;
              clk_out : out std_logic);
    end component;

    signal clk_in, reset, clk_out : std_logic := '0';
    constant T : time := 10 ns;
begin
    uut : clock_divider
        generic map (DIVISOR => 4)
        port map (clk_in, reset, clk_out);

    clk_gen : process
    begin
        clk_in <= '0'; wait for T/2;
        clk_in <= '1'; wait for T/2;
    end process;

    stim : process
    begin
        -- apply reset
        reset <= '1'; wait for 4*T;
        reset <= '0';

        -- observe several slow clock cycles
        wait for 40*T;

        -- mid-run reset to verify counter clears
        reset <= '1'; wait for 4*T;
        reset <= '0';

        -- observe again after reset
        wait for 40*T;

        wait;
    end process;
end sim;