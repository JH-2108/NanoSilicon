# NanoSilicon
**An 8 bit custom CPU designed for ASIC implementation**

NanoSilicon is a custom 8 bit CPU designed and implemented in Verilog HDL. Its processor, JH-8, uses a modular architecture with a dedicate instruction decoder, arithmetic logic unit (ALU), register file, program counter, instruction ROM, data RAM and processor status flags. 

The project explores processor architecture, RTL design, simulation, verification and the ASIC implementation flow using the **Tiny Tapeout GF180MCU platform**. 

Project Status: ASIC implementation and automated verification workflows are operational. FPGA hardware validation and timing optimization remain ongoing... 

## Table of contents 
* Overview
* Specifications
* Architecture
* Instruction Set
* RTL Modules
* Simulation and Verification
* ASIC Implementation
* Documentation
* Future Development and Improvement

## Overview 
JH-8 is an 8 bit processor built from individual Verilog modules. 

Its architecture follows a fetch -> decode -> execute cycle:
1. The program counter supplies an address to the instruction ROM.
2. The ROM provides the current instruction and any immediate data.
3. The instruction decoder identifies the operation and generates control signals.
4. The register file supplies the required operands.
5. The ALU performs arithmetic or logical operations when required to do so.
6. The writeback logic chooses the result to store.
7. The processor then updates its flags and program counter.
8. Memory operations access the separate data RAM

The processor also supports conditional branching and a halt instruction. 

## Specification
|Specification|Value|
|---|---|
|Processor|JH-8|
|Architecture|8 bit|
|Architecture type|Harvard|
|Instruction width|8 bits|
|Data width|8 bits|
|Opcode width|4 bits|
|General purpose registers| 4|
|Register width|8 bits|
|Program counter|8 bits|
|Instruction memory|256 x 8 bit ROM|
|Data memory|256 x 8 bit RAM|
|Status flags| zero, carry negative|
|Instruction encoding| variable length|
|ASIC platform| GF180MCU|
|Tiny Tapeout tile configuration| 1 x 1 tile|
|Configured clock frequency| 50MHz|

## Architecture 
The processor consists of the following major components:

* **Control and decoder**: Interprets the instructions and generates processor control signals.
* **Arithmetic Logic Unit (ALU)**: Contains four independently addressable 8 bit registers.
* **Register file**: Tracks the current instruction address and handles jumps.
* **Instruction ROM**: Stores program instructions and immediate values
* **Data RAM**: Provides 256 bytes of data storage.
* **Status flags**: Stores zero, carry and negative results.

## Architecture Diagram

<img width="783" height="597" alt="image" src="https://github.com/user-attachments/assets/0fb1294f-984c-4093-a9e3-7f8c2143c728" />


## Instruction Encoding 
Each instruction begins with an 8 bit instruction byte:
|Bits|Field|Width|
|---|---|---|
|[7:4]|Opcode| 4 bits|
|[3:2]|Destination Register(D)| 2 bits|
|[1:0]|Source register(S)| 2 bits|

Instructions requiring an immediate value or memory address use an additional byte. 

## Instruction Set 
JH-8 supports 16 opcodes. 
|Opcode|Instruction|length|Description|
|---|---|---|---|
|0X0|NOP|1 byte| no operation|
|0x1|MOV|1 byte| register transfer|
|0x2|LDI|2 byte| load immediate value|
|0x3|ADD| 1 byte| addition|
|0x4|SUB|1 byte| subtraction|
|0x5|AND| 1 byte| bitwise AND|
|0x6|OR| 1 byte| Bitwise OR|
|0x7|XOR| 1 byte| Bitwise XOR|
|0x8|NOT| 1 byte| bitwise inversion|
|0x9|JMP|2 bytes| unconditional jump|
|0xA|JZ|2 bytes| jump if zero|
|0XB|JNZ|2 bytes| jump if not zero|
|0xC|LD|2 bytes| load from RAM|
|0xD|ST|2 bytes| store to RAM|
|0xE|CMP|1 byte| compare registers|
|0XF|HLT|1 byte| halt execution|

