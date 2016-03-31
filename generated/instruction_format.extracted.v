
// Instruction opcode1
parameter NANORV32_INST_FORMAT_OPCODE1_OFFSET = 0;
parameter NANORV32_INST_FORMAT_OPCODE1_SIZE = 7;
parameter NANORV32_INST_FORMAT_OPCODE1_MSB = 6;

// Instruction func3
parameter NANORV32_INST_FORMAT_FUNC3_OFFSET = 12;
parameter NANORV32_INST_FORMAT_FUNC3_SIZE = 3;
parameter NANORV32_INST_FORMAT_FUNC3_MSB = 2;

// Instruction func7
parameter NANORV32_INST_FORMAT_FUNC7_OFFSET = 25;
parameter NANORV32_INST_FORMAT_FUNC7_SIZE = 7;
parameter NANORV32_INST_FORMAT_FUNC7_MSB = 6;

// Instruction rd
parameter NANORV32_INST_FORMAT_RD_OFFSET = 7;
parameter NANORV32_INST_FORMAT_RD_SIZE = 5;
parameter NANORV32_INST_FORMAT_RD_MSB = 4;

// Instruction rs1
parameter NANORV32_INST_FORMAT_RS1_OFFSET = 15;
parameter NANORV32_INST_FORMAT_RS1_SIZE = 5;
parameter NANORV32_INST_FORMAT_RS1_MSB = 4;

// Instruction rs2
parameter NANORV32_INST_FORMAT_RS2_OFFSET = 20;
parameter NANORV32_INST_FORMAT_RS2_SIZE = 5;
parameter NANORV32_INST_FORMAT_RS2_MSB = 4;

// Instruction imm12
parameter NANORV32_INST_FORMAT_IMM12_OFFSET = 20;
parameter NANORV32_INST_FORMAT_IMM12_SIZE = 12;
parameter NANORV32_INST_FORMAT_IMM12_MSB = 11;

// Instruction imm12hi
parameter NANORV32_INST_FORMAT_IMM12HI_OFFSET = 25;
parameter NANORV32_INST_FORMAT_IMM12HI_SIZE = 7;
parameter NANORV32_INST_FORMAT_IMM12HI_MSB = 6;

// Instruction imm12lo
parameter NANORV32_INST_FORMAT_IMM12LO_OFFSET = 7;
parameter NANORV32_INST_FORMAT_IMM12LO_SIZE = 5;
parameter NANORV32_INST_FORMAT_IMM12LO_MSB = 4;

// Instruction immsb2
parameter NANORV32_INST_FORMAT_IMMSB2_OFFSET = 25;
parameter NANORV32_INST_FORMAT_IMMSB2_SIZE = 7;
parameter NANORV32_INST_FORMAT_IMMSB2_MSB = 6;

// Instruction immsb1
parameter NANORV32_INST_FORMAT_IMMSB1_OFFSET = 7;
parameter NANORV32_INST_FORMAT_IMMSB1_SIZE = 5;
parameter NANORV32_INST_FORMAT_IMMSB1_MSB = 4;

// Instruction imm20
parameter NANORV32_INST_FORMAT_IMM20_OFFSET = 12;
parameter NANORV32_INST_FORMAT_IMM20_SIZE = 20;
parameter NANORV32_INST_FORMAT_IMM20_MSB = 19;

// Instruction imm20uj
parameter NANORV32_INST_FORMAT_IMM20UJ_OFFSET = 12;
parameter NANORV32_INST_FORMAT_IMM20UJ_SIZE = 20;
parameter NANORV32_INST_FORMAT_IMM20UJ_MSB = 19;

// Instruction shamt
parameter NANORV32_INST_FORMAT_SHAMT_OFFSET = 20;
parameter NANORV32_INST_FORMAT_SHAMT_SIZE = 5;
parameter NANORV32_INST_FORMAT_SHAMT_MSB = 4;

// Instruction sys2_rs1
parameter NANORV32_INST_FORMAT_SYS2_RS1_OFFSET = 15;
parameter NANORV32_INST_FORMAT_SYS2_RS1_SIZE = 5;
parameter NANORV32_INST_FORMAT_SYS2_RS1_MSB = 4;

