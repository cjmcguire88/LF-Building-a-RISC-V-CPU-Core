\m4_TLV_version 1d: tl-x.org
\SV
   // This code can be found in: https://github.com/stevehoover/LF-Building-a-RISC-V-CPU-Core/risc-v_shell.tlv

   m4_include_lib(['https://raw.githubusercontent.com/stevehoover/LF-Building-a-RISC-V-CPU-Core/main/lib/risc-v_shell_lib.tlv'])



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
   m4_test_prog()
   m4_define(['M4_MAX_CYC'], 50)
   //---------------------------------------------------------------------------------

\SV
   m4_makerchip_module   // (Expanded in Nav-TLV pane.)

\TLV

   $reset = *reset;

   // Program Counter
   // Reset to 0x00000000, otherwise increment by 4 bytes per instruction
   $pc[31:0] = $reset ? 32'h00000000 : >>1$next_pc[31:0];

   // Verilog macro for instruction memory - fetch 32-bit
   // instruction at PC address
   `READONLY_MEM($pc[31:0], $$instr[31:0])

   //Decode instruction type by comparing opcodes
   $is_u_instr = $instr[6:2] ==? 5'b00101 ||
                 $instr[6:2] ==? 5'b01101;
   $is_i_instr = $instr[6:2] ==? 5'b00000 ||
                 $instr[6:2] ==? 5'b00001 ||
                 $instr[6:2] ==? 5'b11001 ||
                 $instr[6:2] ==? 5'b00100 ||
                 $instr[6:2] ==? 5'b00110;
   $is_s_instr = $instr[6:2] ==? 5'b01000 ||
                 $instr[6:2] ==? 5'b01001;
   $is_b_instr = $instr[6:2] ==? 5'b11000;
   $is_r_instr = $instr[6:2] ==? 5'b01011 ||
                 $instr[6:2] ==? 5'b01100 ||
                 $instr[6:2] ==? 5'b01110 ||
                 $instr[6:2] ==? 5'b10100;
   $is_j_instr = $instr[6:2] ==? 5'b11011;

   // Split instruction fields
   $opcode[6:0] = $instr[6:0];
   $rd[4:0] = $instr[11:7];
   $rs1[4:0] = $instr[19:15];
   $rs2[4:0] = $instr[24:20];
   $funct3[2:0] = $instr[14:12];

   // Check validity of fields from instruction type
   $rd_valid = $is_r_instr || $is_i_instr || $is_u_instr || $is_j_instr;
   $rs1_valid = $is_r_instr || $is_i_instr || $is_s_instr || $is_b_instr;
   $rs2_valid = $is_r_instr || $is_s_instr || $is_b_instr;
   $funct3_valid = $is_r_instr || $is_i_instr || $is_s_instr || $is_b_instr;
   $imm_valid = $is_i_instr || $is_s_instr || $is_b_instr || $is_u_instr || $is_j_instr;
   `BOGUS_USE($funct3_valid $imm_valid)
   // The fields containing the immediate value vary based on instruction type.
   // Here we construct the immediate value from the instruction bits depending
   // on instruction type.
   $imm[31:0] = $is_i_instr ? {  {21{$instr[31]}},  $instr[30:20]  } :
                $is_s_instr ? {  {20{$instr[31]}},  $instr[31:25], $instr[11:7]  } :
                $is_b_instr ? {  {20{$instr[31]}},  $instr[7], $instr[30:25], $instr[11:8], 1'b0  } :
                $is_u_instr ? {  $instr[31:12], 12'b0  } :
                $is_j_instr ? {  {12{$instr[31]}},  $instr[19:12], $instr[20], $instr[30:21], 1'b0  } :
                32'b0;

   // Here we combine the opcode, funct3 and instr[30] (funct7[5] if r-type)
   // fields in $dec_bits and then compare them to known instructions. We use
   // x as a don't care value i.e. instr[30] is only needed to distinguish
   // between add and sub instructions. Underscore is used as a field separator.
   $dec_bits[10:0] = {$instr[30],$funct3,$opcode};
   $is_lui   = $is_u_instr && $dec_bits ==? 11'bx_xxx_x1xxxxx;
   $is_auipc = $is_u_instr && $dec_bits ==? 11'bx_xxx_x0xxxxx;
   $is_jal   = $is_j_instr;
   $is_jalr  = $is_i_instr && $dec_bits ==? 11'bx_000_11001xx;
   $is_beq   = $is_b_instr && $dec_bits ==? 11'bx_000_xxxxxxx;
   $is_bne   = $is_b_instr && $dec_bits ==? 11'bx_001_xxxxxxx;
   $is_blt   = $is_b_instr && $dec_bits ==? 11'bx_100_xxxxxxx;
   $is_bge   = $is_b_instr && $dec_bits ==? 11'bx_101_xxxxxxx;
   $is_bltu  = $is_b_instr && $dec_bits ==? 11'bx_110_xxxxxxx;
   $is_bgeu  = $is_b_instr && $dec_bits ==? 11'bx_111_xxxxxxx;
   $is_addi  = $is_i_instr && $dec_bits ==? 11'bx_000_00100xx;
   $is_slti  = $is_i_instr && $dec_bits ==? 11'bx_010_00100xx;
   $is_sltiu = $is_i_instr && $dec_bits ==? 11'bx_011_00100xx;
   $is_xori  = $is_i_instr && $dec_bits ==? 11'bx_100_00100xx;
   $is_ori   = $is_i_instr && $dec_bits ==? 11'bx_110_00100xx;
   $is_andi  = $is_i_instr && $dec_bits ==? 11'bx_111_00100xx;
   $is_slli  = $is_i_instr && $dec_bits ==? 11'b0_001_00100xx;
   $is_srli  = $is_i_instr && $dec_bits ==? 11'b0_101_00100xx;
   $is_srai  = $is_i_instr && $dec_bits ==? 11'b1_101_00100xx;
   $is_add   = $is_r_instr && $dec_bits ==? 11'b0_000_01100xx;
   $is_sub   = $is_r_instr && $dec_bits ==? 11'b1_000_01100xx;
   $is_sll   = $is_r_instr && $dec_bits ==? 11'b0_001_01100xx;
   $is_slt   = $is_r_instr && $dec_bits ==? 11'b0_010_01100xx;
   $is_sltu  = $is_r_instr && $dec_bits ==? 11'b0_011_01100xx;
   $is_xor   = $is_r_instr && $dec_bits ==? 11'b0_100_01100xx;
   $is_srl   = $is_r_instr && $dec_bits ==? 11'b0_101_01100xx;
   $is_sra   = $is_r_instr && $dec_bits ==? 11'b1_101_01100xx;
   $is_or    = $is_r_instr && $dec_bits ==? 11'b0_110_01100xx;
   $is_and   = $is_r_instr && $dec_bits ==? 11'b0_111_01100xx;
   $is_load  = $is_i_instr && $dec_bits ==? 11'bx_xxx_00000xx;
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
   $sltu_rslt[31:0] = {31'b0, $src1_value < $src2_value};
   $sltiu_rslt[31:0] = {31'b0, $src1_value < $imm};

   // SRA and SRAI (shift right, arithmetic) results:
   //  sign-extended src1
   $sext_src1[63:0] = { {32{$src1_value[31]}}, $src1_value };

   // 64 bit sign-extended results, to be truncated
   $sra_rslt[63:0] = $sext_src1 >> $src2_value[4:0];
   $srai_rslt[63:0] = $sext_src1 >> $imm[4:0];

   // ALU: Determine the instruction and assign the 32 bit result to $result
   // based on the instruction.
   $result[31:0] = $is_andi ? $src1_value & $imm :
                    $is_ori ? $src1_value | $imm :
                    $is_xori ? $src1_value ^ $imm :
                    $is_addi ? $src1_value + $imm :
                    $is_slli ? $src1_value << $imm[5:0] :
                    $is_srli ? $src1_value >> $imm[5:0] :
                    $is_and ? $src1_value & $src2_value :
                    $is_or ? $src1_value | $src2_value :
                    $is_xor ? $src1_value ^ $src2_value :
                    $is_add ? $src1_value + $src2_value :
                    $is_sub ? $src1_value - $src2_value :
                    $is_sll ? $src1_value << $src2_value[4:0] :
                    $is_srl ? $src1_value >> $src2_value[4:0] :
                    $is_sltu ? $sltu_rslt :
                    $is_sltiu ? $sltiu_rslt :
                    $is_lui ? {$imm[31:12], 12'b0} :
                    $is_auipc ? $pc + $imm :
                    $is_jal ? $pc + 32'd4 :
                    $is_jalr ? $pc + 32'd4 :
                    $is_slt ? ( ($src1_value[31] == $src2_value[31]) ? $sltu_rslt : {31'b0, $src1_value[31]} ) :
                    $is_slti ? ( ($src1_value[31] == $imm[31]) ? $sltiu_rslt : {31'b0, $src1_value[31]} ) :
                    $is_sra ? $sra_rslt :
                    $is_srai ? $srai_rslt :
                    $is_load ? $src1_value + $imm :
                    $is_s_instr ? $src1_value + $imm :
                    32'b0;

   // Branch Logic: Check whether the instruction is a branch instruction.
   // If so determine the branch condition and whether the condition is met.
   // If conditions are met $taken_br will be true (1) or false (0) if not.
   $taken_br = $is_beq ? $src1_value == $src2_value :
                $is_bne ? $src1_value != $src2_value :
                $is_blt ? ($src1_value < $src2_value) ^ ($src1_value[31] != $src2_value[31]) :
                $is_bge ? ($src1_value >= $src2_value) ^ ($src1_value[31] != $src2_value[31]) :
                $is_bltu ? $src1_value < $src2_value :
                $is_bgeu ? $src1_value >= $src2_value :
                1'b0;

   // Assign the branch target to $br_tgt_pc and if the branch is taken,
   // update $next_pc to $br_tgt_pc. Go to next instruction if not.
   $br_tgt_pc[31:0] = $pc + $imm;
   $jalr_tgt_pc[31:0] = $src1_value + $imm;
   $next_pc[31:0] = $reset ? 32'b0 :
                     $taken_br ? $br_tgt_pc :
                     $is_jal ? $br_tgt_pc :
                     $is_jalr ? $jalr_tgt_pc :
                     $pc + 4;

   // Assign the data to be written to the register file
   $rf_wr_data[31:0] = $is_load ? $ld_data : $result;

   // Assert these to end simulation (before Makerchip cycle limit).
   *passed = 1'b0;
   *failed = *cyc_cnt > M4_MAX_CYC;

   // Instantiate the Makerchip register file
   m4+rf(32, 32, $reset, $rd_valid, $rd, $rf_wr_data, $rs1_valid, $rs1, $src1_value, $rs2_valid, $rs2, $src2_value)

   // Instantiate the Makerchip data memory file
   m4+dmem(32, 32, $reset, $result[6:2], $is_s_instr, $src2_value[31:0], $is_load, $ld_data)

   // Instantiate the Makerchip cpu viz
   m4+cpu_viz()
\SV
   endmodule
