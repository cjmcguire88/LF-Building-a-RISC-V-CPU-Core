\TLV_version [\source top.tlv] 1d: tl-x.org
\SV
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

\SV
   module top(input wire clk, input wire reset, input wire [31:0] cyc_cnt, output wire passed, output wire failed);    /* verilator lint_save */ /* verilator lint_off UNOPTFLAT */  bit [256:0] RW_rand_raw; bit [256+63:0] RW_rand_vect; pseudo_rand #(.WIDTH(257)) pseudo_rand (clk, reset, RW_rand_raw[256:0]); assign RW_rand_vect[256+63:0] = {RW_rand_raw[62:0], RW_rand_raw};  /* verilator lint_restore */  /* verilator lint_off WIDTH */ /* verilator lint_off UNOPTFLAT */   // (Expanded in Nav-TLV pane.)

\TLV

   $reset = *reset;

   // Program Counter
   // Reset to 0x00000000, otherwise increment by 4 bytes per instruction
   $pc[31:0] = >>1$reset ? 32'h00000000 : >>1$next_pc[31:0];

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
   $next_pc[31:0] = $taken_br ? $br_tgt_pc :
                     $is_jal ? $br_tgt_pc :
                     $is_jalr ? $jalr_tgt_pc :
                     $pc + 4;

   // Assign the data to be written to the register file
   $rf_wr_data[31:0] = $is_load ? $ld_data : $result;

   // Assert these to end simulation (before Makerchip cycle limit).
   *passed = 1'b0;
   *failed = *cyc_cnt > 60;

   // Instantiate the Makerchip register file
   \source /raw.githubusercontent.com/stevehoover/LFBuildingaRISCVCPUCore/main/lib/riscvshelllib.tlv 124   // Instantiated from top.tlv, 208 as: m4+rf(32, 32, $reset, $rd_valid, $rd, $rf_wr_data, $rs1_valid, $rs1, $src1_value, $rs2_valid, $rs2, $src2_value)
      $rf1_wr_en = $rd_valid;
      $rf1_wr_index[\$clog2(32)-1:0]  = $rd;
      $rf1_wr_data[32-1:0] = $rf_wr_data;
      
      $rf1_rd_en1 = $rs1_valid;
      $rf1_rd_index1[\$clog2(32)-1:0] = $rs1;
      
      $rf1_rd_en2 = $rs2_valid;
      $rf1_rd_index2[\$clog2(32)-1:0] = $rs2;
      
      /xreg[31:0]
         $wr = /top$rf1_wr_en && (/top$rf1_wr_index == #xreg);
         <<1$value[32-1:0] = /top$reset ? #xreg              :
                                    $wr      ? /top$rf1_wr_data :
                                               $RETAIN;
      
      $src1_value[32-1:0]  =  $rf1_rd_en1 ? /xreg[$rf1_rd_index1]$value : 'X;
      $src2_value[32-1:0]  =  $rf1_rd_en2 ? /xreg[$rf1_rd_index2]$value : 'X;
      
      /xreg[31:0]
         \viz_js
            box: {width: 120, height: 18, strokeWidth: 0},
            render() {
               let siggen = (name) => {
                  let sig = this.svSigRef(`${name}`)
                  return (sig == null || !sig.exists()) ? this.svSigRef(`sticky_zero`) : sig;
               }
               let rf_rd_en1 = siggen(`L0_rf1_rd_en1_a0`)
               let rf_rd_index1 = siggen(`L0_rf1_rd_index1_a0`)
               let rf_rd_en2 = siggen(`L0_rf1_rd_en2_a0`)
               let rf_rd_index2 = siggen(`L0_rf1_rd_index2_a0`)
               let wr = siggen(`L1_Xreg[${this.getIndex()}].L1_wr_a0`)
               let value = siggen(`Xreg_value_a0[${this.getIndex()}]`)
               
               let rd = (rf_rd_en1.asBool(false) && rf_rd_index1.asInt() == this.getIndex()) || 
                        (rf_rd_en2.asBool(false) && rf_rd_index2.asInt() == this.getIndex())
               
               let mod = wr.asBool(false);
               let reg = parseInt(this.getIndex())
               let regIdent = reg.toString().padEnd(2, " ")
               let newValStr = (regIdent + ": ").padEnd(14, " ")
               let reg_str = new fabric.Text((regIdent + ": " + value.asInt(NaN).toString(16)).padEnd(14, " "), {
                  top: 0,
                  left: 0,
                  fontSize: 14,
                  fill: mod ? "blue" : "black",
                  fontWeight: mod ? 800 : 400,
                  fontFamily: "monospace",
                  textBackgroundColor: rd ? "#b0ffff" : mod ? "#f0f0f0" : "white"
               })
               if (mod) {
                  setTimeout(() => {
                     reg_str.set({text: newValStr, textBackgroundColor: "#d0e8ff", dirty: true})
                     this.global.canvas.renderAll()
                  }, 1500)
               }
               return [reg_str]
            },
            where: {left: 316, top: -40}
            
   \end_source

   // Instantiate the Makerchip data memory file
   \source /raw.githubusercontent.com/stevehoover/LFBuildingaRISCVCPUCore/main/lib/riscvshelllib.tlv 186   // Instantiated from top.tlv, 211 as: m4+dmem(32, 32, $reset, $result[6:2], $is_s_instr, $src2_value[31:0], $is_load, $ld_data)
      // Allow expressions for most inputs, so define input signals.
      $dmem1_wr_en = $is_s_instr;
      $dmem1_addr[\$clog2(32)-1:0] = $result[6:2];
      $dmem1_wr_data[32-1:0] = $src2_value[31:0];
      
      $dmem1_rd_en = $is_load;
      
      /dmem[31:0]
         $wr = /top$dmem1_wr_en && (/top$dmem1_addr == #dmem);
         <<1$value[32-1:0] = /top$reset ? 0                 :
                                 $wr         ? /top$dmem1_wr_data :
                                               $RETAIN;
      
      $ld_data[32-1:0] = $dmem1_rd_en ? /dmem[$dmem1_addr]$value : 'X;
      /dmem[31:0]
         \viz_js
            box: {width: 120, height: 18, strokeWidth: 0},
            render() {
               let siggen = (name) => {
                  let sig = this.svSigRef(`${name}`)
                  return (sig == null || !sig.exists()) ? this.svSigRef(`sticky_zero`) : sig;
               }
               //
               let dmem_rd_en = siggen(`L0_dmem1_rd_en_a0`);
               let dmem_addr = siggen(`L0_dmem1_addr_a0`);
               //
               let wr = siggen(`L1_Dmem[${this.getIndex()}].L1_wr_a0`);
               let value = siggen(`Dmem_value_a0[${this.getIndex()}]`);
               //
               let rd = dmem_rd_en.asBool() && dmem_addr.asInt() == this.getIndex();
               let mod = wr.asBool(false);
               let reg = parseInt(this.getIndex());
               let regIdent = reg.toString().padEnd(2, " ");
               let newValStr = (regIdent + ": ").padEnd(14, " ");
               let dmem_str = new fabric.Text((regIdent + ": " + value.asInt(NaN).toString(16)).padEnd(14, " "), {
                  top: 0,
                  left: 0,
                  fontSize: 14,
                  fill: mod ? "blue" : "black",
                  fontWeight: mod ? 800 : 400,
                  fontFamily: "monospace",
                  textBackgroundColor: rd ? "#b0ffff" : mod ? "#d0e8ff" : "white"
               })
               if (mod) {
                  setTimeout(() => {
                     dmem_str.set({text: newValStr, dirty: true})
                     this.global.canvas.renderAll()
                  }, 1500)
               }
               return [dmem_str]
            },
            where: {left: 480, top: -40}
   \end_source

   // Instantiate the Makerchip cpu viz
   \source /raw.githubusercontent.com/stevehoover/LFBuildingaRISCVCPUCore/main/lib/riscvshelllib.tlv 240   // Instantiated from top.tlv, 214 as: m4+cpu_viz()
      // String representations of the instructions for debug.
      \SV_plus
         // A default signal for ones that are not found.
         logic sticky_zero;
         assign sticky_zero = 0;
         // Instruction strings from the assembler.
         logic [40*8-1:0] instr_strs [0:58];
         assign instr_strs = '{ "(I) ADDI x1,x0,10101                    ",  "(I) ADDI x2,x0,111                      ",  "(I) ADDI x3,x0,111111111100             ",  "(I) ANDI x5,x1,1011100                  ",  "(I) XORI x5,x5,10101                    ",  "(I) ORI x6,x1,1011100                   ",  "(I) XORI x6,x6,1011100                  ",  "(I) ADDI x7,x1,111                      ",  "(I) XORI x7,x7,11101                    ",  "(I) SLLI x8,x1,110                      ",  "(I) XORI x8,x8,10101000001              ",  "(I) SRLI x9,x1,10                       ",  "(I) XORI x9,x9,100                      ",  "(R) AND r10,x1,x2                       ",  "(I) XORI x10,x10,100                    ",  "(R) OR x11,x1,x2                        ",  "(I) XORI x11,x11,10110                  ",  "(R) XOR x12,x1,x2                       ",  "(I) XORI x12,x12,10011                  ",  "(R) ADD x13,x1,x2                       ",  "(I) XORI x13,x13,11101                  ",  "(R) SUB x14,x1,x2                       ",  "(I) XORI x14,x14,1111                   ",  "(R) SLL x15,x2,x2                       ",  "(I) XORI x15,x15,1110000001             ",  "(R) SRL x16,x1,x2                       ",  "(I) XORI x16,x16,1                      ",  "(R) SLTU x17,x2,x1                      ",  "(I) XORI x17,x17,0                      ",  "(I) SLTIU x18,x2,10101                  ",  "(I) XORI x18,x18,0                      ",  "(U) LUI x19,0                           ",  "(I) XORI x19,x19,1                      ",  "(I) SRAI x20,x3,1                       ",  "(I) XORI x20,x20,111111111111           ",  "(R) SLT x21,x3,x1                       ",  "(I) XORI x21,x21,0                      ",  "(I) SLTI x22,x3,1                       ",  "(I) XORI x22,x22,0                      ",  "(R) SRA x23,x1,x2                       ",  "(I) XORI x23,x23,1                      ",  "(U) AUIPC x4,100                        ",  "(I) SRLI x24,x4,111                     ",  "(I) XORI x24,x24,10000000               ",  "(J) JAL x25,10                          ",  "(U) AUIPC x4,0                          ",  "(R) XOR x25,x25,x4                      ",  "(I) XORI x25,x25,1                      ",  "(I) JALR x26,x4,10000                   ",  "(R) SUB x26,x26,x4                      ",  "(I) ADDI x26,x26,111111110001           ",  "(S) SW x2,x1,1                          ",  "(I) LW x27,x2,1                         ",  "(I) XORI x27,x27,10100                  ",  "(I) ADDI x28,x0,1                       ",  "(I) ADDI x29,x0,1                       ",  "(I) ADDI x30,x0,1                       ",  "(J) JAL x0,0                            ",  "END                                     "};
      
      \viz_js
         
         box: {strokeWidth: 0},
         init() {
            let imem_box = new fabric.Rect({
                  top: -756 - 50,
                  left: -700,
                  fill: "#208028",
                  width: 665,
                  height: 76 + 18 * 58,
                  stroke: "black",
                  visible: false
               })
            let decode_box = new fabric.Rect({
                  top: -25,
                  left: -15,
                  fill: "#f8f0e8",
                  width: 280,
                  height: 215,
                  stroke: "#ff8060",
                  visible: false
               })
            let rf_box = new fabric.Rect({
                  top: -90,
                  left: 306,
                  fill: "#2028b0",
                  width: 145,
                  height: 650,
                  stroke: "black",
                  visible: false
               })
            let dmem_box = new fabric.Rect({
                  top: -90,
                  left: 470,
                  fill: "#208028",
                  width: 145,
                  height: 650,
                  stroke: "black",
                  visible: false
               })
            let imem_header = new fabric.Text("🗃️ IMem", {
                  top: -756 - 35,
                  left: -460,
                  fontSize: 18,
                  fontWeight: 800,
                  fontFamily: "monospace",
                  fill: "white",
                  visible: false
               })
            let decode_header = new fabric.Text("⚙️ Instr. Decode", {
                  top: -4,
                  left: 20,
                  fill: "maroon",
                  fontSize: 18,
                  fontWeight: 800,
                  fontFamily: "monospace",
                  visible: false
               })
            let rf_header = new fabric.Text("📂 RF", {
                  top: -75,
                  left: 316,
                  fontSize: 18,
                  fontWeight: 800,
                  fontFamily: "monospace",
                  fill: "white",
                  visible: false
               })
            let dmem_header = new fabric.Text("🗃️ DMem", {
                  top: -75,
                  left: 480,
                  fontSize: 18,
                  fontWeight: 800,
                  fontFamily: "monospace",
                  fill: "white",
                  visible: false
               })
            
            let passed = new fabric.Text("", {
                  top: 340,
                  left: -30,
                  fontSize: 46,
                  fontWeight: 800
               })
            this.missing_col1 = new fabric.Text("", {
                  top: 420,
                  left: -480,
                  fontSize: 16,
                  fontWeight: 500,
                  fontFamily: "monospace",
                  fill: "purple"
               })
            this.missing_col2 = new fabric.Text("", {
                  top: 420,
                  left: -300,
                  fontSize: 16,
                  fontWeight: 500,
                  fontFamily: "monospace",
                  fill: "purple"
               })
            let missing_sigs = new fabric.Group(
               [new fabric.Text("🚨 To Be Implemented:", {
                  top: 350,
                  left: -466,
                  fontSize: 18,
                  fontWeight: 800,
                  fill: "red",
                  fontFamily: "monospace"
               }),
               new fabric.Rect({
                  top: 400,
                  left: -500,
                  fill: "#ffffe0",
                  width: 400,
                  height: 300,
                  stroke: "black"
               }),
               this.missing_col1,
               this.missing_col2,
              ],
              {visible: false}
            )
            return {imem_box, decode_box, rf_box, dmem_box, imem_header, decode_header, rf_header, dmem_header, passed, missing_sigs}
         },
         render() {
            // Strings (2 columns) of missing signals.
            var missing_list = ["", ""]
            var missing_cnt = 0
            let sticky_zero = this.svSigRef(`sticky_zero`);  // A default zero-valued signal.
            // Attempt to look up a signal, using sticky_zero as default and updating missing_list if expected.
            let siggen = (name, full_name, expected = true) => {
               var sig = this.svSigRef(full_name ? full_name : `L0_${name}_a0`)
               if (sig == null || !sig.exists()) {
                  sig         = sticky_zero;
                  if (expected) {
                     missing_list[missing_cnt > 11 ? 1 : 0] += `◾ $${name}      \n`;
                     missing_cnt++
                  }
               }
               return sig
            }
            // Look up signal, and it's ok if it doesn't exist.
            siggen_rf_dmem = (name, scope) => {
               return siggen(name, scope, false)
            }
            
            // Determine which is_xxx signal is asserted.
            siggen_mnemonic = () => {
               let instrs = ["lui", "auipc", "jal", "jalr", "beq", "bne", "blt", "bge", "bltu", "bgeu", "lb", "lh", "lw", "lbu", "lhu", "sb", "sh", "sw", "addi", "slti", "sltiu", "xori", "ori", "andi", "slli", "srli", "srai", "add", "sub", "sll", "slt", "sltu", "xor", "srl", "sra", "or", "and", "csrrw", "csrrs", "csrrc", "csrrwi", "csrrsi", "csrrci", "load", "s_instr"];
               for(i=0;i<instrs.length;i++) {
                  var sig = this.svSigRef(`L0_is_${instrs[i]}_a0`)
                  if(sig != null && sig.asBool(false)) {
                     return instrs[i].toUpperCase()
                  }
               }
               return "ILLEGAL"
            }
            
            let pc            =   siggen("pc")
            let instr         =   siggen("instr")
            let types = {I: siggen("is_i_instr"),
                         R: siggen("is_r_instr"),
                         S: siggen("is_s_instr"),
                         B: siggen("is_b_instr"),
                         J: siggen("is_j_instr"),
                         U: siggen("is_u_instr"),
                        }
            let rd_valid      =   siggen("rd_valid")
            let rd            =   siggen("rd")
            let result        =   siggen("result")
            let src1_value    =   siggen("src1_value")
            let src2_value    =   siggen("src2_value")
            let imm           =   siggen("imm")
            let imm_valid     =   siggen("imm_valid")
            let rs1           =   siggen("rs1")
            let rs2           =   siggen("rs2")
            let rs1_valid     =   siggen("rs1_valid")
            let rs2_valid     =   siggen("rs2_valid")
            let ld_data       =   siggen("ld_data")
            let mnemonic      =   siggen_mnemonic()
            let passed        =   siggen("passed_cond", false, false)
            
            let rf_rd_en1     =   siggen_rf_dmem("rf1_rd_en1")
            let rf_rd_index1  =   siggen_rf_dmem("rf1_rd_index1")
            let rf_rd_en2     =   siggen_rf_dmem("rf1_rd_en2")
            let rf_rd_index2  =   siggen_rf_dmem("rf1_rd_index2")
            let rf_wr_en      =   siggen_rf_dmem("rf1_wr_en")
            let rf_wr_index   =   siggen_rf_dmem("rf1_wr_index")
            let rf_wr_data    =   siggen_rf_dmem("rf1_wr_data")
            let dmem_rd_en    =   siggen_rf_dmem("dmem1_rd_en")
            let dmem_wr_en    =   siggen_rf_dmem("dmem1_wr_en")
            let dmem_addr     =   siggen_rf_dmem("dmem1_addr")
            
            if (instr != sticky_zero) {
               this.getObjects().imem_box.set({visible: true})
               this.getObjects().imem_header.set({visible: true})
               this.getObjects().decode_box.set({visible: true})
               this.getObjects().decode_header.set({visible: true})
            }
            let pcPointer = new fabric.Text("👉", {
               top: -756 + 18 * (pc.asInt() / 4),
               left: -375,
               fill: "blue",
               fontSize: 14,
               fontFamily: "monospace",
               visible: pc != sticky_zero
            })
            let pc_arrow = new fabric.Line([-57, -756 + 18 * (pc.asInt() / 4) + 6, 6, 35], {
               stroke: "#b0c8df",
               strokeWidth: 2,
               visible: instr != sticky_zero
            })
            
            // Display instruction type(s)
            let type_texts = []
            for (const [type, sig] of Object.entries(types)) {
               if (sig.asBool()) {
                  type_texts.push(
                     new fabric.Text(`(${type})`, {
                        top: 60,
                        left: 10,
                        fill: "blue",
                        fontSize: 20,
                        fontFamily: "monospace"
                     })
                  )
               }
            }
            let rs1_arrow = new fabric.Line([330, 18 * rf_rd_index1.asInt() + 6 - 40, 190, 75 + 18 * 2], {
               stroke: "#b0c8df",
               strokeWidth: 2,
               visible: rf_rd_en1.asBool()
            })
            let rs2_arrow = new fabric.Line([330, 18 * rf_rd_index2.asInt() + 6 - 40, 190, 75 + 18 * 3], {
               stroke: "#b0c8df",
               strokeWidth: 2,
               visible: rf_rd_en2.asBool()
            })
            let rd_arrow = new fabric.Line([330, 18 * rf_wr_index.asInt() + 6 - 40, 168, 75 + 18 * 0], {
               stroke: "#b0b0df",
               strokeWidth: 3,
               visible: rf_wr_en.asBool()
            })
            let ld_arrow = new fabric.Line([490, 18 * dmem_addr.asInt() + 6 - 40, 168, 75 + 18 * 0], {
               stroke: "#b0c8df",
               strokeWidth: 2,
               visible: dmem_rd_en.asBool()
            })
            let st_arrow = new fabric.Line([490, 18 * dmem_addr.asInt() + 6 - 40, 190, 75 + 18 * 3], {
               stroke: "#b0b0df",
               strokeWidth: 3,
               visible: dmem_wr_en.asBool()
            })
            if (rf_rd_en1 != sticky_zero) {
               this.getObjects().rf_box.set({visible: true})
               this.getObjects().rf_header.set({visible: true})
            }
            if (dmem_rd_en != sticky_zero) {
               this.getObjects().dmem_box.set({visible: true})
               this.getObjects().dmem_header.set({visible: true})
            }
            
            
            // Instruction with values
            
            let regStr = (valid, regNum, regValue) => {
               return valid ? `x${regNum}` : `xX`  // valid ? `x${regNum} (${regValue})` : `xX`
            }
            let immStr = (valid, immValue) => {
               immValue = parseInt(immValue,2) + 2*(immValue[0] << 31)
               return valid ? `i[${immValue}]` : ``;
            }
            let srcStr = ($src, $valid, $reg, $value) => {
               return $valid.asBool(false)
                          ? `\n      ${regStr(true, $reg.asInt(NaN), $value.asInt(NaN))}`
                          : "";
            }
            let str = `${regStr(rd_valid.asBool(false), rd.asInt(NaN), result.asInt(NaN))}\n` +
                      `  = ${mnemonic}${srcStr(1, rs1_valid, rs1, src1_value)}${srcStr(2, rs2_valid, rs2, src2_value)}\n` +
                      `      ${immStr(imm_valid.asBool(false), imm.asBinaryStr("0"))}`;
            let instrWithValues = new fabric.Text(str, {
               top: 70,
               left: 65,
               fill: "blue",
               fontSize: 14,
               fontFamily: "monospace",
               visible: instr != sticky_zero
            })
            
            
            // Animate fetch (and provide onChange behavior for other animation).
            
            let fetch_instr_str = siggen(`instr_strs[${pc.asInt() >> 2}]`, `instr_strs[${pc.asInt() >> 2}]`).asString("(?) UNKNOWN fetch instr").substr(4)
            let fetch_instr_viz = new fabric.Text(fetch_instr_str, {
               top: -756 + 18 * (pc.asInt() >> 2),
               left: -352 + 8 * 4,
               fill: "black",
               fontSize: 14,
               fontFamily: "monospace",
               visible: instr != sticky_zero
            })
            fetch_instr_viz.animate({top: 32, left: 10}, {
                 onChange: this.global.canvas.renderAll.bind(this.global.canvas),
                 duration: 500
            })
            
            // Animate RF value read/write.
            
            let src1_value_viz = new fabric.Text(src1_value.asInt(0).toString(16), {
               left: 316 + 8 * 4,
               top: 18 * rs1.asInt(0) - 40,
               fill: "blue",
               fontSize: 14,
               fontFamily: "monospace",
               fontWeight: 800,
               visible: (src1_value != sticky_zero) && rs1_valid.asBool(false)
            })
            setTimeout(() => {src1_value_viz.animate({left: 166, top: 70 + 18 * 2}, {
                 onChange: this.global.canvas.renderAll.bind(this.global.canvas),
                 duration: 500
            })}, 500)
            let src2_value_viz = new fabric.Text(src2_value.asInt(0).toString(16), {
               left: 316 + 8 * 4,
               top: 18 * rs2.asInt(0) - 40,
               fill: "blue",
               fontSize: 14,
               fontFamily: "monospace",
               fontWeight: 800,
               visible: (src2_value != sticky_zero) && rs2_valid.asBool(false)
            })
            setTimeout(() => {src2_value_viz.animate({left: 166, top: 70 + 18 * 3}, {
                 onChange: this.global.canvas.renderAll.bind(this.global.canvas),
                 duration: 500
            })}, 500)
            
            let load_viz = new fabric.Text(ld_data.asInt(0).toString(16), {
               left: 470,
               top: 18 * dmem_addr.asInt() + 6 - 40,
               fill: "blue",
               fontSize: 14,
               fontFamily: "monospace",
               fontWeight: 1000,
               visible: false
            })
            if (dmem_rd_en.asBool()) {
               setTimeout(() => {
                  load_viz.set({visible: true})
                  load_viz.animate({left: 146, top: 70}, {
                    onChange: this.global.canvas.renderAll.bind(this.global.canvas),
                    duration: 500
                  })
                  setTimeout(() => {
                     load_viz.set({visible: false})
                     }, 500)
               }, 500)
            }
            
            let store_viz = new fabric.Text(src2_value.asInt(0).toString(16), {
               left: 166,
               top: 70 + 18 * 3,
               fill: "blue",
               fontSize: 14,
               fontFamily: "monospace",
               fontWeight: 1000,
               visible: false
            })
            if (dmem_wr_en.asBool()) {
               setTimeout(() => {
                  store_viz.set({visible: true})
                  store_viz.animate({left: 515, top: 18 * dmem_addr.asInt() - 40}, {
                    onChange: this.global.canvas.renderAll.bind(this.global.canvas),
                    duration: 500
                  })
               }, 1000)
            }
            
            let result_shadow = new fabric.Text(result.asInt(0).toString(16), {
               left: 146,
               top: 70,
               fill: "#b0b0df",
               fontSize: 14,
               fontFamily: "monospace",
               fontWeight: 800,
               visible: false
            })
            let result_viz = new fabric.Text(rf_wr_data.asInt(0).toString(16), {
               left: 146,
               top: 70,
               fill: "blue",
               fontSize: 14,
               fontFamily: "monospace",
               fontWeight: 800,
               visible: false
            })
            if (rd_valid.asBool()) {
               setTimeout(() => {
                  result_viz.set({visible: rf_wr_data != sticky_zero && rf_wr_en.asBool()})
                  result_shadow.set({visible: result != sticky_zero})
                  result_viz.animate({left: 317 + 8 * 4, top: 18 * rf_wr_index.asInt(0) - 40}, {
                    onChange: this.global.canvas.renderAll.bind(this.global.canvas),
                    duration: 500
                  })
               }, 1000)
            }
            
            // Lab completion
            
            // Passed?
            this.getObjects().passed.set({visible: false})
            if (passed) {
              if (passed.step(-1).asBool()) {
                this.getObjects().passed.set({visible: true, text:"Passed !!!", fill: "green"})
              } else {
                // Using an unstable API, so:
                try {
                  passed.goToSimEnd().step(-1)
                  if (passed.asBool()) {
                     this.getObjects().passed.set({text:"Sim Passes", visible: true, fill: "lightgray"})
                  }
                } catch(e) {
                }
              }
            }
            
            // Missing signals
            if (missing_list[0]) {
               this.getObjects().missing_sigs.set({visible: true})
               this.missing_col1.set({text: missing_list[0]})
               this.missing_col2.set({text: missing_list[1]})
            }
            return [pcPointer, pc_arrow, ...type_texts, rs1_arrow, rs2_arrow, rd_arrow, instrWithValues, fetch_instr_viz, src1_value_viz, src2_value_viz, result_shadow, result_viz, ld_arrow, st_arrow, load_viz, store_viz]
         }
         
      /imem[57:0]
         \viz_js
            box: {width: 630, height: 18, strokeWidth: 0},
            init() {
              let binary = new fabric.Text("", {
                 top: 0,
                 left: 0,
                 fontSize: 14,
                 fontFamily: "monospace",
            
              })
              let disassembled = new fabric.Text("", {
                 top: 0,
                 left: 330,
                 fontSize: 14,
                 fontFamily: "monospace"
              })
              return {binary, disassembled}
            },
            onTraceData() {
               let instr = this.svSigRef(`instrs[${this.getIndex()}]`)
               if (!instr) {
                  // Previously, Verilator used (), not []. This should no longer be needed, but, just in case:
                  instr = this.svSigRef(`instrs(${this.getIndex()})`)
               }
               if (instr) {
                  let binary_str = instr.goToSimStart().asBinaryStr("")
                  this.getObjects().binary.set({text: binary_str})
               }
               let disassembled = this.svSigRef(`instr_strs[${this.getIndex()}]`)
               if (!disassembled) {
                  // Previously, Verilator used (), not []. This should no longer be needed, but, just in case:
                  disassembled = this.svSigRef(`instr_strs(${this.getIndex()})`)
               }
               if (disassembled) {
                  let disassembled_str = disassembled.goToSimStart().asString("")
                  disassembled_str = disassembled_str.slice(0, -5)
                  this.getObjects().disassembled.set({text: disassembled_str})
               }
            },
            render() {
               // Instruction memory is constant, so just create it once.
               let reset = this.svSigRef(`L0_reset_a0`)
               let pc = this.svSigRef(`L0_pc_a0`)
               let rd_viz = pc && !reset.asBool() && (pc.asInt() >> 2) == this.getIndex()
               this.getObjects().disassembled.set({textBackgroundColor: rd_viz ? "#b0ffff" : "white"})
               this.getObjects().binary      .set({textBackgroundColor: rd_viz ? "#b0ffff" : "white"})
            },
            where: {left: -680, top: -756}
         
   \end_source
\SV
   endmodule
