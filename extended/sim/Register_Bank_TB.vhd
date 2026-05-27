library ieee;
use ieee.std_logic_1164.all;

entity Register_Bank_TB is
end Register_Bank_TB;

architecture sim of Register_Bank_TB is
    component register_bank
        port (clk, reset, write_en : in std_logic;
              dest_sel : in  std_logic_vector(2 downto 0);
              data_in  : in  std_logic_vector(3 downto 0);
              r0, r1, r2, r3 : out std_logic_vector(3 downto 0);
              r4, r5, r6, r7 : out std_logic_vector(3 downto 0));
    end component;

    signal clk, reset, write_en : std_logic := '0';
    signal dest_sel : std_logic_vector(2 downto 0) := "000";
    signal data_in  : std_logic_vector(3 downto 0) := (others => '0');
    signal r0, r1, r2, r3, r4, r5, r6, r7 : std_logic_vector(3 downto 0);
    constant T : time := 10 ns;
begin
    uut : register_bank
        port map (clk, reset, write_en, dest_sel, data_in,
                  r0, r1, r2, r3, r4, r5, r6, r7);

    clk_gen : process
    begin
        clk <= '0'; wait for T/2;
        clk <= '1'; wait for T/2;
    end process;

    stim : process
    begin
        reset <= '1'; wait for 2*T;
        reset <= '0'; wait for T;

        dest_sel <= "001"; data_in <= "0101"; write_en <= '1'; wait for T;
        write_en <= '0'; wait for T;

        dest_sel <= "111"; data_in <= "1010"; write_en <= '1'; wait for T;
        write_en <= '0'; wait for T;

        -- attempt write to R0 (hardwired zero, ignored)
        dest_sel <= "000"; data_in <= "1111"; write_en <= '1'; wait for T;
        write_en <= '0'; wait for T;

        -- 240180: data_in=bits[3:0]="0100", dest=bits[2:0]="100"(R4)
        dest_sel <= "100"; data_in <= "0100"; write_en <= '1'; wait for T; -- 240180
        write_en <= '0'; wait for T;

        -- 240225: data_in=bits[3:0]="0001", dest=bits[2:0]="001"(R1)
        dest_sel <= "001"; data_in <= "0001"; write_en <= '1'; wait for T; -- 240225
        write_en <= '0'; wait for T;

        -- 240497: data_in=bits[7:4]="0111", dest=bits[2:0]="001"(R1)
        dest_sel <= "001"; data_in <= "0111"; write_en <= '1'; wait for T; -- 240497
        write_en <= '0'; wait for T;

        -- 240498: data_in=bits[3:0]="0010", dest=bits[2:0]="010"(R2)
        dest_sel <= "010"; data_in <= "0010"; write_en <= '1'; wait for T; -- 240498
        write_en <= '0'; wait for T;

        reset <= '1'; wait for 2*T;
        reset <= '0'; wait for T;

        wait;
    end process;
end sim;
