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
   m4_asm(ADDI, x0, x0, 0)              // NOP to compensate for makerchip cycle skip
   m4_asm(ADDI, x14, x0, 0)             // Initialize sum register a4 with 0
   m4_asm(ADDI, x12, x0, 1010)          // Store count of 10 in register a2.
   m4_asm(ADDI, x13, x0, 1)             // Initialize loop count register a3 with 0
   // Loop:
   m4_asm(ADD, x14, x13, x14)           // Incremental summation
   m4_asm(ADDI, x13, x13, 1)            // Increment loop count by 1
   m4_asm(BLT, x13, x12, 1111111111000) // If a3 is less than a2, branch to label named <loop>
   // Test result value in x14, and set x31 to reflect pass/fail.
   m4_asm(ADDI, x30, x14, 111111010100) // Subtract expected value of 44 to set x30 to 1 if and only iff the result is 45 (1 + 2 + ... + 9).
   m4_asm(BGE, x0, x0, 0) // Done. Jump to itself (infinite loop). (Up to 20-bit signed immediate plus implicit 0 bit (unlike JALR) provides byte address; last immediate bit should also be 0)
   m4_asm_end()
   m4_define(['M4_MAX_CYC'], 50)
   //---------------------------------------------------------------------------------



\SV
   m4_makerchip_module   // (Expanded in Nav-TLV pane.)
   /* verilator lint_on WIDTH */
\TLV

   $reset = *reset;
   // Program Counter
   // Reset to 0x00000000, otherwise increment by 4 bytes per instruction
   $pc[31:0] = $reset ? 32'h00000000 : >>1$next_pc[31:0];

   // Verilog macro for instruction memory - fetch 32-bit
   // instruction at PC address
   `READONLY_MEM($pc[31:0], $$instr[31:0])

   //Decode instruction type by comparing opcodes
   $is_u_instr = $instr[6:2] ==? 5'b00101;
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

   // Prevent "unused signal" warnings
   `BOGUS_USE($rd $rd_valid $rs1 $rs1_valid $rs2 $rs2_valid $funct3 $funct3_valid $imm $imm_valid)

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
   // x as a don't care value as instr[30] is only needed to distinguish between
   // add and sub instructions. Underscore is used as a field separator.
   $dec_bits[10:0] = {$instr[30],$funct3,$opcode};
   $is_beq = $dec_bits ==? 11'bx_000_1100011;
   $is_bne = $dec_bits ==? 11'bx_001_1100011;
   $is_blt = $dec_bits ==? 11'bx_100_1100011;
   $is_bge = $dec_bits ==? 11'bx_101_1100011;
   $is_bltu = $dec_bits ==? 11'bx_110_1100011;
   $is_bgeu = $dec_bits ==? 11'bx_111_1100011;
   $is_addi = $dec_bits ==? 11'bx_000_0010011;
   $is_add = $dec_bits ==? 11'b0_000_0110011;

   // Prevent "unused signal" warnings
   `BOGUS_USE($is_beq $is_bne $is_blt $is_bge $is_bltu $is_bgeu $is_addi $is_add)

   // ALU: Determine the instruction and assign the 32 bit result to $result
   // based on the instruction.
   $result[31:0] = $is_add ? $src1_value + $src2_value :
                    $is_addi ? $src1_value + $imm :
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
   $next_pc[31:0] = $taken_br ? $br_tgt_pc :
               $pc + 4;

   // Assert these to end simulation (before Makerchip cycle limit).
   *passed = 1'b0;
   *failed = *cyc_cnt > M4_MAX_CYC;

   // TL-Verilog array definition, expanded by the M4 macro preprocessor.
   // Instantiates a 32-entry, 32-bit-wide register file connected to the given
   // input and output signals.
   // Reads rs1 -> src1_value when rs1_valid, rs2 -> src2_value when rs2_valid
   m4+rf(32, 32, $reset, $rd_valid, $rd, $result, $rs1_valid, $rs1, $src1_value, $rs2_valid, $rs2, $src2_value)
   //m4+dmem(32, 32, $reset, $addr[4:0], $wr_en, $wr_data[31:0], $rd_en, $rd_data)
   m4+cpu_viz()
\SV
   endmodule
