library ieee;
use ieee.std_logic_1164.all;

entity NanoProcessor_TB is
end NanoProcessor_TB;

-- Expected final state: R7="1001" (9), LD14=zero flag, LD15=jump active
-- Program halts at PC=15 (JMP 15 loop)

architecture sim of NanoProcessor_TB is
    component nanoprocessor_top_v2
        generic (SIM_MODE : boolean; DIVISOR : integer);
        port (clk, reset : in  std_logic;
              led        : out std_logic_vector(15 downto 0);
              seg        : out std_logic_vector(6 downto 0);
              an         : out std_logic_vector(3 downto 0));
    end component;

    signal clk, reset : std_logic := '0';
    signal led        : std_logic_vector(15 downto 0);
    signal seg        : std_logic_vector(6 downto 0);
    signal an         : std_logic_vector(3 downto 0);
    constant T : time := 20 ns;
begin
    uut : nanoprocessor_top_v2
        generic map (SIM_MODE => true, DIVISOR => 4)
        port map (clk, reset, led, seg, an);

    clk_gen : process
    begin
        clk <= '0'; wait for T/2;
        clk <= '1'; wait for T/2;
    end process;

    stim : process
    begin
        reset <= '1'; wait for 3*T;
        reset <= '0';

        wait;
    end process;
end sim;
