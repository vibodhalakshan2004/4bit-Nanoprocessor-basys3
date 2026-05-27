
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity clock_divider is
    generic (
        DIVISOR : integer := 100_000_000
    );
    port (
        clk_in  : in  std_logic;
        reset   : in  std_logic;
        clk_out : out std_logic
    );
end clock_divider;

architecture behavioral of clock_divider is
    signal counter   : integer range 0 to DIVISOR-1 := 0;
    signal clk_state : std_logic := '0';
begin
    process(clk_in, reset)
    begin
        if reset = '1' then
            counter   <= 0;
            clk_state <= '0';
        elsif rising_edge(clk_in) then
            if counter = DIVISOR - 1 then
                counter   <= 0;
                clk_state <= not clk_state;
            else
                counter <= counter + 1;
            end if;
        end if;
    end process;

    clk_out <= clk_state;
end behavioral;
