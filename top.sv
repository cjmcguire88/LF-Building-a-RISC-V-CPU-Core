`line 2 "top.tlv" 0
//_\SV
   // This code can be found in: https://github.com/stevehoover/LF-Building-a-RISC-V-CPU-Core/risc-v_shell.tlv

   // Included URL: "https://raw.githubusercontent.com/stevehoover/LF-Building-a-RISC-V-CPU-Core/main/lib/risc-v_shell_lib.tlv"// Included URL: "https://raw.githubusercontent.com/stevehoover/warp-v_includes/1d1023ccf8e7b0a8cf8e8fc4f0a823ebb61008e3/risc-v_defs.tlv"



   //---------------------------------------------------------------------------------
   // /====================\
   // | Sum 1 to 9 Program |
   // \====================/
   //
   // Program to test RV32I
   // Add 1,2,3,...,9 (in that order).
   //
   // Regs:
   //  x12 (a2): 10
   //  x13 (a3): 1..10
   //  x14 (a4): Sum
   //
   // m4_asm(ADDI, x14, x0, 0)             // Initialize sum register a4 with 0
   // m4_asm(ADDI, x12, x0, 1010)          // Store count of 10 in register a2.
   // m4_asm(ADDI, x13, x0, 1)             // Initialize loop count register a3 with 0
   // Loop:
   // m4_asm(ADD, x14, x13, x14)           // Incremental summation
   // m4_asm(ADDI, x13, x13, 1)            // Increment loop count by 1
   // m4_asm(BLT, x13, x12, 1111111111000) // If a3 is less than a2, branch to label named <loop>
   // Test result value in x14, and set x31 to reflect pass/fail.
   // m4_asm(ADDI, x30, x14, 111111010100) // Subtract expected value of 44 to set x30 to 1 if and only iff the result is 45 (1 + 2 + ... + 9).
   // m4_asm(BGE, x0, x0, 0) // Done. Jump to itself (infinite loop). (Up to 20-bit signed immediate plus implicit 0 bit (unlike JALR) provides byte address; last immediate bit should also be 0)
   // m4_asm_end()
   // Test program
   `define READONLY_MEM(ADDR, DATA) logic [31:0] instrs [0:58-1]; assign DATA = instrs[ADDR[$clog2($size(instrs)) + 1 : 2]]; assign instrs = '{{12'b10101, 5'd0, 3'b000, 5'd1, 7'b0010011}, {12'b111, 5'd0, 3'b000, 5'd2, 7'b0010011}, {12'b111111111100, 5'd0, 3'b000, 5'd3, 7'b0010011}, {12'b1011100, 5'd1, 3'b111, 5'd5, 7'b0010011}, {12'b10101, 5'd5, 3'b100, 5'd5, 7'b0010011}, {12'b1011100, 5'd1, 3'b110, 5'd6, 7'b0010011}, {12'b1011100, 5'd6, 3'b100, 5'd6, 7'b0010011}, {12'b111, 5'd1, 3'b000, 5'd7, 7'b0010011}, {12'b11101, 5'd7, 3'b100, 5'd7, 7'b0010011}, {6'b000000, 6'b110, 5'd1, 3'b001, 5'd8, 7'b0010011}, {12'b10101000001, 5'd8, 3'b100, 5'd8, 7'b0010011}, {6'b000000, 6'b10, 5'd1, 3'b101, 5'd9, 7'b0010011}, {12'b100, 5'd9, 3'b100, 5'd9, 7'b0010011}, {7'b0000000, 5'd2, 5'd1, 3'b111, 5'd10, 7'b0110011}, {12'b100, 5'd10, 3'b100, 5'd10, 7'b0010011}, {7'b0000000, 5'd2, 5'd1, 3'b110, 5'd11, 7'b0110011}, {12'b10110, 5'd11, 3'b100, 5'd11, 7'b0010011}, {7'b0000000, 5'd2, 5'd1, 3'b100, 5'd12, 7'b0110011}, {12'b10011, 5'd12, 3'b100, 5'd12, 7'b0010011}, {7'b0000000, 5'd2, 5'd1, 3'b000, 5'd13, 7'b0110011}, {12'b11101, 5'd13, 3'b100, 5'd13, 7'b0010011}, {7'b0100000, 5'd2, 5'd1, 3'b000, 5'd14, 7'b0110011}, {12'b1111, 5'd14, 3'b100, 5'd14, 7'b0010011}, {7'b0000000, 5'd2, 5'd2, 3'b001, 5'd15, 7'b0110011}, {12'b1110000001, 5'd15, 3'b100, 5'd15, 7'b0010011}, {7'b0000000, 5'd2, 5'd1, 3'b101, 5'd16, 7'b0110011}, {12'b1, 5'd16, 3'b100, 5'd16, 7'b0010011}, {7'b0000000, 5'd1, 5'd2, 3'b011, 5'd17, 7'b0110011}, {12'b0, 5'd17, 3'b100, 5'd17, 7'b0010011}, {12'b10101, 5'd2, 3'b011, 5'd18, 7'b0010011}, {12'b0, 5'd18, 3'b100, 5'd18, 7'b0010011}, {20'b00000000000000000000, 5'd19, 7'b0110111}, {12'b1, 5'd19, 3'b100, 5'd19, 7'b0010011}, {6'b010000, 6'b1, 5'd3, 3'b101, 5'd20, 7'b0010011}, {12'b111111111111, 5'd20, 3'b100, 5'd20, 7'b0010011}, {7'b0000000, 5'd1, 5'd3, 3'b010, 5'd21, 7'b0110011}, {12'b0, 5'd21, 3'b100, 5'd21, 7'b0010011}, {12'b1, 5'd3, 3'b010, 5'd22, 7'b0010011}, {12'b0, 5'd22, 3'b100, 5'd22, 7'b0010011}, {7'b0100000, 5'd2, 5'd1, 3'b101, 5'd23, 7'b0110011}, {12'b1, 5'd23, 3'b100, 5'd23, 7'b0010011}, {20'b00000000000000000100, 5'd4, 7'b0010111}, {6'b000000, 6'b111, 5'd4, 3'b101, 5'd24, 7'b0010011}, {12'b10000000, 5'd24, 3'b100, 5'd24, 7'b0010011}, {1'b0, 10'b0000000010, 1'b0, 8'b00000000, 5'd25, 7'b1101111}, {20'b00000000000000000000, 5'd4, 7'b0010111}, {7'b0000000, 5'd4, 5'd25, 3'b100, 5'd25, 7'b0110011}, {12'b1, 5'd25, 3'b100, 5'd25, 7'b0010011}, {12'b10000, 5'd4, 3'b000, 5'd26, 7'b1100111}, {7'b0100000, 5'd4, 5'd26, 3'b000, 5'd26, 7'b0110011}, {12'b111111110001, 5'd26, 3'b000, 5'd26, 7'b0010011}, {7'b0000000, 5'd1, 5'd2, 3'b010, 5'b00001, 7'b0100011}, {12'b1, 5'd2, 3'b010, 5'd27, 7'b0000011}, {12'b10100, 5'd27, 3'b100, 5'd27, 7'b0010011}, {12'b1, 5'd0, 3'b000, 5'd28, 7'b0010011}, {12'b1, 5'd0, 3'b000, 5'd29, 7'b0010011}, {12'b1, 5'd0, 3'b000, 5'd30, 7'b0010011}, {1'b0, 10'b0000000000, 1'b0, 8'b00000000, 5'd0, 7'b1101111}};
   
   //---------------------------------------------------------------------------------

