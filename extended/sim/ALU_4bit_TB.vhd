library ieee;
use ieee.std_logic_1164.all;

entity ALU_4bit_TB is
end ALU_4bit_TB;

architecture sim of ALU_4bit_TB is
    component alu_4bit
        port (a, b   : in  std_logic_vector(3 downto 0);
              op     : in  std_logic_vector(2 downto 0);
              result : out std_logic_vector(3 downto 0);
              zero, overflow : out std_logic);
    end component;

    signal a, b, result : std_logic_vector(3 downto 0) := (others => '0');
    signal op           : std_logic_vector(2 downto 0) := (others => '0');
    signal zero, overflow : std_logic;
begin
    uut : alu_4bit port map (a, b, op, result, zero, overflow);

    stim : process
    begin
        -- ADD (op="000")
        a <= "0011"; b <= "0100"; op <= "000"; wait for 20 ns; -- 3+4=7
        a <= "0111"; b <= "0001"; op <= "000"; wait for 20 ns; -- 7+1=8 overflow

        -- SUB (op="001")
        a <= "0101"; b <= "0011"; op <= "001"; wait for 20 ns; -- 5-3=2
        a <= "0011"; b <= "0011"; op <= "001"; wait for 20 ns; -- 3-3=0 zero=1

        -- AND (op="010")
        a <= "1100"; b <= "1010"; op <= "010"; wait for 20 ns; -- 1100 AND 1010 = 1000

        -- OR  (op="011")
        a <= "1100"; b <= "1010"; op <= "011"; wait for 20 ns; -- 1100 OR 1010 = 1110

        -- XOR (op="100")
        a <= "1100"; b <= "1010"; op <= "100"; wait for 20 ns; -- 1100 XOR 1010 = 0110

        -- NOT (op="101")
        a <= "1010"; b <= "0000"; op <= "101"; wait for 20 ns; -- NOT 1010 = 0101

        -- MUL (op="110")
        a <= "0011"; b <= "0011"; op <= "110"; wait for 20 ns; -- 3*3=9
        a <= "0101"; b <= "0101"; op <= "110"; wait for 20 ns; -- 5*5=25 overflow

        -- DIV (op="111")
        a <= "1100"; b <= "0011"; op <= "111"; wait for 20 ns; -- 12/3=4
        a <= "0101"; b <= "0000"; op <= "111"; wait for 20 ns; -- div by zero ovf=1

        -- 240180: a=bits[3:0]="0100", b=bits[7:4]="0011"
        a <= "0100"; b <= "0011"; op <= "000"; wait for 20 ns; -- ADD 4+3=7
        a <= "0100"; b <= "0011"; op <= "001"; wait for 20 ns; -- SUB 4-3=1
        a <= "0100"; b <= "0011"; op <= "010"; wait for 20 ns; -- AND 0100&0011=0000 zero=1
        a <= "0100"; b <= "0011"; op <= "011"; wait for 20 ns; -- OR  0100|0011=0111
        a <= "0100"; b <= "0011"; op <= "100"; wait for 20 ns; -- XOR 0100^0011=0111
        a <= "0100"; b <= "0000"; op <= "101"; wait for 20 ns; -- NOT 0100=1011
        a <= "0100"; b <= "0011"; op <= "110"; wait for 20 ns; -- MUL 4*3=12
        a <= "0100"; b <= "0011"; op <= "111"; wait for 20 ns; -- DIV 4/3=1

        -- 240225: a=bits[3:0]="0001", b=bits[7:4]="0110"
        a <= "0001"; b <= "0110"; op <= "000"; wait for 20 ns; -- ADD 1+6=7
        a <= "0001"; b <= "0110"; op <= "001"; wait for 20 ns; -- SUB 1-6=-5
        a <= "0001"; b <= "0110"; op <= "010"; wait for 20 ns; -- AND 0001&0110=0000 zero=1
        a <= "0001"; b <= "0110"; op <= "011"; wait for 20 ns; -- OR  0001|0110=0111
        a <= "0001"; b <= "0110"; op <= "100"; wait for 20 ns; -- XOR 0001^0110=0111
        a <= "0001"; b <= "0000"; op <= "101"; wait for 20 ns; -- NOT 0001=1110
        a <= "0001"; b <= "0110"; op <= "110"; wait for 20 ns; -- MUL 1*6=6
        a <= "0001"; b <= "0110"; op <= "111"; wait for 20 ns; -- DIV 1/6=0 zero=1

        -- 240497: a=bits[3:0]="0001", b=bits[7:4]="0111"
        a <= "0001"; b <= "0111"; op <= "000"; wait for 20 ns; -- ADD 1+7=8 overflow
        a <= "0001"; b <= "0111"; op <= "001"; wait for 20 ns; -- SUB 1-7=-6
        a <= "0001"; b <= "0111"; op <= "110"; wait for 20 ns; -- MUL 1*7=7
        a <= "0001"; b <= "0111"; op <= "111"; wait for 20 ns; -- DIV 1/7=0 zero=1

        -- 240498: a=bits[3:0]="0010", b=bits[7:4]="0111"
        a <= "0010"; b <= "0111"; op <= "000"; wait for 20 ns; -- ADD 2+7=9 overflow
        a <= "0010"; b <= "0111"; op <= "001"; wait for 20 ns; -- SUB 2-7=-5
        a <= "0010"; b <= "0111"; op <= "110"; wait for 20 ns; -- MUL 2*7=14
        a <= "0010"; b <= "0111"; op <= "111"; wait for 20 ns; -- DIV 2/7=0 zero=1

        wait;
    end process;
end sim;