// Instruction sys1_rd
parameter NANORV32_INST_FORMAT_SYS1_RD_OFFSET = 7;
parameter NANORV32_INST_FORMAT_SYS1_RD_SIZE = 5;
parameter NANORV32_INST_FORMAT_SYS1_RD_MSB = 4;

// Instruction func12
parameter NANORV32_INST_FORMAT_FUNC12_OFFSET = 20;
parameter NANORV32_INST_FORMAT_FUNC12_SIZE = 12;
parameter NANORV32_INST_FORMAT_FUNC12_MSB = 11;

// Instruction opcodervc
parameter NANORV32_INST_FORMAT_OPCODERVC_OFFSET = 0;
parameter NANORV32_INST_FORMAT_OPCODERVC_SIZE = 2;
parameter NANORV32_INST_FORMAT_OPCODERVC_MSB = 1;

// Instruction hint_rvc_rd_rs1_is_two
parameter NANORV32_INST_FORMAT_HINT_RVC_RD_RS1_IS_TWO_OFFSET = 33;
parameter NANORV32_INST_FORMAT_HINT_RVC_RD_RS1_IS_TWO_SIZE = 1;
parameter NANORV32_INST_FORMAT_HINT_RVC_RD_RS1_IS_TWO_MSB = 0;

// Instruction hint_rvc_rd_rs1_is_zero
parameter NANORV32_INST_FORMAT_HINT_RVC_RD_RS1_IS_ZERO_OFFSET = 32;
parameter NANORV32_INST_FORMAT_HINT_RVC_RD_RS1_IS_ZERO_SIZE = 1;
parameter NANORV32_INST_FORMAT_HINT_RVC_RD_RS1_IS_ZERO_MSB = 0;

// Instruction c_func4
parameter NANORV32_INST_FORMAT_C_FUNC4_OFFSET = 12;
parameter NANORV32_INST_FORMAT_C_FUNC4_SIZE = 4;
parameter NANORV32_INST_FORMAT_C_FUNC4_MSB = 3;

// Instruction hint_rvc_rs2_is_zero
parameter NANORV32_INST_FORMAT_HINT_RVC_RS2_IS_ZERO_OFFSET = 34;
parameter NANORV32_INST_FORMAT_HINT_RVC_RS2_IS_ZERO_SIZE = 1;
parameter NANORV32_INST_FORMAT_HINT_RVC_RS2_IS_ZERO_MSB = 0;

// Instruction c_rs2
parameter NANORV32_INST_FORMAT_C_RS2_OFFSET = 2;
parameter NANORV32_INST_FORMAT_C_RS2_SIZE = 5;
parameter NANORV32_INST_FORMAT_C_RS2_MSB = 4;

// Instruction c_rd_rs1
parameter NANORV32_INST_FORMAT_C_RD_RS1_OFFSET = 7;
parameter NANORV32_INST_FORMAT_C_RD_RS1_SIZE = 5;
parameter NANORV32_INST_FORMAT_C_RD_RS1_MSB = 4;

// Instruction c_func3
parameter NANORV32_INST_FORMAT_C_FUNC3_OFFSET = 13;
parameter NANORV32_INST_FORMAT_C_FUNC3_SIZE = 3;
parameter NANORV32_INST_FORMAT_C_FUNC3_MSB = 2;

// Instruction ci_immlo
parameter NANORV32_INST_FORMAT_CI_IMMLO_OFFSET = 2;
parameter NANORV32_INST_FORMAT_CI_IMMLO_SIZE = 5;
parameter NANORV32_INST_FORMAT_CI_IMMLO_MSB = 4;

// Instruction ci_immhi
parameter NANORV32_INST_FORMAT_CI_IMMHI_OFFSET = 12;
parameter NANORV32_INST_FORMAT_CI_IMMHI_SIZE = 1;
parameter NANORV32_INST_FORMAT_CI_IMMHI_MSB = 0;

// Instruction css_imm
parameter NANORV32_INST_FORMAT_CSS_IMM_OFFSET = 7;
parameter NANORV32_INST_FORMAT_CSS_IMM_SIZE = 6;
parameter NANORV32_INST_FORMAT_CSS_IMM_MSB = 5;

// Instruction ciw_imm
parameter NANORV32_INST_FORMAT_CIW_IMM_OFFSET = 5;
parameter NANORV32_INST_FORMAT_CIW_IMM_SIZE = 8;
parameter NANORV32_INST_FORMAT_CIW_IMM_MSB = 7;

