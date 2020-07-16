//****************************************************************************/
//  nanorv32 CPU
//  RTL IMPLEMENTATION, Synchronous Version
//
//  Copyright (C) 2016  Ronan Barzic - rbarzic@gmail.com
//                      Jean-Baptiste Brelot
//  Date            :  Tue Jan 19 20:28:48 2016
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
//  Filename        :  nanorv32.v
//
//  Description     :   Nanorv32 CPU top file
//
//
//
//****************************************************************************/

module nanorv32 (/*AUTOARG*/
   // Outputs
   illegal_instruction, haddri, hproti, hsizei, hmasteri,
   hmasterlocki, hbursti, hwdatai, hwritei, htransi, haddrd, hprotd,
   hsized, hmasterd, hmasterlockd, hburstd, hwdatad, hwrited, htransd,
   irq_ack,
   // Inputs
   rst_n, clk, hrdatai, hrespi, hreadyi, hrdatad, hrespd, hreadyd,
   irq
   );

`include "nanorv32_parameters.v"
`include "nanorv32_rvc_func.v"


   input                     rst_n;
   input                     clk;

   output                    illegal_instruction;


   // Code memory interface

   input  [NANORV32_DATA_MSB:0] hrdatai;
   input                        hrespi;
   input                        hreadyi;
   output [NANORV32_DATA_MSB:0] haddri;
   output [3:0]                 hproti;
   output [2:0]                 hsizei;
   output                       hmasteri;
   output                       hmasterlocki;
   output [2:0]                 hbursti;
   output [NANORV32_DATA_MSB:0] hwdatai;
   output                       hwritei;
   output                       htransi;

   // Data memory interface


   input  [NANORV32_DATA_MSB:0] hrdatad;
   input                        hrespd;
   input                        hreadyd;
   output [NANORV32_DATA_MSB:0] haddrd;
   output [3:0]                 hprotd;
   output [2:0]                 hsized;
   output                       hmasterd;
   output                       hmasterlockd;
   output [2:0]                 hburstd;
   output [NANORV32_DATA_MSB:0] hwdatad;
   output                       hwrited;
   output                       htransd;

   input                        irq;                    // To U_FLOW_CTRL of nanorv32_flow_ctrl.v
   output                       irq_ack;



   /*AUTOINPUT*/
   /*AUTOOUTPUT*/

   /*AUTOREG*/
   /*AUTOWIRE*/

   wire  [NANORV32_DATA_MSB:0] codeif_cpu_rdata = hrdatai;
   wire                        codeif_cpu_ready_r = hreadyi;     // From U_ARBITRER of nanorv32_tcm_arbitrer.v

   reg  [1:0] cpu_dataif_addr;
   reg  [NANORV32_DATA_MSB:0] cpu_dataif_wdata;
   reg  [3:0]              cpu_dataif_bytesel;
   wire                    cpu_dataif_req;
   wire [NANORV32_DATA_MSB:0]  dataif_cpu_rdata;
   wire                     dataif_cpu_early_ready = hreadyd;
   wire                     dataif_cpu_ready_r;
   wire [1:0]               read_byte_sel;
   reg                      pc_branch;

   wire [NANORV32_DATA_MSB:0]                instruction_r;


   wire [NANORV32_DATA_MSB:0]                inst_from_buffer;
   wire                                      is_32;


   //@begin[mux_select_declarations_as_wire]

    wire  [NANORV32_MUX_SEL_PC_NEXT_MSB:0] pc_next_sel;
    wire  [NANORV32_MUX_SEL_PC_BRANCH_MSB:0] pc_branch_sel;
    wire  [NANORV32_MUX_SEL_ALU_OP_MSB:0] alu_op_sel;
    wire  [NANORV32_MUX_SEL_ALU_PORTB_MSB:0] alu_portb_sel;
    wire  [NANORV32_MUX_SEL_ALU_PORTA_MSB:0] alu_porta_sel;
    wire  [NANORV32_MUX_SEL_DATAMEM_SIZE_READ_MSB:0] datamem_size_read_sel;
    wire  [NANORV32_MUX_SEL_DATAMEM_WRITE_MSB:0] datamem_write_sel;
    wire  [NANORV32_MUX_SEL_DATAMEM_SIZE_WRITE_MSB:0] datamem_size_write_sel;
    wire  [NANORV32_MUX_SEL_DATAMEM_READ_MSB:0] datamem_read_sel;
    wire  [NANORV32_MUX_SEL_REGFILE_PORTW_MSB:0] regfile_portw_sel;
    wire  [NANORV32_MUX_SEL_REGFILE_SOURCE_MSB:0] regfile_source_sel;
    wire  [NANORV32_MUX_SEL_REGFILE_WRITE_MSB:0] regfile_write_sel;
    wire  [NANORV32_MUX_SEL_REGFILE_PORT1_MSB:0] regfile_port1_sel;
    wire  [NANORV32_MUX_SEL_REGFILE_PORT2_MSB:0] regfile_port2_sel;
   //@end[mux_select_declarations_as_wire]


   //@begin[instruction_fields]

    wire [NANORV32_INST_FORMAT_OPCODE1_MSB:0] dec_opcode1  = instruction_r[NANORV32_INST_FORMAT_OPCODE1_OFFSET +: NANORV32_INST_FORMAT_OPCODE1_SIZE];
    wire [NANORV32_INST_FORMAT_FUNC3_MSB:0] dec_func3  = instruction_r[NANORV32_INST_FORMAT_FUNC3_OFFSET +: NANORV32_INST_FORMAT_FUNC3_SIZE];
    wire [NANORV32_INST_FORMAT_FUNC7_MSB:0] dec_func7  = instruction_r[NANORV32_INST_FORMAT_FUNC7_OFFSET +: NANORV32_INST_FORMAT_FUNC7_SIZE];
    wire [NANORV32_INST_FORMAT_RD_MSB:0] dec_rd  = instruction_r[NANORV32_INST_FORMAT_RD_OFFSET +: NANORV32_INST_FORMAT_RD_SIZE];
    wire [NANORV32_INST_FORMAT_RS1_MSB:0] dec_rs1  = instruction_r[NANORV32_INST_FORMAT_RS1_OFFSET +: NANORV32_INST_FORMAT_RS1_SIZE];
    wire [NANORV32_INST_FORMAT_RS2_MSB:0] dec_rs2  = instruction_r[NANORV32_INST_FORMAT_RS2_OFFSET +: NANORV32_INST_FORMAT_RS2_SIZE];
    wire [NANORV32_INST_FORMAT_IMM12_MSB:0] dec_imm12  = instruction_r[NANORV32_INST_FORMAT_IMM12_OFFSET +: NANORV32_INST_FORMAT_IMM12_SIZE];
    wire [NANORV32_INST_FORMAT_IMM12HI_MSB:0] dec_imm12hi  = instruction_r[NANORV32_INST_FORMAT_IMM12HI_OFFSET +: NANORV32_INST_FORMAT_IMM12HI_SIZE];
    wire [NANORV32_INST_FORMAT_IMM12LO_MSB:0] dec_imm12lo  = instruction_r[NANORV32_INST_FORMAT_IMM12LO_OFFSET +: NANORV32_INST_FORMAT_IMM12LO_SIZE];
    wire [NANORV32_INST_FORMAT_IMMSB2_MSB:0] dec_immsb2  = instruction_r[NANORV32_INST_FORMAT_IMMSB2_OFFSET +: NANORV32_INST_FORMAT_IMMSB2_SIZE];
    wire [NANORV32_INST_FORMAT_IMMSB1_MSB:0] dec_immsb1  = instruction_r[NANORV32_INST_FORMAT_IMMSB1_OFFSET +: NANORV32_INST_FORMAT_IMMSB1_SIZE];
    wire [NANORV32_INST_FORMAT_IMM20_MSB:0] dec_imm20  = instruction_r[NANORV32_INST_FORMAT_IMM20_OFFSET +: NANORV32_INST_FORMAT_IMM20_SIZE];
    wire [NANORV32_INST_FORMAT_IMM20UJ_MSB:0] dec_imm20uj  = instruction_r[NANORV32_INST_FORMAT_IMM20UJ_OFFSET +: NANORV32_INST_FORMAT_IMM20UJ_SIZE];
    wire [NANORV32_INST_FORMAT_SHAMT_MSB:0] dec_shamt  = instruction_r[NANORV32_INST_FORMAT_SHAMT_OFFSET +: NANORV32_INST_FORMAT_SHAMT_SIZE];
    wire [NANORV32_INST_FORMAT_SYS2_RS1_MSB:0] dec_sys2_rs1  = instruction_r[NANORV32_INST_FORMAT_SYS2_RS1_OFFSET +: NANORV32_INST_FORMAT_SYS2_RS1_SIZE];
    wire [NANORV32_INST_FORMAT_SYS1_RD_MSB:0] dec_sys1_rd  = instruction_r[NANORV32_INST_FORMAT_SYS1_RD_OFFSET +: NANORV32_INST_FORMAT_SYS1_RD_SIZE];
    wire [NANORV32_INST_FORMAT_FUNC12_MSB:0] dec_func12  = instruction_r[NANORV32_INST_FORMAT_FUNC12_OFFSET +: NANORV32_INST_FORMAT_FUNC12_SIZE];
    wire [NANORV32_INST_FORMAT_OPCODERVC_MSB:0] dec_opcodervc  = instruction_r[NANORV32_INST_FORMAT_OPCODERVC_OFFSET +: NANORV32_INST_FORMAT_OPCODERVC_SIZE];
    wire [NANORV32_INST_FORMAT_C_FUNC4_MSB:0] dec_c_func4  = instruction_r[NANORV32_INST_FORMAT_C_FUNC4_OFFSET +: NANORV32_INST_FORMAT_C_FUNC4_SIZE];
    wire [NANORV32_INST_FORMAT_C_RS2_MSB:0] dec_c_rs2  = instruction_r[NANORV32_INST_FORMAT_C_RS2_OFFSET +: NANORV32_INST_FORMAT_C_RS2_SIZE];
    wire [NANORV32_INST_FORMAT_C_RD_RS1_MSB:0] dec_c_rd_rs1  = instruction_r[NANORV32_INST_FORMAT_C_RD_RS1_OFFSET +: NANORV32_INST_FORMAT_C_RD_RS1_SIZE];
    wire [NANORV32_INST_FORMAT_C_FUNC3_MSB:0] dec_c_func3  = instruction_r[NANORV32_INST_FORMAT_C_FUNC3_OFFSET +: NANORV32_INST_FORMAT_C_FUNC3_SIZE];
    wire [NANORV32_INST_FORMAT_CI_IMMLO_MSB:0] dec_ci_immlo  = instruction_r[NANORV32_INST_FORMAT_CI_IMMLO_OFFSET +: NANORV32_INST_FORMAT_CI_IMMLO_SIZE];
    wire [NANORV32_INST_FORMAT_CI_IMMHI_MSB:0] dec_ci_immhi  = instruction_r[NANORV32_INST_FORMAT_CI_IMMHI_OFFSET +: NANORV32_INST_FORMAT_CI_IMMHI_SIZE];
    wire [NANORV32_INST_FORMAT_CSS_IMM_MSB:0] dec_css_imm  = instruction_r[NANORV32_INST_FORMAT_CSS_IMM_OFFSET +: NANORV32_INST_FORMAT_CSS_IMM_SIZE];
    wire [NANORV32_INST_FORMAT_CIW_IMM_MSB:0] dec_ciw_imm  = instruction_r[NANORV32_INST_FORMAT_CIW_IMM_OFFSET +: NANORV32_INST_FORMAT_CIW_IMM_SIZE];
    wire [NANORV32_INST_FORMAT_C_RD_P_MSB:0] dec_c_rd_p  = instruction_r[NANORV32_INST_FORMAT_C_RD_P_OFFSET +: NANORV32_INST_FORMAT_C_RD_P_SIZE];
    wire [NANORV32_INST_FORMAT_C_RS1_P_MSB:0] dec_c_rs1_p  = instruction_r[NANORV32_INST_FORMAT_C_RS1_P_OFFSET +: NANORV32_INST_FORMAT_C_RS1_P_SIZE];
    wire [NANORV32_INST_FORMAT_CL_IMMLO_MSB:0] dec_cl_immlo  = instruction_r[NANORV32_INST_FORMAT_CL_IMMLO_OFFSET +: NANORV32_INST_FORMAT_CL_IMMLO_SIZE];
    wire [NANORV32_INST_FORMAT_CL_IMMHI_MSB:0] dec_cl_immhi  = instruction_r[NANORV32_INST_FORMAT_CL_IMMHI_OFFSET +: NANORV32_INST_FORMAT_CL_IMMHI_SIZE];
    wire [NANORV32_INST_FORMAT_CS_IMMLO_MSB:0] dec_cs_immlo  = instruction_r[NANORV32_INST_FORMAT_CS_IMMLO_OFFSET +: NANORV32_INST_FORMAT_CS_IMMLO_SIZE];
    wire [NANORV32_INST_FORMAT_C_RS2_P_MSB:0] dec_c_rs2_p  = instruction_r[NANORV32_INST_FORMAT_C_RS2_P_OFFSET +: NANORV32_INST_FORMAT_C_RS2_P_SIZE];
    wire [NANORV32_INST_FORMAT_CS_IMMHI_MSB:0] dec_cs_immhi  = instruction_r[NANORV32_INST_FORMAT_CS_IMMHI_OFFSET +: NANORV32_INST_FORMAT_CS_IMMHI_SIZE];
    wire [NANORV32_INST_FORMAT_CB_OFFSET_LO_MSB:0] dec_cb_offset_lo  = instruction_r[NANORV32_INST_FORMAT_CB_OFFSET_LO_OFFSET +: NANORV32_INST_FORMAT_CB_OFFSET_LO_SIZE];
    wire [NANORV32_INST_FORMAT_CB_OFFSET_HI_MSB:0] dec_cb_offset_hi  = instruction_r[NANORV32_INST_FORMAT_CB_OFFSET_HI_OFFSET +: NANORV32_INST_FORMAT_CB_OFFSET_HI_SIZE];
    wire [NANORV32_INST_FORMAT_CJ_IMM_MSB:0] dec_cj_imm  = instruction_r[NANORV32_INST_FORMAT_CJ_IMM_OFFSET +: NANORV32_INST_FORMAT_CJ_IMM_SIZE];
    wire [NANORV32_INST_FORMAT_CS2_FUNC2_MSB:0] dec_cs2_func2  = instruction_r[NANORV32_INST_FORMAT_CS2_FUNC2_OFFSET +: NANORV32_INST_FORMAT_CS2_FUNC2_SIZE];
    wire [NANORV32_INST_FORMAT_C_FUNC6_MSB:0] dec_c_func6  = instruction_r[NANORV32_INST_FORMAT_C_FUNC6_OFFSET +: NANORV32_INST_FORMAT_C_FUNC6_SIZE];
    wire [NANORV32_INST_FORMAT_CB2_IMMLO_MSB:0] dec_cb2_immlo  = instruction_r[NANORV32_INST_FORMAT_CB2_IMMLO_OFFSET +: NANORV32_INST_FORMAT_CB2_IMMLO_SIZE];
    wire [NANORV32_INST_FORMAT_CB2_FUNC2_MSB:0] dec_cb2_func2  = instruction_r[NANORV32_INST_FORMAT_CB2_FUNC2_OFFSET +: NANORV32_INST_FORMAT_CB2_FUNC2_SIZE];
   //@end[instruction_fields]

   reg                                       write_rd;
   reg                                       datamem_read;
   reg                                       datamem_write;


   reg [NANORV32_DATA_MSB:0]                next_pc;


   wire [NANORV32_DATA_MSB:0]               rf_porta;
   wire [NANORV32_DATA_MSB:0]               rf_portb;
   reg [NANORV32_DATA_MSB:0]                rd_tmp;
   wire [NANORV32_DATA_MSB:0]                rd;

   reg [NANORV32_DATA_MSB:0]                alu_porta;
   reg [NANORV32_DATA_MSB:0]                alu_portb;
   wire [NANORV32_DATA_MSB:0]               alu_res;
   wire [NANORV32_DATA_MSB:0]               alu_add_res;


   reg [NANORV32_DATA_MSB:0]               pc_next;
   reg [NANORV32_DATA_MSB:0]               pc_fetch_r;
   reg [NANORV32_DATA_MSB:0]               pc_exe_r;  // Fixme - we track the PC for the exe stage explicitly
                                                       // this may not be optimal in term of size


   reg                                     branch_taken;
   reg                                     inst_valid_fetch;


   wire                                    alu_cond;
   wire                                    fifo_empty;
   wire                                    illegal_instruction_tmp;
   wire                                    illegal_instruction = illegal_instruction_tmp  & ~fifo_empty;


   reg [NANORV32_DATA_MSB:0]               mem2regfile;

   wire                                    stall_exe;
   wire                                    interlock;
   wire                                    branch_wait;
   wire                                    div_ready;
   wire                                    stall_fetch;
   wire                                    force_stall_pstate;
   wire                                    force_stall_pstate2;
   wire                                    force_stall_reset;

   wire                                    inst_ret;

   wire                                     output_new_pc;
   wire                                     cpu_codeif_req;
   wire                                     valid_inst;
   wire             [NANORV32_PSTATE_MSB:0] pstate_r;

   wire [NANORV32_DATA_MSB:0]               inst_irq;
   wire                                     reti_inst_detected; // an instruction equivalent
   wire                                     irq_bypass_inst_reg_r;
   wire                                     interrupt_state_r;
   wire                                     irq_ack;

   wire                                     allow_hidden_use_of_x0;
   wire                                     reset_over;

   reg [4:0]                                     regfile_port1;
   reg [4:0]                                     regfile_port2;
   reg [4:0]                                     regfile_portw;
   wire [NANORV32_DATA_MSB:0]               csr_core_rdata;

   // to a "return from interrupt" as been detected
   reg [NANORV32_MUX_SEL_DATAMEM_SIZE_READ_MSB:0] datamem_size_read_sel_r;


   genvar i;

   //===========================================================================
   // Immediate value reconstruction
   //===========================================================================

   wire [NANORV32_DATA_MSB:0]                   imm12_sext;
   wire [NANORV32_DATA_MSB:0]                   imm12hilo_sext;
   wire [NANORV32_DATA_MSB:0]                   imm12sb_sext;
   wire [NANORV32_DATA_MSB:0]                   imm20u_sext;
   wire [NANORV32_DATA_MSB:0]                   imm20uj_sext;
   wire [NANORV32_DATA_MSB:0]                   cimm12cj;
   wire [NANORV32_DATA_MSB:0]                   cimm5;
   wire [NANORV32_DATA_MSB:0]                   cimm5_lui;
   wire [NANORV32_DATA_MSB:0]                   cimm5_swsp;
   wire [NANORV32_DATA_MSB:0]                   cimm5_lwsp;
   wire [NANORV32_DATA_MSB:0]                   cimm5_cl;
   wire [NANORV32_DATA_MSB:0]                   cimm5_ciw;
   wire [NANORV32_DATA_MSB:0]                   cimm5_16sp;
   wire [NANORV32_DATA_MSB:0]                   cimm8_ciw;
   wire [NANORV32_DATA_MSB:0]                   cimm5_cb;


   assign imm12_sext = {{20{dec_imm12 [11]}},dec_imm12[11:0]};
   assign imm12hilo_sext = {{20{dec_imm12hi[6]}},dec_imm12hi[6:0],dec_imm12lo[4:0]};
   assign imm12sb_sext = {{20{dec_immsb2[6]}},dec_immsb2[6],dec_immsb1[0],dec_immsb2[5:0],dec_immsb1[4:1],1'b0};
   // Compressed encoding
   assign cimm12cj      =  {{20{dec_cj_imm[10]}} , dec_cj_imm[10], dec_cj_imm[6],
                           dec_cj_imm[8:7], dec_cj_imm[4],
                           dec_cj_imm[5], dec_cj_imm[0],
                           dec_cj_imm[9], dec_cj_imm[3:1] ,1'b0};
   assign cimm5        =   {{26{dec_ci_immhi}},dec_ci_immhi,dec_ci_immlo};
   assign cimm5_lui    =   {{15{dec_ci_immhi}},dec_ci_immhi,dec_ci_immlo,12'b0};
   assign cimm5_swsp   =   {24'b0,dec_css_imm[1:0],dec_css_imm[5:2],2'b0};
   assign cimm5_lwsp   =   {24'b0,dec_ci_immlo[1:0],dec_ci_immhi[0],dec_ci_immlo[4:2],2'b0};
   assign cimm5_cl     =   {25'b0,dec_cl_immlo[0],dec_cl_immhi[2:0],dec_cl_immlo[1],2'b0};
   assign cimm8_ciw    =   {24'b0,dec_ciw_imm[5:2], dec_ciw_imm[7:6],dec_ciw_imm[0],dec_ciw_imm[1],2'b0};
   assign cimm5_16sp   =   {{22{dec_ci_immhi[0]}},dec_ci_immhi[0],dec_ci_immlo[2:1],dec_ci_immlo[3],dec_ci_immlo[0],dec_ci_immlo[4],4'b0};
   assign cimm5_cb     =   {{23{dec_cb_offset_hi[2]}},dec_cb_offset_hi[2],dec_cb_offset_lo[4:3],dec_cb_offset_lo[0],dec_cb_offset_hi[1:0],dec_cb_offset_lo[2:1],1'b0};

   // Fixme - incomplete/wrong


   assign imm20u_sext = {dec_imm20uj[19:0],12'b0};

   assign imm20uj_sext = {{12{dec_imm20uj[19]}},
                        dec_imm20uj[19],
                        dec_imm20uj[7:3],
                        dec_imm20uj[2:0],
                        dec_imm20uj[8],
                        dec_imm20uj[18:13],
                        dec_imm20uj[12:9],
                        1'b0};


    /* nanorv32_prefetch AUTO_TEMPLATE(
     ); */
   nanorv32_prefetch
     U_PREFETCH_BUFFER (
                        .inst_ret       (inst_ret),
                        .inst_from_buffer(inst_from_buffer[NANORV32_DATA_MSB:0]),
                        .is_32           (is_32),
                        .reset_over     (reset_over),
                        .fifo_empty     (fifo_empty),
                        /*AUTOINST*/
                        // Outputs
                        .haddri         (haddri[NANORV32_DATA_MSB:0]),
                        .hproti         (hproti[3:0]),
                        .hsizei         (hsizei[2:0]),
                        .hmasteri       (hmasteri),
                        .hmasterlocki   (hmasterlocki),
                        .hbursti        (hbursti[2:0]),
                        .hwdatai        (hwdatai[NANORV32_DATA_MSB:0]),
                        .hwritei        (hwritei),
                        .htransi        (htransi),
                        // Inputs
                        .branch_taken   (branch_taken),
                        .pstate_r       (pstate_r[NANORV32_PSTATE_MSB:0]),
                        .pc_next        (pc_next[NANORV32_DATA_MSB:0]),
                        .hrdatai        (hrdatai[NANORV32_DATA_MSB:0]),
                        .hrespi         (hrespi),
                        .hreadyi        (hreadyi),
                        .hreadyd        (hreadyd),
                        .stall_exe      (stall_exe),
                        .force_stall_reset(force_stall_reset),
                        .rst_n          (rst_n),
                        .clk            (clk),
                        .irq_bypass_inst_reg_r(irq_bypass_inst_reg_r),
                        .interlock      (interlock));





   // If an irq is detected, we override the instruction register with the code from
   // the the micro-rom in the flow controller

   assign instruction_r = irq_bypass_inst_reg_r ? inst_irq : inst_from_buffer;






 /* module_name AUTO_TEMPLATE(
  ); */
   nanorv32_decoder U_DECODER (

                               .dec_c_rd_rs1(dec_c_rd_rs1),
                               .dec_c_rs2(dec_c_rs2),
                               .instruction_r(instruction_r),
                               .illegal_instruction(illegal_instruction_tmp),

                               .pc_next_sel(pc_next_sel),
                               .pc_branch_sel(pc_branch_sel),
                               .alu_op_sel(alu_op_sel),
                               .alu_portb_sel(alu_portb_sel),
                               .alu_porta_sel(alu_porta_sel),
                               .datamem_size_read_sel(datamem_size_read_sel),
                               .datamem_write_sel(datamem_write_sel),
                               .datamem_size_write_sel(datamem_size_write_sel),
                               .datamem_read_sel(datamem_read_sel),
                               .regfile_source_sel(regfile_source_sel),
                               .regfile_write_sel(regfile_write_sel),

                               // Added for RVC support
                               .regfile_port1_sel(regfile_port1_sel),
                               .regfile_port2_sel(regfile_port2_sel),
                               .regfile_portw_sel(regfile_portw_sel)
                               );

   //===========================================================================
   // Register file index - Addedd to support RVC
   //===========================================================================
   always @* begin
      case(regfile_port1_sel)
        NANORV32_MUX_SEL_REGFILE_PORT1_RS1_C_P: begin
           regfile_port1 = rvc_to_rv32_reg(dec_c_rs1_p);
        end
        NANORV32_MUX_SEL_REGFILE_PORT1_RS1_C: begin
           regfile_port1 = dec_c_rd_rs1;
        end
        NANORV32_MUX_SEL_REGFILE_PORT1_RS1: begin
           regfile_port1 = dec_rs1;
        end
        NANORV32_MUX_SEL_REGFILE_PORT1_C_X2: begin
           regfile_port1 = 5'h02;
        end
        default: begin
           regfile_port1 = dec_rs1;
        end
      endcase
   end

   always @* begin
      case(regfile_port2_sel)
        NANORV32_MUX_SEL_REGFILE_PORT2_X0: begin
           regfile_port2 = 5'h00;
        end
        NANORV32_MUX_SEL_REGFILE_PORT2_RS2_C: begin
           regfile_port2 = dec_c_rs2;
        end
        NANORV32_MUX_SEL_REGFILE_PORT2_RS2: begin
           regfile_port2 = dec_rs2;
        end
        NANORV32_MUX_SEL_REGFILE_PORT2_RS2_C_P: begin
           regfile_port2 = rvc_to_rv32_reg(dec_c_rs2_p);
        end

        default: begin
           regfile_port2 = dec_rs2;
        end
      endcase
   end
   always @* begin
      case(regfile_portw_sel)
        NANORV32_MUX_SEL_REGFILE_PORTW_RD: begin
           regfile_portw = dec_rd;
        end
        NANORV32_MUX_SEL_REGFILE_PORTW_RD_C: begin
           regfile_portw = dec_c_rd_rs1;
        end
        NANORV32_MUX_SEL_REGFILE_PORTW_C_X1: begin
           regfile_portw = 5'h01;
        end
        NANORV32_MUX_SEL_REGFILE_PORTW_RD_C_P: begin
           regfile_portw =  rvc_to_rv32_reg(dec_c_rs2_p);
        end
        NANORV32_MUX_SEL_REGFILE_PORTW_RS1_C_P: begin
           regfile_portw = rvc_to_rv32_reg(dec_c_rs1_p);
        end
        default: begin
	   regfile_portw = dec_rd;
        end
      endcase
   end




   //===========================================================================
   // ALU input selection
   //===========================================================================
   always@* begin
      case(alu_portb_sel)
        NANORV32_MUX_SEL_ALU_PORTB_IMM20U: begin
           alu_portb = imm20u_sext;
        end
        NANORV32_MUX_SEL_ALU_PORTB_SHAMT: begin
           alu_portb = {{NANORV32_SHAMT_FILL{1'b0}},dec_shamt};
        end
        NANORV32_MUX_SEL_ALU_PORTB_IMM12: begin
           alu_portb = imm12_sext;
        end
        NANORV32_MUX_SEL_ALU_PORTB_CIMM5: begin
           alu_portb = cimm5;
        end
        NANORV32_MUX_SEL_ALU_PORTB_CIMM10CJ: begin
           alu_portb = cimm12cj;
        end
        NANORV32_MUX_SEL_ALU_PORTB_CIMM5_CL: begin
           alu_portb = cimm5_cl;
        end
        NANORV32_MUX_SEL_ALU_PORTB_CIMM8_CIW: begin
           alu_portb = cimm8_ciw;
        end
        NANORV32_MUX_SEL_ALU_PORTB_CIMM5_SWSP: begin
           alu_portb = cimm5_swsp;
        end
        NANORV32_MUX_SEL_ALU_PORTB_CIMM5_LWSP: begin
           alu_portb = cimm5_lwsp;
        end
        NANORV32_MUX_SEL_ALU_PORTB_CIMM5_16SP: begin
           alu_portb = cimm5_16sp;
        end
        NANORV32_MUX_SEL_ALU_PORTB_RS2: begin
           alu_portb = rf_portb;
        end
        NANORV32_MUX_SEL_ALU_PORTB_IMM20UJ: begin
           alu_portb = imm20uj_sext;
        end
        NANORV32_MUX_SEL_ALU_PORTB_IMM12HILO: begin
           alu_portb = imm12hilo_sext;
        end
        NANORV32_MUX_SEL_ALU_PORTB_CIMM5_LUI: begin
           alu_portb = cimm5_lui;
        end
        default begin
           alu_portb = rf_portb;
        end
      endcase
   end

   always @* begin
      case(alu_porta_sel)
        NANORV32_MUX_SEL_ALU_PORTA_PC_EXE: begin
           alu_porta = pc_exe_r;
        end
        NANORV32_MUX_SEL_ALU_PORTA_RS1: begin
           alu_porta = rf_porta;
        end// Mux definitions for datamem
      default begin
         alu_porta = rf_porta;
      end  // default:
      endcase
   end

   //===========================================================================
   // Register file write-back
   //===========================================================================
   reg [NANORV32_INST_FORMAT_RD_MSB:0] dec_rd2;
   reg write_rd2;
   always @* begin
      case(regfile_source_sel)
        NANORV32_MUX_SEL_REGFILE_SOURCE_PC_EXE_PLUS_4:begin
           rd_tmp = pc_exe_r + 4;
        end
        NANORV32_MUX_SEL_REGFILE_SOURCE_PC_EXE_PLUS_2:begin
           rd_tmp = pc_exe_r + 2;
        end
        NANORV32_MUX_SEL_REGFILE_SOURCE_ALU: begin
           rd_tmp = alu_res;
        end
        NANORV32_MUX_SEL_REGFILE_SOURCE_DATAMEM: begin
           rd_tmp = mem2regfile ;
        end
        NANORV32_MUX_SEL_REGFILE_SOURCE_CSR_RDATA: begin
           rd_tmp = csr_core_rdata;
        end

        default begin
           rd_tmp = alu_res;
        end
      endcase
   end // always @ *
   assign rd = rd_tmp;
   always @* begin
      case(regfile_write_sel)
        NANORV32_MUX_SEL_REGFILE_WRITE_YES: begin
           write_rd = (!stall_exe) & valid_inst;
        end
        NANORV32_MUX_SEL_REGFILE_WRITE_NO: begin
           write_rd = 1'b0;
        end
        default begin
           write_rd = 1'b0;
        end
        // default:
      endcase // case (regfile_write)

   end
   always @(posedge clk or negedge rst_n) begin
      if(rst_n == 1'b0) begin
         /*AUTORESET*/
         // Beginning of autoreset for uninitialized flops
         datamem_size_read_sel_r <= {(1+(NANORV32_MUX_SEL_DATAMEM_SIZE_READ_MSB)){1'b0}};
         dec_rd2 <= {(1+(NANORV32_INST_FORMAT_RD_MSB)){1'b0}};
         write_rd2 <= 1'h0;
         // End of automatics
      end
      else begin
         if (hreadyd)
           begin
           write_rd2 <= (datamem_write || datamem_read) & write_rd;
           dec_rd2   <= {NANORV32_INST_FORMAT_RD_SIZE{(datamem_write || datamem_read)}} & regfile_portw;
           datamem_size_read_sel_r <= {NANORV32_MUX_SEL_DATAMEM_SIZE_READ_SIZE{(datamem_write || datamem_read)}} & datamem_size_read_sel;
           end
      end
   end
   wire [31:0]  rd2 = mem2regfile;

   //===========================================================================
   // Data memory interface
   //===========================================================================

   always @* begin
      case(datamem_read_sel)
        NANORV32_MUX_SEL_DATAMEM_READ_YES: begin
           datamem_read = valid_inst;
        end
        NANORV32_MUX_SEL_DATAMEM_READ_NO: begin
           datamem_read = 1'b0;
        end
        default begin
           datamem_read = 1'b0;
        end
      endcase
   end

   always @* begin
      case(datamem_write_sel)
        NANORV32_MUX_SEL_DATAMEM_WRITE_YES: begin
           datamem_write = valid_inst;
        end
        NANORV32_MUX_SEL_DATAMEM_WRITE_NO: begin
           datamem_write = 0;
        end
        default begin
           datamem_write = 1'b0;
        end
      endcase
   end

//========================================

   always @* begin
      case(pc_branch_sel)
          NANORV32_MUX_SEL_PC_BRANCH_YES: begin
              pc_branch <= 1'b1;
          end
          NANORV32_MUX_SEL_PC_BRANCH_NO: begin
              pc_branch <= 1'b0;
          end// Mux definitions for alu
        default begin
              pc_branch <= 1'b0;
        end
      endcase
   end

   //===========================================================================
   // PC management
   //===========================================================================
   always @* begin


      case(pc_next_sel)
        NANORV32_MUX_SEL_PC_NEXT_COND_PC_PLUS_IMMSB: begin
           pc_next = (alu_cond & output_new_pc & pc_branch) ? (pc_exe_r + imm12sb_sext) : (is_32 ? (pc_fetch_r + 4) : (pc_fetch_r + 2));
           // branch_taken = alu_cond & !stall_exe;
           branch_taken = alu_cond & pc_branch & ~fifo_empty & ~interlock;
        end
        NANORV32_MUX_SEL_PC_NEXT_COND_PC_PLUS_IMMSB_C: begin
           pc_next = (alu_cond & output_new_pc & pc_branch) ? (pc_exe_r + cimm5_cb) : (is_32 ? (pc_fetch_r + 4) : (pc_fetch_r + 2));
           // branch_taken = alu_cond & !stall_exe;
           branch_taken = alu_cond & pc_branch & ~fifo_empty & ~interlock;
        end
        NANORV32_MUX_SEL_PC_NEXT_PLUS4: begin
           if(!stall_exe) begin
              pc_next = (pc_fetch_r + 4); // Only 32-bit instruction for now
              branch_taken = 0;
           end
           else begin
              pc_next = pc_fetch_r; // Only 32-bit instruction for now
              branch_taken = 0;
           end
        end
        NANORV32_MUX_SEL_PC_NEXT_PLUS2: begin
           if(!stall_exe) begin
              pc_next = (pc_fetch_r + 2); // Only 16-bit instruction for now
              branch_taken = 0;
           end
           else begin
              pc_next = pc_fetch_r; // Only 32-bit instruction for now
              branch_taken = 0;
           end
        end
        NANORV32_MUX_SEL_PC_NEXT_ALU_RES: begin
           // The first cycle of a branch instruction, we need to output the
           // pc - but once we have fetch the new instruction, we need to start
           // fetching  the n+1 instruction
           // Fixme - this may not be valid if there is some wait-state
           pc_next = output_new_pc  ? alu_add_res & 32'hFFFFFFFE : (is_32 ? (pc_fetch_r + 4) : (pc_fetch_r + 2));

           // We cancel the branch if we detect a "reti"
           // while in interrupt state
            // branch_taken = !(reti_inst_detected && interrupt_state_r);
           branch_taken = ~fifo_empty & ~interlock;

        end// Mux definitions for alu
        default begin
           pc_next = (is_32 ? (pc_fetch_r + 4) : (pc_fetch_r + 2));
           branch_taken = 0;
        end
      endcase
   end

   always @(posedge clk or negedge rst_n) begin
      if(rst_n == 1'b0) begin
         /*AUTORESET*/
         // Beginning of autoreset for uninitialized flops
         pc_exe_r <= {(1+(NANORV32_DATA_MSB)){1'b0}};
         pc_fetch_r <= {(1+(NANORV32_DATA_MSB)){1'b0}};
         // End of automatics
      end
      else begin
         if(inst_ret &&  (!irq_bypass_inst_reg_r ||  branch_taken))
           // if we are overriding the intruction register with the micro-rom content
           // we should not update the PC - except for the latest instruction
           // that will be a branch
           pc_fetch_r <= {32{~reset_over}} & pc_next;

         if(inst_ret && (!irq_bypass_inst_reg_r  ||  branch_taken)) begin

            pc_exe_r  <=  {32{~reset_over}} & pc_next;
         end
      end
   end

   //===========================================================================
   // Flow management
   //===========================================================================

   assign cpu_codeif_req = 1'b1;
   wire  data_access_cycle; // Indicate when it is ok to access data space
   // (the first cycle normally)

   // Detection of return from interrupt
   // jalr x0,x1,0  with x1/ra = -1
   // with x1/ra coming from reg file port a
   assign reti_inst_detected = (instruction_r ==NANORV32_RET_INSTRUCTION) &&
                          (rf_porta == NANORV32_X1_RA_RETI_MAGIC_VALUE);


   nanorv32_regfile #(.NUM_REGS(32))
   U_REG_FILE (
               .porta          (rf_porta[NANORV32_DATA_MSB:0]),
               .portb          (rf_portb[NANORV32_DATA_MSB:0]),
               // Inputs
               .allow_hidden_use_of_x0  (allow_hidden_use_of_x0),
               .sel_porta               (regfile_port1[NANORV32_RF_PORTA_MSB:0]),
               .sel_portb               (regfile_port2[NANORV32_RF_PORTB_MSB:0]),
               .sel_rd                  (regfile_portw[NANORV32_RF_PORTRD_MSB:0]),
               .sel_rd2                 (dec_rd2[NANORV32_RF_PORTRD_MSB:0]),
               .rd                      (rd[NANORV32_DATA_MSB:0]),
               .rd2                     (rd2[NANORV32_DATA_MSB:0]),
               .write_rd                (write_rd),
               .write_rd2               (write_rd2),
               .clk                     (clk),
               .rst_n                   (rst_n));



   nanorv32_alumuldiv U_ALU (
                             .alu_add_res         (alu_add_res[NANORV32_DATA_MSB:0]),
                             // Outputs
                             .div_ready       (div_ready),
                             .alu_res         (alu_res[NANORV32_DATA_MSB:0]),
                             .alu_cond        (alu_cond),
                             // Inputs
                             .alu_op_sel      (alu_op_sel[NANORV32_MUX_SEL_ALU_OP_MSB:0]),
                             .alu_porta       (alu_porta[NANORV32_DATA_MSB:0]),
                             .alu_portb       (alu_portb[NANORV32_DATA_MSB:0]),
                             .interlock       (interlock),
                             .clk             (clk),
                             .rst_n           (rst_n));




                             /* nanorv32_csr AUTO_TEMPLATE(
                              .core_csr_wdata  ({@"vl-width"{1'b0}}),
                              .core_csr_write(1'b0),
                              ); */
                             nanorv32_csr U_CSR (
                       // Outputs
                       .csr_core_rdata  (csr_core_rdata),
                       // Inputs
                       .core_csr_addr   (dec_func12),
                       .force_stall_reset(force_stall_reset),
                       .stall_exe(stall_exe),
                       .clk(clk),
                       .rst_n(rst_n),
                       /*AUTOINST*/
                       // Inputs
                       .core_csr_wdata  ({(1+(NANORV32_DATA_MSB)){1'b0}}), // Templated
                       .core_csr_write  (1'b0));                  // Templated


   // data memory interface

   assign haddrd[31:2] = alu_add_res[31:2];
   // When we are pushing/stacking registers for interrupt entry/exit
   // we realign the stack pointer the "hard way" :-)
   // so that we don't have to do special computation or extra register
   // so be careful, don't use -4(sp)
   assign haddrd[1:0]  =  irq_bypass_inst_reg_r ? 2'b00 : alu_add_res[1:0];



   always @ (posedge clk or negedge rst_n) begin
   if (rst_n == 1'b0)
      cpu_dataif_addr <= 2'b00;
   else if (hreadyd & htransd)
      cpu_dataif_addr <= alu_add_res[1:0];
   end





   nanorv32_flow_ctrl
     U_FLOW_CTRL (
                  .reti_inst_detected    (reti_inst_detected),
                  .interrupt_state_r     (interrupt_state_r),
                  // Outputs
                  .allow_hidden_use_of_x0  (allow_hidden_use_of_x0),
                  .force_stall_pstate   (force_stall_pstate),
                  .force_stall_pstate2  (force_stall_pstate2),
                  .force_stall_reset    (force_stall_reset),
                  .output_new_pc        (output_new_pc),
                  .valid_inst           (valid_inst),
                  .data_access_cycle    (data_access_cycle),
                  .pstate_r             (pstate_r[NANORV32_PSTATE_MSB:0]),
                  .irq_ack              (irq_ack),
                  .irq_bypass_inst_reg_r  (irq_bypass_inst_reg_r),
                  .inst_irq             (inst_irq[NANORV32_DATA_MSB:0]),
                  // Inputs
                  .interlock           (interlock),
                  .branch_wait          (branch_wait),
                  .branch_taken         (branch_taken),
                  .datamem_read         (datamem_read),
                  .datamem_write        (datamem_write),
                  .hreadyd              (hreadyd),
                  .codeif_cpu_ready_r   (codeif_cpu_ready_r),
                  .irq                  (irq),
                  .clk                  (clk),
                  .rst_n                (rst_n));





   // assign mem2regfile = dataif_cpu_rdata;
   // assign cpu_dataif_wdata = rf_portb;

   assign cpu_dataif_req = (datamem_write || datamem_read) & data_access_cycle &~interlock & ~fifo_empty;
   // assign stall_fetch = !codeif_cpu_early_ready  | force_stall_pstate | !codeif_cpu_ready_r;
   assign stall_fetch = force_stall_pstate | !codeif_cpu_ready_r;
//   assign interlock   = write_rd2 & (dec_rd2 == dec_rs1 | dec_rd2 == dec_rs2) & ~(htransd & hreadyd & hwrited);
   assign interlock   = write_rd2 & (dec_rd2 == regfile_port1 | dec_rd2 == regfile_port2) |
                        write_rd2 & ~hreadyd & (datamem_write || datamem_read);

   assign branch_wait = branch_taken & pstate_r != NANORV32_PSTATE_BRANCH & ~hreadyi;
   assign stall_exe = force_stall_pstate | interlock | ~div_ready | fifo_empty | branch_wait; // REVISIT case where branch in a shadow store or load | pstate_r == NANORV32_PSTATE_WAITLD & ~hreadyd ;
   assign read_byte_sel = cpu_dataif_addr[1:0];
   wire  [2:0] hsized_tmp = {3{(datamem_size_read_sel == NANORV32_MUX_SEL_DATAMEM_SIZE_READ_HALFWORD_UNSIGNED |
                             datamem_size_read_sel == NANORV32_MUX_SEL_DATAMEM_SIZE_READ_HALFWORD)}} & 3'b001 |
                            {3{ (datamem_size_read_sel == NANORV32_MUX_SEL_DATAMEM_SIZE_READ_BYTE_UNSIGNED |
                             datamem_size_read_sel == NANORV32_MUX_SEL_DATAMEM_SIZE_READ_BYTE)}} & 3'b000 |
                            {3{ datamem_size_read_sel == NANORV32_MUX_SEL_DATAMEM_SIZE_READ_WORD }} & 3'b010;

   always @* begin
      case(datamem_size_read_sel_r)
        NANORV32_MUX_SEL_DATAMEM_SIZE_READ_HALFWORD_UNSIGNED: begin
           case(cpu_dataif_addr[1])
             1'b0: begin
                mem2regfile =  {16'b0,dataif_cpu_rdata[15:0]};
             end
             1'b1: begin
                mem2regfile =  {16'b0,dataif_cpu_rdata[31:16]};
             end
           endcase

        end
        NANORV32_MUX_SEL_DATAMEM_SIZE_READ_HALFWORD: begin
           case(cpu_dataif_addr[1])
             1'b0: begin
                mem2regfile =  {{16{dataif_cpu_rdata[15]}},dataif_cpu_rdata[15:0]};
             end
             1'b1: begin
                mem2regfile =  {{16{dataif_cpu_rdata[31]}},dataif_cpu_rdata[31:16]};
             end
           endcase
        end
        NANORV32_MUX_SEL_DATAMEM_SIZE_READ_WORD: begin
           mem2regfile = dataif_cpu_rdata ;
        end
        NANORV32_MUX_SEL_DATAMEM_SIZE_READ_BYTE: begin
           case(cpu_dataif_addr[1:0])
             2'b00: begin
                mem2regfile =  {{24{dataif_cpu_rdata[7]}},dataif_cpu_rdata[7:0]};
             end
             2'b01: begin
                mem2regfile =  {{24{dataif_cpu_rdata[15]}},dataif_cpu_rdata[15:8]};
             end
             2'b10: begin
                mem2regfile =  {{24{dataif_cpu_rdata[23]}},dataif_cpu_rdata[23:16]};
             end
             2'b11: begin
                mem2regfile =  {{24{dataif_cpu_rdata[31]}},dataif_cpu_rdata[31:24]};
             end
           endcase
        end
        NANORV32_MUX_SEL_DATAMEM_SIZE_READ_BYTE_UNSIGNED: begin
           case(cpu_dataif_addr[1:0])
             2'b00: begin
                mem2regfile =  {24'b0,dataif_cpu_rdata[7:0]};
             end
             2'b01: begin
                mem2regfile =  {24'b0,dataif_cpu_rdata[15:8]};
             end
             2'b10: begin
                mem2regfile =  {24'b0,dataif_cpu_rdata[23:16]};
             end
             2'b11: begin
                mem2regfile =  {24'b0,dataif_cpu_rdata[31:24]};
             end
           endcase
        end
        default begin
           mem2regfile =  dataif_cpu_rdata;
        end // UNMATCHED !!
      endcase
   end
  wire [31:0] wdata_nxt = ((regfile_port2 == dec_rd2) & write_rd2 & htransd & hwrited & hreadyd) ? mem2regfile : rf_portb ;
   // fixme - we don't need to mux zeros in unwritten bytes
  reg [1:0] write_sized;
   always @* begin
      case(datamem_size_write_sel)
        NANORV32_MUX_SEL_DATAMEM_SIZE_WRITE_BYTE: begin
           write_sized = 2'b00;
           case(haddrd[1:0])
             2'b00: begin
                cpu_dataif_wdata =  {24'b0,wdata_nxt[7:0]};
                cpu_dataif_bytesel = {3'b0,datamem_write};
             end
             2'b01: begin
                cpu_dataif_wdata =  {16'b0,wdata_nxt[7:0],8'b0};
                cpu_dataif_bytesel = {2'b0,datamem_write,1'b0};
             end
             2'b10: begin
                cpu_dataif_wdata =  {8'b0,wdata_nxt[7:0],16'b0};
                cpu_dataif_bytesel = {1'b0,datamem_write,2'b0};
             end
             2'b11: begin
                cpu_dataif_wdata =  {wdata_nxt[7:0],24'b0};
                cpu_dataif_bytesel = {datamem_write,3'b0};
             end
             default begin
                cpu_dataif_bytesel = {4{datamem_write}};
                cpu_dataif_wdata =  wdata_nxt;
             end
           endcase
        end
        NANORV32_MUX_SEL_DATAMEM_SIZE_WRITE_HALFWORD: begin
           write_sized = 2'b01;
           case(haddrd[1])
             1'b0: begin
                cpu_dataif_wdata =  {16'b0,wdata_nxt[15:0]};
                cpu_dataif_bytesel = {2'b0,datamem_write,datamem_write};
             end
             1'b1: begin
                cpu_dataif_wdata =  {wdata_nxt[15:0],16'b0};
                cpu_dataif_bytesel = {datamem_write,datamem_write,2'b0};
             end

             default begin
                cpu_dataif_bytesel = {4{datamem_write}};
                cpu_dataif_wdata =  wdata_nxt;
             end
           endcase

        end
        NANORV32_MUX_SEL_DATAMEM_SIZE_WRITE_WORD: begin
           write_sized = 2'b10;
           cpu_dataif_wdata = wdata_nxt;
           cpu_dataif_bytesel = {4{datamem_write}};
        end
        default begin
           write_sized = 2'b10;
           cpu_dataif_wdata = wdata_nxt;
           cpu_dataif_bytesel = {4{datamem_write}};
        end
      endcase
   end


   reg [31:0] cpu_dataif_wdata_reg;
   always @ (posedge clk or negedge rst_n) begin
   if (rst_n == 1'b0)
      cpu_dataif_wdata_reg <= 31'b00;
   else if (hreadyd & htransd)
      cpu_dataif_wdata_reg <= cpu_dataif_wdata;
   end

   assign hwdatad          = cpu_dataif_wdata_reg;
   assign htransd          = cpu_dataif_req;
   assign hwrited          = datamem_write;
   assign hsized           = datamem_write ? write_sized : hsized_tmp ;
   assign hburstd          = 3'b000 ;
   assign hmasterd         = 1'b0 ;
   assign hmasterlockd     = 1'b0 ;
   assign hprotd           = 4'b0000;
   assign dataif_cpu_rdata = hrdatad;

endmodule // nanorv32
/*
 Local Variables:
 verilog-library-directories:(
 "."
 )
 End:
 */
