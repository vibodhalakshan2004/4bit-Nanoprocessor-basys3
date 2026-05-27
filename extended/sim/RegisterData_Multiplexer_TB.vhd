library ieee;
use ieee.std_logic_1164.all;

entity RegisterData_Multiplexer_TB is
end RegisterData_Multiplexer_TB;

architecture sim of RegisterData_Multiplexer_TB is
    component mux_8way_4bit
        port (sel            : in  std_logic_vector(2 downto 0);
              i0, i1, i2, i3 : in  std_logic_vector(3 downto 0);
              i4, i5, i6, i7 : in  std_logic_vector(3 downto 0);
              y              : out std_logic_vector(3 downto 0));
    end component;

    signal sel             : std_logic_vector(2 downto 0) := "000";
    signal i0, i1, i2, i3 : std_logic_vector(3 downto 0) := (others => '0');
    signal i4, i5, i6, i7 : std_logic_vector(3 downto 0) := (others => '0');
    signal y               : std_logic_vector(3 downto 0);
begin
    i0 <= "0000"; -- R0 hardwired 0
    i1 <= "0001"; -- 240225 bits[3:0]
    i2 <= "0010"; -- 240498 bits[3:0]
    i3 <= "0011"; -- general
    i4 <= "0100"; -- 240180 bits[3:0]
    i5 <= "0101"; -- general
    i6 <= "0110"; -- 240225 bits[7:4]
    i7 <= "0111"; -- 240497 bits[7:4]

    uut : mux_8way_4bit port map (sel, i0, i1, i2, i3, i4, i5, i6, i7, y);

    stim : process
    begin
        sel <= "000"; wait for 20 ns; -- y="0000"
        sel <= "001"; wait for 20 ns; -- y="0001"
        sel <= "010"; wait for 20 ns; -- y="0010"
        sel <= "011"; wait for 20 ns; -- y="0011"
        sel <= "100"; wait for 20 ns; -- y="0100"
        sel <= "101"; wait for 20 ns; -- y="0101"
        sel <= "110"; wait for 20 ns; -- y="0110"
        sel <= "111"; wait for 20 ns; -- y="0111"

        -- 240180: sel=bits[2:0]="100" -> y=i4="0100"
        sel <= "100"; wait for 20 ns; -- 240180
        -- 240225: sel=bits[2:0]="001" -> y=i1="0001"
        sel <= "001"; wait for 20 ns; -- 240225
        -- 240497: sel=bits[2:0]="001" -> y=i1="0001"
        sel <= "001"; wait for 20 ns; -- 240497
        -- 240498: sel=bits[2:0]="010" -> y=i2="0010"
        sel <= "010"; wait for 20 ns; -- 240498

        wait;
    end process;
end sim;
