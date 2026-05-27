
library ieee;
use ieee.std_logic_1164.all;

entity instruction_decoder_v2 is
    port (
        instruction  : in  std_logic_vector(13 downto 0);
        mux_a_sel    : out std_logic_vector(2 downto 0);
        mux_b_sel    : out std_logic_vector(2 downto 0);
        alu_op       : out std_logic_vector(2 downto 0);
        data_src_sel : out std_logic;
        imm_value    : out std_logic_vector(3 downto 0);
        dest_reg     : out std_logic_vector(2 downto 0);
        reg_write_en : out std_logic;
        jump_addr    : out std_logic_vector(3 downto 0);
        is_jzr       : out std_logic;
        is_jmp       : out std_logic
    );
end instruction_decoder_v2;

architecture behavioral of instruction_decoder_v2 is
    signal opcode : std_logic_vector(3 downto 0);

    -- ALU op constants (must match alu_4bit)
    constant ALU_ADD : std_logic_vector(2 downto 0) := "000";
    constant ALU_SUB : std_logic_vector(2 downto 0) := "001";
    constant ALU_AND : std_logic_vector(2 downto 0) := "010";
    constant ALU_OR  : std_logic_vector(2 downto 0) := "011";
    constant ALU_XOR : std_logic_vector(2 downto 0) := "100";
    constant ALU_NOT : std_logic_vector(2 downto 0) := "101";
    constant ALU_MUL : std_logic_vector(2 downto 0) := "110";
    constant ALU_DIV : std_logic_vector(2 downto 0) := "111";
begin
    opcode <= instruction(13 downto 10);

    process (instruction, opcode)
    begin
        -- safe defaults
        mux_a_sel    <= "000";
        mux_b_sel    <= "000";
        alu_op       <= ALU_ADD;
        data_src_sel <= '0';
        imm_value    <= "0000";
        dest_reg     <= "000";
        reg_write_en <= '0';
        jump_addr    <= "0000";
        is_jzr       <= '0';
        is_jmp       <= '0';

        case opcode is
            -- ADD Ra, Rb : Ra <= Ra + Rb
            when "0000" =>
                mux_a_sel    <= instruction(9 downto 7);
                mux_b_sel    <= instruction(6 downto 4);
                alu_op       <= ALU_ADD;
                dest_reg     <= instruction(9 downto 7);
                reg_write_en <= '1';

            -- NEG R : R <= 0 - R   (R0 - R)
            when "0001" =>
                mux_a_sel    <= "000";                    -- R0 = 0
                mux_b_sel    <= instruction(9 downto 7);
                alu_op       <= ALU_SUB;
                dest_reg     <= instruction(9 downto 7);
                reg_write_en <= '1';

            -- MOVI R, d : R <= d
            when "0010" =>
                data_src_sel <= '1';
                imm_value    <= instruction(3 downto 0);
                dest_reg     <= instruction(9 downto 7);
                reg_write_en <= '1';

            -- JZR R, d : if R = 0 then PC <= d
            -- (ALU computes R + 0 = R so its zero flag is the jump condition)
            when "0011" =>
                mux_a_sel    <= instruction(9 downto 7);
                mux_b_sel    <= "000";
                alu_op       <= ALU_ADD;
                jump_addr    <= instruction(3 downto 0);
                is_jzr       <= '1';

            -- SUB Ra, Rb : Ra <= Ra - Rb
            when "0100" =>
                mux_a_sel    <= instruction(9 downto 7);
                mux_b_sel    <= instruction(6 downto 4);
                alu_op       <= ALU_SUB;
                dest_reg     <= instruction(9 downto 7);
                reg_write_en <= '1';

            -- AND Ra, Rb
            when "0101" =>
                mux_a_sel    <= instruction(9 downto 7);
                mux_b_sel    <= instruction(6 downto 4);
                alu_op       <= ALU_AND;
                dest_reg     <= instruction(9 downto 7);
                reg_write_en <= '1';

            -- OR  Ra, Rb
            when "0110" =>
                mux_a_sel    <= instruction(9 downto 7);
                mux_b_sel    <= instruction(6 downto 4);
                alu_op       <= ALU_OR;
                dest_reg     <= instruction(9 downto 7);
                reg_write_en <= '1';

            -- XOR Ra, Rb
            when "0111" =>
                mux_a_sel    <= instruction(9 downto 7);
                mux_b_sel    <= instruction(6 downto 4);
                alu_op       <= ALU_XOR;
                dest_reg     <= instruction(9 downto 7);
                reg_write_en <= '1';

            -- MUL Ra, Rb : Ra <= (Ra*Rb)(3..0)
            when "1000" =>
                mux_a_sel    <= instruction(9 downto 7);
                mux_b_sel    <= instruction(6 downto 4);
                alu_op       <= ALU_MUL;
                dest_reg     <= instruction(9 downto 7);
                reg_write_en <= '1';

            -- CMP Ra, Rb : Z flag <= (Ra - Rb = 0); no register write
            when "1001" =>
                mux_a_sel    <= instruction(9 downto 7);
                mux_b_sel    <= instruction(6 downto 4);
                alu_op       <= ALU_SUB;
                reg_write_en <= '0';

            -- NOT R : R <= NOT R
            when "1010" =>
                mux_a_sel    <= instruction(9 downto 7);
                mux_b_sel    <= "000";
                alu_op       <= ALU_NOT;
                dest_reg     <= instruction(9 downto 7);
                reg_write_en <= '1';

            -- DIV Ra, Rb : Ra <= Ra / Rb (b=0 -> 1111, overflow flag)
            when "1011" =>
                mux_a_sel    <= instruction(9 downto 7);
                mux_b_sel    <= instruction(6 downto 4);
                alu_op       <= ALU_DIV;
                dest_reg     <= instruction(9 downto 7);
                reg_write_en <= '1';

            -- JMP d : unconditional jump
            when "1100" =>
                jump_addr    <= instruction(3 downto 0);
                is_jmp       <= '1';

            when others =>
                null;
        end case;
    end process;
end behavioral;
