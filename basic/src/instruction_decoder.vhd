
library ieee;
use ieee.std_logic_1164.all;

entity instruction_decoder is
    port (
        instruction  : in  std_logic_vector(11 downto 0);
        mux_a_sel    : out std_logic_vector(2 downto 0);
        mux_b_sel    : out std_logic_vector(2 downto 0);
        addsub_sel   : out std_logic;
        data_src_sel : out std_logic;
        imm_value    : out std_logic_vector(3 downto 0);
        dest_reg     : out std_logic_vector(2 downto 0);
        reg_write_en : out std_logic;
        jump_addr    : out std_logic_vector(2 downto 0);
        is_jzr       : out std_logic
    );
end instruction_decoder;

architecture behavioral of instruction_decoder is
    signal opcode : std_logic_vector(1 downto 0);
begin
    opcode <= instruction(11 downto 10);

    process(instruction, opcode)
    begin
        -- safe defaults
        mux_a_sel    <= "000";
        mux_b_sel    <= "000";
        addsub_sel   <= '0';
        data_src_sel <= '0';
        imm_value    <= "0000";
        dest_reg     <= "000";
        reg_write_en <= '0';
        jump_addr    <= "000";
        is_jzr       <= '0';

        case opcode is
            -- ADD Ra, Rb : Ra <= Ra + Rb
            when "00" =>
                mux_a_sel    <= instruction(9 downto 7);  -- Ra
                mux_b_sel    <= instruction(6 downto 4);  -- Rb
                addsub_sel   <= '0';                      -- add
                data_src_sel <= '0';                      -- write ALU result
                dest_reg     <= instruction(9 downto 7);  -- target Ra
                reg_write_en <= '1';

            -- NEG R : R <= 0 - R   (R0 is hardwired zero)
            when "01" =>
                mux_a_sel    <= "000";                    -- R0 = 0
                mux_b_sel    <= instruction(9 downto 7);  -- R
                addsub_sel   <= '1';                      -- subtract
                data_src_sel <= '0';                      -- ALU result
                dest_reg     <= instruction(9 downto 7);
                reg_write_en <= '1';

            -- MOVI R, d : R <= d
            when "10" =>
                data_src_sel <= '1';                      -- pass immediate
                imm_value    <= instruction(3 downto 0);
                dest_reg     <= instruction(9 downto 7);
                reg_write_en <= '1';

            -- JZR R, d : if R = 0 then PC <= d else PC <= PC + 1
            when "11" =>
                mux_a_sel    <= instruction(9 downto 7);  -- R
                mux_b_sel    <= "000";                    -- + 0
                addsub_sel   <= '0';                      -- ALU sees R + 0 = R
                reg_write_en <= '0';                      -- no register write
                jump_addr    <= instruction(2 downto 0);
                is_jzr       <= '1';

            when others =>
                null;
        end case;
    end process;
end behavioral;
