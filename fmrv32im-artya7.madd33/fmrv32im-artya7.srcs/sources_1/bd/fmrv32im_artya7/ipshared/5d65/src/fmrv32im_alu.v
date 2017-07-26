module fmrv32im_alu
  (
   input 			 RST_N,
   input 			 CLK,

   input 			 INST_ADDI,
   input 			 INST_SLTI,
   input 			 INST_SLTIU,
   input 			 INST_XORI,
   input 			 INST_ORI,
   input 			 INST_ANDI,
   input 			 INST_SLLI,
   input 			 INST_SRLI,
   input 			 INST_SRAI,
   input 			 INST_ADD,
   input 			 INST_SUB,
   input 			 INST_SLL,
   input 			 INST_SLT,
   input 			 INST_SLTU,
   input 			 INST_XOR,
   input 			 INST_SRL,
   input 			 INST_SRA,
   input 			 INST_OR,
   input 			 INST_AND,

   input 			 INST_BEQ,
   input 			 INST_BNE,
   input 			 INST_BLT,
   input 			 INST_BGE,
   input 			 INST_BLTU,
   input 			 INST_BGEU,

   input 			 INST_LB,
   input 			 INST_LH,
   input 			 INST_LW,
   input 			 INST_LBU,
   input 			 INST_LHU,
   input 			 INST_SB,
   input 			 INST_SH,
   input 			 INST_SW,

   input [31:0] 	 RS1,
   input [31:0] 	 RS2,
   input [31:0] 	 IMM,

   output reg        RSLT_VALID,
   output reg [31:0] RSLT

   );

   /*
	下記の命令でrs1+IMMを行うのはLOAD, STORE命令のアドレス値を
	算出するためです。
	INST_LB, INST_LH, INST_LW, INST_LBU, INST_LHU,
	INST_SB, INST_SH, INST_SW
	*/
   reg [31:0] 		 reg_op2;
   always @(*) begin
	  reg_op2 <= (INST_ADDI | INST_SLTI | INST_SLTIU |
				  INST_XORI | INST_ANDI | INST_ORI |
				  INST_SLLI | INST_SRLI | INST_SRAI |
				  INST_LB | INST_LH | INST_LW | INST_LBU | INST_LHU |
				  INST_SB | INST_SH | INST_SW)?IMM:RS2;
   end

   reg [31:0] alu_add_sub, alu_shl, alu_shr;
   reg [31:0] alu_xor, alu_or, alu_and;
   reg 	   alu_eq, alu_ltu, alu_lts;

   always @(*) begin
	  alu_add_sub <= (INST_SUB)?(RS1 - reg_op2):(RS1 + reg_op2);
	  alu_shl     <= RS1 << reg_op2[4:0];
	  alu_shr     <= $signed({(INST_SRA | INST_SRAI)?RS1[31]:1'b0, RS1}) >>> reg_op2[4:0];
	  alu_eq      <= (RS1 == reg_op2);
	  alu_lts     <= ($signed(RS1) < $signed(reg_op2));
	  alu_ltu     <= (RS1 < reg_op2);
	  alu_xor     <= RS1 ^ reg_op2;
	  alu_or      <= RS1 | reg_op2;
	  alu_and     <= RS1 & reg_op2;
   end // always @ (posedge CLK)

   always @(posedge CLK) begin
      if(!RST_N) begin
         RSLT       <= 0;
         RSLT_VALID <= 0;
      end else begin
	 RSLT <= (INST_ADDI | INST_ADD | INST_SUB |
		  INST_LB | INST_LH | INST_LW | INST_LBU | INST_LHU |
		  INST_SB | INST_SH | INST_SW)?alu_add_sub:
		 (INST_SLTI | INST_SLT)?alu_lts:
		 (INST_SLTIU | INST_SLTU)?alu_ltu:
		 (INST_SLLI | INST_SLL)?alu_shl:
		 (INST_SRLI | INST_SRAI | INST_SRL | INST_SRA)?alu_shr:
		 (INST_XORI | INST_XOR)?alu_xor:
		 (INST_ORI | INST_OR)?alu_or:
		 (INST_ANDI | INST_AND)?alu_and:
		 (INST_BEQ)?alu_eq:
		 (INST_BNE)?!alu_eq:
		 (INST_BGE)?!alu_lts:
		 (INST_BGEU)?!alu_ltu:
		 (INST_BLT)?alu_lts:
		 (INST_BLTU)?alu_ltu:
		 32'd0;
         RSLT_VALID <= INST_ADDI | INST_ADD | INST_SUB |
                       INST_LB | INST_LH | INST_LW | INST_LBU | INST_LHU |
                       INST_SB | INST_SH | INST_SW |
                       INST_SLTI | INST_SLT | INST_SLTIU | INST_SLTU |
		       INST_SLLI | INST_SLL |
                       INST_SRLI | INST_SRAI | INST_SRL | INST_SRA |
                       INST_XORI | INST_XOR |
                       INST_ORI | INST_OR |
                       INST_ANDI | INST_AND |
                       INST_BEQ | INST_BNE | INST_BGE | INST_BGEU |
		       INST_BLT | INST_BLTU;
      end
   end

endmodule // fmrv32im_alu
