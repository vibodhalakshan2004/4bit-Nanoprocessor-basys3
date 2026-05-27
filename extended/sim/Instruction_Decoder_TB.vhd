library ieee;
use ieee.std_logic_1164.all;

entity Instruction_Decoder_TB is
end Instruction_Decoder_TB;

-- Instruction format (14 bits): [13:10]=opcode [9:7]=Ra [6:4]=Rb [3:0]=imm/jump
-- Opcodes: 0000=ADD 0001=NEG 0010=MOVI 0011=JZR 0100=SUB 0101=AND
--          0110=OR  0111=XOR 1000=MUL  1001=CMP  1010=NOT 1011=DIV 1100=JMP

architecture sim of Instruction_Decoder_TB is
    component instruction_decoder_v2
        port (instruction  : in  std_logic_vector(13 downto 0);
              mux_a_sel    : out std_logic_vector(2 downto 0);
              mux_b_sel    : out std_logic_vector(2 downto 0);
              alu_op       : out std_logic_vector(2 downto 0);
              data_src_sel : out std_logic;
              imm_value    : out std_logic_vector(3 downto 0);
              dest_reg     : out std_logic_vector(2 downto 0);
              reg_write_en : out std_logic;
              jump_addr    : out std_logic_vector(3 downto 0);
              is_jzr       : out std_logic;
              is_jmp       : out std_logic);
    end component;

    signal instruction  : std_logic_vector(13 downto 0) := (others => '0');
    signal mux_a_sel, mux_b_sel, dest_reg : std_logic_vector(2 downto 0);
    signal alu_op       : std_logic_vector(2 downto 0);
    signal jump_addr    : std_logic_vector(3 downto 0);
    signal data_src_sel, reg_write_en, is_jzr, is_jmp : std_logic;
    signal imm_value    : std_logic_vector(3 downto 0);
begin
    uut : instruction_decoder_v2
        port map (instruction, mux_a_sel, mux_b_sel, alu_op, data_src_sel,
                  imm_value, dest_reg, reg_write_en, jump_addr, is_jzr, is_jmp);

    stim : process
    begin
        -- ADD  R1, R2 -> 0000 001 010 0000
        instruction <= "00000010100000"; wait for 20 ns;
        -- NEG  R2     -> 0001 010 000 0000
        instruction <= "00010100000000"; wait for 20 ns;
        -- MOVI R1, 3  -> 0010 001 000 0011
        instruction <= "00100010000011"; wait for 20 ns;
        -- JZR  R1, 7  -> 0011 001 000 0111
        instruction <= "00110010000111"; wait for 20 ns;
        -- SUB  R3, R4 -> 0100 011 100 0000
        instruction <= "01000111000000"; wait for 20 ns;
        -- AND  R5, R6 -> 0101 101 110 0000
        instruction <= "01011011100000"; wait for 20 ns;
        -- OR   R1, R2 -> 0110 001 010 0000
        instruction <= "01100010100000"; wait for 20 ns;
        -- XOR  R2, R2 -> 0111 010 010 0000
        instruction <= "01110100100000"; wait for 20 ns;
        -- MUL  R1, R2 -> 1000 001 010 0000
        instruction <= "10000010100000"; wait for 20 ns;
        -- CMP  R1, R1 -> 1001 001 001 0000
        instruction <= "10010010010000"; wait for 20 ns;
        -- NOT  R2     -> 1010 010 000 0000
        instruction <= "10100100000000"; wait for 20 ns;
        -- DIV  R3, R4 -> 1011 011 100 0000
        instruction <= "10110111000000"; wait for 20 ns;
        -- JMP  15     -> 1100 000 000 1111
        instruction <= "11000000001111"; wait for 20 ns;

        -- 240180: R=bits[2:0]="100"(R4), Rb=bits[6:4]="011"(R3), d=bits[3:0]="0100"(4)
        -- MOVI R4, 4  -> 0010 100 000 0100
        instruction <= "00101000000100"; wait for 20 ns; -- 240180
        -- ADD  R4, R3 -> 0000 100 011 0000
        instruction <= "00001000110000"; wait for 20 ns; -- 240180

        -- 240225: R=bits[2:0]="001"(R1), Rb=bits[6:4]="110"(R6), d=bits[3:0]="0001"(1)
        -- NEG  R1     -> 0001 001 000 0000
        instruction <= "00010010000000"; wait for 20 ns; -- 240225
        -- JZR  R1, 1  -> 0011 001 000 0001
        instruction <= "00110010000001"; wait for 20 ns; -- 240225

        -- 240497: R=bits[2:0]="001"(R1), Rb=bits[6:4]="111"(R7)
        -- SUB  R1, R7 -> 0100 001 111 0000
        instruction <= "01000011110000"; wait for 20 ns; -- 240497
        -- MUL  R1, R7 -> 1000 001 111 0000
        instruction <= "10000011110000"; wait for 20 ns; -- 240497

        -- 240498: R=bits[2:0]="010"(R2), Rb=bits[6:4]="111"(R7), d=bits[3:0]="0010"(2)
        -- XOR  R2, R7 -> 0111 010 111 0000
        instruction <= "01110101110000"; wait for 20 ns; -- 240498
        -- JMP  2      -> 1100 000 000 0010
        instruction <= "11000000000010"; wait for 20 ns; -- 240498

        wait;
    end process;
end sim;
