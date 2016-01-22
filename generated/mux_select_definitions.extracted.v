// Mux definitions for pc

//  pc_next

parameter NANORV32_MUX_SEL_PC_NEXT_SIZE = 1;
parameter NANORV32_MUX_SEL_PC_NEXT_MSB = 0;
 
parameter NANORV32_MUX_SEL_PC_NEXT_COND_PC_PLUS_IMMSB = 0;
parameter NANORV32_MUX_SEL_PC_NEXT_PLUS4 = 1;
// Mux definitions for alu

//  alu_op

parameter NANORV32_MUX_SEL_ALU_OP_SIZE = 3;
parameter NANORV32_MUX_SEL_ALU_OP_MSB = 2;
 
parameter NANORV32_MUX_SEL_ALU_OP_AND = 0;
parameter NANORV32_MUX_SEL_ALU_OP_XOR = 1;
parameter NANORV32_MUX_SEL_ALU_OP_SUB = 2;
parameter NANORV32_MUX_SEL_ALU_OP_COMP = 3;
parameter NANORV32_MUX_SEL_ALU_OP_ADD = 4;
parameter NANORV32_MUX_SEL_ALU_OP_NOOP = 5;
parameter NANORV32_MUX_SEL_ALU_OP_OR = 6;
parameter NANORV32_MUX_SEL_ALU_OP_ADDI = 7;
//  alu_portb

parameter NANORV32_MUX_SEL_ALU_PORTB_SIZE = 3;
parameter NANORV32_MUX_SEL_ALU_PORTB_MSB = 2;
 
parameter NANORV32_MUX_SEL_ALU_PORTB_SHAMT = 0;
parameter NANORV32_MUX_SEL_ALU_PORTB_IMM12 = 1;
parameter NANORV32_MUX_SEL_ALU_PORTB_IMM12HILO = 2;
parameter NANORV32_MUX_SEL_ALU_PORTB_IMM20U = 3;
parameter NANORV32_MUX_SEL_ALU_PORTB_IMM20UJ = 4;
parameter NANORV32_MUX_SEL_ALU_PORTB_RS2 = 5;
//  alu_porta

parameter NANORV32_MUX_SEL_ALU_PORTA_SIZE = 1;
parameter NANORV32_MUX_SEL_ALU_PORTA_MSB = 0;
 
parameter NANORV32_MUX_SEL_ALU_PORTA_PC = 0;
parameter NANORV32_MUX_SEL_ALU_PORTA_RS1 = 1;
// Mux definitions for datamem

//  datamem_write

parameter NANORV32_MUX_SEL_DATAMEM_WRITE_SIZE = 1;
parameter NANORV32_MUX_SEL_DATAMEM_WRITE_MSB = 0;
 
parameter NANORV32_MUX_SEL_DATAMEM_WRITE_WORD = 0;
parameter NANORV32_MUX_SEL_DATAMEM_WRITE_NO = 1;
//  datamem_read

parameter NANORV32_MUX_SEL_DATAMEM_READ_SIZE = 1;
parameter NANORV32_MUX_SEL_DATAMEM_READ_MSB = 0;
 
parameter NANORV32_MUX_SEL_DATAMEM_READ_YES = 0;
parameter NANORV32_MUX_SEL_DATAMEM_READ_NO = 1;
// Mux definitions for regfile

//  regfile_source

parameter NANORV32_MUX_SEL_REGFILE_SOURCE_SIZE = 1;
parameter NANORV32_MUX_SEL_REGFILE_SOURCE_MSB = 0;
 
parameter NANORV32_MUX_SEL_REGFILE_SOURCE_NEXT_PC = 0;
parameter NANORV32_MUX_SEL_REGFILE_SOURCE_ALU = 1;
//  regfile_write

parameter NANORV32_MUX_SEL_REGFILE_WRITE_SIZE = 1;
parameter NANORV32_MUX_SEL_REGFILE_WRITE_MSB = 0;
 
parameter NANORV32_MUX_SEL_REGFILE_WRITE_YES = 0;
parameter NANORV32_MUX_SEL_REGFILE_WRITE_NO = 1;