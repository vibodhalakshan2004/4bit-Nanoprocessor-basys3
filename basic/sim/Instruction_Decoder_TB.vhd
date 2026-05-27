library ieee;
use ieee.std_logic_1164.all;

entity Instruction_Decoder_TB is
end Instruction_Decoder_TB;

architecture sim of Instruction_Decoder_TB is
    component instruction_decoder
        port (instruction  : in  std_logic_vector(11 downto 0);
              mux_a_sel    : out std_logic_vector(2 downto 0);
              mux_b_sel    : out std_logic_vector(2 downto 0);
              addsub_sel   : out std_logic;
              data_src_sel : out std_logic;
              imm_value    : out std_logic_vector(3 downto 0);
              dest_reg     : out std_logic_vector(2 downto 0);
              reg_write_en : out std_logic;
              jump_addr    : out std_logic_vector(2 downto 0);
              is_jzr       : out std_logic);
    end component;

    signal instruction  : std_logic_vector(11 downto 0) := (others => '0');
    signal mux_a_sel, mux_b_sel, dest_reg, jump_addr : std_logic_vector(2 downto 0);
    signal addsub_sel, data_src_sel, reg_write_en, is_jzr : std_logic;
    signal imm_value : std_logic_vector(3 downto 0);
begin
    uut : instruction_decoder
        port map (instruction, mux_a_sel, mux_b_sel, addsub_sel,
                  data_src_sel, imm_value, dest_reg, reg_write_en,
                  jump_addr, is_jzr);

    stim : process
    begin
        -- MOVI R1, 3 -> 1 0 001 000 0011
        instruction <= "100001000011"; wait for 20 ns;
        -- MOVI R2, 1 -> 1 0 010 000 0001
        instruction <= "100010000001"; wait for 20 ns;
        -- NEG R2     -> 0 1 010 000 0000
        instruction <= "010010000000"; wait for 20 ns;
        -- ADD R7, R1 -> 0 0 111 001 0000
        instruction <= "001110010000"; wait for 20 ns;
        -- ADD R1, R2 -> 0 0 001 010 0000
        instruction <= "000010100000"; wait for 20 ns;
        -- JZR R1, 7  -> 1 1 001 000 0111
        instruction <= "110010000111"; wait for 20 ns;
        -- JZR R0, 3  -> 1 1 000 000 0011
        instruction <= "110000000011"; wait for 20 ns;

        -- 240180: MOVI R4,4 -> 1 0 100 000 0100
        instruction <= "101000000100"; wait for 20 ns;
        -- 240180: ADD R4,R3  -> 0 0 100 011 0000
        instruction <= "001000110000"; wait for 20 ns;

        -- 240225: NEG R1     -> 0 1 001 000 0000
        instruction <= "010010000000"; wait for 20 ns;
        -- 240225: JZR R1,1   -> 1 1 001 000 0001
        instruction <= "110010000001"; wait for 20 ns;

        -- 240497: ADD R1,R7  -> 0 0 001 111 0000
        instruction <= "000011110000"; wait for 20 ns;

        -- 240498: JZR R2,2   -> 1 1 010 000 0010
        instruction <= "110100000010"; wait for 20 ns;

        wait;
    end process;
end sim;
