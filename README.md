# Nanoprocessor 

A fully structural VHDL implementation of a 4-bit nanoprocessor, designed and synthesised for the **Digilent Basys 3 (Artix-7)** FPGA board. The project is delivered in two versions: a **Basic** implementation and an **Extended** implementation with an expanded instruction set and ALU.

---

## Table of Contents

- [Project Overview](#project-overview)
- [Repository Structure](#repository-structure)
- [Basic Nanoprocessor](#basic-nanoprocessor)
  - [Architecture](#architecture)
  - [Instruction Set](#instruction-set)
  - [Instruction Encoding (12-bit)](#instruction-encoding-12-bit)
  - [Sample Program](#sample-program)
- [Extended Nanoprocessor](#extended-nanoprocessor)
  - [Architecture](#architecture-1)
  - [Instruction Set](#instruction-set-1)
  - [Instruction Encoding (14-bit)](#instruction-encoding-14-bit)
  - [ALU Operations](#alu-operations)
- [Board I/O Mapping](#board-io-mapping)
- [Opening in Vivado](#opening-in-vivado)
- [Programming the FPGA](#programming-the-fpga)
- [Running Simulations](#running-simulations)
- [Component Hierarchy](#component-hierarchy)

---

## Project Overview

This project implements a nanoprocessor entirely in structural/behavioral VHDL from the ground up — no IP cores. It was developed as part of a digital design module assignment.

| Feature | Basic | Extended |
|---|---|---|
| Data width | 4-bit | 4-bit |
| PC width | 3-bit (8 addresses) | 4-bit (16 addresses) |
| Instruction width | 12-bit | 14-bit |
| Register file | 8 × 4-bit (R0–R7) | 8 × 4-bit (R0–R7) |
| ALU operations | ADD, NEG (SUB) | ADD, SUB, AND, OR, XOR, NOT, MUL, DIV |
| Jump instructions | JZR (conditional) | JZR (conditional), JMP (unconditional) |
| Board clock divider | 100 MHz → 1 Hz | 100 MHz → 1 Hz |
| Target board | Basys 3 (Artix-7) | Basys 3 (Artix-7) |

---

## Repository Structure

```
Nanoprocessor_Team5/
│
├── README.md
├── .gitignore
│
├── basic/                        # Basic Nanoprocessor
│   ├── src/                      # RTL source files
│   │   ├── nanoprocessor_top.vhd       ← Top-level entity
│   │   ├── instruction_decoder.vhd
│   │   ├── program_rom.vhd
│   │   ├── program_counter.vhd
│   │   ├── register_bank.vhd
│   │   ├── add_sub_4bit.vhd
│   │   ├── adder_3bit.vhd
│   │   ├── full_adder.vhd
│   │   ├── mux_2way_3bit.vhd
│   │   ├── mux_2way_4bit.vhd
│   │   ├── mux_8way_4bit.vhd
│   │   ├── decoder_3to8.vhd
│   │   ├── d_ff.vhd
│   │   ├── reg_4bit.vhd
│   │   ├── clock_divider.vhd
│   │   └── seven_seg_display.vhd
│   ├── constraints/
│   │   └── nanoprocessor.xdc           ← Basys 3 pin constraints
│   └── sim/                      # Testbench files
│       ├── NanoProcessor_TB.vhd
│       ├── Instruction_Decoder_TB.vhd
│       ├── Program_Counter_TB.vhd
│       ├── Program_ROM_TB.vhd
│       ├── Register_Bank_TB.vhd
│       ├── Add_Sub_4_TB.vhd
│       ├── PC_Adder_TB.vhd
│       ├── Address_Selector_TB.vhd
│       ├── Load_Selector_TB.vhd
│       ├── LUT_16_7_TB.vhd
│       ├── RegisterData_Multiplexer_TB.vhd
│       └── Slow_Clk_TB.vhd
│
├── extended/                     # Extended Nanoprocessor
│   ├── src/                      # RTL source files
│   │   ├── nanoprocessor_top_v2.vhd    ← Top-level entity
│   │   ├── instruction_decoder_v2.vhd
│   │   ├── alu_4bit.vhd                ← Full 8-operation ALU
│   │   ├── program_rom_v2.vhd
│   │   ├── program_counter_v2.vhd
│   │   ├── register_bank.vhd
│   │   ├── add_sub_4bit.vhd
│   │   ├── adder_4bit.vhd
│   │   ├── full_adder.vhd
│   │   ├── mux_2way_4bit.vhd
│   │   ├── mux_8way_4bit.vhd
│   │   ├── decoder_3to8.vhd
│   │   ├── d_ff.vhd
│   │   ├── reg_4bit.vhd
│   │   ├── clock_divider.vhd
│   │   └── seven_seg_display.vhd
│   ├── constraints/
│   │   └── nanoprocessor_v2.xdc        ← Basys 3 pin constraints
│   └── sim/                      # Testbench files
│       ├── NanoProcessor_TB.vhd
│       ├── ALU_4bit_TB.vhd
│       ├── Instruction_Decoder_TB.vhd
│       ├── Program_ROM_TB.vhd
│       ├── Register_Bank_TB.vhd
│       ├── Add_Sub_4_TB.vhd
│       ├── PC_Adder_TB.vhd
│       ├── Address_Selector_TB.vhd
│       ├── Load_Selector_TB.vhd
│       ├── LUT_16_7_TB.vhd
│       ├── RegisterData_Multiplexer_TB.vhd
│       └── Slow_Clk_TB.vhd
│
├── bitstreams/                   # Pre-built FPGA bitstreams (ready to flash)
│   ├── NanoProcessor_Basic_Team5.bit
│   └── Nanoprocessor_Extended_Team5.bit
│
└── docs/
    └── Nanoprocessor_Report_Team5.pdf  ← Full design report
```

---

## Basic Nanoprocessor

### Architecture

The basic processor is a single-cycle, fully structural design. All components are connected via explicit signal wiring in `nanoprocessor_top.vhd`.

```
              ┌──────────────┐
  clk ───────►│ Clock Divider│──► slow_clk
  reset ──────┤              │
              └──────────────┘
                    │ slow_clk
         ┌──────────▼─────────┐
         │   Program Counter  │◄──── PC_next (from PC MUX)
         └──────────┬─────────┘
                    │ PC [2:0]
              ┌─────▼──────┐
              │ Program ROM│
              └─────┬──────┘
                    │ Instruction [11:0]
          ┌─────────▼──────────┐
          │ Instruction Decoder│
          └┬──┬──┬──┬──┬──┬───┘
           │  │  │  │  │  │
     ┌─────▼──▼──▼──▼──▼──▼───┐
     │      Register Bank      │◄── data_bus
     │   R0 R1 R2 R3 R4 R5 R6 R7   │
     └──┬──────────────────────┘
        │ Register outputs
  ┌─────▼────┐   ┌────────────┐
  │  MUX A   │   │   MUX B    │   (8-way 4-bit muxes)
  └─────┬────┘   └─────┬──────┘
        │               │
        └───────┬────────┘
            ┌───▼───────┐
            │ Add/Sub   │──► zero, overflow flags
            │  4-bit    │
            └─────┬─────┘
                  │ alu_out
            ┌─────▼─────┐
            │  Data MUX │◄── imm_value  (MOVI selects immediate)
            └─────┬─────┘
                  │ data_bus → Register Bank write
                  └──────────► LED/7-seg display (R7)
```

### Instruction Set

The basic processor supports **4 instructions** encoded in 12 bits:

| Opcode [11:10] | Mnemonic | Operation |
|---|---|---|
| `00` | `ADD Ra, Rb` | Ra ← Ra + Rb |
| `01` | `NEG R` | R ← 0 − R (2's complement negate) |
| `10` | `MOVI R, d` | R ← d (load 4-bit immediate) |
| `11` | `JZR R, addr` | if R = 0 then PC ← addr else PC ← PC+1 |

### Instruction Encoding (12-bit)

```
ADD Ra, Rb   : [ 00 | Ra[2:0] | Rb[2:0] | 000 | 0 ]
NEG R        : [ 01 | R[2:0]  | 000000       ]
MOVI R, d   : [ 10 | R[2:0]  | 00000 | d[3:0] ]
JZR R, addr : [ 11 | R[2:0]  | 0000  | addr[2:0] ]
```

> **Note:** R0 is hardwired to zero inside the register bank. `JZR R0, addr` therefore always jumps, acting as an unconditional halt loop.

### Sample Program (ROM contents)

```
Address  Hex    Assembly             Comment
  0      881    MOVI R1, 1           Load 1 into R1
  1      390    ADD  R7, R1          R7 = 0 + 1 = 1
  2      882    MOVI R1, 2           Load 2 into R1
  3      390    ADD  R7, R1          R7 = 1 + 2 = 3
  4      883    MOVI R1, 3           Load 3 into R1
  5      390    ADD  R7, R1          R7 = 3 + 3 = 6
  6      C06    JZR  R0, 6           Halt (R0=0, always jumps back to 6)
  7      C07    JZR  R0, 7           Safety halt
```

---

## Extended Nanoprocessor

### Architecture

The extended processor expands the basic design with:
- A wider **4-bit program counter** (16 instruction addresses)
- A **14-bit instruction word** with a 4-bit opcode field
- A full **8-operation ALU** (`alu_4bit.vhd`) supporting arithmetic and logic
- An additional **unconditional jump** instruction (`JMP`)
- Extended **LED output**: PC value displayed on LD4–LD7

### Instruction Set

| Opcode [13:10] | Mnemonic | Operation |
|---|---|---|
| `0000` | `ADD Ra, Rb` | Ra ← Ra + Rb |
| `0001` | `NEG R` | R ← 0 − R |
| `0010` | `MOVI R, d` | R ← d (4-bit immediate) |
| `0011` | `JZR R, addr` | if R = 0 then PC ← addr |
| `0100` | `SUB Ra, Rb` | Ra ← Ra − Rb |
| `0101` | `AND Ra, Rb` | Ra ← Ra AND Rb |
| `0110` | `OR Ra, Rb` | Ra ← Ra OR Rb |
| `0111` | `XOR Ra, Rb` | Ra ← Ra XOR Rb |
| `1000` | `NOT R` | R ← NOT R |
| `1001` | `MUL Ra, Rb` | Ra ← (Ra × Rb)[3:0] |
| `1010` | `DIV Ra, Rb` | Ra ← Ra / Rb (div-by-zero → 0xF, overflow=1) |
| `1011` | `JMP addr` | PC ← addr (unconditional) |

### Instruction Encoding (14-bit)

```
ADD Ra, Rb  : [ 0000 | Ra[2:0] | Rb[2:0] | 000 ]
NEG R       : [ 0001 | R[2:0]  | 0000000  ]
MOVI R, d  : [ 0010 | R[2:0]  | 000 | d[3:0] ]
JZR R, addr: [ 0011 | R[2:0]  | 000 | addr[3:0] ]
SUB Ra, Rb  : [ 0100 | Ra[2:0] | Rb[2:0] | 000 ]
AND Ra, Rb  : [ 0101 | Ra[2:0] | Rb[2:0] | 000 ]
OR Ra, Rb   : [ 0110 | Ra[2:0] | Rb[2:0] | 000 ]
XOR Ra, Rb  : [ 0111 | Ra[2:0] | Rb[2:0] | 000 ]
NOT R       : [ 1000 | R[2:0]  | 0000000  ]
MUL Ra, Rb  : [ 1001 | Ra[2:0] | Rb[2:0] | 000 ]
DIV Ra, Rb  : [ 1010 | Ra[2:0] | Rb[2:0] | 000 ]
JMP addr    : [ 1011 | 000     | 000 | addr[3:0] ]
```

### ALU Operations

The `alu_4bit` component implements all operations in a single entity:

| `op` [2:0] | Operation | Overflow flag |
|---|---|---|
| `000` | ADD | Carry/overflow from ripple-carry adder |
| `001` | SUB | Borrow/overflow |
| `010` | AND | Always 0 |
| `011` | OR | Always 0 |
| `100` | XOR | Always 0 |
| `101` | NOT A | Always 0 |
| `110` | MUL (low 4 bits) | 1 if upper nibble of product ≠ 0 |
| `111` | DIV | 1 if divisor = 0 |

---

## Board I/O Mapping

### Basic Nanoprocessor

| Board Signal | Direction | Function |
|---|---|---|
| `CLK` (W5) | Input | 100 MHz system clock |
| `BTNC` or SW0 | Input | Synchronous reset |
| `LD[3:0]` | Output | R7 value (result register) |
| `LD14` | Output | ALU zero flag |
| `LD15` | Output | ALU overflow / carry flag |
| `SEG[6:0]` | Output | 7-segment display (shows R7) |
| `AN[3:0]` | Output | 7-segment digit select |

### Extended Nanoprocessor

| Board Signal | Direction | Function |
|---|---|---|
| `CLK` (W5) | Input | 100 MHz system clock |
| `BTNC` or SW0 | Input | Synchronous reset |
| `LD[3:0]` | Output | R7 value (result register) |
| `LD[7:4]` | Output | Current PC value |
| `LD13` | Output | Negative flag (MSB of ALU result) |
| `LD14` | Output | ALU zero flag |
| `LD15` | Output | Jump-active flag (JZR or JMP triggered) |
| `SEG[6:0]` | Output | 7-segment display (shows R7) |
| `AN[3:0]` | Output | 7-segment digit select |

---

## Opening in Vivado

> Requires **Xilinx Vivado 2018.1** or later.

1. Open Vivado and select **Create Project**.
2. Choose **RTL Project** → **Do not specify sources at this time**.
3. Select **Basys3** as the target board (Part: `xc7a35tcpg236-1`).
4. After the project is created, go to **Add Sources**:
   - Add all `.vhd` files from `basic/src/` (or `extended/src/`) as **Design Sources**.
   - Add all `.vhd` files from `basic/sim/` (or `extended/sim/`) as **Simulation Sources**.
   - Add the `.xdc` file from `basic/constraints/` (or `extended/constraints/`) as a **Constraints** file.
5. Set the top-level module to `nanoprocessor_top` (basic) or `nanoprocessor_top_v2` (extended).
6. Run **Synthesis → Implementation → Generate Bitstream**.

---

## Programming the FPGA

Pre-built bitstreams are provided in the `bitstreams/` folder, so you can program the board without re-synthesising.

1. Connect your Basys 3 board via USB and power it on.
2. In Vivado, open the **Hardware Manager** (`Flow → Open Hardware Manager`).
3. Click **Open Target → Auto Connect**.
4. Click **Program Device** and select the appropriate `.bit` file from the `bitstreams/` folder.
5. The board will program in seconds. Press the reset button (BTNC) to start execution.

---

## Running Simulations

1. In Vivado, open the project and navigate to **Simulation Sources**.
2. Set the desired testbench (e.g. `NanoProcessor_TB`) as the top module.
3. Click **Run Simulation → Run Behavioral Simulation**.
4. Use the waveform viewer to inspect signal values over time.

> All testbenches are self-contained and do not require any additional stimulus files.

---

## Component Hierarchy

### Basic (`nanoprocessor_top`)

```
nanoprocessor_top
├── clock_divider
├── program_counter
│   └── d_ff (×3)
├── adder_3bit
│   └── full_adder (×3)
├── mux_2way_3bit
├── program_rom
├── instruction_decoder
├── register_bank
│   ├── decoder_3to8
│   └── reg_4bit (×8)
│       └── d_ff (×4)
├── mux_8way_4bit (×2)
├── add_sub_4bit (ALU)
│   └── full_adder (×4)
├── mux_2way_4bit
└── seven_seg_display
```

### Extended (`nanoprocessor_top_v2`)

```
nanoprocessor_top_v2
├── clock_divider
├── program_counter_v2
│   └── d_ff (×4)
├── adder_4bit
│   └── full_adder (×4)
├── mux_2way_4bit (PC mux)
├── program_rom_v2
├── instruction_decoder_v2
├── register_bank
│   ├── decoder_3to8
│   └── reg_4bit (×8)
├── mux_8way_4bit (×2)
├── alu_4bit
│   └── add_sub_4bit
│       └── full_adder (×4)
├── mux_2way_4bit (data mux)
└── seven_seg_display
```

---
> See [`docs/Nanoprocessor_Report_Team5.pdf`](docs/Nanoprocessor_Report.pdf) for the full design report including waveform screenshots, resource utilisation, and design decisions.

---

## License

This project was developed for academic purposes.