For detailed instruction behavior and flag semantics, see the [instruction set documentation](instruction.md)

## RTL Modules 
|Module|File|Function|
|---|---|---|
|CPU integration|jh8_cpu.v|Connects processor components and coordinates execution|
|ALU|jh8_alu.v|arithmetic and logical operations|
|Decoder|jh8_decoder.v|instruction decoding and control generation|
|Register file|jh8_registers.v|four general purpose registers|
|Program counter|jh8_pc.v|instruction address tracking|
|ROM|jh8_rom.v|instructino storage|
|RAM|jh8_ram.v|data storage|
|flags|jh8_flags.v|
|top level wrapper |project.v| tiny tapeout interface|

## Simulation and verification
Nano Silicon is tested using the RTL simulation and automated verification workflows. 

### RTL simulation
The integration testbench is located at: sim/tb_jh8_cpu.v 

The simulation uses Icarus Verilog and generates a VCD waveform that can be inspected using GTKWave.

To run the integration simulation from the project root using PowerShell:
```text
$files = Get-ChildItem src -Filter '*.v' |
  Where-Object {$_.Name -notlike '*_backup.v'} |
  ForEach-Object { $_.FullName}

iverilog -g2012 -o sim/nanosilicon_text.vvp
```
Open the waveform:
```text
gtkwave sim/nanosilicon_cpu.vcd
```
The saved GTKWave layout is available at 
sim/nanosilicon.gtkw
### Integration test results 
The recorded CPU integration test demonstrates:
|Signal|Expected result|
|---|---|
|R0|35|
|R1|10|
|RAM[128]|35|
|Final PC|8|
|HALTED|1|

The integration test reports:
PASS: CPU integration test successful 

### Automated GitHub actions
The repository includes the automated workflows for:
|Workflow|Purpose|
|---|---|
|test.yaml|Cocotb-based testing|
|gds.yaml| GF180MCU ASIC implementation, precheck, gate-level test and viewer|
|docs.yaml| documentaion build|
|fpga.yaml| FPGA bitstream generation|

The GDS, documentation and test workflows have passed on the project repository's checked runs. 

## ASIC implementation 
NanoSilicon uses the Tiny Tapeout GlobalFoundries GF180MCU design flow. 

The GDS workflow uses:
* Tiny Tapeout GF180MCU template and implementation actions
* GF180MCU D process configuration
* Synthesis and physical implementation
* Design precheck
* gate-level simulation
* layout viewer generation

### Physical verification
The recorded physical verification results are: 
|Check|Recorded result|
|---|---|
|Design rule check (DRC) violations| 0 |
|Layout versus schematic (LVS) violations| 0|
|Antenna violations| 0|
|Hold timing violations| 0|

**Timing limitations**: The recorded implementation report documents a worst setup slack of approximately -2.331ns at a 20ns clock period. Setup timing is therefore not yet closed. Further critical path optimization is required. 

## GDS Layout visualization 
An interactive visualization of the generated GDS layout will be added here. 

A photo will be added here

## Documentation 
Further technical documentation is available in the docs/ directory: 
* CPU architecture
* Instruction set architecture
* project information

## Future development and improvements 
Planned areas of development and small improvements would be in:
* Optimizing critical timing paths and improving setup slack.
* FPGA based hardware validation
* Improving processor functionality
* Expanding automated verification
* Further ASIC implementation and physical verificaation


## Small side notes and extras
JH-8 was named after JH (my name: Jie Hao) and 8: 8 bit. 

**Why I decided to make this**: Well, after Jensen Huang stepped down as CEO, which was a rly big news, I decided to learn more into his life and understand how he created NVIDIA, so I went through his history and learned that he made a chip for a GPU card. I decided that I wanted to create my own CPU, a small one to just try something new!!! 

