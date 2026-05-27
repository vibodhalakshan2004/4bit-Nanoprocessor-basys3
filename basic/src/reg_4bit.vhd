library ieee;
use ieee.std_logic_1164.all;

entity reg_4bit is
    port (
        clk   : in  std_logic;
        reset : in  std_logic;
        en    : in  std_logic;
        d     : in  std_logic_vector(3 downto 0);
        q     : out std_logic_vector(3 downto 0)
    );
end reg_4bit;

architecture structural of reg_4bit is
    component d_ff
        port (clk, reset, en : in std_logic; d : in std_logic; q : out std_logic);
    end component;
begin
    gen_ff : for i in 0 to 3 generate
        ff_i : d_ff port map (clk => clk, reset => reset, en => en,
                              d => d(i), q => q(i));
    end generate;
end structural;
