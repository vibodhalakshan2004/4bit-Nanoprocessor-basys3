library ieee;
use ieee.std_logic_1164.all;

entity mux_2way_4bit is
    port (
        sel : in  std_logic;
        i0  : in  std_logic_vector(3 downto 0);
        i1  : in  std_logic_vector(3 downto 0);
        y   : out std_logic_vector(3 downto 0)
    );
end mux_2way_4bit;

architecture dataflow of mux_2way_4bit is
begin
    y <= i0 when sel = '0' else i1;
end dataflow;
