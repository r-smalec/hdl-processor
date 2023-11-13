// instructions and its codes

`define NOT     6'b000000 // !  NOT x
`define XOR     6'b000001 // ^  XOR Rx y
`define OR      6'b000010 // |  OR Rx y
`define AND     6'b000011 // &  AND Rx y
`define SUB     6'b000100 // -  SUB Rx y
`define ADD     6'b000101 // +  ADD Rx y
`define RR      6'b000110 // >> RR x
`define RL      6'b000111 // << RL x
`define DEC     6'b001000 // -- DEC x
`define INC     6'b001001 // ++ INC x

`define LD      6'b001010 // Load   LD x
`define ST      6'b001011 // Store  ST Rx

`define JMPF    6'b001100 // Jump forward (relative address) JMPF label_name
`define JMPB    6'b001101 // Jump backward (relative address) JMPB label_name

`define NOP     6'b111100 // Nope
`define RST     6'b111111 // Reset