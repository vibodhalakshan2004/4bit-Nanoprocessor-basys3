
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu_4bit is
    port (
        a, b     : in  std_logic_vector(3 downto 0);
        op       : in  std_logic_vector(2 downto 0);
        result   : out std_logic_vector(3 downto 0);
        zero     : out std_logic;
        overflow : out std_logic
    );
end alu_4bit;

architecture mixed of alu_4bit is

    component add_sub_4bit
        port (a, b           : in  std_logic_vector(3 downto 0);
              sub            : in  std_logic;
              result         : out std_logic_vector(3 downto 0);
              overflow, zero : out std_logic);
    end component;

    -- ADD/SUB sub-result
    signal addsub_sub    : std_logic;
    signal addsub_result : std_logic_vector(3 downto 0);
    signal addsub_ovf    : std_logic;
    signal addsub_zero   : std_logic;

    -- Logical sub-results
    signal and_r, or_r, xor_r, not_r : std_logic_vector(3 downto 0);

    -- MUL sub-result  (full 8-bit product, low 4 bits feed result mux)
    signal mul_full : unsigned(7 downto 0);
    signal mul_r    : std_logic_vector(3 downto 0);
    signal mul_ovf  : std_logic;

    -- DIV sub-result
    signal div_r    : std_logic_vector(3 downto 0);
    signal div_ovf  : std_logic;

    -- Final mux
    signal r        : std_logic_vector(3 downto 0);
    signal ovf      : std_logic;

begin
    --------------------------------------------------------------------
    -- ADD / SUB  : reuse the structural ripple-carry adder/subtractor
    --------------------------------------------------------------------
    addsub_sub <= '1' when op = "001" else '0';

    addsub : add_sub_4bit
        port map (a        => a,
                  b        => b,
                  sub      => addsub_sub,
                  result   => addsub_result,
                  overflow => addsub_ovf,
                  zero     => addsub_zero);

    --------------------------------------------------------------------
    -- Bit-wise ops (dataflow)
    --------------------------------------------------------------------
    and_r <= a and b;
    or_r  <= a or  b;
    xor_r <= a xor b;
    not_r <= not a;

    --------------------------------------------------------------------
    -- MUL : 4 x 4 -> 8 unsigned. Keep low 4 bits, flag overflow if
    --       upper nibble non-zero.
    --------------------------------------------------------------------
    mul_full <= unsigned(a) * unsigned(b);
    mul_r    <= std_logic_vector(mul_full(3 downto 0));
    mul_ovf  <= '0' when mul_full(7 downto 4) = "0000" else '1';

    --------------------------------------------------------------------
    -- DIV : unsigned a / b. Divide-by-zero -> result=1111, overflow=1.
    --------------------------------------------------------------------
    div_proc : process (a, b)
    begin
        if b = "0000" then
            div_r   <= "1111";
            div_ovf <= '1';
        else
            div_r   <= std_logic_vector(unsigned(a) / unsigned(b));
            div_ovf <= '0';
        end if;
    end process;

    --------------------------------------------------------------------
    -- Final result and overflow muxes (op-driven)
    --------------------------------------------------------------------
    with op select
        r <= addsub_result when "000",
             addsub_result when "001",
             and_r          when "010",
             or_r           when "011",
             xor_r          when "100",
             not_r          when "101",
             mul_r          when "110",
             div_r          when "111",
             "0000"         when others;

    with op select
        ovf <= addsub_ovf when "000",
               addsub_ovf when "001",
               '0'        when "010",
               '0'        when "011",
               '0'        when "100",
               '0'        when "101",
               mul_ovf    when "110",
               div_ovf    when "111",
               '0'        when others;

    result   <= r;
    overflow <= ovf;
    zero     <= '1' when r = "0000" else '0';

end mixed;