// Instruction c_rd_p
parameter NANORV32_INST_FORMAT_C_RD_P_OFFSET = 2;
parameter NANORV32_INST_FORMAT_C_RD_P_SIZE = 3;
parameter NANORV32_INST_FORMAT_C_RD_P_MSB = 2;

// Instruction c_rs1_p
parameter NANORV32_INST_FORMAT_C_RS1_P_OFFSET = 7;
parameter NANORV32_INST_FORMAT_C_RS1_P_SIZE = 3;
parameter NANORV32_INST_FORMAT_C_RS1_P_MSB = 2;

// Instruction cl_immlo
parameter NANORV32_INST_FORMAT_CL_IMMLO_OFFSET = 5;
parameter NANORV32_INST_FORMAT_CL_IMMLO_SIZE = 2;
parameter NANORV32_INST_FORMAT_CL_IMMLO_MSB = 1;

// Instruction cl_immhi
parameter NANORV32_INST_FORMAT_CL_IMMHI_OFFSET = 10;
parameter NANORV32_INST_FORMAT_CL_IMMHI_SIZE = 3;
parameter NANORV32_INST_FORMAT_CL_IMMHI_MSB = 2;

// Instruction cs_immlo
parameter NANORV32_INST_FORMAT_CS_IMMLO_OFFSET = 5;
parameter NANORV32_INST_FORMAT_CS_IMMLO_SIZE = 2;
parameter NANORV32_INST_FORMAT_CS_IMMLO_MSB = 1;

// Instruction c_rs2_p
parameter NANORV32_INST_FORMAT_C_RS2_P_OFFSET = 2;
parameter NANORV32_INST_FORMAT_C_RS2_P_SIZE = 3;
parameter NANORV32_INST_FORMAT_C_RS2_P_MSB = 2;

// Instruction cs_immhi
parameter NANORV32_INST_FORMAT_CS_IMMHI_OFFSET = 10;
parameter NANORV32_INST_FORMAT_CS_IMMHI_SIZE = 3;
parameter NANORV32_INST_FORMAT_CS_IMMHI_MSB = 2;

// Instruction cb_offset_lo
parameter NANORV32_INST_FORMAT_CB_OFFSET_LO_OFFSET = 2;
parameter NANORV32_INST_FORMAT_CB_OFFSET_LO_SIZE = 5;
parameter NANORV32_INST_FORMAT_CB_OFFSET_LO_MSB = 4;

// Instruction cb_offset_hi
parameter NANORV32_INST_FORMAT_CB_OFFSET_HI_OFFSET = 10;
parameter NANORV32_INST_FORMAT_CB_OFFSET_HI_SIZE = 3;
parameter NANORV32_INST_FORMAT_CB_OFFSET_HI_MSB = 2;

// Instruction cj_imm
parameter NANORV32_INST_FORMAT_CJ_IMM_OFFSET = 2;
parameter NANORV32_INST_FORMAT_CJ_IMM_SIZE = 11;
parameter NANORV32_INST_FORMAT_CJ_IMM_MSB = 10;

// Instruction cb2_dec
parameter NANORV32_INST_FORMAT_CB2_DEC_OFFSET = 5;
parameter NANORV32_INST_FORMAT_CB2_DEC_SIZE = 2;
parameter NANORV32_INST_FORMAT_CB2_DEC_MSB = 1;

// Instruction c_func6
parameter NANORV32_INST_FORMAT_C_FUNC6_OFFSET = 10;
parameter NANORV32_INST_FORMAT_C_FUNC6_SIZE = 6;
parameter NANORV32_INST_FORMAT_C_FUNC6_MSB = 5;

// Instruction c_func2
parameter NANORV32_INST_FORMAT_C_FUNC2_OFFSET = 10;
parameter NANORV32_INST_FORMAT_C_FUNC2_SIZE = 2;
parameter NANORV32_INST_FORMAT_C_FUNC2_MSB = 1;

// Instruction cb2_immlo
parameter NANORV32_INST_FORMAT_CB2_IMMLO_OFFSET = 12;
parameter NANORV32_INST_FORMAT_CB2_IMMLO_SIZE = 1;
parameter NANORV32_INST_FORMAT_CB2_IMMLO_MSB = 0;
