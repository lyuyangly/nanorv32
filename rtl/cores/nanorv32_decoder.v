//****************************************************************************/
//  Nanorv32 CPU
//  RTL IMPLEMENTATION, Synchronous Version
//
//  Copyright (C) yyyy  Ronan Barzic - rbarzic@gmail.com
//  Date            :  Tue Mar  1 08:19:03 2016
//
//  This program is free software; you can redistribute it and/or
//  modify it under the terms of the GNU General Public License
//  as published by the Free Software Foundation; either version 2
//  of the License, or (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program; if not, write to the Free Software
//  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,MA 02110-1301,USA.
//
//
//  Filename        :  nanorv32_decoder.v
//
//  Description     :   Instruction decoder for the Nanorv32 core
//                      Note : most of the code is generated
//
//
//
//****************************************************************************/


module nanorv32_decoder (/*AUTOARG*/
   // Outputs
   illegal_instruction, pc_next_sel, alu_op_sel, alu_portb_sel,
   alu_porta_sel, datamem_size_read_sel, datamem_write_sel,
   datamem_size_write_sel, datamem_read_sel, regfile_source_sel,
   regfile_write_sel,
   // Inputs
   instruction_r
   );


`include "nanorv32_parameters.v"


   output illegal_instruction;
   input  [NANORV32_INSTRUCTION_MSB:0]instruction_r;

   //@begin[mux_select_declarations_as_output]

    output  [NANORV32_MUX_SEL_PC_NEXT_MSB:0] pc_next_sel;
    output  [NANORV32_MUX_SEL_ALU_OP_MSB:0] alu_op_sel;
    output  [NANORV32_MUX_SEL_ALU_PORTB_MSB:0] alu_portb_sel;
    output  [NANORV32_MUX_SEL_ALU_PORTA_MSB:0] alu_porta_sel;
    output  [NANORV32_MUX_SEL_DATAMEM_SIZE_READ_MSB:0] datamem_size_read_sel;
    output  [NANORV32_MUX_SEL_DATAMEM_WRITE_MSB:0] datamem_write_sel;
    output  [NANORV32_MUX_SEL_DATAMEM_SIZE_WRITE_MSB:0] datamem_size_write_sel;
    output  [NANORV32_MUX_SEL_DATAMEM_READ_MSB:0] datamem_read_sel;
    output  [NANORV32_MUX_SEL_REGFILE_SOURCE_MSB:0] regfile_source_sel;
    output  [NANORV32_MUX_SEL_REGFILE_WRITE_MSB:0] regfile_write_sel;
   //@end[mux_select_declarations_as_output]

   /*AUTOINPUT*/
   /*AUTOOUTPUT*/

   /*AUTOREG*/
   // Beginning of automatic regs (for this module's undeclared outputs)
   reg			illegal_instruction;
   // End of automatics
   /*AUTOWIRE*/

   //@begin[mux_select_declarations]

    reg  [NANORV32_MUX_SEL_PC_NEXT_MSB:0] pc_next_sel;
    reg  [NANORV32_MUX_SEL_ALU_OP_MSB:0] alu_op_sel;
    reg  [NANORV32_MUX_SEL_ALU_PORTB_MSB:0] alu_portb_sel;
    reg  [NANORV32_MUX_SEL_ALU_PORTA_MSB:0] alu_porta_sel;
    reg  [NANORV32_MUX_SEL_DATAMEM_SIZE_READ_MSB:0] datamem_size_read_sel;
    reg  [NANORV32_MUX_SEL_DATAMEM_WRITE_MSB:0] datamem_write_sel;
    reg  [NANORV32_MUX_SEL_DATAMEM_SIZE_WRITE_MSB:0] datamem_size_write_sel;
    reg  [NANORV32_MUX_SEL_DATAMEM_READ_MSB:0] datamem_read_sel;
    reg  [NANORV32_MUX_SEL_REGFILE_SOURCE_MSB:0] regfile_source_sel;
    reg  [NANORV32_MUX_SEL_REGFILE_WRITE_MSB:0] regfile_write_sel;
   //@end[mux_select_declarations]


   always @* begin
      illegal_instruction = 0;
      casez(instruction_r[NANORV32_INSTRUCTION_MSB:0])
        //@begin[instruction_decoder]
    NANORV32_DECODE_AND: begin
        pc_next_sel = NANORV32_MUX_SEL_PC_NEXT_PLUS4;
        alu_op_sel = NANORV32_MUX_SEL_ALU_OP_AND;
        alu_portb_sel = NANORV32_MUX_SEL_ALU_PORTB_RS2;
        alu_porta_sel = NANORV32_MUX_SEL_ALU_PORTA_RS1;
        datamem_size_read_sel = NANORV32_MUX_SEL_DATAMEM_SIZE_READ_WORD;
        datamem_write_sel = NANORV32_MUX_SEL_DATAMEM_WRITE_NO;
        datamem_size_write_sel = NANORV32_MUX_SEL_DATAMEM_SIZE_WRITE_WORD;
        datamem_read_sel = NANORV32_MUX_SEL_DATAMEM_READ_NO;
        regfile_source_sel = NANORV32_MUX_SEL_REGFILE_SOURCE_ALU;
        regfile_write_sel = NANORV32_MUX_SEL_REGFILE_WRITE_YES;
    end
    NANORV32_DECODE_LBU: begin
        pc_next_sel = NANORV32_MUX_SEL_PC_NEXT_PLUS4;
        alu_op_sel = NANORV32_MUX_SEL_ALU_OP_ADD;
        alu_portb_sel = NANORV32_MUX_SEL_ALU_PORTB_IMM12;
        alu_porta_sel = NANORV32_MUX_SEL_ALU_PORTA_RS1;
        datamem_size_read_sel = NANORV32_MUX_SEL_DATAMEM_SIZE_READ_BYTE_UNSIGNED;
        datamem_write_sel = NANORV32_MUX_SEL_DATAMEM_WRITE_NO;
        datamem_size_write_sel = NANORV32_MUX_SEL_DATAMEM_SIZE_WRITE_WORD;
        datamem_read_sel = NANORV32_MUX_SEL_DATAMEM_READ_YES;
        regfile_source_sel = NANORV32_MUX_SEL_REGFILE_SOURCE_DATAMEM;
        regfile_write_sel = NANORV32_MUX_SEL_REGFILE_WRITE_YES;
    end
    NANORV32_DECODE_FENCE: begin
        pc_next_sel = NANORV32_MUX_SEL_PC_NEXT_PLUS4;
        alu_op_sel = NANORV32_MUX_SEL_ALU_OP_NOOP;
        alu_portb_sel = NANORV32_MUX_SEL_ALU_PORTB_RS2;
        alu_porta_sel = NANORV32_MUX_SEL_ALU_PORTA_RS1;
        datamem_size_read_sel = NANORV32_MUX_SEL_DATAMEM_SIZE_READ_WORD;
        datamem_write_sel = NANORV32_MUX_SEL_DATAMEM_WRITE_NO;
        datamem_size_write_sel = NANORV32_MUX_SEL_DATAMEM_SIZE_WRITE_WORD;
        datamem_read_sel = NANORV32_MUX_SEL_DATAMEM_READ_NO;
        regfile_source_sel = NANORV32_MUX_SEL_REGFILE_SOURCE_ALU;
        regfile_write_sel = NANORV32_MUX_SEL_REGFILE_WRITE_NO;
    end
    NANORV32_DECODE_SW: begin
        pc_next_sel = NANORV32_MUX_SEL_PC_NEXT_PLUS4;
        alu_op_sel = NANORV32_MUX_SEL_ALU_OP_ADD;
        alu_portb_sel = NANORV32_MUX_SEL_ALU_PORTB_IMM12HILO;
        alu_porta_sel = NANORV32_MUX_SEL_ALU_PORTA_RS1;
        datamem_size_read_sel = NANORV32_MUX_SEL_DATAMEM_SIZE_READ_WORD;
        datamem_write_sel = NANORV32_MUX_SEL_DATAMEM_WRITE_YES;
        datamem_size_write_sel = NANORV32_MUX_SEL_DATAMEM_SIZE_WRITE_WORD;
        datamem_read_sel = NANORV32_MUX_SEL_DATAMEM_READ_NO;
        regfile_source_sel = NANORV32_MUX_SEL_REGFILE_SOURCE_ALU;
        regfile_write_sel = NANORV32_MUX_SEL_REGFILE_WRITE_NO;
    end
    NANORV32_DECODE_BLTU: begin
        pc_next_sel = NANORV32_MUX_SEL_PC_NEXT_COND_PC_PLUS_IMMSB;
        alu_op_sel = NANORV32_MUX_SEL_ALU_OP_LT_UNSIGNED;
        alu_portb_sel = NANORV32_MUX_SEL_ALU_PORTB_RS2;
        alu_porta_sel = NANORV32_MUX_SEL_ALU_PORTA_RS1;
        datamem_size_read_sel = NANORV32_MUX_SEL_DATAMEM_SIZE_READ_WORD;
        datamem_write_sel = NANORV32_MUX_SEL_DATAMEM_WRITE_NO;
        datamem_size_write_sel = NANORV32_MUX_SEL_DATAMEM_SIZE_WRITE_WORD;
        datamem_read_sel = NANORV32_MUX_SEL_DATAMEM_READ_NO;
        regfile_source_sel = NANORV32_MUX_SEL_REGFILE_SOURCE_ALU;
        regfile_write_sel = NANORV32_MUX_SEL_REGFILE_WRITE_NO;
    end
    NANORV32_DECODE_XOR: begin
        pc_next_sel = NANORV32_MUX_SEL_PC_NEXT_PLUS4;
        alu_op_sel = NANORV32_MUX_SEL_ALU_OP_XOR;
        alu_portb_sel = NANORV32_MUX_SEL_ALU_PORTB_RS2;
        alu_porta_sel = NANORV32_MUX_SEL_ALU_PORTA_RS1;
        datamem_size_read_sel = NANORV32_MUX_SEL_DATAMEM_SIZE_READ_WORD;
        datamem_write_sel = NANORV32_MUX_SEL_DATAMEM_WRITE_NO;
        datamem_size_write_sel = NANORV32_MUX_SEL_DATAMEM_SIZE_WRITE_WORD;
        datamem_read_sel = NANORV32_MUX_SEL_DATAMEM_READ_NO;
        regfile_source_sel = NANORV32_MUX_SEL_REGFILE_SOURCE_ALU;
        regfile_write_sel = NANORV32_MUX_SEL_REGFILE_WRITE_YES;
    end
    NANORV32_DECODE_SLTU: begin
        pc_next_sel = NANORV32_MUX_SEL_PC_NEXT_PLUS4;
        alu_op_sel = NANORV32_MUX_SEL_ALU_OP_LT_UNSIGNED;
        alu_portb_sel = NANORV32_MUX_SEL_ALU_PORTB_RS2;
        alu_porta_sel = NANORV32_MUX_SEL_ALU_PORTA_RS1;
        datamem_size_read_sel = NANORV32_MUX_SEL_DATAMEM_SIZE_READ_WORD;
        datamem_write_sel = NANORV32_MUX_SEL_DATAMEM_WRITE_NO;
        datamem_size_write_sel = NANORV32_MUX_SEL_DATAMEM_SIZE_WRITE_WORD;
        datamem_read_sel = NANORV32_MUX_SEL_DATAMEM_READ_NO;
        regfile_source_sel = NANORV32_MUX_SEL_REGFILE_SOURCE_ALU;
        regfile_write_sel = NANORV32_MUX_SEL_REGFILE_WRITE_YES;
    end
    NANORV32_DECODE_ANDI: begin
        pc_next_sel = NANORV32_MUX_SEL_PC_NEXT_PLUS4;
        alu_op_sel = NANORV32_MUX_SEL_ALU_OP_AND;
        alu_portb_sel = NANORV32_MUX_SEL_ALU_PORTB_IMM12;
        alu_porta_sel = NANORV32_MUX_SEL_ALU_PORTA_RS1;
        datamem_size_read_sel = NANORV32_MUX_SEL_DATAMEM_SIZE_READ_WORD;
        datamem_write_sel = NANORV32_MUX_SEL_DATAMEM_WRITE_NO;
        datamem_size_write_sel = NANORV32_MUX_SEL_DATAMEM_SIZE_WRITE_WORD;
        datamem_read_sel = NANORV32_MUX_SEL_DATAMEM_READ_NO;
        regfile_source_sel = NANORV32_MUX_SEL_REGFILE_SOURCE_ALU;
        regfile_write_sel = NANORV32_MUX_SEL_REGFILE_WRITE_YES;
    end
    NANORV32_DECODE_JALR: begin
        pc_next_sel = NANORV32_MUX_SEL_PC_NEXT_ALU_RES;
        alu_op_sel = NANORV32_MUX_SEL_ALU_OP_ADD;
        alu_portb_sel = NANORV32_MUX_SEL_ALU_PORTB_IMM12;
        alu_porta_sel = NANORV32_MUX_SEL_ALU_PORTA_RS1;
        datamem_size_read_sel = NANORV32_MUX_SEL_DATAMEM_SIZE_READ_WORD;
        datamem_write_sel = NANORV32_MUX_SEL_DATAMEM_WRITE_NO;
        datamem_size_write_sel = NANORV32_MUX_SEL_DATAMEM_SIZE_WRITE_WORD;
        datamem_read_sel = NANORV32_MUX_SEL_DATAMEM_READ_NO;
        regfile_source_sel = NANORV32_MUX_SEL_REGFILE_SOURCE_PC_EXE_PLUS_4;
        regfile_write_sel = NANORV32_MUX_SEL_REGFILE_WRITE_YES;
    end
    NANORV32_DECODE_BLT: begin
        pc_next_sel = NANORV32_MUX_SEL_PC_NEXT_COND_PC_PLUS_IMMSB;
        alu_op_sel = NANORV32_MUX_SEL_ALU_OP_LT_SIGNED;
        alu_portb_sel = NANORV32_MUX_SEL_ALU_PORTB_RS2;
        alu_porta_sel = NANORV32_MUX_SEL_ALU_PORTA_RS1;
        datamem_size_read_sel = NANORV32_MUX_SEL_DATAMEM_SIZE_READ_WORD;
        datamem_write_sel = NANORV32_MUX_SEL_DATAMEM_WRITE_NO;
        datamem_size_write_sel = NANORV32_MUX_SEL_DATAMEM_SIZE_WRITE_WORD;
        datamem_read_sel = NANORV32_MUX_SEL_DATAMEM_READ_NO;
        regfile_source_sel = NANORV32_MUX_SEL_REGFILE_SOURCE_ALU;
        regfile_write_sel = NANORV32_MUX_SEL_REGFILE_WRITE_NO;
    end
    NANORV32_DECODE_SCALL: begin
        pc_next_sel = NANORV32_MUX_SEL_PC_NEXT_PLUS4;
        alu_op_sel = NANORV32_MUX_SEL_ALU_OP_NOOP;
        alu_portb_sel = NANORV32_MUX_SEL_ALU_PORTB_RS2;
        alu_porta_sel = NANORV32_MUX_SEL_ALU_PORTA_RS1;
        datamem_size_read_sel = NANORV32_MUX_SEL_DATAMEM_SIZE_READ_WORD;
        datamem_write_sel = NANORV32_MUX_SEL_DATAMEM_WRITE_NO;
        datamem_size_write_sel = NANORV32_MUX_SEL_DATAMEM_SIZE_WRITE_WORD;
        datamem_read_sel = NANORV32_MUX_SEL_DATAMEM_READ_NO;
        regfile_source_sel = NANORV32_MUX_SEL_REGFILE_SOURCE_ALU;
        regfile_write_sel = NANORV32_MUX_SEL_REGFILE_WRITE_NO;
    end
    NANORV32_DECODE_FENCE_I: begin
        pc_next_sel = NANORV32_MUX_SEL_PC_NEXT_PLUS4;
        alu_op_sel = NANORV32_MUX_SEL_ALU_OP_NOOP;
        alu_portb_sel = NANORV32_MUX_SEL_ALU_PORTB_RS2;
        alu_porta_sel = NANORV32_MUX_SEL_ALU_PORTA_RS1;
        datamem_size_read_sel = NANORV32_MUX_SEL_DATAMEM_SIZE_READ_WORD;
        datamem_write_sel = NANORV32_MUX_SEL_DATAMEM_WRITE_NO;
        datamem_size_write_sel = NANORV32_MUX_SEL_DATAMEM_SIZE_WRITE_WORD;
        datamem_read_sel = NANORV32_MUX_SEL_DATAMEM_READ_NO;
        regfile_source_sel = NANORV32_MUX_SEL_REGFILE_SOURCE_ALU;
        regfile_write_sel = NANORV32_MUX_SEL_REGFILE_WRITE_NO;
    end
    NANORV32_DECODE_JAL: begin
        pc_next_sel = NANORV32_MUX_SEL_PC_NEXT_ALU_RES;
        alu_op_sel = NANORV32_MUX_SEL_ALU_OP_ADD;
        alu_portb_sel = NANORV32_MUX_SEL_ALU_PORTB_IMM20UJ;
        alu_porta_sel = NANORV32_MUX_SEL_ALU_PORTA_PC_EXE;
        datamem_size_read_sel = NANORV32_MUX_SEL_DATAMEM_SIZE_READ_WORD;
        datamem_write_sel = NANORV32_MUX_SEL_DATAMEM_WRITE_NO;
        datamem_size_write_sel = NANORV32_MUX_SEL_DATAMEM_SIZE_WRITE_WORD;
        datamem_read_sel = NANORV32_MUX_SEL_DATAMEM_READ_NO;
        regfile_source_sel = NANORV32_MUX_SEL_REGFILE_SOURCE_PC_EXE_PLUS_4;
        regfile_write_sel = NANORV32_MUX_SEL_REGFILE_WRITE_YES;
    end
    NANORV32_DECODE_LH: begin
        pc_next_sel = NANORV32_MUX_SEL_PC_NEXT_PLUS4;
        alu_op_sel = NANORV32_MUX_SEL_ALU_OP_ADD;
        alu_portb_sel = NANORV32_MUX_SEL_ALU_PORTB_IMM12;
        alu_porta_sel = NANORV32_MUX_SEL_ALU_PORTA_RS1;
        datamem_size_read_sel = NANORV32_MUX_SEL_DATAMEM_SIZE_READ_HALFWORD;
        datamem_write_sel = NANORV32_MUX_SEL_DATAMEM_WRITE_NO;
        datamem_size_write_sel = NANORV32_MUX_SEL_DATAMEM_SIZE_WRITE_WORD;
        datamem_read_sel = NANORV32_MUX_SEL_DATAMEM_READ_YES;
        regfile_source_sel = NANORV32_MUX_SEL_REGFILE_SOURCE_DATAMEM;
        regfile_write_sel = NANORV32_MUX_SEL_REGFILE_WRITE_YES;
    end
    NANORV32_DECODE_LW: begin
        pc_next_sel = NANORV32_MUX_SEL_PC_NEXT_PLUS4;
        alu_op_sel = NANORV32_MUX_SEL_ALU_OP_ADD;
        alu_portb_sel = NANORV32_MUX_SEL_ALU_PORTB_IMM12;
        alu_porta_sel = NANORV32_MUX_SEL_ALU_PORTA_RS1;
        datamem_size_read_sel = NANORV32_MUX_SEL_DATAMEM_SIZE_READ_WORD;
        datamem_write_sel = NANORV32_MUX_SEL_DATAMEM_WRITE_NO;
        datamem_size_write_sel = NANORV32_MUX_SEL_DATAMEM_SIZE_WRITE_WORD;
        datamem_read_sel = NANORV32_MUX_SEL_DATAMEM_READ_YES;
        regfile_source_sel = NANORV32_MUX_SEL_REGFILE_SOURCE_DATAMEM;
        regfile_write_sel = NANORV32_MUX_SEL_REGFILE_WRITE_YES;
    end
    NANORV32_DECODE_ADD: begin
        pc_next_sel = NANORV32_MUX_SEL_PC_NEXT_PLUS4;
        alu_op_sel = NANORV32_MUX_SEL_ALU_OP_ADD;
        alu_portb_sel = NANORV32_MUX_SEL_ALU_PORTB_RS2;
        alu_porta_sel = NANORV32_MUX_SEL_ALU_PORTA_RS1;
        datamem_size_read_sel = NANORV32_MUX_SEL_DATAMEM_SIZE_READ_WORD;
        datamem_write_sel = NANORV32_MUX_SEL_DATAMEM_WRITE_NO;
        datamem_size_write_sel = NANORV32_MUX_SEL_DATAMEM_SIZE_WRITE_WORD;
        datamem_read_sel = NANORV32_MUX_SEL_DATAMEM_READ_NO;
        regfile_source_sel = NANORV32_MUX_SEL_REGFILE_SOURCE_ALU;
        regfile_write_sel = NANORV32_MUX_SEL_REGFILE_WRITE_YES;
    end
    NANORV32_DECODE_AUIPC: begin
        pc_next_sel = NANORV32_MUX_SEL_PC_NEXT_PLUS4;
        alu_op_sel = NANORV32_MUX_SEL_ALU_OP_ADD;
        alu_portb_sel = NANORV32_MUX_SEL_ALU_PORTB_IMM20U;
        alu_porta_sel = NANORV32_MUX_SEL_ALU_PORTA_PC_EXE;
        datamem_size_read_sel = NANORV32_MUX_SEL_DATAMEM_SIZE_READ_WORD;
        datamem_write_sel = NANORV32_MUX_SEL_DATAMEM_WRITE_WORD;
        datamem_size_write_sel = NANORV32_MUX_SEL_DATAMEM_SIZE_WRITE_WORD;
        datamem_read_sel = NANORV32_MUX_SEL_DATAMEM_READ_NO;
        regfile_source_sel = NANORV32_MUX_SEL_REGFILE_SOURCE_ALU;
        regfile_write_sel = NANORV32_MUX_SEL_REGFILE_WRITE_YES;
    end
    NANORV32_DECODE_LUI: begin
        pc_next_sel = NANORV32_MUX_SEL_PC_NEXT_PLUS4;
        alu_op_sel = NANORV32_MUX_SEL_ALU_OP_NOP;
        alu_portb_sel = NANORV32_MUX_SEL_ALU_PORTB_IMM20U;
        alu_porta_sel = NANORV32_MUX_SEL_ALU_PORTA_RS1;
        datamem_size_read_sel = NANORV32_MUX_SEL_DATAMEM_SIZE_READ_WORD;
        datamem_write_sel = NANORV32_MUX_SEL_DATAMEM_WRITE_WORD;
        datamem_size_write_sel = NANORV32_MUX_SEL_DATAMEM_SIZE_WRITE_WORD;
        datamem_read_sel = NANORV32_MUX_SEL_DATAMEM_READ_NO;
        regfile_source_sel = NANORV32_MUX_SEL_REGFILE_SOURCE_ALU;
        regfile_write_sel = NANORV32_MUX_SEL_REGFILE_WRITE_YES;
    end
    NANORV32_DECODE_BNE: begin
        pc_next_sel = NANORV32_MUX_SEL_PC_NEXT_COND_PC_PLUS_IMMSB;
        alu_op_sel = NANORV32_MUX_SEL_ALU_OP_NEQ;
        alu_portb_sel = NANORV32_MUX_SEL_ALU_PORTB_RS2;
        alu_porta_sel = NANORV32_MUX_SEL_ALU_PORTA_RS1;
        datamem_size_read_sel = NANORV32_MUX_SEL_DATAMEM_SIZE_READ_WORD;
        datamem_write_sel = NANORV32_MUX_SEL_DATAMEM_WRITE_NO;
        datamem_size_write_sel = NANORV32_MUX_SEL_DATAMEM_SIZE_WRITE_WORD;
        datamem_read_sel = NANORV32_MUX_SEL_DATAMEM_READ_NO;
        regfile_source_sel = NANORV32_MUX_SEL_REGFILE_SOURCE_ALU;
        regfile_write_sel = NANORV32_MUX_SEL_REGFILE_WRITE_NO;
    end
    NANORV32_DECODE_SBREAK: begin
        pc_next_sel = NANORV32_MUX_SEL_PC_NEXT_PLUS4;
        alu_op_sel = NANORV32_MUX_SEL_ALU_OP_NOOP;
        alu_portb_sel = NANORV32_MUX_SEL_ALU_PORTB_RS2;
        alu_porta_sel = NANORV32_MUX_SEL_ALU_PORTA_RS1;
        datamem_size_read_sel = NANORV32_MUX_SEL_DATAMEM_SIZE_READ_WORD;
        datamem_write_sel = NANORV32_MUX_SEL_DATAMEM_WRITE_NO;
        datamem_size_write_sel = NANORV32_MUX_SEL_DATAMEM_SIZE_WRITE_WORD;
        datamem_read_sel = NANORV32_MUX_SEL_DATAMEM_READ_NO;
        regfile_source_sel = NANORV32_MUX_SEL_REGFILE_SOURCE_ALU;
        regfile_write_sel = NANORV32_MUX_SEL_REGFILE_WRITE_NO;
    end
    NANORV32_DECODE_BGEU: begin
        pc_next_sel = NANORV32_MUX_SEL_PC_NEXT_COND_PC_PLUS_IMMSB;
        alu_op_sel = NANORV32_MUX_SEL_ALU_OP_GE_UNSIGNED;
        alu_portb_sel = NANORV32_MUX_SEL_ALU_PORTB_RS2;
        alu_porta_sel = NANORV32_MUX_SEL_ALU_PORTA_RS1;
        datamem_size_read_sel = NANORV32_MUX_SEL_DATAMEM_SIZE_READ_WORD;
        datamem_write_sel = NANORV32_MUX_SEL_DATAMEM_WRITE_NO;
        datamem_size_write_sel = NANORV32_MUX_SEL_DATAMEM_SIZE_WRITE_WORD;
        datamem_read_sel = NANORV32_MUX_SEL_DATAMEM_READ_NO;
        regfile_source_sel = NANORV32_MUX_SEL_REGFILE_SOURCE_ALU;
        regfile_write_sel = NANORV32_MUX_SEL_REGFILE_WRITE_NO;
    end
    NANORV32_DECODE_SLTIU: begin
        pc_next_sel = NANORV32_MUX_SEL_PC_NEXT_PLUS4;
        alu_op_sel = NANORV32_MUX_SEL_ALU_OP_LT_UNSIGNED;
        alu_portb_sel = NANORV32_MUX_SEL_ALU_PORTB_IMM12;
        alu_porta_sel = NANORV32_MUX_SEL_ALU_PORTA_RS1;
        datamem_size_read_sel = NANORV32_MUX_SEL_DATAMEM_SIZE_READ_WORD;
        datamem_write_sel = NANORV32_MUX_SEL_DATAMEM_WRITE_NO;
        datamem_size_write_sel = NANORV32_MUX_SEL_DATAMEM_SIZE_WRITE_WORD;
        datamem_read_sel = NANORV32_MUX_SEL_DATAMEM_READ_NO;
        regfile_source_sel = NANORV32_MUX_SEL_REGFILE_SOURCE_ALU;
        regfile_write_sel = NANORV32_MUX_SEL_REGFILE_WRITE_YES;
    end
    NANORV32_DECODE_SRAI: begin
        pc_next_sel = NANORV32_MUX_SEL_PC_NEXT_PLUS4;
        alu_op_sel = NANORV32_MUX_SEL_ALU_OP_ARSHIFT;
        alu_portb_sel = NANORV32_MUX_SEL_ALU_PORTB_SHAMT;
        alu_porta_sel = NANORV32_MUX_SEL_ALU_PORTA_RS1;
        datamem_size_read_sel = NANORV32_MUX_SEL_DATAMEM_SIZE_READ_WORD;
        datamem_write_sel = NANORV32_MUX_SEL_DATAMEM_WRITE_NO;
        datamem_size_write_sel = NANORV32_MUX_SEL_DATAMEM_SIZE_WRITE_WORD;
        datamem_read_sel = NANORV32_MUX_SEL_DATAMEM_READ_NO;
        regfile_source_sel = NANORV32_MUX_SEL_REGFILE_SOURCE_ALU;
        regfile_write_sel = NANORV32_MUX_SEL_REGFILE_WRITE_YES;
    end
    NANORV32_DECODE_ORI: begin
        pc_next_sel = NANORV32_MUX_SEL_PC_NEXT_PLUS4;
        alu_op_sel = NANORV32_MUX_SEL_ALU_OP_OR;
        alu_portb_sel = NANORV32_MUX_SEL_ALU_PORTB_IMM12;
        alu_porta_sel = NANORV32_MUX_SEL_ALU_PORTA_RS1;
        datamem_size_read_sel = NANORV32_MUX_SEL_DATAMEM_SIZE_READ_WORD;
        datamem_write_sel = NANORV32_MUX_SEL_DATAMEM_WRITE_NO;
        datamem_size_write_sel = NANORV32_MUX_SEL_DATAMEM_SIZE_WRITE_WORD;
        datamem_read_sel = NANORV32_MUX_SEL_DATAMEM_READ_NO;
        regfile_source_sel = NANORV32_MUX_SEL_REGFILE_SOURCE_ALU;
        regfile_write_sel = NANORV32_MUX_SEL_REGFILE_WRITE_YES;
    end
    NANORV32_DECODE_XORI: begin
        pc_next_sel = NANORV32_MUX_SEL_PC_NEXT_PLUS4;
        alu_op_sel = NANORV32_MUX_SEL_ALU_OP_XOR;
        alu_portb_sel = NANORV32_MUX_SEL_ALU_PORTB_IMM12;
        alu_porta_sel = NANORV32_MUX_SEL_ALU_PORTA_RS1;
        datamem_size_read_sel = NANORV32_MUX_SEL_DATAMEM_SIZE_READ_WORD;
        datamem_write_sel = NANORV32_MUX_SEL_DATAMEM_WRITE_NO;
        datamem_size_write_sel = NANORV32_MUX_SEL_DATAMEM_SIZE_WRITE_WORD;
        datamem_read_sel = NANORV32_MUX_SEL_DATAMEM_READ_NO;
        regfile_source_sel = NANORV32_MUX_SEL_REGFILE_SOURCE_ALU;
        regfile_write_sel = NANORV32_MUX_SEL_REGFILE_WRITE_YES;
    end
    NANORV32_DECODE_LB: begin
        pc_next_sel = NANORV32_MUX_SEL_PC_NEXT_PLUS4;
        alu_op_sel = NANORV32_MUX_SEL_ALU_OP_ADD;
        alu_portb_sel = NANORV32_MUX_SEL_ALU_PORTB_IMM12;
        alu_porta_sel = NANORV32_MUX_SEL_ALU_PORTA_RS1;
        datamem_size_read_sel = NANORV32_MUX_SEL_DATAMEM_SIZE_READ_BYTE;
        datamem_write_sel = NANORV32_MUX_SEL_DATAMEM_WRITE_NO;
        datamem_size_write_sel = NANORV32_MUX_SEL_DATAMEM_SIZE_WRITE_WORD;
        datamem_read_sel = NANORV32_MUX_SEL_DATAMEM_READ_YES;
        regfile_source_sel = NANORV32_MUX_SEL_REGFILE_SOURCE_DATAMEM;
        regfile_write_sel = NANORV32_MUX_SEL_REGFILE_WRITE_YES;
    end
    NANORV32_DECODE_SUB: begin
        pc_next_sel = NANORV32_MUX_SEL_PC_NEXT_PLUS4;
        alu_op_sel = NANORV32_MUX_SEL_ALU_OP_SUB;
        alu_portb_sel = NANORV32_MUX_SEL_ALU_PORTB_RS2;
        alu_porta_sel = NANORV32_MUX_SEL_ALU_PORTA_RS1;
        datamem_size_read_sel = NANORV32_MUX_SEL_DATAMEM_SIZE_READ_WORD;
        datamem_write_sel = NANORV32_MUX_SEL_DATAMEM_WRITE_NO;
        datamem_size_write_sel = NANORV32_MUX_SEL_DATAMEM_SIZE_WRITE_WORD;
        datamem_read_sel = NANORV32_MUX_SEL_DATAMEM_READ_NO;
        regfile_source_sel = NANORV32_MUX_SEL_REGFILE_SOURCE_ALU;
        regfile_write_sel = NANORV32_MUX_SEL_REGFILE_WRITE_YES;
    end
    NANORV32_DECODE_SRA: begin
        pc_next_sel = NANORV32_MUX_SEL_PC_NEXT_PLUS4;
        alu_op_sel = NANORV32_MUX_SEL_ALU_OP_ARSHIFT;
        alu_portb_sel = NANORV32_MUX_SEL_ALU_PORTB_RS2;
        alu_porta_sel = NANORV32_MUX_SEL_ALU_PORTA_RS1;
        datamem_size_read_sel = NANORV32_MUX_SEL_DATAMEM_SIZE_READ_WORD;
        datamem_write_sel = NANORV32_MUX_SEL_DATAMEM_WRITE_NO;
        datamem_size_write_sel = NANORV32_MUX_SEL_DATAMEM_SIZE_WRITE_WORD;
        datamem_read_sel = NANORV32_MUX_SEL_DATAMEM_READ_NO;
        regfile_source_sel = NANORV32_MUX_SEL_REGFILE_SOURCE_ALU;
        regfile_write_sel = NANORV32_MUX_SEL_REGFILE_WRITE_YES;
    end
    NANORV32_DECODE_BGE: begin
        pc_next_sel = NANORV32_MUX_SEL_PC_NEXT_COND_PC_PLUS_IMMSB;
        alu_op_sel = NANORV32_MUX_SEL_ALU_OP_GE_SIGNED;
        alu_portb_sel = NANORV32_MUX_SEL_ALU_PORTB_RS2;
        alu_porta_sel = NANORV32_MUX_SEL_ALU_PORTA_RS1;
        datamem_size_read_sel = NANORV32_MUX_SEL_DATAMEM_SIZE_READ_WORD;
        datamem_write_sel = NANORV32_MUX_SEL_DATAMEM_WRITE_NO;
        datamem_size_write_sel = NANORV32_MUX_SEL_DATAMEM_SIZE_WRITE_WORD;
        datamem_read_sel = NANORV32_MUX_SEL_DATAMEM_READ_NO;
        regfile_source_sel = NANORV32_MUX_SEL_REGFILE_SOURCE_ALU;
        regfile_write_sel = NANORV32_MUX_SEL_REGFILE_WRITE_NO;
    end
    NANORV32_DECODE_SLT: begin
        pc_next_sel = NANORV32_MUX_SEL_PC_NEXT_PLUS4;
        alu_op_sel = NANORV32_MUX_SEL_ALU_OP_LT_SIGNED;
        alu_portb_sel = NANORV32_MUX_SEL_ALU_PORTB_RS2;
        alu_porta_sel = NANORV32_MUX_SEL_ALU_PORTA_RS1;
        datamem_size_read_sel = NANORV32_MUX_SEL_DATAMEM_SIZE_READ_WORD;
        datamem_write_sel = NANORV32_MUX_SEL_DATAMEM_WRITE_NO;
        datamem_size_write_sel = NANORV32_MUX_SEL_DATAMEM_SIZE_WRITE_WORD;
        datamem_read_sel = NANORV32_MUX_SEL_DATAMEM_READ_NO;
        regfile_source_sel = NANORV32_MUX_SEL_REGFILE_SOURCE_ALU;
        regfile_write_sel = NANORV32_MUX_SEL_REGFILE_WRITE_YES;
    end
    NANORV32_DECODE_SRLI: begin
        pc_next_sel = NANORV32_MUX_SEL_PC_NEXT_PLUS4;
        alu_op_sel = NANORV32_MUX_SEL_ALU_OP_RSHIFT;
        alu_portb_sel = NANORV32_MUX_SEL_ALU_PORTB_SHAMT;
        alu_porta_sel = NANORV32_MUX_SEL_ALU_PORTA_RS1;
        datamem_size_read_sel = NANORV32_MUX_SEL_DATAMEM_SIZE_READ_WORD;
        datamem_write_sel = NANORV32_MUX_SEL_DATAMEM_WRITE_NO;
        datamem_size_write_sel = NANORV32_MUX_SEL_DATAMEM_SIZE_WRITE_WORD;
        datamem_read_sel = NANORV32_MUX_SEL_DATAMEM_READ_NO;
        regfile_source_sel = NANORV32_MUX_SEL_REGFILE_SOURCE_ALU;
        regfile_write_sel = NANORV32_MUX_SEL_REGFILE_WRITE_YES;
    end
    NANORV32_DECODE_SLTI: begin
        pc_next_sel = NANORV32_MUX_SEL_PC_NEXT_PLUS4;
        alu_op_sel = NANORV32_MUX_SEL_ALU_OP_LT_SIGNED;
        alu_portb_sel = NANORV32_MUX_SEL_ALU_PORTB_IMM12;
        alu_porta_sel = NANORV32_MUX_SEL_ALU_PORTA_RS1;
        datamem_size_read_sel = NANORV32_MUX_SEL_DATAMEM_SIZE_READ_WORD;
        datamem_write_sel = NANORV32_MUX_SEL_DATAMEM_WRITE_NO;
        datamem_size_write_sel = NANORV32_MUX_SEL_DATAMEM_SIZE_WRITE_WORD;
        datamem_read_sel = NANORV32_MUX_SEL_DATAMEM_READ_NO;
        regfile_source_sel = NANORV32_MUX_SEL_REGFILE_SOURCE_ALU;
        regfile_write_sel = NANORV32_MUX_SEL_REGFILE_WRITE_YES;
    end
    NANORV32_DECODE_SRL: begin
        pc_next_sel = NANORV32_MUX_SEL_PC_NEXT_PLUS4;
        alu_op_sel = NANORV32_MUX_SEL_ALU_OP_RSHIFT;
        alu_portb_sel = NANORV32_MUX_SEL_ALU_PORTB_RS2;
        alu_porta_sel = NANORV32_MUX_SEL_ALU_PORTA_RS1;
        datamem_size_read_sel = NANORV32_MUX_SEL_DATAMEM_SIZE_READ_WORD;
        datamem_write_sel = NANORV32_MUX_SEL_DATAMEM_WRITE_NO;
        datamem_size_write_sel = NANORV32_MUX_SEL_DATAMEM_SIZE_WRITE_WORD;
        datamem_read_sel = NANORV32_MUX_SEL_DATAMEM_READ_NO;
        regfile_source_sel = NANORV32_MUX_SEL_REGFILE_SOURCE_ALU;
        regfile_write_sel = NANORV32_MUX_SEL_REGFILE_WRITE_YES;
    end
    NANORV32_DECODE_SLL: begin
        pc_next_sel = NANORV32_MUX_SEL_PC_NEXT_PLUS4;
        alu_op_sel = NANORV32_MUX_SEL_ALU_OP_LSHIFT;
        alu_portb_sel = NANORV32_MUX_SEL_ALU_PORTB_RS2;
        alu_porta_sel = NANORV32_MUX_SEL_ALU_PORTA_RS1;
        datamem_size_read_sel = NANORV32_MUX_SEL_DATAMEM_SIZE_READ_WORD;
        datamem_write_sel = NANORV32_MUX_SEL_DATAMEM_WRITE_NO;
        datamem_size_write_sel = NANORV32_MUX_SEL_DATAMEM_SIZE_WRITE_WORD;
        datamem_read_sel = NANORV32_MUX_SEL_DATAMEM_READ_NO;
        regfile_source_sel = NANORV32_MUX_SEL_REGFILE_SOURCE_ALU;
        regfile_write_sel = NANORV32_MUX_SEL_REGFILE_WRITE_YES;
    end
    NANORV32_DECODE_LHU: begin
        pc_next_sel = NANORV32_MUX_SEL_PC_NEXT_PLUS4;
        alu_op_sel = NANORV32_MUX_SEL_ALU_OP_ADD;
        alu_portb_sel = NANORV32_MUX_SEL_ALU_PORTB_IMM12;
        alu_porta_sel = NANORV32_MUX_SEL_ALU_PORTA_RS1;
        datamem_size_read_sel = NANORV32_MUX_SEL_DATAMEM_SIZE_READ_HALFWORD_UNSIGNED;
        datamem_write_sel = NANORV32_MUX_SEL_DATAMEM_WRITE_NO;
        datamem_size_write_sel = NANORV32_MUX_SEL_DATAMEM_SIZE_WRITE_WORD;
        datamem_read_sel = NANORV32_MUX_SEL_DATAMEM_READ_YES;
        regfile_source_sel = NANORV32_MUX_SEL_REGFILE_SOURCE_DATAMEM;
        regfile_write_sel = NANORV32_MUX_SEL_REGFILE_WRITE_YES;
    end
    NANORV32_DECODE_SH: begin
        pc_next_sel = NANORV32_MUX_SEL_PC_NEXT_PLUS4;
        alu_op_sel = NANORV32_MUX_SEL_ALU_OP_ADD;
        alu_portb_sel = NANORV32_MUX_SEL_ALU_PORTB_IMM12HILO;
        alu_porta_sel = NANORV32_MUX_SEL_ALU_PORTA_RS1;
        datamem_size_read_sel = NANORV32_MUX_SEL_DATAMEM_SIZE_READ_WORD;
        datamem_write_sel = NANORV32_MUX_SEL_DATAMEM_WRITE_YES;
        datamem_size_write_sel = NANORV32_MUX_SEL_DATAMEM_SIZE_WRITE_HALFWORD;
        datamem_read_sel = NANORV32_MUX_SEL_DATAMEM_READ_NO;
        regfile_source_sel = NANORV32_MUX_SEL_REGFILE_SOURCE_ALU;
        regfile_write_sel = NANORV32_MUX_SEL_REGFILE_WRITE_NO;
    end
    NANORV32_DECODE_SLLI: begin
        pc_next_sel = NANORV32_MUX_SEL_PC_NEXT_PLUS4;
        alu_op_sel = NANORV32_MUX_SEL_ALU_OP_LSHIFT;
        alu_portb_sel = NANORV32_MUX_SEL_ALU_PORTB_SHAMT;
        alu_porta_sel = NANORV32_MUX_SEL_ALU_PORTA_RS1;
        datamem_size_read_sel = NANORV32_MUX_SEL_DATAMEM_SIZE_READ_WORD;
        datamem_write_sel = NANORV32_MUX_SEL_DATAMEM_WRITE_NO;
        datamem_size_write_sel = NANORV32_MUX_SEL_DATAMEM_SIZE_WRITE_WORD;
        datamem_read_sel = NANORV32_MUX_SEL_DATAMEM_READ_NO;
        regfile_source_sel = NANORV32_MUX_SEL_REGFILE_SOURCE_ALU;
        regfile_write_sel = NANORV32_MUX_SEL_REGFILE_WRITE_YES;
    end
    NANORV32_DECODE_ADDI: begin
        pc_next_sel = NANORV32_MUX_SEL_PC_NEXT_PLUS4;
        alu_op_sel = NANORV32_MUX_SEL_ALU_OP_ADD;
        alu_portb_sel = NANORV32_MUX_SEL_ALU_PORTB_IMM12;
        alu_porta_sel = NANORV32_MUX_SEL_ALU_PORTA_RS1;
        datamem_size_read_sel = NANORV32_MUX_SEL_DATAMEM_SIZE_READ_WORD;
        datamem_write_sel = NANORV32_MUX_SEL_DATAMEM_WRITE_NO;
        datamem_size_write_sel = NANORV32_MUX_SEL_DATAMEM_SIZE_WRITE_WORD;
        datamem_read_sel = NANORV32_MUX_SEL_DATAMEM_READ_NO;
        regfile_source_sel = NANORV32_MUX_SEL_REGFILE_SOURCE_ALU;
        regfile_write_sel = NANORV32_MUX_SEL_REGFILE_WRITE_YES;
    end
    NANORV32_DECODE_SB: begin
        pc_next_sel = NANORV32_MUX_SEL_PC_NEXT_PLUS4;
        alu_op_sel = NANORV32_MUX_SEL_ALU_OP_ADD;
        alu_portb_sel = NANORV32_MUX_SEL_ALU_PORTB_IMM12HILO;
        alu_porta_sel = NANORV32_MUX_SEL_ALU_PORTA_RS1;
        datamem_size_read_sel = NANORV32_MUX_SEL_DATAMEM_SIZE_READ_WORD;
        datamem_write_sel = NANORV32_MUX_SEL_DATAMEM_WRITE_YES;
        datamem_size_write_sel = NANORV32_MUX_SEL_DATAMEM_SIZE_WRITE_BYTE;
        datamem_read_sel = NANORV32_MUX_SEL_DATAMEM_READ_NO;
        regfile_source_sel = NANORV32_MUX_SEL_REGFILE_SOURCE_ALU;
        regfile_write_sel = NANORV32_MUX_SEL_REGFILE_WRITE_NO;
    end
    NANORV32_DECODE_BEQ: begin
        pc_next_sel = NANORV32_MUX_SEL_PC_NEXT_COND_PC_PLUS_IMMSB;
        alu_op_sel = NANORV32_MUX_SEL_ALU_OP_EQ;
        alu_portb_sel = NANORV32_MUX_SEL_ALU_PORTB_RS2;
        alu_porta_sel = NANORV32_MUX_SEL_ALU_PORTA_RS1;
        datamem_size_read_sel = NANORV32_MUX_SEL_DATAMEM_SIZE_READ_WORD;
        datamem_write_sel = NANORV32_MUX_SEL_DATAMEM_WRITE_NO;
        datamem_size_write_sel = NANORV32_MUX_SEL_DATAMEM_SIZE_WRITE_WORD;
        datamem_read_sel = NANORV32_MUX_SEL_DATAMEM_READ_NO;
        regfile_source_sel = NANORV32_MUX_SEL_REGFILE_SOURCE_ALU;
        regfile_write_sel = NANORV32_MUX_SEL_REGFILE_WRITE_NO;
    end
    NANORV32_DECODE_OR: begin
        pc_next_sel = NANORV32_MUX_SEL_PC_NEXT_PLUS4;
        alu_op_sel = NANORV32_MUX_SEL_ALU_OP_OR;
        alu_portb_sel = NANORV32_MUX_SEL_ALU_PORTB_RS2;
        alu_porta_sel = NANORV32_MUX_SEL_ALU_PORTA_RS1;
        datamem_size_read_sel = NANORV32_MUX_SEL_DATAMEM_SIZE_READ_WORD;
        datamem_write_sel = NANORV32_MUX_SEL_DATAMEM_WRITE_NO;
        datamem_size_write_sel = NANORV32_MUX_SEL_DATAMEM_SIZE_WRITE_WORD;
        datamem_read_sel = NANORV32_MUX_SEL_DATAMEM_READ_NO;
        regfile_source_sel = NANORV32_MUX_SEL_REGFILE_SOURCE_ALU;
        regfile_write_sel = NANORV32_MUX_SEL_REGFILE_WRITE_YES;
    end
        //@end[instruction_decoder]
        default begin
           illegal_instruction = 1;

           pc_next_sel = NANORV32_MUX_SEL_PC_NEXT_PLUS4;
           alu_op_sel = NANORV32_MUX_SEL_ALU_OP_NOP;
           alu_portb_sel = NANORV32_MUX_SEL_ALU_PORTB_RS2;
           alu_porta_sel = NANORV32_MUX_SEL_ALU_PORTA_RS1;
           datamem_size_read_sel = NANORV32_MUX_SEL_DATAMEM_SIZE_READ_WORD;
           datamem_write_sel = NANORV32_MUX_SEL_DATAMEM_WRITE_NO;
           datamem_read_sel = NANORV32_MUX_SEL_DATAMEM_READ_NO;
           regfile_source_sel = NANORV32_MUX_SEL_REGFILE_SOURCE_ALU;
           regfile_write_sel = NANORV32_MUX_SEL_REGFILE_WRITE_NO;
        end
      endcase // casez (instruction[NANORV32_INSTRUCTION_MSB:0])
   end







endmodule // nanorv32_decoder
/*
 Local Variables:
 verilog-library-directories:(
 "."
 )
 End:
 */