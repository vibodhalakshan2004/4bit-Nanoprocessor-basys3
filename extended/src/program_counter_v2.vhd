
library ieee;
use ieee.std_logic_1164.all;

entity program_counter_v2 is
    port (
        clk, reset : in  std_logic;
        d          : in  std_logic_vector(3 downto 0);
        q          : out std_logic_vector(3 downto 0)
    );
end program_counter_v2;

architecture structural of program_counter_v2 is

    component d_ff
        port (clk, reset, en, d : in  std_logic;
              q                 : out std_logic);
    end component;

begin
    gen_ff : for i in 0 to 3 generate
        ff_i : d_ff
            port map (clk   => clk,
                      reset => reset,
                      en    => '1',
                      d     => d(i),
                      q     => q(i));
    end generate;
end structural;
