# NanoSilicon 8-bit CPU 

## How it works 

NanoSilicon is a custom 8-bit CPU implemented in Verilog HDL. Its processor, with designation JH08, is designed as an educational hardware project to explore computer architecture and the implementation of a complete processor at the RTL level. 

The CPU is composed of several interconnected hardware units: 

- Program Counter (PC): Tracks the address of the instruction that is being executed. 
- Instruction Decoder: Decodes the instructions given and generates teh corresponding control signals. 
- Register File: Stores the values used during instruction execution. 
- Arithmetic Logic Unit (ALU): Performs arithmetic and logical operations. 
- Random Access Memory (RAM): Provides 256 bytes of on-chip data storage. 
- Control Logic: Coordinates instruction execution and manages processor state. 

The processor follows an instruction execution cycle invoving instruction retrieval, decoding and execution. Its components communicate through internal data and control signals. 

The design is written mainly in Verilog and uses a moduler RTL structure, allowing individual components to be simulated and tested independently as well as integrated into the complete CPU. 

## How to test
The design is tested through RTL simulation using Icarus Verilog. 

The project includes an integration testbench at sim/tb_jh8_cpu.v, which tests the interaction between the CPU's internal components. 

From the project root directory, compile the Verilog source files: 

```text
$files = Get-ChildItem src - Filter '*.v'| 
    Where-Object { $_.Name -notlike '*_backup.v'} |
    ForEach-Object { $_.FullName}

iverilog -g2012 -o sim/nanosilicon_test.vvp $files sim/tb_jh8_cpu.v
``` 
Run the simulation afterwards 
```text
vvp sim\nanosilicon_test.vvp
```
If the integration test is successful it produces teh following final results:
```text
R0 = 35
R1 = 10
RAM[128] = 35
Final PC = 8
HALTED = 1 

PASS: CPU integration test successful 
```
The testbench would also generate a VCD waveform 
```text
file at sim/nanosilicon_cpu.vcd 
```
This waveform can be opened in GTKWave to inspect the processor signals and observe the execution sequence. 

## External hardware 
There's no external memory or perihperal hardware required to run the RTL simulation 

Hardware-level testing requires the complete compatible FPGA board or chip evaluation setup with the access to the processor's clock, control signals and external input/output connections. The required connections mainly depend on the final top-level module and pin configuration. 

## ASIC implementation and verification 
NanoSilicon has been taken through an ASIC implementation flow using LibreLane and OpenROAD 

The physical verification results from the recorded GDS logs run are: 
- DRC violations: 0
- LVS violations: 0
- Antenna violations: 0
- Hold timing violations: 0 

The recorded worst setup slack is around -2.331ns against a 20ns clock period. Setup timing is therefore not yet closed at the 50MHz target. 