//_\SV
   module top(input wire clk, input wire reset, input wire [31:0] cyc_cnt, output wire passed, output wire failed);    /* verilator lint_save */ /* verilator lint_off UNOPTFLAT */  bit [256:0] RW_rand_raw; bit [256+63:0] RW_rand_vect; pseudo_rand #(.WIDTH(257)) pseudo_rand (clk, reset, RW_rand_raw[256:0]); assign RW_rand_vect[256+63:0] = {RW_rand_raw[62:0], RW_rand_raw};  /* verilator lint_restore */  /* verilator lint_off WIDTH */ /* verilator lint_off UNOPTFLAT */   // (Expanded in Nav-TLV pane.)

`include "top_gen.sv" //_\TLV

   assign L0_reset_a0 = reset;

   // Program Counter
   // Reset to 0x00000000, otherwise increment by 4 bytes per instruction
   assign L0_pc_a0[31:0] = L0_reset_a1 ? 32'h00000000 : L0_next_pc_a1[31:0];

   // Verilog macro for instruction memory - fetch 32-bit
   // instruction at PC address
   `READONLY_MEM(L0_pc_a0[31:0], L0_instr_a0[31:0])

   //Decode instruction type by comparing opcodes
   assign L0_is_u_instr_a0 = L0_instr_a0[6:2] ==? 5'b00101 ||
                 L0_instr_a0[6:2] ==? 5'b01101;
   assign L0_is_i_instr_a0 = L0_instr_a0[6:2] ==? 5'b00000 ||
                 L0_instr_a0[6:2] ==? 5'b00001 ||
                 L0_instr_a0[6:2] ==? 5'b11001 ||
                 L0_instr_a0[6:2] ==? 5'b00100 ||
                 L0_instr_a0[6:2] ==? 5'b00110;
   assign L0_is_s_instr_a0 = L0_instr_a0[6:2] ==? 5'b01000 ||
                 L0_instr_a0[6:2] ==? 5'b01001;
   assign L0_is_b_instr_a0 = L0_instr_a0[6:2] ==? 5'b11000;
   assign L0_is_r_instr_a0 = L0_instr_a0[6:2] ==? 5'b01011 ||
                 L0_instr_a0[6:2] ==? 5'b01100 ||
                 L0_instr_a0[6:2] ==? 5'b01110 ||
                 L0_instr_a0[6:2] ==? 5'b10100;
   assign L0_is_j_instr_a0 = L0_instr_a0[6:2] ==? 5'b11011;

   // Split instruction fields
   assign L0_opcode_a0[6:0] = L0_instr_a0[6:0];
   assign L0_rd_a0[4:0] = L0_instr_a0[11:7];
   assign L0_rs1_a0[4:0] = L0_instr_a0[19:15];
   assign L0_rs2_a0[4:0] = L0_instr_a0[24:20];
   assign L0_funct3_a0[2:0] = L0_instr_a0[14:12];

   // Check validity of fields from instruction type
   assign L0_rd_valid_a0 = L0_is_r_instr_a0 || L0_is_i_instr_a0 || L0_is_u_instr_a0 || L0_is_j_instr_a0;
   assign L0_rs1_valid_a0 = L0_is_r_instr_a0 || L0_is_i_instr_a0 || L0_is_s_instr_a0 || L0_is_b_instr_a0;
   assign L0_rs2_valid_a0 = L0_is_r_instr_a0 || L0_is_s_instr_a0 || L0_is_b_instr_a0;
   assign L0_funct3_valid_a0 = L0_is_r_instr_a0 || L0_is_i_instr_a0 || L0_is_s_instr_a0 || L0_is_b_instr_a0;
   assign L0_imm_valid_a0 = L0_is_i_instr_a0 || L0_is_s_instr_a0 || L0_is_b_instr_a0 || L0_is_u_instr_a0 || L0_is_j_instr_a0;
   `BOGUS_USE(L0_funct3_valid_a0 L0_imm_valid_a0)
   // The fields containing the immediate value vary based on instruction type.
   // Here we construct the immediate value from the instruction bits depending
   // on instruction type.
   assign L0_imm_a0[31:0] = L0_is_i_instr_a0 ? {  {21{L0_instr_a0[31]}},  L0_instr_a0[30:20]  } :
                L0_is_s_instr_a0 ? {  {20{L0_instr_a0[31]}},  L0_instr_a0[31:25], L0_instr_a0[11:7]  } :
                L0_is_b_instr_a0 ? {  {20{L0_instr_a0[31]}},  L0_instr_a0[7], L0_instr_a0[30:25], L0_instr_a0[11:8], 1'b0  } :
                L0_is_u_instr_a0 ? {  L0_instr_a0[31:12], 12'b0  } :
                L0_is_j_instr_a0 ? {  {12{L0_instr_a0[31]}},  L0_instr_a0[19:12], L0_instr_a0[20], L0_instr_a0[30:21], 1'b0  } :
                32'b0;

   // Here we combine the opcode, funct3 and instr[30] (funct7[5] if r-type)
   // fields in $dec_bits and then compare them to known instructions. We use
   // x as a don't care value i.e. instr[30] is only needed to distinguish
   // between add and sub instructions. Underscore is used as a field separator.
   assign L0_dec_bits_a0[10:0] = {L0_instr_a0[30],L0_funct3_a0,L0_opcode_a0};
   assign L0_is_lui_a0   = L0_is_u_instr_a0 && L0_dec_bits_a0 ==? 11'bx_xxx_x1xxxxx;
   assign L0_is_auipc_a0 = L0_is_u_instr_a0 && L0_dec_bits_a0 ==? 11'bx_xxx_x0xxxxx;
   assign L0_is_jal_a0   = L0_is_j_instr_a0;
   assign L0_is_jalr_a0  = L0_is_i_instr_a0 && L0_dec_bits_a0 ==? 11'bx_000_11001xx;
   assign L0_is_beq_a0   = L0_is_b_instr_a0 && L0_dec_bits_a0 ==? 11'bx_000_xxxxxxx;
   assign L0_is_bne_a0   = L0_is_b_instr_a0 && L0_dec_bits_a0 ==? 11'bx_001_xxxxxxx;
   assign L0_is_blt_a0   = L0_is_b_instr_a0 && L0_dec_bits_a0 ==? 11'bx_100_xxxxxxx;
   assign L0_is_bge_a0   = L0_is_b_instr_a0 && L0_dec_bits_a0 ==? 11'bx_101_xxxxxxx;
   assign L0_is_bltu_a0  = L0_is_b_instr_a0 && L0_dec_bits_a0 ==? 11'bx_110_xxxxxxx;
   assign L0_is_bgeu_a0  = L0_is_b_instr_a0 && L0_dec_bits_a0 ==? 11'bx_111_xxxxxxx;
   assign L0_is_addi_a0  = L0_is_i_instr_a0 && L0_dec_bits_a0 ==? 11'bx_000_00100xx;
   assign L0_is_slti_a0  = L0_is_i_instr_a0 && L0_dec_bits_a0 ==? 11'bx_010_00100xx;
   assign L0_is_sltiu_a0 = L0_is_i_instr_a0 && L0_dec_bits_a0 ==? 11'bx_011_00100xx;
   assign L0_is_xori_a0  = L0_is_i_instr_a0 && L0_dec_bits_a0 ==? 11'bx_100_00100xx;
   assign L0_is_ori_a0   = L0_is_i_instr_a0 && L0_dec_bits_a0 ==? 11'bx_110_00100xx;
   assign L0_is_andi_a0  = L0_is_i_instr_a0 && L0_dec_bits_a0 ==? 11'bx_111_00100xx;
   assign L0_is_slli_a0  = L0_is_i_instr_a0 && L0_dec_bits_a0 ==? 11'b0_001_00100xx;
   assign L0_is_srli_a0  = L0_is_i_instr_a0 && L0_dec_bits_a0 ==? 11'b0_101_00100xx;
   assign L0_is_srai_a0  = L0_is_i_instr_a0 && L0_dec_bits_a0 ==? 11'b1_101_00100xx;
   assign L0_is_add_a0   = L0_is_r_instr_a0 && L0_dec_bits_a0 ==? 11'b0_000_01100xx;
   assign L0_is_sub_a0   = L0_is_r_instr_a0 && L0_dec_bits_a0 ==? 11'b1_000_01100xx;
   assign L0_is_sll_a0   = L0_is_r_instr_a0 && L0_dec_bits_a0 ==? 11'b0_001_01100xx;
   assign L0_is_slt_a0   = L0_is_r_instr_a0 && L0_dec_bits_a0 ==? 11'b0_010_01100xx;
   assign L0_is_sltu_a0  = L0_is_r_instr_a0 && L0_dec_bits_a0 ==? 11'b0_011_01100xx;
   assign L0_is_xor_a0   = L0_is_r_instr_a0 && L0_dec_bits_a0 ==? 11'b0_100_01100xx;
   assign L0_is_srl_a0   = L0_is_r_instr_a0 && L0_dec_bits_a0 ==? 11'b0_101_01100xx;
   assign L0_is_sra_a0   = L0_is_r_instr_a0 && L0_dec_bits_a0 ==? 11'b1_101_01100xx;
   assign L0_is_or_a0    = L0_is_r_instr_a0 && L0_dec_bits_a0 ==? 11'b0_110_01100xx;
   assign L0_is_and_a0   = L0_is_r_instr_a0 && L0_dec_bits_a0 ==? 11'b0_111_01100xx;
   assign L0_is_load_a0  = L0_is_i_instr_a0 && L0_dec_bits_a0 ==? 11'bx_xxx_00000xx;
   // $is_lb    = $is_i_instr && $dec_bits ==? 11'bx_000_00000xx;
   // $is_lh    = $is_i_instr && $dec_bits ==? 11'bx_001_00000xx;
   // $is_lw    = $is_i_instr && $dec_bits ==? 11'bx_010_00000xx;
   // $is_lbu   = $is_i_instr && $dec_bits ==? 11'bx_100_00000xx;
   // $is_lhu   = $is_i_instr && $dec_bits ==? 11'bx_101_00000xx;
   // $is_store = $is_s_instr;
   // $is_sb    = $is_s_instr && $dec_bits ==? 11'b0_000_01000xx;
   // $is_sh    = $is_s_instr && $dec_bits ==? 11'b0_001_01000xx;
   // $is_sw    = $is_s_instr && $dec_bits ==? 11'b0_010_01000xx;

   // SLTU and SLTIU (set if less than, unsigned) results:
   assign L0_sltu_rslt_a0[31:0] = {31'b0, L0_src1_value_a0 < L0_src2_value_a0};
   assign L0_sltiu_rslt_a0[31:0] = {31'b0, L0_src1_value_a0 < L0_imm_a0};

   // SRA and SRAI (shift right, arithmetic) results:
   //  sign-extended src1
   assign L0_sext_src1_a0[63:0] = { {32{L0_src1_value_a0[31]}}, L0_src1_value_a0 };

   // 64 bit sign-extended results, to be truncated
   assign L0_sra_rslt_a0[63:0] = L0_sext_src1_a0 >> L0_src2_value_a0[4:0];
   assign L0_srai_rslt_a0[63:0] = L0_sext_src1_a0 >> L0_imm_a0[4:0];

   // ALU: Determine the instruction and assign the 32 bit result to $result
   // based on the instruction.
   assign L0_result_a0[31:0] = L0_is_andi_a0 ? L0_src1_value_a0 & L0_imm_a0 :
                    L0_is_ori_a0 ? L0_src1_value_a0 | L0_imm_a0 :
                    L0_is_xori_a0 ? L0_src1_value_a0 ^ L0_imm_a0 :
                    L0_is_addi_a0 ? L0_src1_value_a0 + L0_imm_a0 :
                    L0_is_slli_a0 ? L0_src1_value_a0 << L0_imm_a0[5:0] :
                    L0_is_srli_a0 ? L0_src1_value_a0 >> L0_imm_a0[5:0] :
                    L0_is_and_a0 ? L0_src1_value_a0 & L0_src2_value_a0 :
                    L0_is_or_a0 ? L0_src1_value_a0 | L0_src2_value_a0 :
                    L0_is_xor_a0 ? L0_src1_value_a0 ^ L0_src2_value_a0 :
                    L0_is_add_a0 ? L0_src1_value_a0 + L0_src2_value_a0 :
                    L0_is_sub_a0 ? L0_src1_value_a0 - L0_src2_value_a0 :
                    L0_is_sll_a0 ? L0_src1_value_a0 << L0_src2_value_a0[4:0] :
                    L0_is_srl_a0 ? L0_src1_value_a0 >> L0_src2_value_a0[4:0] :
                    L0_is_sltu_a0 ? L0_sltu_rslt_a0 :
                    L0_is_sltiu_a0 ? L0_sltiu_rslt_a0 :
                    L0_is_lui_a0 ? {L0_imm_a0[31:12], 12'b0} :
                    L0_is_auipc_a0 ? L0_pc_a0 + L0_imm_a0 :
                    L0_is_jal_a0 ? L0_pc_a0 + 32'd4 :
                    L0_is_jalr_a0 ? L0_pc_a0 + 32'd4 :
                    L0_is_slt_a0 ? ( (L0_src1_value_a0[31] == L0_src2_value_a0[31]) ? L0_sltu_rslt_a0 : {31'b0, L0_src1_value_a0[31]} ) :
                    L0_is_slti_a0 ? ( (L0_src1_value_a0[31] == L0_imm_a0[31]) ? L0_sltiu_rslt_a0 : {31'b0, L0_src1_value_a0[31]} ) :
                    L0_is_sra_a0 ? L0_sra_rslt_a0 :
                    L0_is_srai_a0 ? L0_srai_rslt_a0 :
                    L0_is_load_a0 ? L0_src1_value_a0 + L0_imm_a0 :
                    L0_is_s_instr_a0 ? L0_src1_value_a0 + L0_imm_a0 :
                    32'b0;

   // Branch Logic: Check whether the instruction is a branch instruction.
   // If so determine the branch condition and whether the condition is met.
   // If conditions are met $taken_br will be true (1) or false (0) if not.
   assign L0_taken_br_a0 = L0_is_beq_a0 ? L0_src1_value_a0 == L0_src2_value_a0 :
                L0_is_bne_a0 ? L0_src1_value_a0 != L0_src2_value_a0 :
                L0_is_blt_a0 ? (L0_src1_value_a0 < L0_src2_value_a0) ^ (L0_src1_value_a0[31] != L0_src2_value_a0[31]) :
                L0_is_bge_a0 ? (L0_src1_value_a0 >= L0_src2_value_a0) ^ (L0_src1_value_a0[31] != L0_src2_value_a0[31]) :
                L0_is_bltu_a0 ? L0_src1_value_a0 < L0_src2_value_a0 :
                L0_is_bgeu_a0 ? L0_src1_value_a0 >= L0_src2_value_a0 :
                1'b0;

   // Assign the branch target to $br_tgt_pc and if the branch is taken,
   // update $next_pc to $br_tgt_pc. Go to next instruction if not.
   assign L0_br_tgt_pc_a0[31:0] = L0_pc_a0 + L0_imm_a0;
   assign L0_jalr_tgt_pc_a0[31:0] = L0_src1_value_a0 + L0_imm_a0;
   assign L0_next_pc_a0[31:0] = L0_taken_br_a0 ? L0_br_tgt_pc_a0 :
                     L0_is_jal_a0 ? L0_br_tgt_pc_a0 :
                     L0_is_jalr_a0 ? L0_jalr_tgt_pc_a0 :
                     L0_pc_a0 + 4;

   // Assign the data to be written to the register file
   assign L0_rf_wr_data_a0[31:0] = L0_is_load_a0 ? L0_ld_data_a0 : L0_result_a0;

   // Assert these to end simulation (before Makerchip cycle limit).
   assign passed = 1'b0;
   assign failed = cyc_cnt > 60;

   // Instantiate the Makerchip register file
   `line 125 "/raw.githubusercontent.com/stevehoover/LFBuildingaRISCVCPUCore/main/lib/riscvshelllib.tlv" 1
      assign L0_rf1_wr_en_a0 = L0_rd_valid_a0;
      assign L0_rf1_wr_index_a0[$clog2(32)-1:0]  = L0_rd_a0;
      assign L0_rf1_wr_data_a0[32-1:0] = L0_rf_wr_data_a0;
      
      assign L0_rf1_rd_en1_a0 = L0_rs1_valid_a0;
      assign L0_rf1_rd_index1_a0[$clog2(32)-1:0] = L0_rs1_a0;
      
      assign L0_rf1_rd_en2_a0 = L0_rs2_valid_a0;
      assign L0_rf1_rd_index2_a0[$clog2(32)-1:0] = L0_rs2_a0;
      
      for (xreg = 0; xreg <= 31; xreg++) begin : L1_Xreg logic L1_wr_a0; //_/xreg
         assign L1_wr_a0 = L0_rf1_wr_en_a0 && (L0_rf1_wr_index_a0 == xreg);
         assign Xreg_value_n1[xreg][32-1:0] = L0_reset_a0 ? xreg              :
                                    L1_wr_a0      ? L0_rf1_wr_data_a0 :
                                               Xreg_value_a0[xreg][32-1:0]; end
      
      assign L0_src1_value_a0[32-1:0]  =  L0_rf1_rd_en1_a0 ? Xreg_value_a0[L0_rf1_rd_index1_a0] : 'X;
      assign L0_src2_value_a0[32-1:0]  =  L0_rf1_rd_en2_a0 ? Xreg_value_a0[L0_rf1_rd_index2_a0] : 'X;
      
      for (xreg = 0; xreg <= 31; xreg++) begin : L1b_Xreg //_/xreg
         /* Viz omitted here */





































         end
            
   //_\end_source
   `line 209 "top.tlv" 2

   // Instantiate the Makerchip data memory file
   `line 187 "/raw.githubusercontent.com/stevehoover/LFBuildingaRISCVCPUCore/main/lib/riscvshelllib.tlv" 1
      // Allow expressions for most inputs, so define input signals.
      assign L0_dmem1_wr_en_a0 = L0_is_s_instr_a0;
      assign L0_dmem1_addr_a0[$clog2(32)-1:0] = L0_result_a0[6:2];
      assign L0_dmem1_wr_data_a0[32-1:0] = L0_src2_value_a0[31:0];
      
      assign L0_dmem1_rd_en_a0 = L0_is_load_a0;
      
      for (dmem = 0; dmem <= 31; dmem++) begin : L1_Dmem logic L1_wr_a0; //_/dmem
         assign L1_wr_a0 = L0_dmem1_wr_en_a0 && (L0_dmem1_addr_a0 == dmem);
         assign Dmem_value_n1[dmem][32-1:0] = L0_reset_a0 ? 0                 :
                                 L1_wr_a0         ? L0_dmem1_wr_data_a0 :
                                               Dmem_value_a0[dmem][32-1:0]; end
      
      assign L0_ld_data_a0[32-1:0] = L0_dmem1_rd_en_a0 ? Dmem_value_a0[L0_dmem1_addr_a0] : 'X;
      for (dmem = 0; dmem <= 31; dmem++) begin : L1b_Dmem //_/dmem
         /* Viz omitted here */



































         end
   //_\end_source
   `line 212 "top.tlv" 2

   // Instantiate the Makerchip cpu viz
   `line 241 "/raw.githubusercontent.com/stevehoover/LFBuildingaRISCVCPUCore/main/lib/riscvshelllib.tlv" 1
      // String representations of the instructions for debug.
      /*SV_plus*/
         // A default signal for ones that are not found.
         logic sticky_zero;
         assign sticky_zero = 0;
         // Instruction strings from the assembler.
         logic [40*8-1:0] instr_strs [0:58];
         assign instr_strs = '{ "(I) ADDI x1,x0,10101                    ",  "(I) ADDI x2,x0,111                      ",  "(I) ADDI x3,x0,111111111100             ",  "(I) ANDI x5,x1,1011100                  ",  "(I) XORI x5,x5,10101                    ",  "(I) ORI x6,x1,1011100                   ",  "(I) XORI x6,x6,1011100                  ",  "(I) ADDI x7,x1,111                      ",  "(I) XORI x7,x7,11101                    ",  "(I) SLLI x8,x1,110                      ",  "(I) XORI x8,x8,10101000001              ",  "(I) SRLI x9,x1,10                       ",  "(I) XORI x9,x9,100                      ",  "(R) AND r10,x1,x2                       ",  "(I) XORI x10,x10,100                    ",  "(R) OR x11,x1,x2                        ",  "(I) XORI x11,x11,10110                  ",  "(R) XOR x12,x1,x2                       ",  "(I) XORI x12,x12,10011                  ",  "(R) ADD x13,x1,x2                       ",  "(I) XORI x13,x13,11101                  ",  "(R) SUB x14,x1,x2                       ",  "(I) XORI x14,x14,1111                   ",  "(R) SLL x15,x2,x2                       ",  "(I) XORI x15,x15,1110000001             ",  "(R) SRL x16,x1,x2                       ",  "(I) XORI x16,x16,1                      ",  "(R) SLTU x17,x2,x1                      ",  "(I) XORI x17,x17,0                      ",  "(I) SLTIU x18,x2,10101                  ",  "(I) XORI x18,x18,0                      ",  "(U) LUI x19,0                           ",  "(I) XORI x19,x19,1                      ",  "(I) SRAI x20,x3,1                       ",  "(I) XORI x20,x20,111111111111           ",  "(R) SLT x21,x3,x1                       ",  "(I) XORI x21,x21,0                      ",  "(I) SLTI x22,x3,1                       ",  "(I) XORI x22,x22,0                      ",  "(R) SRA x23,x1,x2                       ",  "(I) XORI x23,x23,1                      ",  "(U) AUIPC x4,100                        ",  "(I) SRLI x24,x4,111                     ",  "(I) XORI x24,x24,10000000               ",  "(J) JAL x25,10                          ",  "(U) AUIPC x4,0                          ",  "(R) XOR x25,x25,x4                      ",  "(I) XORI x25,x25,1                      ",  "(I) JALR x26,x4,10000                   ",  "(R) SUB x26,x26,x4                      ",  "(I) ADDI x26,x26,111111110001           ",  "(S) SW x2,x1,1                          ",  "(I) LW x27,x2,1                         ",  "(I) XORI x27,x27,10100                  ",  "(I) ADDI x28,x0,1                       ",  "(I) ADDI x29,x0,1                       ",  "(I) ADDI x30,x0,1                       ",  "(J) JAL x0,0                            ",  "END                                     "};
      
      /* Viz omitted here */














































































































































































































































































































































































































































         
      for (imem = 0; imem <= 57; imem++) begin : L1_Imem //_/imem
         /* Viz omitted here */














































         end
         
   //_\end_source
   `line 215 "top.tlv" 2
//_\SV
   endmodule


// Undefine macros defined by SandPiper (in "top_gen.sv").
`undef BOGUS_USE
