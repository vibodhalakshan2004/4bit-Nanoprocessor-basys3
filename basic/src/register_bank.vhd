
library ieee;
use ieee.std_logic_1164.all;

entity register_bank is
    port (
        clk      : in  std_logic;
        reset    : in  std_logic;
        write_en : in  std_logic;                       -- master write-enable
        dest_sel : in  std_logic_vector(2 downto 0);    -- destination register
        data_in  : in  std_logic_vector(3 downto 0);    -- value to write
        r0, r1, r2, r3 : out std_logic_vector(3 downto 0);
        r4, r5, r6, r7 : out std_logic_vector(3 downto 0)
    );
end register_bank;

architecture structural of register_bank is
    component reg_4bit
        port (clk, reset, en : in std_logic;
              d : in std_logic_vector(3 downto 0);
              q : out std_logic_vector(3 downto 0));
    end component;
    component decoder_3to8
        port (sel : in std_logic_vector(2 downto 0);
              en  : in std_logic;
              y   : out std_logic_vector(7 downto 0));
    end component;

    signal en_lines : std_logic_vector(7 downto 0);
begin
    -- R0 is read-only zero (no flip-flops needed)
    r0 <= "0000";

    -- decoder gates the per-register enables with the master write_en
    dec : decoder_3to8 port map (sel => dest_sel, en => write_en, y => en_lines);

    -- en_lines(0) is intentionally unused (R0 is hardwired)
    reg1 : reg_4bit port map (clk, reset, en_lines(1), data_in, r1);
    reg2 : reg_4bit port map (clk, reset, en_lines(2), data_in, r2);
    reg3 : reg_4bit port map (clk, reset, en_lines(3), data_in, r3);
    reg4 : reg_4bit port map (clk, reset, en_lines(4), data_in, r4);
    reg5 : reg_4bit port map (clk, reset, en_lines(5), data_in, r5);
    reg6 : reg_4bit port map (clk, reset, en_lines(6), data_in, r6);
    reg7 : reg_4bit port map (clk, reset, en_lines(7), data_in, r7);
end structural;
