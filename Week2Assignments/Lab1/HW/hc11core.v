/*******************************************************************************

-- File Type: Verilog HDL 
-- Tool Version: VHDL2verilog v5.5.6 Tue Feb 3 2004 Linux 2.4.2-2 
-- Input file was: hc11rtl.vhd
-- Date Created: Wed Feb 4 17:39:26 2004

*******************************************************************************/

`define false 1'b 0
`define FALSE 1'b 0
`define true 1'b 1
`define TRUE 1'b 1

//
// GM HC11 CPU Core
// Copyright (C) Green Mountain Computing Systems, 2000
// All rights reserved.
//
// This file may not be freely distributed. This file has been provided
// under the terms of the GM Core License Agreement in license.txt.
//
// hc11rtl.vhd - This is the synthesizable model of the CPU Core. The testmode generic
// is used for the purpose of testing, and should be set to false for synthesis.
//
// 8/15/00 Created - Scott Thibault
//

module hc11cpu (
 E,
 ph1,
 reset,
 ino,
 iavail,
 iaccept,
 CCR_X,
 CCR_I,
 rw,
 address,
 data,
 write_data,
 debug_cycle,
 debug_A,
 debug_B,
 debug_CCR,
 debug_X,
 debug_Y,
 debug_SP,
 debug_micro);

parameter testmode = `false;

input E;
input ph1;
input reset;
input [3:0] ino;
input iavail;
output iaccept;
output CCR_X;
output CCR_I;
output rw;
output [15:0] address;
input [7:0] data;
output [7:0] write_data;
output [5:0] debug_cycle;
output [7:0] debug_A;
output [7:0] debug_B;
output [7:0] debug_CCR;
output [15:0] debug_X;
output [15:0] debug_Y;
output [15:0] debug_SP;
output [3:0] debug_micro;

parameter PREFIX_Y = 8'b 00011000;
// 18
parameter PREFIX_D = 8'b 00011010;
// 1A
parameter PREFIX_D_Y = 8'b 11001101;
// CD
parameter ABA = 8'b 00011011;
// 1B
parameter ABI = 8'b 00111010;
// 3A
parameter ADCA = 8'b 10001001;
// 89
parameter ADCB = 8'b 11001001;
// C9
parameter ADDA = 8'b 10001011;
// 8B
parameter ADDB = 8'b 11001011;
// CB
parameter ADDD = 8'b 11000011;
// C3
parameter ANDA = 8'b 10000100;
// 84
parameter ANDB = 8'b 11000100;
// C4
parameter ASLA = 8'b 01001000;
// 48
parameter ASLB = 8'b 01011000;
// 58
parameter ASL = 8'b 01001000;
// 48
parameter ASLD = 8'b 00000101;
// 05
parameter ASRA = 8'b 01000111;
// 47
parameter ASRB = 8'b 01010111;
// 57
parameter ASR = 8'b 01000111;
// 47
parameter BCC = 8'b 00100100;
// 24
parameter BCLR_DIR = 8'b 00010101;
// 15
parameter BCLR_IND = 8'b 00011101;
// 1D
parameter BCS = 8'b 00100101;
// 25
parameter BEQ = 8'b 00100111;
// 27
parameter BGE = 8'b 00101100;
// 2C
parameter BGT = 8'b 00101110;
// 2E
parameter BHI = 8'b 00100010;
// 22
parameter BITA = 8'b 10000101;
// 85
parameter BITB = 8'b 11000101;
// C5
parameter BLE = 8'b 00101111;
// 2F
parameter BLS = 8'b 00100011;
// 23
parameter BLT = 8'b 00101101;
// 2D
parameter BMI = 8'b 00101011;
// 2B
parameter BNE = 8'b 00100110;
// 26
parameter BPL = 8'b 00101010;
// 2A
parameter BRA = 8'b 00100000;
// 20
parameter BRCLR_DIR = 8'b 00010011;
// 13
parameter BRCLR_IND = 8'b 00011111;
// 1F
parameter BRN = 8'b 00100001;
// 21
parameter BRSET_DIR = 8'b 00010010;
// 12
parameter BRSET_IND = 8'b 00011110;
// 1E
parameter BSET_DIR = 8'b 00010100;
// 14
parameter BSET_IND = 8'b 00011100;
// 1C
parameter BSR = 8'b 10001101;
// 8D
parameter BVC = 8'b 00101000;
// 28
parameter BVS = 8'b 00101001;
// 29
parameter CBA = 8'b 00010001;
// 11
parameter CLC = 8'b 00001100;
// 0C
parameter CLI = 8'b 00001110;
// 0E
parameter CLV = 8'b 00001010;
// 0A
parameter CLRA = 8'b 01001111;
// 4F
parameter CLRB = 8'b 01011111;
// 5F
parameter CLR = 8'b 01001111;
// 4F
parameter CMPA = 8'b 10000001;
// 81
parameter CMPB = 8'b 11000001;
// C1
parameter COMA = 8'b 01000011;
// 43
parameter COMB = 8'b 01010011;
// 53
parameter COM = 8'b 01000011;
// 43
parameter CPI = 8'b 10001100;
// 8C
parameter DAA = 8'b 00011001;
// 19
parameter DECA = 8'b 01001010;
// 4A
parameter DECB = 8'b 01011010;
// 5A
parameter DEC = 8'b 01001010;
// 4A
parameter DES = 8'b 00110100;
// 34
parameter DEI = 8'b 00001001;
// 09
parameter EORA = 8'b 10001000;
// 88
parameter EORB = 8'b 11001000;
// C8
parameter INCA = 8'b 01001100;
// 4C
parameter INCB = 8'b 01011100;
// 5C
parameter INC = 8'b 01001100;
// 4C
parameter INS = 8'b 00110001;
// 31
parameter INI = 8'b 00001000;
// 08
parameter JMP = 8'b 01001110;
// 4E
parameter JSR = 8'b 10001101;
// 8D
parameter LDAA = 8'b 10000110;
// 86
parameter LDAB = 8'b 11000110;
// C6
parameter LDD = 8'b 11001100;
// CC
parameter LDS = 8'b 10001110;
// 8E
parameter LDI = 8'b 11001110;
// CE
parameter LSRA = 8'b 01000100;
// 44
parameter LSRB = 8'b 01010100;
// 54
parameter LSR = 8'b 01000100;
// 44
parameter LSRD = 8'b 00000100;
// 04
parameter MUL = 8'b 00111101;
// 3D
parameter NEGA = 8'b 01000000;
// 40
parameter NEGB = 8'b 01010000;
// 50
parameter NEG = 8'b 01000000;
// 40
parameter NOP = 8'b 00000001;
// 01
parameter ORA = 8'b 10001010;
// 8A
parameter ORB = 8'b 11001010;
// CA
parameter PSHA = 8'b 00110110;
// 36
parameter PSHB = 8'b 00110111;
// 37
parameter PSHI = 8'b 00111100;
// 3C
parameter PULA = 8'b 00110010;
// 32
parameter PULB = 8'b 00110011;
// 33
parameter PULI = 8'b 00111000;
// 38
parameter ROLA = 8'b 01001001;
// 49
parameter ROLB = 8'b 01011001;
// 59
parameter ROLc = 8'b 01001001;
// 49
parameter RORA = 8'b 01000110;
// 46
parameter RORB = 8'b 01010110;
// 56
parameter RORc = 8'b 01000110;
// 46
parameter RTI = 8'b 00111011;
// 3B
parameter RTS = 8'b 00111001;
// 39
parameter SBA = 8'b 00010000;
// 10
parameter SBCA = 8'b 10000010;
// 82
parameter SBCB = 8'b 11000010;
// C2
parameter SEC = 8'b 00001101;
// 0D
parameter SEI = 8'b 00001111;
// 0F
parameter SEV = 8'b 00001011;
// 0B
parameter STAA = 8'b 10000111;
// 87
parameter STAB = 8'b 11000111;
// C7
parameter STD = 8'b 11001101;
// CD
parameter STS = 8'b 10001111;
// 8F
parameter STI = 8'b 11001111;
// CF
parameter SUBA = 8'b 10000000;
// 80
parameter SUBB = 8'b 11000000;
// C0
parameter SUBD = 8'b 10000011;
// 83
parameter SWI = 8'b 00111111;
// 3F
parameter TAB = 8'b 00010110;
// 16
parameter TAP = 8'b 00000110;
// 06
parameter TBA = 8'b 00010111;
// 17
parameter TPA = 8'b 00000111;
// 07
parameter TSTA = 8'b 01001101;
// 4D
parameter TSTB = 8'b 01011101;
// 5D
parameter TST = 8'b 01001101;
// 4D
parameter TSI = 8'b 00110000;
// 30
parameter TIS = 8'b 00110101;
// 35
parameter WAI = 8'b 00111110;
// 3E
parameter XGDI = 8'b 10001111;
// 8F
parameter IMM = 2'b 00;
parameter DIR = 2'b 01;
parameter EXT = 2'b 11;
parameter IND = 2'b 10;
parameter SBIT = 7;
parameter XBIT = 6;
parameter HBIT = 5;
parameter IBIT = 4;
parameter NBIT = 3;
parameter ZBIT = 2;
parameter VBIT = 1;
parameter CBIT = 0;
wire iaccept;
wire CCR_X;
wire CCR_I;
wire rw;
wire [15:0] address;
reg [7:0] write_data;
wire [5:0] debug_cycle;
wire [7:0] debug_A;
wire [7:0] debug_B;
wire [7:0] debug_CCR;
wire [15:0] debug_X;
wire [15:0] debug_Y;
wire [15:0] debug_SP;
wire [3:0] debug_micro;

// TYPE cpu_states:
parameter cpu_states_INIT = 0;
parameter cpu_states_FETCH1 = 1;
parameter cpu_states_FETCH2 = 2;
parameter cpu_states_FETCH_AGAIN = 3;
parameter cpu_states_FETCH3 = 4;
parameter cpu_states_FETCH4 = 5;
parameter cpu_states_LOAD1 = 6;
parameter cpu_states_LOAD2 = 7;
parameter cpu_states_IGNORE = 8;
parameter cpu_states_IGNORE2 = 9;
parameter cpu_states_CALCADDR = 10;
parameter cpu_states_WRITE = 11;
parameter cpu_states_WRITE2 = 12;
parameter cpu_states_WAIT_INT = 13;
parameter cpu_states_INT1 = 14;
parameter cpu_states_INT2 = 15;


// TYPE alu_ops:
parameter alu_ops_ALU_PASS = 0;
parameter alu_ops_ALU_ADD = 1;
parameter alu_ops_ALU_ADDC = 2;
parameter alu_ops_ALU_AND = 3;
parameter alu_ops_ALU_LSL = 4;
parameter alu_ops_ALU_LSR = 5;
parameter alu_ops_ALU_ASR = 6;
parameter alu_ops_ALU_CLR = 7;
parameter alu_ops_ALU_OR = 8;
parameter alu_ops_ALU_SUB = 9;
parameter alu_ops_ALU_PASS2 = 10;
parameter alu_ops_ALU_XOR = 11;
parameter alu_ops_ALU_MUL = 12;
parameter alu_ops_ALU_LSL16 = 13;
parameter alu_ops_ALU_SADD16 = 14;
parameter alu_ops_ALU_SUBC = 15;
parameter alu_ops_ALU_LSR16 = 16;
parameter alu_ops_ALU_ROL = 17;
parameter alu_ops_ALU_ROR = 18;


// TYPE alu_loc:
parameter alu_loc_ZERO = 0;
parameter alu_loc_ALU_REG = 1;
parameter alu_loc_ACCA = 2;
parameter alu_loc_ACCB = 3;
parameter alu_loc_ACCD = 4;
parameter alu_loc_IX = 5;
parameter alu_loc_IY = 6;
parameter alu_loc_SPC = 7;
parameter alu_loc_IMM8 = 8;
parameter alu_loc_IMM16 = 9;
parameter alu_loc_ANT_IMM8 = 10;
parameter alu_loc_SSP = 11;
parameter alu_loc_ONE = 12;
parameter alu_loc_BIT1 = 13;
parameter alu_loc_BIT4 = 14;
parameter alu_loc_NEGONE = 15;
parameter alu_loc_DEC_ADJ = 16;
parameter alu_loc_MULOP = 17;
parameter alu_loc_IXH = 18;
parameter alu_loc_IYH = 19;
parameter alu_loc_BUS_DATA = 20;
parameter alu_loc_SCCR = 21;


// TYPE cond_ops:
parameter cond_ops_COND_PASS = 0;
parameter cond_ops_COND_ADD8 = 1;
parameter cond_ops_COND_ADD16 = 2;
parameter cond_ops_COND_LOGIC8 = 3;
parameter cond_ops_COND_SHIFTL8 = 4;
parameter cond_ops_COND_SHIFTR8 = 5;
parameter cond_ops_COND_SHIFTL16 = 6;
parameter cond_ops_COND_SHIFTR16 = 7;
parameter cond_ops_COND_SUB8 = 8;
parameter cond_ops_COND_SUB16 = 9;
parameter cond_ops_COND_CLR = 10;
parameter cond_ops_COND_SET = 11;
parameter cond_ops_COND_NEG = 12;
parameter cond_ops_COND_DA = 13;
parameter cond_ops_COND_NZV = 14;
parameter cond_ops_COND_Z16 = 15;
parameter cond_ops_COND_MUL = 16;
parameter cond_ops_COND_LOAD16 = 17;
parameter cond_ops_COND_ADDLO = 18;
parameter cond_ops_COND_RESTORE = 19;


// TYPE sp_ops:
parameter sp_ops_PASS_SP = 0;
parameter sp_ops_SET_SP = 1;
parameter sp_ops_INC_SP = 2;
parameter sp_ops_DEC_SP = 3;

reg rw_i;
reg [15:0] address_i;
reg [15:0] naddress;
reg [15:0] load_addr;
reg [3:0] state;
reg [3:0] nstate;
reg [3:0] micro_cnt;
reg micro_rst;
reg [7:0] prev_data;
reg [7:0] datain;
reg [15:0] PC;
reg [15:0] nPC;
reg [15:0] SP;
wire [15:0] svc_vec;
reg [15:0] ind_addr;
reg branch;
reg write_byte;
reg is_prefix_1;
reg is_prefix_2;
reg is_prefix_3;
wire prefixed;
reg y_prefix;
reg d_prefix;
reg [7:0] opcode;
wire [7:0] next_opcode;
reg interrupt;
`define mode opcode[5:4]
reg [7:0] A;
reg [7:0] B;
reg [7:0] CCR;
reg [15:0] X;
reg [15:0] Y;
reg [1:0] sp_op;
reg [4:0] alu_op;
reg [7:0] alu_in1;
reg [7:0] alu_in2;
reg [4:0] alu_res;
reg [4:0] cond_op;
reg shift_b;
reg [7:0] alucond;
reg [15:0] aluout;
reg [15:0] alureg;
reg [8:0] alu_int;
reg [15:0] address_gen_src;
reg [8:0] address_gen_lo;
reg [7:0] address_gen_hi;
reg address_gen_sign;
reg [15:0] control_next_PC;
reg [15:0] control_next_addr;
reg [3:0] control_next_state;
reg control_start;
reg [7:0] control_opclass;
reg control_even;
reg [1:0] decode_spop_out;
reg [4:0] decode_aluop_out;
reg [4:0] decode_condop_out;
reg [4:0] decode_aluin1_out;
reg [4:0] decode_aluin2_out;
reg [4:0] decode_alures_out;
reg decode_writebyte_out;
reg [7:0] decode_opclass;
reg decode_even;
reg decode_start;
reg [8:0] alu_in1hi;
reg [8:0] alu_alu_out;
reg [8:0] alu_alu_hi_out;
reg [8:0] alu_alu_int_out;
reg [7:0] alu_cond_out;
reg [0:0] alu_carry_in;
reg alu_carry_out;


