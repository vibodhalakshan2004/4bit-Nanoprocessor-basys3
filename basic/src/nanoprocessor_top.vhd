
library ieee;
use ieee.std_logic_1164.all;

entity nanoprocessor_top is
    generic (
        SIM_MODE : boolean := false;
        DIVISOR  : integer := 100_000_000
    );
    port (
        clk   : in  std_logic;
        reset : in  std_logic;
        led   : out std_logic_vector(15 downto 0);
        seg   : out std_logic_vector(6 downto 0);
        an    : out std_logic_vector(3 downto 0)
    );
end nanoprocessor_top;

architecture structural of nanoprocessor_top is
    -- Component declarations
    component clock_divider
        generic (DIVISOR : integer);
        port (clk_in, reset : in std_logic; clk_out : out std_logic);
    end component;
    component program_counter
        port (clk, reset : in std_logic;
              d : in std_logic_vector(2 downto 0);
              q : out std_logic_vector(2 downto 0));
    end component;
    component adder_3bit
        port (a, b : in std_logic_vector(2 downto 0); cin : in std_logic;
              sum : out std_logic_vector(2 downto 0); cout : out std_logic);
    end component;
    component mux_2way_3bit
        port (sel : in std_logic;
              i0, i1 : in std_logic_vector(2 downto 0);
              y : out std_logic_vector(2 downto 0));
    end component;
    component program_rom
        port (addr : in std_logic_vector(2 downto 0);
              data : out std_logic_vector(11 downto 0));
    end component;
    component instruction_decoder
        port (instruction  : in std_logic_vector(11 downto 0);
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
    component register_bank
        port (clk, reset, write_en : in std_logic;
              dest_sel : in std_logic_vector(2 downto 0);
              data_in  : in std_logic_vector(3 downto 0);
              r0, r1, r2, r3 : out std_logic_vector(3 downto 0);
              r4, r5, r6, r7 : out std_logic_vector(3 downto 0));
    end component;
    component mux_8way_4bit
        port (sel : in std_logic_vector(2 downto 0);
              i0, i1, i2, i3 : in std_logic_vector(3 downto 0);
              i4, i5, i6, i7 : in std_logic_vector(3 downto 0);
              y : out std_logic_vector(3 downto 0));
    end component;
    component add_sub_4bit
        port (a, b : in std_logic_vector(3 downto 0);
              sub  : in std_logic;
              result   : out std_logic_vector(3 downto 0);
              overflow, zero : out std_logic);
    end component;
    component mux_2way_4bit
        port (sel : in std_logic;
              i0, i1 : in std_logic_vector(3 downto 0);
              y : out std_logic_vector(3 downto 0));
    end component;
    component seven_seg_display
        port (value : in std_logic_vector(3 downto 0);
              seg : out std_logic_vector(6 downto 0);
              an  : out std_logic_vector(3 downto 0));
    end component;

    -- Internal signals
    signal slow_clk        : std_logic;
    signal pc, pc_plus_1   : std_logic_vector(2 downto 0);
    signal pc_next, jump_addr_sig : std_logic_vector(2 downto 0);
    signal pc_carry        : std_logic;
    signal instruction     : std_logic_vector(11 downto 0);

    signal mux_a_sel_sig, mux_b_sel_sig, dest_reg_sig : std_logic_vector(2 downto 0);
    signal addsub_sel_sig, data_src_sel_sig          : std_logic;
    signal reg_write_en_sig, is_jzr_sig, jump_flag   : std_logic;
    signal imm_value_sig                              : std_logic_vector(3 downto 0);

    signal r0, r1, r2, r3, r4, r5, r6, r7            : std_logic_vector(3 downto 0);
    signal mux_a_out, mux_b_out                       : std_logic_vector(3 downto 0);
    signal alu_out, data_bus                          : std_logic_vector(3 downto 0);
    signal alu_overflow, alu_zero                     : std_logic;
begin
    -----------------------------------------------------------------
    -- Slow clock generation
    -----------------------------------------------------------------
    gen_div : if not SIM_MODE generate
        cdiv : clock_divider
            generic map (DIVISOR => DIVISOR)
            port map (clk_in => clk, reset => reset, clk_out => slow_clk);
    end generate;
    gen_sim : if SIM_MODE generate
        slow_clk <= clk;     -- bypass divider in simulation
    end generate;

    -----------------------------------------------------------------
    -- Program Counter and PC update
    -----------------------------------------------------------------
    pc_inst : program_counter
        port map (clk => slow_clk, reset => reset, d => pc_next, q => pc);

    pc_adder : adder_3bit
        port map (a => pc, b => "000", cin => '1',
                  sum => pc_plus_1, cout => pc_carry);

    pc_mux : mux_2way_3bit
        port map (sel => jump_flag, i0 => pc_plus_1, i1 => jump_addr_sig,
                  y => pc_next);

    -----------------------------------------------------------------
    -- Program ROM and Instruction Decoder
    -----------------------------------------------------------------
    rom : program_rom
        port map (addr => pc, data => instruction);

    dec : instruction_decoder
        port map (instruction  => instruction,
                  mux_a_sel    => mux_a_sel_sig,
                  mux_b_sel    => mux_b_sel_sig,
                  addsub_sel   => addsub_sel_sig,
                  data_src_sel => data_src_sel_sig,
                  imm_value    => imm_value_sig,
                  dest_reg     => dest_reg_sig,
                  reg_write_en => reg_write_en_sig,
                  jump_addr    => jump_addr_sig,
                  is_jzr       => is_jzr_sig);

    -- Final jump signal: only jump on JZR when ALU zero flag is set
    jump_flag <= is_jzr_sig and alu_zero;

    -----------------------------------------------------------------
    -- Register bank
    -----------------------------------------------------------------
    rb : register_bank
        port map (clk => slow_clk, reset => reset,
                  write_en => reg_write_en_sig,
                  dest_sel => dest_reg_sig,
                  data_in  => data_bus,
                  r0 => r0, r1 => r1, r2 => r2, r3 => r3,
                  r4 => r4, r5 => r5, r6 => r6, r7 => r7);

    -----------------------------------------------------------------
    -- Two 8-way 4-bit muxes feed the ALU operands
    -----------------------------------------------------------------
    mux_a : mux_8way_4bit
        port map (sel => mux_a_sel_sig,
                  i0 => r0, i1 => r1, i2 => r2, i3 => r3,
                  i4 => r4, i5 => r5, i6 => r6, i7 => r7,
                  y => mux_a_out);

    mux_b : mux_8way_4bit
        port map (sel => mux_b_sel_sig,
                  i0 => r0, i1 => r1, i2 => r2, i3 => r3,
                  i4 => r4, i5 => r5, i6 => r6, i7 => r7,
                  y => mux_b_out);

    -----------------------------------------------------------------
    -- ALU
    -----------------------------------------------------------------
    alu : add_sub_4bit
        port map (a => mux_a_out, b => mux_b_out, sub => addsub_sel_sig,
                  result => alu_out,
                  overflow => alu_overflow, zero => alu_zero);

    -----------------------------------------------------------------
    -- Data-bus mux: choose ALU output or immediate value
    -----------------------------------------------------------------
    data_mux : mux_2way_4bit
        port map (sel => data_src_sel_sig, i0 => alu_out, i1 => imm_value_sig,
                  y => data_bus);

    -----------------------------------------------------------------
    -- Output drivers
    -----------------------------------------------------------------
    seg_disp : seven_seg_display
        port map (value => r7, seg => seg, an => an);

    led(3 downto 0)   <= r7;            -- LD0..LD3 show R7
    led(13 downto 4)  <= (others => '0');
    led(14)           <= alu_zero;      -- LD14 = zero flag
    led(15)           <= alu_overflow;  -- LD15 = overflow / carry flag
end structural;
