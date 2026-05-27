
library ieee;
use ieee.std_logic_1164.all;

entity adder_4bit is
    port (
        a, b : in  std_logic_vector(3 downto 0);
        cin  : in  std_logic;
        sum  : out std_logic_vector(3 downto 0);
        cout : out std_logic
    );
end adder_4bit;

architecture structural of adder_4bit is

    component full_adder
        port (a, b, cin : in  std_logic;
              sum, cout : out std_logic);
    end component;

    signal carry : std_logic_vector(4 downto 0);

begin
    carry(0) <= cin;

    gen_fa : for i in 0 to 3 generate
        fa_i : full_adder
            port map (a    => a(i),
                      b    => b(i),
                      cin  => carry(i),
                      sum  => sum(i),
                      cout => carry(i+1));
    end generate;

    cout <= carry(4);
end structural;