always @(negedge E)
begin : process_1
 prev_data <= datain;
 datain <= data;
end

assign iaccept = state === cpu_states_WAIT_INT & interrupt === 1'b 1 ? 1'b 0 :
 1'b 1;
assign next_opcode = interrupt !== 1'b 1 ? data :
 WAI;

always @(negedge E)
begin : process_2
 if (state === cpu_states_FETCH1 | state === cpu_states_FETCH2 &
 prefixed === 1'b 1)
 begin
 opcode <= next_opcode;
 end
end


always @(posedge reset or negedge E)
begin : process_3
 if (reset === 1'b 1)
 begin
 PC <= 16'b 0000000000000000;
 if (testmode)
 begin
 state <= cpu_states_FETCH1;
 address_i <= 16'b 0000000000000000;
 end
 else
 begin
 state <= cpu_states_INIT;
 address_i <= 16'b 1111111111111110;
 end
 interrupt <= 1'b 0;
 end
 else
 begin
 PC <= nPC;
 state <= nstate;
 if (nstate !== cpu_states_INT1 | state === cpu_states_INIT)
 begin
 address_i <= naddress;
 end
 else
 begin
 address_i <= svc_vec;
 end
 interrupt <= iavail;
 end
end


always @(negedge E)
begin : process_4
 if (state === cpu_states_LOAD1)
 begin
 load_addr <= address_i;
 end
end


always @(negedge E)
begin : process_5
 if (micro_rst === 1'b 1)
 begin
 micro_cnt <= {4{1'b 0}};
 end
 else
 begin
 micro_cnt <= micro_cnt + 1;
 end
end


always @(data)
begin : prefix
 if (data === PREFIX_Y)
 begin
 is_prefix_1 <= 1'b 1;
 is_prefix_2 <= 1'b 0;
 is_prefix_3 <= 1'b 0;
 end
 else if (data === PREFIX_D )
 begin
 is_prefix_1 <= 1'b 0;
 is_prefix_2 <= 1'b 1;
 is_prefix_3 <= 1'b 0;
 end
 else if (data === PREFIX_D_Y )
 begin
 is_prefix_1 <= 1'b 0;
 is_prefix_2 <= 1'b 0;
 is_prefix_3 <= 1'b 1;
 end
 else
 begin
 is_prefix_1 <= 1'b 0;
 is_prefix_2 <= 1'b 0;
 is_prefix_3 <= 1'b 0;
 end
end


always @(negedge E)
begin : process_6
 if (state === cpu_states_FETCH1)
 begin
 y_prefix <= is_prefix_1 | is_prefix_3;
 d_prefix <= is_prefix_2 | is_prefix_3;
 end
end

assign prefixed = y_prefix | d_prefix;
assign svc_vec = 16'b 1111111111010110 + {11'b 00000000000, ino, 1'b 0};

always @(state or y_prefix or PC or X or Y
 or datain)
begin : address_gen
 if (state === cpu_states_CALCADDR)
 begin
 if (y_prefix === 1'b 0)
 begin
 address_gen_src = X;
 end
 else
 begin
 address_gen_src = Y;
 end
 address_gen_sign = `false;
 end
 else
 begin
 address_gen_src = PC;
 address_gen_sign = datain[7] == 1'b 1;
 end
 address_gen_lo = {1'b 0, address_gen_src[7:0]} + {1'b 0, datain};
 if (address_gen_sign)
 begin
 if (address_gen_lo[8] === 1'b 0)
 begin
 address_gen_hi = address_gen_src[15:8] - 1;
 end
 else
 begin
 address_gen_hi = address_gen_src[15:8];
 end
 end
 else if (address_gen_lo[8] === 1'b 1 )
 begin
 address_gen_hi = address_gen_src[15:8] + 1;
 end
 else
 begin
 address_gen_hi = address_gen_src[15:8];
 end
 ind_addr <= {address_gen_hi, address_gen_lo[7:0]};
end
task control_inc_pc;

 begin
 begin
 control_next_PC = PC + 1;
 control_next_addr = control_next_PC;
 end
 end
endtask


always @(PC or state or opcode or datain or ind_addr
 or data or load_addr or SP or micro_cnt or svc_vec
 or address_i or branch or interrupt or prefixed)
begin : control
 control_start = state == cpu_states_FETCH2 & prefixed == 1'b 0 |
 state == cpu_states_FETCH_AGAIN;
 control_next_PC = PC;
 control_next_addr = control_next_PC;
 if (control_start)
 begin
 micro_rst <= 1'b 1;
 end
 else
 begin
 micro_rst <= 1'b 0;
 end
 control_next_state = state;
 if (state === cpu_states_FETCH1)
 begin
 if (interrupt !== 1'b 1)
 begin
 control_inc_pc;
 end
 control_next_state = cpu_states_FETCH2;
 end
 else if (state === cpu_states_INIT )
 begin
 control_next_addr = 16'b 1111111111111110;
 control_next_state = cpu_states_INT1;
 end
 else if (state === cpu_states_INT1 )
 begin
 control_next_addr = address_i + 1;
 control_next_state = cpu_states_INT2;
 end
 else if (state === cpu_states_INT2 )
 begin
 control_next_addr = {datain, data};
 control_next_PC = control_next_addr;
 control_next_state = cpu_states_FETCH1;
 end
 else
 begin
 case (opcode)
 PREFIX_Y,
 PREFIX_D,
 PREFIX_D_Y:
 begin
 control_next_state = cpu_states_FETCH_AGAIN;
 control_inc_pc;
 end
 ABA,
 ASLA,
 ASLB,
 ASRA,
 ASRB,
 CBA,
 CLC,
 CLI,
 CLV,
 CLRA,
 CLRB,
 COMA,
 COMB,
 DAA,
 DECA,
 DECB,
 INCA,
 INCB,
 LSRA,
 LSRB,
 NEGA,
 NEGB,
 NOP,
 ROLA,
 ROLB,
 RORA,
 RORB,
 SBA,
 SEC,
 SEI,
 SEV,
 TAB,
 TAP,
 TBA,
 TPA,
 TSTA,
 TSTB:
 begin
 control_next_state = cpu_states_FETCH1;
 end
 ABI,
 ASLD,
 DEI,
 INI,
 LSRD,
 XGDI:
 begin
 if (control_start)
 begin
 control_next_addr = 16'b 1111111111111111;
 control_next_state = cpu_states_IGNORE;
 end
 else
 begin
 control_next_state = cpu_states_FETCH1;
 end
 end
 BCC,
 BCS,
 BEQ,
 BGE,
 BGT,
 BHI,
 BLE,
 BLS,
 BLT,
 BMI,
 BNE,
 BPL,
 BRA,
 BRN,
 BVC,
 BVS:
 begin
 if (state === cpu_states_FETCH2)
 begin
 control_next_PC = PC + 1;
 control_next_addr = 16'b 1111111111111111;
 control_next_state = cpu_states_IGNORE;
 end
 else
 begin
 if (branch === 1'b 1)
 begin
 control_next_PC = ind_addr;
 end
 else
 begin
 control_next_PC = PC;
 end
 control_next_addr = control_next_PC;
 control_next_state = cpu_states_FETCH1;
 end
 end
 BSR:
 begin
 if (state === cpu_states_FETCH2)
 begin
 control_next_PC = control_next_PC + 1;
 control_next_addr = {16{1'b 1}};
 control_next_state = cpu_states_IGNORE;
 end
 else if (state === cpu_states_IGNORE )
 begin
 control_next_PC = ind_addr;
 control_next_addr = ind_addr;
 control_next_state = cpu_states_FETCH3;
 end
 else if (state === cpu_states_FETCH3 )
 begin
 control_next_addr = SP;
 control_next_state = cpu_states_WRITE;
 end
 else if (state === cpu_states_WRITE )
 begin
 if (micro_cnt[0] === 1'b 0)
 begin
 control_next_addr = SP;
 control_next_state = cpu_states_WRITE;
 end
 else
 begin
 control_next_addr = control_next_PC;
 control_next_state = cpu_states_FETCH1;
 end
 end
 end
 BCLR_DIR,
 BSET_DIR:
 begin
 if (state === cpu_states_FETCH2)
 begin
 control_next_addr = {8'b 00000000, data};
 control_next_state = cpu_states_LOAD1;
 end
 else if (state === cpu_states_LOAD1 )
 begin
 control_inc_pc;
 control_next_state = cpu_states_FETCH3;
 end
 else if (state === cpu_states_FETCH3 )
 begin
 control_next_addr = 16'b 1111111111111111;
 control_next_state = cpu_states_IGNORE;
 end
 else if (state === cpu_states_IGNORE )
 begin
 control_next_addr = load_addr;
 control_next_state = cpu_states_WRITE;
 end
 else
 begin
 control_inc_pc;
 control_next_state = cpu_states_FETCH1;
 end
 end
 BCLR_IND,
 BSET_IND:
 begin
 if (control_start)
 begin
 control_next_addr = 16'b 1111111111111111;
 control_next_state = cpu_states_CALCADDR;
 end
 else if (state === cpu_states_CALCADDR )
 begin
 control_next_addr = ind_addr;
 control_next_state = cpu_states_LOAD1;
 end
 else if (state === cpu_states_LOAD1 )
 begin
 control_inc_pc;
 control_next_state = cpu_states_FETCH3;
 end
 else if (state === cpu_states_FETCH3 )
 begin
 control_next_addr = 16'b 1111111111111111;
 control_next_state = cpu_states_IGNORE;
 end
 else if (state === cpu_states_IGNORE )
 begin
 control_next_addr = load_addr;
 control_next_state = cpu_states_WRITE;
 end
 else
 begin
 control_inc_pc;
 control_next_state = cpu_states_FETCH1;
 end
 end
 BRCLR_DIR,
 BRSET_DIR:
 begin
 if (state === cpu_states_FETCH2)
 begin
 control_next_addr = {8'b 00000000, data};
 control_next_state = cpu_states_LOAD1;
 end
 else if (state === cpu_states_LOAD1 )
 begin
 control_inc_pc;
 control_next_state = cpu_states_FETCH3;
 end
 else if (state === cpu_states_FETCH3 )
 begin
 control_inc_pc;
 control_next_state = cpu_states_FETCH4;
 end
 else if (state === cpu_states_FETCH4 )
 begin
 control_next_PC = PC + 1;
 control_next_addr = 16'b 1111111111111111;
 control_next_state = cpu_states_IGNORE;
 end
 else
 begin
 if (branch === 1'b 1)
 begin
 control_next_PC = ind_addr;
 end
 else
 begin
 control_next_PC = PC;
 end
 control_next_addr = control_next_PC;
 control_next_state = cpu_states_FETCH1;
 end
 end
 BRCLR_IND,
 BRSET_IND:
 begin
 if (control_start)
 begin
 control_next_addr = 16'b 1111111111111111;
 control_next_state = cpu_states_CALCADDR;
 end
 else if (state === cpu_states_CALCADDR )
 begin
 control_next_addr = ind_addr;
 control_next_state = cpu_states_LOAD1;
 end
 else if (state === cpu_states_LOAD1 )
 begin
 control_inc_pc;
 control_next_state = cpu_states_FETCH3;
 end
 else if (state === cpu_states_FETCH3 )
 begin
 control_inc_pc;
 control_next_state = cpu_states_FETCH4;
 end
 else if (state === cpu_states_FETCH4 )
 begin
 control_next_PC = PC + 1;
 control_next_addr = 16'b 1111111111111111;
 control_next_state = cpu_states_IGNORE;
 end
 else
 begin
 if (branch === 1'b 1)
 begin
 control_next_PC = ind_addr;
 end
 else
 begin
 control_next_PC = PC;
 end
 control_next_addr = control_next_PC;
 control_next_state = cpu_states_FETCH1;
 end
 end
 DES,
 INS:
 begin
 if (state === cpu_states_FETCH2)
 begin
 control_next_addr = SP;
 control_next_state = cpu_states_IGNORE;
 end
 else
 begin
 control_next_state = cpu_states_FETCH1;
 end
 end
 MUL:
 begin
 if (state === cpu_states_FETCH2)
 begin
 control_next_addr = 16'b 1111111111111111;
 control_next_state = cpu_states_IGNORE;
 end
 else
 begin
 control_next_addr = 16'b 1111111111111111;
 if (micro_cnt !== 4'b 0111)
 begin
 control_next_state = cpu_states_IGNORE;
 end
 else
 begin
 control_next_state = cpu_states_FETCH1;
 end
 end
 end
 PSHA,
 PSHB:
 begin
 if (state === cpu_states_FETCH2)
 begin
 control_next_addr = SP;
 control_next_state = cpu_states_WRITE;
 end
 else
 begin
 control_next_state = cpu_states_FETCH1;
 end
 end
 PSHI:
 begin
 if (control_start)
 begin
 control_next_addr = SP;
 control_next_state = cpu_states_WRITE;
 end
 else
 begin
 if (micro_cnt[0] === 1'b 0)
 begin
 control_next_addr = SP;
 control_next_state = cpu_states_WRITE;
 end
 else
 begin
 control_next_state = cpu_states_FETCH1;
 end
 end
 end
 PULA,
 PULB:
 begin
 if (state === cpu_states_FETCH2)
 begin
 control_next_addr = SP;
 control_next_state = cpu_states_IGNORE;
 end
 else if (state === cpu_states_IGNORE )
 begin
 control_next_addr = SP;
 control_next_state = cpu_states_LOAD1;
 end
 else
 begin
 control_next_state = cpu_states_FETCH1;
 end
 end
 PULI:
 begin
 if (control_start)
 begin
 control_next_addr = SP;
 control_next_state = cpu_states_IGNORE;
 end
 else if (state === cpu_states_IGNORE )
 begin
 control_next_addr = SP;
 control_next_state = cpu_states_LOAD1;
 end
 else if (state === cpu_states_LOAD1 )
 begin
 control_next_addr = SP;
 control_next_state = cpu_states_LOAD2;
 end
 else
 begin
 control_next_state = cpu_states_FETCH1;
 end
 end
 RTI:
 begin
 if (state === cpu_states_FETCH2)
 begin
 control_next_addr = SP;
 control_next_state = cpu_states_IGNORE;
 end
 else
 begin
 if (state === cpu_states_IGNORE | state === cpu_states_LOAD1)
 begin
 if (micro_cnt !== 4'b 0111)
 begin
 control_next_addr = SP;
 control_next_state = cpu_states_LOAD1;
 end
 else
 begin
 control_next_addr = SP;
 control_next_state = cpu_states_FETCH3;
 end
 end
 else if (state === cpu_states_FETCH3 )
 begin
 control_next_addr = SP;
 control_next_state = cpu_states_FETCH4;
 end
 else
 begin
 control_next_addr = {datain, data};
 control_next_PC = control_next_addr;
 control_next_state = cpu_states_FETCH1;
 end
 end
 end
 RTS:
 begin
 if (state === cpu_states_FETCH2)
 begin
 control_next_addr = SP;
 control_next_state = cpu_states_IGNORE;
 end
 else if (state === cpu_states_IGNORE )
 begin
 control_next_addr = SP;
 control_next_state = cpu_states_LOAD1;
 end
 else if (state === cpu_states_LOAD1 )
 begin
 control_next_addr = SP;
 control_next_state = cpu_states_LOAD2;
 end
 else
 begin
 control_next_addr = {datain, data};
 control_next_PC = control_next_addr;
 control_next_state = cpu_states_FETCH1;
 end
 end
 SWI,
 WAI:
 begin
 if (state === cpu_states_FETCH2)
 begin
 control_next_addr = SP;
 control_next_state = cpu_states_WRITE;
 end
 else if (state === cpu_states_WRITE )
 begin
 if (micro_cnt !== 4'b 0110)
 begin
 control_next_addr = SP;
 control_next_state = cpu_states_WRITE;
 end
 else
 begin
 control_next_addr = SP;
 control_next_state = cpu_states_WRITE2;
 end
 end
 else if (state === cpu_states_WRITE2 )
 begin
 if (micro_cnt[0] === 1'b 1)
 begin
 control_next_addr = SP;
 control_next_state = cpu_states_WRITE2;
 end
 else
 begin
 control_next_addr = SP;
 if (opcode === SWI)
 begin
 control_next_state = cpu_states_IGNORE;
 end
 else
 begin
 control_next_state = cpu_states_WAIT_INT;
 end
 end
 end
 else if (state === cpu_states_IGNORE )
 begin
 control_next_addr = 16'b 1111111111110110;
 control_next_state = cpu_states_LOAD1;
 end
 else if (state === cpu_states_LOAD1 )
 begin
 control_next_addr = address_i + 1;
 control_next_state = cpu_states_LOAD2;
 end
 else if (state === cpu_states_WAIT_INT )
 begin
 control_next_addr = SP;
 if (interrupt === 1'b 1)
 begin
 control_next_state = cpu_states_INT1;
 end
 else
 begin
 control_next_state = cpu_states_WAIT_INT;
 end
 end
 else
 begin
 control_next_addr = {datain, data};
 control_next_PC = control_next_addr;
 control_next_state = cpu_states_FETCH1;
 end
 end
 TSI:
 begin
 if (control_start)
 begin
 control_next_addr = SP;
 control_next_state = cpu_states_IGNORE;
 end
 else
 begin
 control_next_state = cpu_states_FETCH1;
 end
 end
 TIS:
 begin
 if (control_start)
 begin
 control_next_addr = 16'b 1111111111111111;
 control_next_state = cpu_states_IGNORE;
 end
 else
 begin
 control_next_state = cpu_states_FETCH1;
 end
 end
 default:
 begin
 control_opclass = opcode & 8'b 11001111;
 case (control_opclass)
 ASL,
 ASR,
 CLR,
 COM,
 DEC,
 INC,
 LSR,
 NEG,
 ROLc,
 RORc,
 TST:
 begin
 case (`mode)
 EXT:
 begin
 if (state === cpu_states_FETCH2)
 begin
 control_inc_pc;
 control_next_state = cpu_states_FETCH3;
 end
 else if (state === cpu_states_FETCH3 )
 begin
 control_next_addr = {datain, data};
 control_next_state = cpu_states_LOAD1;
 end
 else if (state === cpu_states_LOAD1 )
 begin
 control_next_addr = 16'b 1111111111111111;
 control_next_state = cpu_states_IGNORE;
 end
 else if (state === cpu_states_IGNORE )
 begin
 if (control_opclass !== TST)
 begin
 control_next_addr = load_addr;
 control_next_state = cpu_states_WRITE;
 end
 else
 begin
 control_next_addr = 16'b 1111111111111111;
 control_next_state = cpu_states_IGNORE2;
 end
 end
 else
 begin
 control_inc_pc;
 control_next_state = cpu_states_FETCH1;
 end
 end
 IND:
 begin
 if (control_start)
 begin
 control_next_addr = 16'b 1111111111111111;
 control_next_state = cpu_states_CALCADDR;
 end
 else if (state === cpu_states_CALCADDR )
 begin
 control_next_addr = ind_addr;
 control_next_state = cpu_states_LOAD1;
 end
 else if (state === cpu_states_LOAD1 )
 begin
 control_next_addr = 16'b 1111111111111111;
 control_next_state = cpu_states_IGNORE;
 end
 else if (state === cpu_states_IGNORE )
 begin
 if (control_opclass !== TST)
 begin
 control_next_addr = load_addr;
 control_next_state = cpu_states_WRITE;
 end
 else
 begin
 control_next_addr = 16'b 1111111111111111;
 control_next_state = cpu_states_IGNORE2;
 end
 end
 else
 begin
 control_inc_pc;
 control_next_state = cpu_states_FETCH1;
 end
 end
 default:
 ;
 endcase
 end
 ADCA,
 ADCB,
 ADDA,
 ADDB,
 ANDA,
 ANDB,
 BITA,
 BITB,
 CMPA,
 CMPB,
 EORA,
 EORB,
 LDAA,
 LDAB,
 ORA,
 ORB,
 SBCA,
 SBCB,
 STAA,
 STAB,
 SUBA,
 SUBB:
 begin
 case (`mode)
 IMM:
 begin
 control_inc_pc;
 control_next_state = cpu_states_FETCH1;
 end
 DIR:
 begin
 if (state === cpu_states_FETCH2)
 begin
 control_next_addr = {8'b 00000000, data};
 if (control_opclass === STAA | control_opclass === STAB)
 begin
 control_next_state = cpu_states_WRITE;
 end
 else
 begin
 control_next_state = cpu_states_LOAD1;
 end
 end
 else
 begin
 control_inc_pc;
 control_next_state = cpu_states_FETCH1;
 end
 end
 EXT:
 begin
 if (state === cpu_states_FETCH2)
 begin
 control_inc_pc;
 control_next_state = cpu_states_FETCH3;
 end
 else if (state === cpu_states_FETCH3 )
 begin
 control_next_addr = {datain, data};
 if (control_opclass === STAA | control_opclass === STAB)
 begin
 control_next_state = cpu_states_WRITE;
 end
 else
 begin
 control_next_state = cpu_states_LOAD1;
 end
 end
 else
 begin
 control_inc_pc;
 control_next_state = cpu_states_FETCH1;
 end
 end
 IND:
 begin
 if (control_start)
 begin
 control_next_addr = 16'b 1111111111111111;
 control_next_state = cpu_states_CALCADDR;
 end
 else if (state === cpu_states_CALCADDR )
 begin
 control_next_addr = ind_addr;
 if (control_opclass === STAA | control_opclass === STAB)
 begin
 control_next_state = cpu_states_WRITE;
 end
 else
 begin
 control_next_state = cpu_states_LOAD1;
 end
 end
 else
 begin
 control_inc_pc;
 control_next_state = cpu_states_FETCH1;
 end
 end
 default:
 ;
 endcase
 end
 ADDD,
 SUBD,
 CPI:
 begin
 case (`mode)
 IMM:
 begin
 if (control_start)
 begin
 control_inc_pc;
 control_next_state = cpu_states_FETCH3;
 end
 else if (state === cpu_states_FETCH3 )
 begin
 control_next_addr = 16'b 1111111111111111;
 control_next_state = cpu_states_IGNORE;
 end
 else
 begin
 control_inc_pc;
 control_next_state = cpu_states_FETCH1;
 end
 end
 DIR:
 begin
 if (control_start)
 begin
 control_next_addr = {8'b 00000000, data};
 control_next_state = cpu_states_LOAD1;
 end
 else if (state === cpu_states_LOAD1 )
 begin
 control_next_addr = address_i + 1;
 control_next_state = cpu_states_LOAD2;
 end
 else if (state === cpu_states_LOAD2 )
 begin
 control_next_addr = 16'b 1111111111111111;
 control_next_state = cpu_states_IGNORE;
 end
 else
 begin
 control_inc_pc;
 control_next_state = cpu_states_FETCH1;
 end
 end
 EXT:
 begin
 if (control_start)
 begin
 control_inc_pc;
 control_next_state = cpu_states_FETCH3;
 end
 else if (state === cpu_states_FETCH3 )
 begin
 control_next_addr = {datain, data};
 control_next_state = cpu_states_LOAD1;
 end
 else if (state === cpu_states_LOAD1 )
 begin
 control_next_addr = address_i + 1;
 control_next_state = cpu_states_LOAD2;
 end
 else if (state === cpu_states_LOAD2 )
 begin
 control_next_addr = 16'b 1111111111111111;
 control_next_state = cpu_states_IGNORE;
 end
 else
 begin
 control_inc_pc;
 control_next_state = cpu_states_FETCH1;
 end
 end
 IND:
 begin
 if (control_start)
 begin
 control_next_addr = 16'b 1111111111111111;
 control_next_state = cpu_states_CALCADDR;
 end
 else if (state === cpu_states_CALCADDR )
 begin
 control_next_addr = ind_addr;
 control_next_state = cpu_states_LOAD1;
 end
 else if (state === cpu_states_LOAD1 )
 begin
 control_next_addr = address_i + 1;
 control_next_state = cpu_states_LOAD2;
 end
 else if (state === cpu_states_LOAD2 )
 begin
 control_next_addr = 16'b 1111111111111111;
 control_next_state = cpu_states_IGNORE;
 end
 else
 begin
 control_inc_pc;
 control_next_state = cpu_states_FETCH1;
 end
 end
 default:
 ;
 endcase
 end
 LDD,
 LDS,
 LDI:
 begin
 case (`mode)
 IMM:
 begin
 if (control_start)
 begin
 control_inc_pc;
 control_next_state = cpu_states_FETCH3;
 end
 else
 begin
 control_inc_pc;
 control_next_state = cpu_states_FETCH1;
 end
 end
 DIR:
 begin
 if (control_start)
 begin
 control_next_addr = {8'b 00000000, data};
 control_next_state = cpu_states_LOAD1;
 end
 else if (state === cpu_states_LOAD1 )
 begin
 control_next_addr = address_i + 1;
 control_next_state = cpu_states_LOAD2;
 end
 else
 begin
 control_inc_pc;
 control_next_state = cpu_states_FETCH1;
 end
 end
 EXT:
 begin
 if (control_start)
 begin
 control_inc_pc;
 control_next_state = cpu_states_FETCH3;
 end
 else if (state === cpu_states_FETCH3 )
 begin
 control_next_addr = {datain, data};
 control_next_state = cpu_states_LOAD1;
 end
 else if (state === cpu_states_LOAD1 )
 begin
 control_next_addr = address_i + 1;
 control_next_state = cpu_states_LOAD2;
 end
 else
 begin
 control_inc_pc;
 control_next_state = cpu_states_FETCH1;
 end
 end
 IND:
 begin
 if (control_start)
 begin
 control_next_addr = 16'b 1111111111111111;
 control_next_state = cpu_states_CALCADDR;
 end
 else if (state === cpu_states_CALCADDR )
 begin
 control_next_addr = ind_addr;
 control_next_state = cpu_states_LOAD1;
 end
 else if (state === cpu_states_LOAD1 )
 begin
 control_next_addr = address_i + 1;
 control_next_state = cpu_states_LOAD2;
 end
 else
 begin
 control_inc_pc;
 control_next_state = cpu_states_FETCH1;
 end
 end
 default:
 ;
 endcase
 end
 STD,
 STS,
 STI:
 begin
 case (`mode)
 DIR:
 begin
 if (control_start)
 begin
 control_next_addr = {8'b 00000000, data};
 control_next_state = cpu_states_WRITE;
 end
 else if (state === cpu_states_WRITE )
 begin
 control_next_addr = address_i + 1;
 control_next_state = cpu_states_WRITE2;
 end
 else
 begin
 control_inc_pc;
 control_next_state = cpu_states_FETCH1;
 end
 end
 EXT:
 begin
 if (control_start)
 begin
 control_inc_pc;
 control_next_state = cpu_states_FETCH3;
 end
 else if (state === cpu_states_FETCH3 )
 begin
 control_next_addr = {datain, data};
 control_next_state = cpu_states_WRITE;
 end
 else if (state === cpu_states_WRITE )
 begin
 control_next_addr = address_i + 1;
 control_next_state = cpu_states_WRITE2;
 end
 else
 begin
 control_inc_pc;
 control_next_state = cpu_states_FETCH1;
 end
 end
 IND:
 begin
 if (control_start)
 begin
 control_next_addr = 16'b 1111111111111111;
 control_next_state = cpu_states_CALCADDR;
 end
 else if (state === cpu_states_CALCADDR )
 begin
 control_next_addr = ind_addr;
 control_next_state = cpu_states_WRITE;
 end
 else if (state === cpu_states_WRITE )
 begin
 control_next_addr = address_i + 1;
 control_next_state = cpu_states_WRITE2;
 end
 else
 begin
 control_inc_pc;
 control_next_state = cpu_states_FETCH1;
 end
 end
 default:
 ;
 endcase
 end
 JMP:
 begin
 case (`mode)
 EXT:
 begin
 if (state === cpu_states_FETCH2)
 begin
 control_inc_pc;
 control_next_state = cpu_states_FETCH3;
 end
 else
 begin
 control_next_addr = {datain, data};
 control_next_PC = control_next_addr;
 control_next_state = cpu_states_FETCH1;
 end
 end
 IND:
 begin
 if (control_start)
 begin
 control_next_addr = 16'b 1111111111111111;
 control_next_state = cpu_states_CALCADDR;
 end
 else
 begin
 control_next_PC = ind_addr;
 control_next_addr = ind_addr;
 control_next_state = cpu_states_FETCH1;
 end
 end
 default:
 ;
 endcase
 end
 JSR:
 begin
 case (`mode)
 DIR:
 begin
 if (state === cpu_states_FETCH2)
 begin
 control_next_PC = PC + 1;
 control_next_addr = {8'b 00000000, data};
 control_next_state = cpu_states_LOAD1;
 end
 end
 EXT:
 begin
 if (state === cpu_states_FETCH2)
 begin
 control_inc_pc;
 control_next_state = cpu_states_FETCH3;
 end
 else if (state === cpu_states_FETCH3 )
 begin
 control_next_PC = PC + 1;
 control_next_addr = {datain, data};
 control_next_state = cpu_states_LOAD1;
 end
 end
 IND:
 begin
 if (control_start)
 begin
 control_next_addr = 16'b 1111111111111111;
 control_next_state = cpu_states_CALCADDR;
 end
 else if (state === cpu_states_CALCADDR )
 begin
 control_next_PC = PC + 1;
 control_next_addr = ind_addr;
 control_next_state = cpu_states_LOAD1;
 end
 end
 default:
 ;
 endcase
 if (state === cpu_states_LOAD1)
 begin
 control_next_addr = SP;
 control_next_state = cpu_states_WRITE;
 end
 else if (state === cpu_states_WRITE )
 begin
 control_next_PC = load_addr;
 if (`mode === DIR)
 begin
 control_even = 1'b 1;
 end
 else
 begin
 control_even = 1'b 0;
 end
 if (micro_cnt[0] === control_even)
 begin
 control_next_addr = SP;
 control_next_state = cpu_states_WRITE;
 end
 else
 begin
 control_next_addr = control_next_PC;
 control_next_state = cpu_states_FETCH1;
 end
 end
 end
 default:
 ;
 endcase
 end
 endcase
 end
 nPC <= control_next_PC;
 nstate <= control_next_state;
 naddress <= control_next_addr;
end

task decode_decode_single;
 input [4:0] op;
 input [4:0] cond;
 input [4:0] src1;
 input [4:0] src2;
 input [4:0] res;

 begin
 begin
 if (state === cpu_states_FETCH2)
 begin
 decode_aluop_out = op;
 decode_condop_out = cond;
 decode_aluin1_out = src1;
 decode_aluin2_out = src2;
 decode_alures_out = res;
 end
 end
 end
endtask

task decode_decode_mode8;
 
input [4:0] op1;
 input [4:0] op2;
 input [4:0] src;
 input [4:0] res;

begin
 begin
if (state === cpu_states_FETCH1)
 begin 
decode_aluin1_out = src;
 decode_aluin2_out = alu_loc_IMM8;
 decode_aluop_out = op1;
 decode_condop_out = op2;
 decode_alures_out = res;
end
 end
end
endtask

task decode_decode_mode16;
 input [4:0] op1;
 input [4:0] op2;
 input [4:0] cop1;
 input [4:0] cop2;
 input [4:0] src1;
 input [4:0] src2;
 input [4:0] res1;
 input [4:0] res2;

 begin
 begin
 if (state === cpu_states_FETCH3 | state === cpu_states_LOAD2)
 begin
 decode_aluop_out = alu_ops_ALU_PASS;
 decode_aluin1_out = alu_loc_IMM8;
 decode_alures_out = alu_loc_ALU_REG;
 end
 else if (state === cpu_states_IGNORE )
 begin
 decode_aluin1_out = src1;
 decode_aluin2_out = alu_loc_IMM8;
 decode_aluop_out = op1;
 decode_condop_out = cop1;
 decode_alures_out = res1;
 end
 else if (state === cpu_states_FETCH1 )
 begin
 decode_aluin1_out = src2;
 decode_aluin2_out = alu_loc_ALU_REG;
 decode_aluop_out = op2;
 decode_condop_out = cop2;
 decode_alures_out = res2;
 end
 end
 end
endtask

task decode_decode_load16;
 input [4:0] res;

 begin
 begin
 if (state === cpu_states_FETCH1)
 begin
 decode_aluin1_out = alu_loc_IMM16;
 decode_aluop_out = alu_ops_ALU_PASS;
 decode_condop_out = cond_ops_COND_LOAD16;
 decode_alures_out = res;
 end
 end
 end
endtask

task decode_decode_store16;
 input [4:0] src;

 begin
 begin
 if (state === cpu_states_WRITE)
 begin
 decode_writebyte_out = 1'b 1;
 decode_aluin1_out = src;
 decode_aluop_out = alu_ops_ALU_PASS;
 decode_alures_out = alu_loc_BUS_DATA;
 end
 else if (state === cpu_states_WRITE2 )
 begin
 decode_aluin1_out = src;
 decode_aluop_out = alu_ops_ALU_PASS;
 decode_alures_out = alu_loc_BUS_DATA;
 decode_condop_out = cond_ops_COND_LOAD16;
 end
 end
 end
endtask

task decode_decode_rw8;
 input [4:0] op1;
 input [4:0] op2;
 input [4:0] src1;
 input [4:0] src2;

 begin
 begin
 if (state === cpu_states_IGNORE)
 begin
 decode_aluin1_out = src1;
 decode_aluin2_out = src2;
 decode_aluop_out = op1;
 decode_condop_out = op2;
 decode_alures_out = alu_loc_ALU_REG;
 end
 end
 end
endtask


always @(opcode or state or micro_cnt or micro_rst or y_prefix
 or d_prefix)
begin : decode
 decode_spop_out = sp_ops_PASS_SP;
 decode_aluop_out = alu_ops_ALU_PASS;
 decode_condop_out = cond_ops_COND_PASS;
 decode_aluin1_out = alu_loc_ACCA;
 decode_aluin2_out = alu_loc_ACCB;
 decode_alures_out = alu_loc_ZERO;
 decode_writebyte_out = 1'b 0;
 decode_start = micro_rst == 1'b 1;
 shift_b <= 1'b 0;
 case (opcode)
 ABA:
 begin
 decode_decode_single(alu_ops_ALU_ADD, cond_ops_COND_ADD8, alu_loc_ACCA, alu_loc_ACCB, alu_loc_ACCA);
 end
 CBA:
 begin
 decode_decode_single(alu_ops_ALU_SUB, cond_ops_COND_SUB8, alu_loc_ACCA, alu_loc_ACCB, alu_loc_ZERO);
 end
 ASLA:
 begin
 decode_decode_single(alu_ops_ALU_LSL, cond_ops_COND_SHIFTL8, alu_loc_ACCA, alu_loc_ZERO, alu_loc_ACCA);
 end
 ASLB:
 begin
 decode_decode_single(alu_ops_ALU_LSL, cond_ops_COND_SHIFTL8, alu_loc_ACCB, alu_loc_ZERO, alu_loc_ACCB);
 end
 ASRA:
 begin
 decode_decode_single(alu_ops_ALU_ASR, cond_ops_COND_SHIFTR8, alu_loc_ACCA, alu_loc_ZERO, alu_loc_ACCA);
 end
 ASRB:
 begin
 decode_decode_single(alu_ops_ALU_ASR, cond_ops_COND_SHIFTR8, alu_loc_ACCB, alu_loc_ZERO, alu_loc_ACCB);
 end
 ABI:
 begin
 if (state === cpu_states_IGNORE)
 begin
 decode_aluop_out = alu_ops_ALU_ADD;
 if (y_prefix === 1'b 0)
 begin
 decode_aluin1_out = alu_loc_IX;
 decode_alures_out = alu_loc_IX;
 end
 else
 begin
 decode_aluin1_out = alu_loc_IY;
 decode_alures_out = alu_loc_IY;
 end
 decode_aluin2_out = alu_loc_ACCB;
 end
 end
 ASLD:
 begin
 if (state === cpu_states_IGNORE)
 begin
 decode_aluop_out = alu_ops_ALU_LSL;
 decode_condop_out = cond_ops_COND_SHIFTL8;
 decode_aluin1_out = alu_loc_ACCB;
 decode_alures_out = alu_loc_ACCB;
 end
 else if (state === cpu_states_FETCH1 )
 begin
 decode_aluop_out = alu_ops_ALU_LSL16;
 decode_condop_out = cond_ops_COND_SHIFTL16;
 decode_aluin1_out = alu_loc_ACCA;
 decode_alures_out = alu_loc_ACCA;
 end
 end
 BCC,
 BCS,
 BEQ,
 BGE,
 BGT,
 BHI,
 BLE,
 BLS,
 BLT,
 BMI,
 BNE,
 BPL,
 BRA,
 BRN,
 BVC,
 BVS:
 begin
 if (state === cpu_states_IGNORE)
 begin
 decode_aluop_out = alu_ops_ALU_SADD16;
 decode_aluin1_out = alu_loc_SPC;
 decode_aluin2_out = alu_loc_IMM8;
 decode_alures_out = alu_loc_ALU_REG;
 end
 end
 BSR:
 begin
 if (state === cpu_states_IGNORE)
 begin
 decode_aluop_out = alu_ops_ALU_SADD16;
 decode_aluin1_out = alu_loc_SPC;
 decode_aluin2_out = alu_loc_IMM8;
 decode_alures_out = alu_loc_ALU_REG;
 end
 else if (state === cpu_states_FETCH3 )
 begin
 decode_spop_out = sp_ops_DEC_SP;
 decode_aluop_out = alu_ops_ALU_PASS;
 decode_aluin1_out = alu_loc_SPC;
 decode_alures_out = alu_loc_ALU_REG;
 end
 else if (state === cpu_states_WRITE )
 begin
 if (micro_cnt[0] === 1'b 0)
 begin
 decode_spop_out = sp_ops_DEC_SP;
 decode_writebyte_out = 1'b 0;
 end
 else
 begin
 decode_writebyte_out = 1'b 1;
 end
 end
 end
 BCLR_DIR,
 BCLR_IND:
 begin
 decode_decode_rw8(alu_ops_ALU_CLR, cond_ops_COND_LOGIC8, alu_loc_ANT_IMM8, alu_loc_IMM8);
 end
 BSET_DIR,
 BSET_IND:
 begin
 decode_decode_rw8(alu_ops_ALU_OR, cond_ops_COND_LOGIC8, alu_loc_ANT_IMM8, alu_loc_IMM8);
 end
 BRCLR_DIR,
 BRCLR_IND,
 BRSET_DIR,
 BRSET_IND:
 begin
 if (state === cpu_states_FETCH4)
 begin
 if (opcode === BRCLR_DIR | opcode === BRCLR_IND)
 begin
 decode_aluop_out = alu_ops_ALU_AND;
 end
 else
 begin
 decode_aluop_out = alu_ops_ALU_CLR;
 end
 decode_alures_out = alu_loc_ALU_REG;
 decode_aluin1_out = alu_loc_IMM8;
 decode_aluin2_out = alu_loc_ANT_IMM8;
 end
 else if (state === cpu_states_IGNORE )
 begin
 decode_aluop_out = alu_ops_ALU_SADD16;
 decode_aluin1_out = alu_loc_SPC;
 decode_aluin2_out = alu_loc_IMM8;
 decode_alures_out = alu_loc_ALU_REG;
 end
 end
 CLC:
 begin
 decode_condop_out = cond_ops_COND_CLR;
 decode_aluin1_out = alu_loc_ONE;
 end
 CLI:
 begin
 decode_condop_out = cond_ops_COND_CLR;
 decode_aluin1_out = alu_loc_BIT4;
 end
 CLV:
 begin
 decode_condop_out = cond_ops_COND_CLR;
 decode_aluin1_out = alu_loc_BIT1;
 end
 SEC:
 begin
 decode_condop_out = cond_ops_COND_SET;
 decode_aluin1_out = alu_loc_ONE;
 end
 SEI:
 begin
 decode_condop_out = cond_ops_COND_SET;
 decode_aluin1_out = alu_loc_BIT4;
 end
 SEV:
 begin
 decode_condop_out = cond_ops_COND_SET;
 decode_aluin1_out = alu_loc_BIT1;
 end
 CLRA:
 begin
 decode_decode_single(alu_ops_ALU_PASS, cond_ops_COND_SHIFTL8, alu_loc_ZERO, alu_loc_ZERO, alu_loc_ACCA);
 end
 CLRB:
 begin
 decode_decode_single(alu_ops_ALU_PASS, cond_ops_COND_SHIFTL8, alu_loc_ZERO, alu_loc_ZERO, alu_loc_ACCB);
 end
 COMA:
 begin
 decode_decode_single(alu_ops_ALU_SUB, cond_ops_COND_NEG, alu_loc_NEGONE, alu_loc_ACCA, alu_loc_ACCA);
 end
 COMB:
 begin
 decode_decode_single(alu_ops_ALU_SUB, cond_ops_COND_NEG, alu_loc_NEGONE, alu_loc_ACCB, alu_loc_ACCB);
 end
 DECA:
 begin
 decode_decode_single(alu_ops_ALU_SUB, cond_ops_COND_NZV, alu_loc_ACCA, alu_loc_ONE, alu_loc_ACCA);
 end
 DECB:
 begin
 decode_decode_single(alu_ops_ALU_SUB, cond_ops_COND_NZV, alu_loc_ACCB, alu_loc_ONE, alu_loc_ACCB);
 end
 DES:
 begin
 if (state === cpu_states_FETCH2)
 begin
 decode_spop_out = sp_ops_DEC_SP;
 end
 end
 INCA:
 begin
 decode_decode_single(alu_ops_ALU_ADD, cond_ops_COND_NZV, alu_loc_ACCA, alu_loc_ONE, alu_loc_ACCA);
 end
 INCB:
 begin
 decode_decode_single(alu_ops_ALU_ADD, cond_ops_COND_NZV, alu_loc_ACCB, alu_loc_ONE, alu_loc_ACCB);
 end
 INS:
 begin
 if (state === cpu_states_FETCH2)
 begin
 decode_spop_out = sp_ops_INC_SP;
 end
 end
 DAA:
 begin
 decode_decode_single(alu_ops_ALU_ADD, cond_ops_COND_DA, alu_loc_ACCA, alu_loc_DEC_ADJ, alu_loc_ACCA);
 end
 DEI:
 begin
 if (state === cpu_states_IGNORE)
 begin
 decode_aluop_out = alu_ops_ALU_SUB;
 decode_condop_out = cond_ops_COND_Z16;
 if (y_prefix === 1'b 0)
 begin
 decode_aluin1_out = alu_loc_IX;
 decode_alures_out = alu_loc_IX;
 end
 else
 begin
 decode_aluin1_out = alu_loc_IY;
 decode_alures_out = alu_loc_IY;
 end
 decode_aluin2_out = alu_loc_ONE;
 end
 end
 INI:
 begin
 if (state === cpu_states_IGNORE)
 begin
 decode_aluop_out = alu_ops_ALU_ADD;
 decode_condop_out = cond_ops_COND_Z16;
 if (y_prefix === 1'b 0)
 begin
 decode_aluin1_out = alu_loc_IX;
 decode_alures_out = alu_loc_IX;
 end
 else
 begin
 decode_aluin1_out = alu_loc_IY;
 decode_alures_out = alu_loc_IY;
 end
 decode_aluin2_out = alu_loc_ONE;
 end
 end
 LSRA:
 begin
 decode_decode_single(alu_ops_ALU_LSR, cond_ops_COND_SHIFTR8, alu_loc_ACCA, alu_loc_ZERO, alu_loc_ACCA);
 end
 LSRB:
 begin
 decode_decode_single(alu_ops_ALU_LSR, cond_ops_COND_SHIFTR8, alu_loc_ACCB, alu_loc_ZERO, alu_loc_ACCB);
 end
 LSRD:
 begin
 if (state === cpu_states_IGNORE)
 begin
 decode_aluop_out = alu_ops_ALU_LSR;
 decode_condop_out = cond_ops_COND_SHIFTR8;
 decode_aluin1_out = alu_loc_ACCA;
 decode_alures_out = alu_loc_ACCA;
 end
 else if (state === cpu_states_FETCH1 )
 begin
 decode_aluop_out = alu_ops_ALU_LSR16;
 decode_condop_out = cond_ops_COND_SHIFTR16;
 decode_aluin1_out = alu_loc_ACCB;
 decode_alures_out = alu_loc_ACCB;
 end
 end
 MUL:
 begin
 if (state === cpu_states_FETCH2)
 begin
 decode_aluop_out = alu_ops_ALU_PASS;
 decode_aluin1_out = alu_loc_ZERO;
 decode_alures_out = alu_loc_ALU_REG;
 end
 else if (state === cpu_states_IGNORE )
 begin
 decode_aluop_out = alu_ops_ALU_MUL;
 decode_condop_out = cond_ops_COND_MUL;
 decode_aluin1_out = alu_loc_ALU_REG;
 decode_aluin2_out = alu_loc_MULOP;
 decode_alures_out = alu_loc_ALU_REG;
 shift_b <= 1'b 1;
 end
 else
 begin
 decode_aluop_out = alu_ops_ALU_PASS;
 decode_aluin1_out = alu_loc_ALU_REG;
 decode_alures_out = alu_loc_ACCA;
 end
 end
 NEGA:
 begin
 decode_decode_single(alu_ops_ALU_SUB, cond_ops_COND_SUB8, alu_loc_ZERO, alu_loc_ACCA, alu_loc_ACCA);
 end
 NEGB:
 begin
 decode_decode_single(alu_ops_ALU_SUB, cond_ops_COND_SUB8, alu_loc_ZERO, alu_loc_ACCB, alu_loc_ACCB);
 end
 PSHA,
 PSHB:
 begin
 if (state === cpu_states_FETCH2)
 begin
 decode_aluop_out = alu_ops_ALU_PASS;
 if (opcode[0] === 1'b 0)
 begin
 decode_aluin1_out = alu_loc_ACCA;
 end
 else
 begin
 decode_aluin1_out = alu_loc_ACCB;
 end
 decode_alures_out = alu_loc_ALU_REG;
 end
 else if (state === cpu_states_WRITE )
 begin
 decode_spop_out = sp_ops_DEC_SP;
 end
 end
 PSHI:
 begin
 if (decode_start)
 begin
 decode_spop_out = sp_ops_DEC_SP;
 decode_aluop_out = alu_ops_ALU_PASS;
 if (y_prefix === 1'b 0)
 begin
 decode_aluin1_out = alu_loc_IX;
 end
 else
 begin
 decode_aluin1_out = alu_loc_IY;
 end
 decode_alures_out = alu_loc_ALU_REG;
 end
 else if (state === cpu_states_WRITE )
 begin
 if (micro_cnt[0] === 1'b 0)
 begin
 decode_spop_out = sp_ops_DEC_SP;
 decode_writebyte_out = 1'b 0;
 end
 else
 begin
 decode_writebyte_out = 1'b 1;
 end
 end
 end
 PULA,
 PULB:
 begin
 if (state === cpu_states_FETCH2)
 begin
 decode_spop_out = sp_ops_INC_SP;
 end
 else if (state === cpu_states_FETCH1 )
 begin
 decode_aluop_out = alu_ops_ALU_PASS;
 decode_aluin1_out = alu_loc_IMM8;
 if (opcode[0] === 1'b 0)
 begin
 decode_alures_out = alu_loc_ACCA;
 end
 else
 begin
 decode_alures_out = alu_loc_ACCB;
 end
 end
 end
 PULI:
 begin
 if (decode_start | state === cpu_states_IGNORE)
 begin
 decode_spop_out = sp_ops_INC_SP;
 end
 else if (state === cpu_states_FETCH1 )
 begin
 decode_aluop_out = alu_ops_ALU_PASS;
 decode_aluin1_out = alu_loc_IMM16;
 if (y_prefix === 1'b 0)
 begin
 decode_alures_out = alu_loc_IX;
 end
 else
 begin
 decode_alures_out = alu_loc_IY;
 end
 end
 end
 ROLA:
 begin
 decode_decode_single(alu_ops_ALU_ROL, cond_ops_COND_SHIFTL8, alu_loc_ACCA, alu_loc_ZERO, alu_loc_ACCA);
 end
 ROLB:
 begin
 decode_decode_single(alu_ops_ALU_ROL, cond_ops_COND_SHIFTL8, alu_loc_ACCB, alu_loc_ZERO, alu_loc_ACCB);
 end
 RORA:
 begin
 decode_decode_single(alu_ops_ALU_ROR, cond_ops_COND_SHIFTR8, alu_loc_ACCA, alu_loc_ZERO, alu_loc_ACCA);
 end
 RORB:
 begin
 decode_decode_single(alu_ops_ALU_ROR, cond_ops_COND_SHIFTR8, alu_loc_ACCB, alu_loc_ZERO, alu_loc_ACCB);
 end
 RTI:
 begin
 if (state === cpu_states_FETCH2 | state === cpu_states_IGNORE |
 state === cpu_states_LOAD1)
 begin
 decode_spop_out = sp_ops_INC_SP;
 end
 if (state === cpu_states_LOAD1)
 begin
 case (micro_cnt)
 4'b 0010:
 begin
 decode_condop_out = cond_ops_COND_RESTORE;
 decode_aluin1_out = alu_loc_IMM8;
 end
 4'b 0011:
 begin
 decode_aluop_out = alu_ops_ALU_PASS;
 decode_aluin1_out = alu_loc_IMM8;
 decode_alures_out = alu_loc_ACCB;
 end
 4'b 0100:
 begin
 decode_aluop_out = alu_ops_ALU_PASS;
 decode_aluin1_out = alu_loc_IMM8;
 decode_alures_out = alu_loc_ACCA;
 end
 4'b 0110:
 begin
 decode_aluop_out = alu_ops_ALU_PASS;
 decode_aluin1_out = alu_loc_IMM16;
 decode_alures_out = alu_loc_IX;
 end
 default:
 ;
 endcase
 end
 else if (state === cpu_states_FETCH3 )
 begin
 decode_aluop_out = alu_ops_ALU_PASS;
 decode_aluin1_out = alu_loc_IMM16;
 decode_alures_out = alu_loc_IY;
 end
 end
 RTS:
 begin
 if (state === cpu_states_FETCH2 | state === cpu_states_IGNORE)
 begin
 decode_spop_out = sp_ops_INC_SP;
 end
 end
 SBA:
 begin
 decode_decode_single(alu_ops_ALU_SUB, cond_ops_COND_SUB8, alu_loc_ACCA, alu_loc_ACCB, alu_loc_ACCA);
 end
 SWI,
 WAI:
 begin
 if (state === cpu_states_FETCH2 | state === cpu_states_WRITE)
 begin
 decode_spop_out = sp_ops_DEC_SP;
 end
 if (state === cpu_states_WRITE | state === cpu_states_WRITE2)
 begin
 case (micro_cnt)
 4'b 0000:
 begin
 decode_aluop_out = alu_ops_ALU_PASS;
 decode_aluin1_out = alu_loc_SPC;
 decode_alures_out = alu_loc_BUS_DATA;
 end
 4'b 0001:
 begin
 decode_writebyte_out = 1'b 1;
 decode_aluop_out = alu_ops_ALU_PASS;
 decode_aluin1_out = alu_loc_SPC;
 decode_alures_out = alu_loc_BUS_DATA;
 end
 4'b 0010:
 begin
 decode_aluop_out = alu_ops_ALU_PASS;
 decode_aluin1_out = alu_loc_IY;
 decode_alures_out = alu_loc_BUS_DATA;
 end
 4'b 0011:
 begin
 decode_writebyte_out = 1'b 1;
 decode_aluop_out = alu_ops_ALU_PASS;
 decode_aluin1_out = alu_loc_IY;
 decode_alures_out = alu_loc_BUS_DATA;
 end
 4'b 0100:
 begin
 decode_aluop_out = alu_ops_ALU_PASS;
 decode_aluin1_out = alu_loc_IX;
 decode_alures_out = alu_loc_BUS_DATA;
 end
 4'b 0101:
 begin
 decode_writebyte_out = 1'b 1;
 decode_aluop_out = alu_ops_ALU_PASS;
 decode_aluin1_out = alu_loc_IX;
 decode_alures_out = alu_loc_BUS_DATA;
 end
 4'b 0110:
 begin
 decode_aluop_out = alu_ops_ALU_PASS;
 decode_aluin1_out = alu_loc_ACCA;
 decode_alures_out = alu_loc_BUS_DATA;
 end
 4'b 0111:
 begin
 decode_aluop_out = alu_ops_ALU_PASS;
 decode_aluin1_out = alu_loc_ACCB;
 decode_alures_out = alu_loc_BUS_DATA;
 end
 4'b 1000:
 begin
 decode_aluop_out = alu_ops_ALU_PASS;
 decode_aluin1_out = alu_loc_SCCR;
 decode_alures_out = alu_loc_BUS_DATA;
 end
 default:
 ;
 endcase
 end
 else if (state === cpu_states_FETCH1 )
 begin
 decode_condop_out = cond_ops_COND_SET;
 decode_aluin1_out = alu_loc_BIT4;
 end
 end
 TAB:
 begin
 decode_decode_single(alu_ops_ALU_PASS, cond_ops_COND_LOGIC8, alu_loc_ACCA, alu_loc_ZERO, alu_loc_ACCB);
 end
 TAP:
 begin
 decode_decode_single(alu_ops_ALU_PASS, cond_ops_COND_RESTORE, alu_loc_ACCA, alu_loc_ZERO, alu_loc_ZERO);
 end
 TPA:
 begin
 decode_decode_single(alu_ops_ALU_PASS, cond_ops_COND_PASS, alu_loc_SCCR, alu_loc_ZERO, alu_loc_ACCA);
 end
 TBA:
 begin
 decode_decode_single(alu_ops_ALU_PASS, cond_ops_COND_LOGIC8, alu_loc_ACCB, alu_loc_ZERO, alu_loc_ACCA);
 end
 TSTA:
 begin
 decode_decode_single(alu_ops_ALU_SUB, cond_ops_COND_SUB8, alu_loc_ACCA, alu_loc_ZERO, alu_loc_ZERO);
 end
 TSTB:
 begin
 decode_decode_single(alu_ops_ALU_SUB, cond_ops_COND_SUB8, alu_loc_ACCB, alu_loc_ZERO, alu_loc_ZERO);
 end
 TSI:
 begin
 if (state === cpu_states_IGNORE)
 begin
 decode_aluop_out = alu_ops_ALU_PASS;
 decode_aluin1_out = alu_loc_SSP;
 if (y_prefix === 1'b 0)
 begin
 decode_alures_out = alu_loc_IX;
 end
 else
 begin
 decode_alures_out = alu_loc_IY;
 end
 end
 end
 TIS:
 begin
 if (state === cpu_states_IGNORE)
 begin
 decode_aluop_out = alu_ops_ALU_PASS;
 if (y_prefix === 1'b 0)
 begin
 decode_aluin1_out = alu_loc_IX;
 end
 else
 begin
 decode_aluin1_out = alu_loc_IY;
 end
 decode_spop_out = sp_ops_SET_SP;
 end
 end
 XGDI:
 begin
 if (decode_start)
 begin
 decode_aluop_out = alu_ops_ALU_PASS;
 if (y_prefix === 1'b 0)
 begin
 decode_aluin1_out = alu_loc_IX;
 end
 else
 begin
 decode_aluin1_out = alu_loc_IY;
 end
 decode_alures_out = alu_loc_ALU_REG;
 end
 else if (state === cpu_states_IGNORE )
 begin
 decode_aluop_out = alu_ops_ALU_PASS;
 decode_aluin1_out = alu_loc_ACCD;
 if (y_prefix === 1'b 0)
 begin
 decode_alures_out = alu_loc_IX;
 end
 else
 begin
 decode_alures_out = alu_loc_IY;
 end
 end
 else if (state === cpu_states_FETCH1 )
 begin
 decode_aluop_out = alu_ops_ALU_PASS;
 decode_aluin1_out = alu_loc_ALU_REG;
 decode_alures_out = alu_loc_ACCD;
 end
 end
 default:
 begin
 decode_opclass = opcode & 8'b 11001111;
 case (decode_opclass)
 ADCA:
 begin
 decode_decode_mode8(alu_ops_ALU_ADDC, cond_ops_COND_ADD8, alu_loc_ACCA, alu_loc_ACCA);
 end
 ADCB:
 begin
 decode_decode_mode8(alu_ops_ALU_ADDC, cond_ops_COND_ADD8, alu_loc_ACCB, alu_loc_ACCB);
 end
 ADDA:
 begin
 decode_decode_mode8(alu_ops_ALU_ADD, cond_ops_COND_ADD8, alu_loc_ACCA, alu_loc_ACCA);
 end
 ADDB:
 begin
 decode_decode_mode8(alu_ops_ALU_ADD, cond_ops_COND_ADD8, alu_loc_ACCB, alu_loc_ACCB);
 end
 ADDD:
 begin
 decode_decode_mode16(alu_ops_ALU_ADD, alu_ops_ALU_ADDC, cond_ops_COND_ADDLO, cond_ops_COND_ADD16, alu_loc_ACCB, alu_loc_ACCA, alu_loc_ACCB, alu_loc_ACCA);
 end
 ANDA:
 begin
 decode_decode_mode8(alu_ops_ALU_AND, cond_ops_COND_LOGIC8, alu_loc_ACCA, alu_loc_ACCA);
 end
 ANDB:
 begin
 decode_decode_mode8(alu_ops_ALU_AND, cond_ops_COND_LOGIC8, alu_loc_ACCB, alu_loc_ACCB);
 end
 ASL:
 begin
 decode_decode_rw8(alu_ops_ALU_LSL, cond_ops_COND_SHIFTL8, alu_loc_IMM8, alu_loc_ACCB);
 end
 ASR:
 begin
 decode_decode_rw8(alu_ops_ALU_ASR, cond_ops_COND_SHIFTR8, alu_loc_IMM8, alu_loc_ACCB);
 end
 BITA:
 begin
 decode_decode_mode8(alu_ops_ALU_AND, cond_ops_COND_LOGIC8, alu_loc_ACCA, alu_loc_ZERO);
 end
 BITB:
 begin
 decode_decode_mode8(alu_ops_ALU_AND, cond_ops_COND_LOGIC8, alu_loc_ACCB, alu_loc_ZERO);
 end
 CLR:
 begin
 decode_decode_rw8(alu_ops_ALU_PASS, cond_ops_COND_SHIFTL8, alu_loc_ZERO, alu_loc_IMM8);
 end
 CMPA:
 begin
 decode_decode_mode8(alu_ops_ALU_SUB, cond_ops_COND_SUB8, alu_loc_ACCA, alu_loc_ZERO);
 end
 CMPB:
 begin
 decode_decode_mode8(alu_ops_ALU_SUB, cond_ops_COND_SUB8, alu_loc_ACCB, alu_loc_ZERO);
 end
 COM:
 begin
 decode_decode_rw8(alu_ops_ALU_SUB, cond_ops_COND_NEG, alu_loc_NEGONE, alu_loc_IMM8);
 end
 SUBD:
 begin
 if (d_prefix === 1'b 0)
 begin
 decode_decode_mode16(alu_ops_ALU_SUB, alu_ops_ALU_SUBC, cond_ops_COND_SUB8, cond_ops_COND_SUB16, alu_loc_ACCB, alu_loc_ACCA, alu_loc_ACCB, alu_loc_ACCA);
 end
 else
 begin
 decode_decode_mode16(alu_ops_ALU_SUB, alu_ops_ALU_SUBC, cond_ops_COND_SUB8, cond_ops_COND_SUB16, alu_loc_ACCB, alu_loc_ACCA, alu_loc_ZERO, alu_loc_ZERO);
 end
 end
 CPI:
 begin
 if (y_prefix === d_prefix)
 begin
 decode_decode_mode16(alu_ops_ALU_SUB, alu_ops_ALU_SUBC, cond_ops_COND_SUB8, cond_ops_COND_SUB16, alu_loc_IX, alu_loc_IXH, alu_loc_ZERO, alu_loc_ZERO);
 end
 else
 begin
 decode_decode_mode16(alu_ops_ALU_SUB, alu_ops_ALU_SUBC, cond_ops_COND_SUB8, cond_ops_COND_SUB16, alu_loc_IY, alu_loc_IYH, alu_loc_ZERO, alu_loc_ZERO);
 end
 end
 DEC:
 begin
 decode_decode_rw8(alu_ops_ALU_SUB, cond_ops_COND_NZV, alu_loc_IMM8, alu_loc_ONE);
 end
 EORA:
 begin
 decode_decode_mode8(alu_ops_ALU_XOR, cond_ops_COND_LOGIC8, alu_loc_ACCA, alu_loc_ACCA);
 end
 EORB:
 begin
 decode_decode_mode8(alu_ops_ALU_XOR, cond_ops_COND_LOGIC8, alu_loc_ACCB, alu_loc_ACCB);
 end
 INC:
 begin
 decode_decode_rw8(alu_ops_ALU_ADD, cond_ops_COND_NZV, alu_loc_IMM8, alu_loc_ONE);
 end
 JMP:
 begin
 decode_decode_mode8(alu_ops_ALU_PASS, cond_ops_COND_PASS, alu_loc_ACCA, alu_loc_ZERO);
 end
 JSR:
 begin
 if (state === cpu_states_LOAD1)
 begin
 decode_spop_out = sp_ops_DEC_SP;
 decode_aluop_out = alu_ops_ALU_PASS;
 decode_aluin1_out = alu_loc_SPC;
 decode_alures_out = alu_loc_ALU_REG;
 end
 else if (state === cpu_states_WRITE )
 begin
 if (`mode === DIR)
 begin
 decode_even = 1'b 1;
 end
 else
 begin
 decode_even = 1'b 0;
 end
 if (micro_cnt[0] === decode_even)
 begin
 decode_spop_out = sp_ops_DEC_SP;
 decode_writebyte_out = 1'b 0;
 end
 else
 begin
 decode_writebyte_out = 1'b 1;
 end
 end
 end
 LDAA:
 begin 
decode_decode_mode8(alu_ops_ALU_PASS2, cond_ops_COND_LOGIC8, alu_loc_ACCA, alu_loc_ACCA);
 end
 LDAB:
 begin
 decode_decode_mode8(alu_ops_ALU_PASS2, cond_ops_COND_LOGIC8, alu_loc_ACCA, alu_loc_ACCB);
 end
 LDD:
 begin
 decode_decode_load16(alu_loc_ACCD);
 end
 LDS:
 begin
 if (state === cpu_states_FETCH1)
 begin
 decode_spop_out = sp_ops_SET_SP;
 decode_aluin1_out = alu_loc_IMM16;
 decode_aluop_out = alu_ops_ALU_PASS;
 decode_condop_out = cond_ops_COND_LOAD16;
 end
 end
 LDI:
 begin
 if (y_prefix === d_prefix)
 begin
 decode_decode_load16(alu_loc_IX);
 end
 else
 begin
 decode_decode_load16(alu_loc_IY);
 end
 end
 LSR:
 begin
 decode_decode_rw8(alu_ops_ALU_LSR, cond_ops_COND_SHIFTR8, alu_loc_IMM8, alu_loc_ACCB);
 end
 NEG:
 begin
 decode_decode_rw8(alu_ops_ALU_SUB, cond_ops_COND_SUB8, alu_loc_ZERO, alu_loc_IMM8);
 end
 ORA:
 begin
 decode_decode_mode8(alu_ops_ALU_OR, cond_ops_COND_LOGIC8, alu_loc_ACCA, alu_loc_ACCA);
 end
 ORB:
 begin
 decode_decode_mode8(alu_ops_ALU_OR, cond_ops_COND_LOGIC8, alu_loc_ACCB, alu_loc_ACCB);
 end
 ROLc:
 begin
 decode_decode_rw8(alu_ops_ALU_ROL, cond_ops_COND_SHIFTL8, alu_loc_IMM8, alu_loc_ACCB);
 end
 RORc:
 begin
 decode_decode_rw8(alu_ops_ALU_ROR, cond_ops_COND_SHIFTR8, alu_loc_IMM8, alu_loc_ACCB);
 end
 SBCA:
 begin
 decode_decode_mode8(alu_ops_ALU_SUBC, cond_ops_COND_SUB8, alu_loc_ACCA, alu_loc_ACCA);
 end
 SBCB:
 begin
 decode_decode_mode8(alu_ops_ALU_SUBC, cond_ops_COND_SUB8, alu_loc_ACCB, alu_loc_ACCB);
 end
 STAA:
 begin
 if (state === cpu_states_WRITE)
 begin
 decode_aluin1_out = alu_loc_ACCA;
 decode_aluop_out = alu_ops_ALU_PASS;
 decode_alures_out = alu_loc_BUS_DATA;
 decode_condop_out = cond_ops_COND_LOGIC8;
 end
 end
 STAB:
 begin
 if (state === cpu_states_WRITE)
 begin
 decode_aluin1_out = alu_loc_ACCB;
 decode_aluop_out = alu_ops_ALU_PASS;
 decode_alures_out = alu_loc_BUS_DATA;
 decode_condop_out = cond_ops_COND_LOGIC8;
 end
 end
 STD:
 begin
 decode_decode_store16(alu_loc_ACCD);
 end
 STS:
 begin
 decode_decode_store16(alu_loc_SSP);
 end
 STI:
 begin
 if (y_prefix === d_prefix)
 begin
 decode_decode_store16(alu_loc_IX);
 end
 else
 begin
 decode_decode_store16(alu_loc_IY);
 end
 end
 SUBA:
 begin
 decode_decode_mode8(alu_ops_ALU_SUB, cond_ops_COND_SUB8, alu_loc_ACCA, alu_loc_ACCA);
 end
 SUBB:
 begin
 decode_decode_mode8(alu_ops_ALU_SUB, cond_ops_COND_SUB8, alu_loc_ACCB, alu_loc_ACCB);
 end
 TST:
 begin
 decode_decode_rw8(alu_ops_ALU_SUB, cond_ops_COND_SUB8, alu_loc_IMM8, alu_loc_ZERO);
 end
 default:
 ;
 endcase
 end
 endcase
 sp_op <= decode_spop_out;
 alu_op <= decode_aluop_out;
 cond_op <= decode_condop_out;
 alu_res <= decode_alures_out;
 alu_in1 <= decode_aluin1_out;
 alu_in2 <= decode_aluin2_out;
 write_byte <= decode_writebyte_out;
end

task alu_calc_dec_adj;
 input [7:0] a;
 output [7:0] ret;
 output carry;

 reg valid_lo;
 reg valid_hi;
 reg half_carry;
 begin
 begin
 valid_lo = a[3:0] <= 9;
 valid_hi = a[7:4] <= 9;
 half_carry = CCR[HBIT] == 1'b 1;
 if (CCR[CBIT] === 1'b 1)
 begin
 if (half_carry | ~valid_lo)
 begin
 ret = 8'b 01100110;
 end
 else
 begin
 ret = 8'b 01100000;
 end
 carry = 1'b 1;
 end
 else
 begin
 if (valid_lo & valid_hi & ~half_carry)
 begin
 ret = 8'b 00000000;
 carry = 1'b 0;
 end
 else if (valid_hi & half_carry )
 begin
 ret = 8'b 00000110;
 carry = 1'b 0;
 end
 else if (~valid_lo & ~half_carry )
 begin
 if (~valid_hi | a[7:4] === 9)
 begin
 ret = 8'b 01100110;
 carry = 1'b 1;
 end
 else
 begin
 ret = 8'b 00000110;
 carry = 1'b 0;
 end
 end
 else if (half_carry )
 begin
 ret = 8'b 01100110;
 carry = 1'b 1;
 end
 else
 begin
 ret = 8'b 01100000;
 carry = 1'b 1;
 end
 end
 end
 end
endtask


always @(alu_op or cond_op or alu_in1 or alu_in2 or A
 or B or X or Y or PC or SP
 or CCR or prev_data or datain or alureg)
begin : alu
 alu_in1hi = 9'b 000000000;
 case (alu_in1)
 alu_loc_ZERO:
 begin
 alu_in1 = 9'b 000000000;
 end
 alu_loc_ONE:
 begin
 alu_in1 = 9'b 000000001;
 end
 alu_loc_NEGONE:
 begin
 alu_in1 = 9'b 111111111;
 end
 alu_loc_BIT1:
 begin
 alu_in1 = 9'b 000000010;
 end
 alu_loc_BIT4:
 begin
 alu_in1 = 9'b 000010000;
 end
 alu_loc_ACCA:
 begin
 alu_in1 = {1'b 0, A};
 end
 alu_loc_ACCB:
 begin
 alu_in1 = {1'b 0, B};
 end
 alu_loc_ACCD:
 begin
 alu_in1hi = {1'b 0, A};
 alu_in1 = {1'b 0, B};
 end
 alu_loc_IX:
 begin
 alu_in1hi = {1'b 0, X[15:8]};
 alu_in1 = {1'b 0, X[7:0]};
 end
 alu_loc_IY:
 begin
 alu_in1hi = {1'b 0, Y[15:8]};
 alu_in1 = {1'b 0, Y[7:0]};
 end
 alu_loc_IXH:
 begin
 alu_in1 = {1'b 0, X[15:8]};
 end
 alu_loc_IYH:
 begin
 alu_in1 = {1'b 0, Y[15:8]};
 end
 alu_loc_SPC:
 begin
 alu_in1 = {1'b 0, PC[7:0]};
 alu_in1hi = {1'b 0, PC[15:8]};
 end
 alu_loc_SSP:
 begin
 alu_in1 = {1'b 0, SP[7:0]};
 alu_in1hi = {1'b 0, SP[15:8]};
 end
 alu_loc_SCCR:
 begin
 alu_in1 = {1'b 0, CCR};
 end
 alu_loc_IMM8:
 begin
 alu_in1 = {1'b 0, datain};
 end
 alu_loc_ANT_IMM8:
 begin
 alu_in1 = {1'b 0, prev_data};
 end
 alu_loc_IMM16:
 begin
 alu_in1 = {1'b 0, datain};
 alu_in1hi = {1'b 0, prev_data};
 end
 alu_loc_ALU_REG:
 begin
 alu_in1 = {1'b 0, alureg[7:0]};
 alu_in1hi = {1'b 0, alureg[15:8]};
 end
 default:
 begin
 alu_in1 = 9'b 000000000;
 end
 endcase
 alu_carry_out = 1'b 0;
 case (alu_in2)
 alu_loc_ZERO:
 begin
 alu_in2 = 9'b 000000000;
 end
 alu_loc_ONE:
 begin
 alu_in2 = 9'b 000000001;
 end
 alu_loc_ACCA:
 begin
 alu_in2 = {1'b 0, A};
 end
 alu_loc_ACCB:
 begin
 alu_in2 = {1'b 0, B};
 end
 alu_loc_IMM8:
 begin
 alu_in2 = {1'b 0, datain};
 end
 alu_loc_ANT_IMM8:
 begin
 alu_in2 = {1'b 0, prev_data};
 end
 alu_loc_ALU_REG:
 begin
 alu_in2 = {1'b 0, alureg[7:0]};

 //
 // when DEC_ADJ =>
 // in2(8) := '0';
 // calc_dec_adj(in1(7 downto 0),in2(7 downto 0),carry_out);
 //
 end
 alu_loc_MULOP:
 begin
 if (B[0] === 1'b 1)
 begin
 alu_in2 = {1'b 0, A};
 end
 else
 begin
 alu_in2 = 9'b 000000000;
 end
 end
 default:
 begin
 alu_in2 = 9'b 000000000;
 end
 endcase
 case (alu_op)
 alu_ops_ALU_ADDC,
 alu_ops_ALU_SUBC,
 alu_ops_ALU_LSL16,
 alu_ops_ALU_LSR16,
 alu_ops_ALU_ROL,
 alu_ops_ALU_ROR:
 begin
 alu_carry_in = CCR[CBIT:CBIT];
 end
 default:
 begin
 alu_carry_in = 1'b 0;
 end
 endcase
 case (alu_op)
 alu_ops_ALU_PASS,
 alu_ops_ALU_LSR,
 alu_ops_ALU_LSR16,
 alu_ops_ALU_ROR:
begin
alu_alu_out = alu_in1;
end
 alu_ops_ALU_PASS2:
 begin
 alu_alu_out = alu_in2;
 end
 alu_ops_ALU_ADD,
 alu_ops_ALU_MUL,
 alu_ops_ALU_ADDC,
 alu_ops_ALU_SADD16:
 begin
 alu_alu_out = alu_in1 + alu_in2 + alu_carry_in;
 end
 alu_ops_ALU_SUB,
 alu_ops_ALU_SUBC:
 begin
alu_alu_out = alu_in1 - alu_in2 - alu_carry_in;
 end
 alu_ops_ALU_AND:
 begin
 alu_alu_out = alu_in1 & alu_in2;
 end
 alu_ops_ALU_OR:
 begin
 alu_alu_out = alu_in1 | alu_in2;
 end
 alu_ops_ALU_XOR:
 begin
 alu_alu_out = alu_in1 ^ alu_in2;
 end
 alu_ops_ALU_LSL,
 alu_ops_ALU_LSL16,
 alu_ops_ALU_ROL:
 begin
 alu_alu_out = {alu_in1[7:0], alu_carry_in};
 end
 alu_ops_ALU_ASR:
 begin
 alu_alu_out = {alu_carry_in, alu_in1[7], alu_in1[7:1]};
 end
 alu_ops_ALU_CLR:
 begin
 alu_alu_out = alu_in1 & ~alu_in2;
 end
 endcase
 if (alu_alu_out[8] === 1'b 1)
 begin
 case (alu_op)
 alu_ops_ALU_SADD16:
 begin
 if (alu_in2[7] === 1'b 0)
 begin
 alu_alu_hi_out = alu_in1hi + 1;
 end
 else
 begin
 alu_alu_hi_out = alu_in1hi;
 end
 end
 alu_ops_ALU_ADD,
 alu_ops_ALU_MUL,
 alu_ops_ALU_ADDC:
 begin
 alu_alu_hi_out = alu_in1hi + 1;
 end
 alu_ops_ALU_SUB:
 begin
 alu_alu_hi_out = alu_in1hi - 1;
 end
 default:
 begin
 alu_alu_hi_out = alu_in1hi;
 end
 endcase
 end
 else if (alu_op === alu_ops_ALU_SADD16 & alu_in2[7] === 1'b 1 )
 begin
 alu_alu_hi_out = alu_in1hi - 1;
 end
 else
 begin
 alu_alu_hi_out = alu_in1hi;
 end
 alu_alu_int_out = alu_alu_out;
 if (alu_op === alu_ops_ALU_LSR | alu_op === alu_ops_ALU_LSR16 |
 alu_op === alu_ops_ALU_MUL | alu_op === alu_ops_ALU_ROR)
 begin
 alu_alu_out = {1'b 0, alu_carry_in, alu_alu_out[7:1]};
 end
 alu_cond_out = CCR;
 case (cond_op)
 cond_ops_COND_PASS,
 cond_ops_COND_CLR,
 cond_ops_COND_SET,
 cond_ops_COND_MUL,
 cond_ops_COND_RESTORE:
 ;
 cond_ops_COND_ADD8,
 cond_ops_COND_LOGIC8,
 cond_ops_COND_SHIFTL8,
 cond_ops_COND_SHIFTR8,
 cond_ops_COND_SUB8,
 cond_ops_COND_NEG,
 cond_ops_COND_DA,
 cond_ops_COND_NZV,
 cond_ops_COND_ADDLO:
 begin
 alu_cond_out[NBIT] = alu_alu_out[7];
 if (alu_alu_out[7:0] === 8'b 00000000)
 begin
 alu_cond_out[ZBIT] = 1'b 1;
 end
 else
 begin
 alu_cond_out[ZBIT] = 1'b 0;
 end
 end
 cond_ops_COND_ADD16,
 cond_ops_COND_SUB16,
 cond_ops_COND_SHIFTL16:
 begin
 alu_cond_out[NBIT] = alu_alu_out[7];
 if (CCR[ZBIT] === 1'b 1 & alu_alu_out[7:0] === 8'b 00000000)
 begin
 alu_cond_out[ZBIT] = 1'b 1;
 end
 else
 begin
 alu_cond_out[ZBIT] = 1'b 0;
 end
 end
 cond_ops_COND_SHIFTR16:
 begin
 alu_cond_out[NBIT] = 1'b 0;
 if (CCR[ZBIT] === 1'b 1 & alu_alu_out[7:0] === 8'b 00000000)
 begin
 alu_cond_out[ZBIT] = 1'b 1;
 end
 else
 begin
 alu_cond_out[ZBIT] = 1'b 0;
 end
 end
 cond_ops_COND_Z16,
 cond_ops_COND_LOAD16:
 begin
 if (alu_alu_out[7:0] === 9'b 000000000 & alu_alu_hi_out[7:0] === 8'b 00000000)
 begin
 alu_cond_out[ZBIT] = 1'b 1;
 end
 else
 begin
 alu_cond_out[ZBIT] = 1'b 0;
 end
 end
 endcase
 case (cond_op)
 cond_ops_COND_PASS:
 ;
 cond_ops_COND_ADD8:
 begin
 alu_cond_out[HBIT] = alu_in1[3] & alu_in2[3] | alu_in2[3] & ~alu_alu_out[3] |
 ~alu_alu_out[3] & alu_in1[3];
 alu_cond_out[VBIT] = alu_in1[7] & alu_in2[7] & ~alu_alu_out[7] | ~alu_in1[7] &
 ~alu_in2[7] & alu_alu_out[7];
 alu_cond_out[CBIT] = alu_in1[7] & alu_in2[7] | alu_in2[7] & ~alu_alu_out[7] |
 ~alu_alu_out[7] & alu_in1[7];
 end
 cond_ops_COND_SUB8,
 cond_ops_COND_SUB16:
 begin
 alu_cond_out[VBIT] = alu_in1[7] & ~alu_in2[7] & ~alu_alu_out[7] | ~alu_in1[7] &
 alu_in2[7] & alu_alu_out[7];
 alu_cond_out[CBIT] = ~alu_in1[7] & alu_in2[7] | alu_in2[7] & alu_alu_out[7] |
 alu_alu_out[7] & ~alu_in1[7];
 end
 cond_ops_COND_NZV:
 begin
 alu_cond_out[VBIT] = alu_in1[7] & ~alu_in2[7] & ~alu_alu_out[7] | ~alu_in1[7] &
 alu_in2[7] & alu_alu_out[7];
 end
 cond_ops_COND_LOGIC8:
 begin
 alu_cond_out[VBIT] = 1'b 0;
 end
 cond_ops_COND_SHIFTL8,
 cond_ops_COND_SHIFTL16:
 begin
 alu_cond_out[CBIT] = alu_in1[7];
 alu_cond_out[VBIT] = alu_cond_out[NBIT] ^ alu_cond_out[CBIT];
 end
 cond_ops_COND_SHIFTR8,
 cond_ops_COND_SHIFTR16:
 begin
 alu_cond_out[CBIT] = alu_in1[0];
 alu_cond_out[VBIT] = alu_cond_out[NBIT] ^ alu_cond_out[CBIT];
 end
 cond_ops_COND_ADD16,
 cond_ops_COND_ADDLO:
 begin
 alu_cond_out[VBIT] = alu_in1[7] & alu_in2[7] & ~alu_alu_out[7] | ~alu_in1[7] &
 ~alu_in2[7] & alu_alu_out[7];
 alu_cond_out[CBIT] = alu_in1[7] & alu_in2[7] | alu_in2[7] & ~alu_alu_out[7] |
 ~alu_alu_out[7] & alu_in1[7];
 end
 cond_ops_COND_CLR:
 begin
 alu_cond_out = CCR & ~alu_in1[7:0];
 end
 cond_ops_COND_SET:
 begin
 alu_cond_out = CCR | alu_in1[7:0];
 end
 cond_ops_COND_NEG:
 begin
 alu_cond_out[VBIT] = 1'b 0;
 alu_cond_out[CBIT] = 1'b 1;
 end
 cond_ops_COND_DA:
 begin
 alu_cond_out[CBIT] = alu_carry_out;
 end
 cond_ops_COND_MUL:
 begin
 alu_cond_out[CBIT] = alu_alu_int_out[0];
 end
 cond_ops_COND_Z16:
 ;
 cond_ops_COND_LOAD16:
 begin
 alu_cond_out[NBIT] = alu_alu_hi_out[7];
 alu_cond_out[VBIT] = 1'b 0;
 end
 cond_ops_COND_RESTORE:
 begin
 alu_cond_out[SBIT] = alu_in1[SBIT];
 alu_cond_out[XBIT] = alu_cond_out[XBIT] & alu_in1[XBIT];
 alu_cond_out[HBIT] = alu_in1[HBIT];
 alu_cond_out[IBIT] = alu_in1[IBIT];
 alu_cond_out[NBIT] = alu_in1[NBIT];
 alu_cond_out[ZBIT] = alu_in1[ZBIT];
 alu_cond_out[VBIT] = alu_in1[VBIT];
 alu_cond_out[CBIT] = alu_in1[CBIT];
 end
 endcase
 alucond <= alu_cond_out;
 aluout <= {alu_alu_hi_out[7:0], alu_alu_out[7:0]};
 alu_int <= alu_alu_int_out;
end


always @(opcode or CCR or alureg)
begin : decode_branch
 case (opcode)
 BCC:
 begin
 branch <= ~CCR[CBIT];
 end
 BCS:
 begin
 branch <= CCR[CBIT];
 end
 BEQ:
 begin
 branch <= CCR[ZBIT];
 end
 BGE:
 begin
 branch <= ~(CCR[NBIT] ^ CCR[VBIT]);
 end
 BGT:
 begin
 branch <= ~(CCR[ZBIT] | CCR[NBIT] ^ CCR[VBIT]);
 end
 BHI:
 begin
 branch <= ~(CCR[CBIT] | CCR[ZBIT]);
 end
 BLE:
 begin
 branch <= CCR[ZBIT] | CCR[NBIT] ^ CCR[VBIT];
 end
 BLS:
 begin
 branch <= CCR[CBIT] | CCR[ZBIT];
 end
 BLT:
 begin
 branch <= CCR[NBIT] ^ CCR[VBIT];
 end
 BMI:
 begin
 branch <= CCR[NBIT];
 end
 BNE:
 begin
 branch <= ~CCR[ZBIT];
 end
 BPL:
 begin
 branch <= ~CCR[NBIT];
 end
 BRA:
 begin
 branch <= 1'b 1;
 end
 BVC:
 begin
 branch <= ~CCR[VBIT];
 end
 BVS:
 begin
 branch <= CCR[VBIT];
 end
 BRCLR_DIR,
 BRCLR_IND,
 BRSET_DIR,
 BRSET_IND:
 begin
 if (alureg[7:0] === 8'b 00000000)
 begin
 branch <= 1'b 1;
 end
 else
 begin
 branch <= 1'b 0;
 end
 end
 BRN:
 begin
 branch <= 1'b 0;
 end
 default:
 begin
 branch <= 1'b 0;
 end
 endcase
end


always @(posedge reset or negedge E)
begin : process_7
 if (reset === 1'b 1)
 begin
 A <= 8'b 00000001;
end
 else
 begin
 if (alu_res === alu_loc_ACCA)
 begin
 A <= aluout[7:0];
 end
 else if (alu_res === alu_loc_ACCD )
 begin
 A <= aluout[15:8];
 end
 end
end


always @(posedge reset or negedge E)
begin : process_8
 if (reset === 1'b 1)
 begin
 B <= 8'b 00000010;
 end
 else
 begin
 if (alu_res === alu_loc_ACCB | alu_res === alu_loc_ACCD)
 begin
 B <= aluout[7:0];
 end
 else if (shift_b === 1'b 1 )
 begin
 B <= {alu_int[0], B[7:1]};
 end
 end
end


always @(posedge reset or negedge E)
begin : process_9
 if (reset === 1'b 1)
 begin
 X <= 16'b 0000000000000011;
 end
 else
 begin
 if (alu_res === alu_loc_IX)
 begin
 X <= aluout;
 end
 end
end


always @(posedge reset or negedge E)
begin : process_10
 if (reset === 1'b 1)
 begin
 Y <= 16'b 0000000000000100;
 end
 else
 begin
 if (alu_res === alu_loc_IY)
 begin
 Y <= aluout;
 end
 end
end


always @(posedge reset or negedge E)
begin : process_11
 if (reset === 1'b 1)
 begin
 alureg <= 16'b 0000000000000100;
 end
 else
 begin
 if (alu_res === alu_loc_ALU_REG)
 begin
 alureg <= aluout;
 end
 end
end


always @(posedge reset or negedge E)
begin : process_12
 if (reset === 1'b 1)
 begin
 CCR <= 8'b 11010000;
 end
 else
 begin
 CCR <= alucond;
 end
end


always @(posedge reset or negedge E)
begin : process_13
 if (reset === 1'b 1)
 begin
 SP <= 16'b 0000000011111111;
 end
 else
 begin
 case (sp_op)
 sp_ops_PASS_SP:
 ;
 sp_ops_SET_SP:
 begin
 SP <= aluout;
 end
 sp_ops_INC_SP:
 begin
 SP <= SP + 1;
 end
 sp_ops_DEC_SP:
 begin
 SP <= SP - 1;
 end
 endcase
 end
end


always @(ph1 or state)
begin : process_14
 if (ph1 === 1'b 0 & (state === cpu_states_WRITE |
 state === cpu_states_WRITE2))
 begin
 rw_i <= 1'b 1;
 end
 else
 begin
 rw_i <= 1'b 0;
 end
end

assign rw = ~rw_i;

always @(alu_res or write_byte or alureg or aluout)
begin : process_15
 if (alu_res === alu_loc_BUS_DATA)
 begin
 if (write_byte === 1'b 0)
 begin
 write_data <= aluout[7:0];
 end
 else
 begin
 write_data <= aluout[15:8];
 end
 end
 else if (write_byte === 1'b 0 )
 begin
 write_data <= alureg[7:0];
 end
 else
 begin
 write_data <= alureg[15:8];
 end
end

assign address = address_i;
assign CCR_X = CCR[XBIT];
assign CCR_I = CCR[IBIT];

// debug_cycle <= std_logic_vector(to_unsigned(cpu_states'pos(state),6));
assign debug_micro = micro_cnt;
assign debug_A = A;
assign debug_B = B;
assign debug_X = X;
assign debug_Y = Y;
assign debug_CCR = CCR;
assign debug_SP = SP;

endmodule // module hc11cpu

