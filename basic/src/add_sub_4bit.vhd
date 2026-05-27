
library ieee;
use ieee.std_logic_1164.all;

entity add_sub_4bit is
    port (
        a        : in  std_logic_vector(3 downto 0);
        b        : in  std_logic_vector(3 downto 0);
        sub      : in  std_logic;
        result   : out std_logic_vector(3 downto 0);
        overflow : out std_logic;
        zero     : out std_logic
    );
end add_sub_4bit;

architecture structural of add_sub_4bit is
    component full_adder
        port (a, b, cin : in std_logic; sum, cout : out std_logic);
    end component;

    signal b_xor : std_logic_vector(3 downto 0);
    signal carry : std_logic_vector(4 downto 0);
    signal sum   : std_logic_vector(3 downto 0);
begin
    carry(0) <= sub;                       -- cin = 1 for subtract

    gen_fa : for i in 0 to 3 generate
        b_xor(i) <= b(i) xor sub;          -- invert b for subtract
        fa_i : full_adder
            port map (a    => a(i),
                      b    => b_xor(i),
                      cin  => carry(i),
                      sum  => sum(i),
                      cout => carry(i+1));
    end generate;

    result   <= sum;
    overflow <= carry(4) xor carry(3);                 -- signed overflow
    zero     <= '1' when sum = "0000" else '0';
end structural;
