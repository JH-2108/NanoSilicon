# NanoSilicon Instruction Set Architecture 

## 1. CPU specifications 
- Architecture: 8-bit 
- Registers: 4 general purpose registers
- Register width: 8 bits
- Program Counter: 8 bits
- Program memory: 256 x 8-bit ROM 
- Data memory: 256 x 8-bit RAM 
- Flags: Zero(Z), Carry(C), Negative(N)
- Architecture type: Harvard 
- Instruction encoding: variable-length 

## 2. Instruction format

Every instruction begins with one 8-bit instruction byte. 

Bits 7-4: Opcode 
Bits 3-2: Register field D
Bits 1-0: Register field S

For register instructions: 
- D identifies the destination or first register
- S identifies the source or second register 

Instructions requiring an immediate value or memory address use one additional byte immediately after the instruction byte. 

## 3. Instruction set 

|Opcode|Instruction|Length|
|---|---|---|
|0x0|NOP|1 byte|
|0X1|MOV|1 byte|
|0x2| LDI| 2 bytes|
|0x3|ADD|1 byte|
|0x4|SUB|1 byte|
|0x5|AND|1 byte|
|0x6|OR|1 byte|
|0x7|XOR|1 byte| 
|0x8|NOT|1 byte|
|0x9|JMP|2 bytes
|0xA|JZ|2 bytes|
|0xB|JNZ|2 bytes|
|0XC|LD|2 bytes|
|0xD|ST|2 bytes|
|0xE|CMP|1 byte|
|0XF|HLT|1 byte|

## 4. Instruction behaviour 

### NOP
no operation. 

### MOV D,S
R[D] = R[S]

### LDI D,IMM
R[D] = IMM

### ADD D,S
R[D] = R[D] + R[S]

### SUB D,S 
R[D] = R[D] - R[S]

### AND D,S 
R[D] = R[D] & R[S]

### OR D,S
R[D] = R[D] | R[S] 

### XOR D,S
R[D] = R[D] ^ R[S]

### NOT D
R[D] = ~R[D]

### JMP ADDR
PC = ADDR

### JZ ADDR
If Z = 1: 
    PC=ADDR

### JNZ ADDR
If Z = 0:
    PC = ADDR

### LD D,ADDR
R[D] = RAM[ADDR]

### ST D,ADDR
RAM[ADDR] = R[D]

### CMP D,S
Calculate R[D] - R[S]. 
Update Z, C and N flags.
Don't modify either register. 

### HLT 
Halt CPU execution. 

## 5. Flag Behaviour 

Z = 1 when the result is zero. 

C = 1 when addition produces a carry. 
For subtraction, C = 1 when no borrow occurs. 

N = Result bit 7. 

Arithmetic and logical instructions update flags. 
MOV, LDI, LD and ST do not update flags. 
CMP updates flags without writing a register. 

## 6. Instruction length 

One-byte instructions: 
NOP, MOV, ADD, SUB, AND, OR, XOR, NOT, CMP, HLT.

Two-byte instructions: 
LDI, JMP, JZ, JNZ, LD, ST.

The PC advances by the length of the instruction unless a taken jump changes the PC. 