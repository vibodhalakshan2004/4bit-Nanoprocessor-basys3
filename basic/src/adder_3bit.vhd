
library ieee;
use ieee.std_logic_1164.all;

entity adder_3bit is
    port (
        a    : in  std_logic_vector(2 downto 0);
        b    : in  std_logic_vector(2 downto 0);
        cin  : in  std_logic;
        sum  : out std_logic_vector(2 downto 0);
        cout : out std_logic
    );
end adder_3bit;

architecture structural of adder_3bit is
    component full_adder
        port (a, b, cin : in std_logic; sum, cout : out std_logic);
    end component;

    signal carry : std_logic_vector(3 downto 0);
begin
    carry(0) <= cin;

    gen_fa : for i in 0 to 2 generate
        fa_i : full_adder
            port map (a    => a(i),
                      b    => b(i),
                      cin  => carry(i),
                      sum  => sum(i),
                      cout => carry(i+1));
    end generate;

    cout <= carry(3);
end structural;
