module fmrv32im_decode
  (
   input 	     RST_N,
   input 	     CLK,

   // インストラクションコード
   input wire [31:0] INST_CODE,

   // レジスタ番号
   output wire [4:0] RD_NUM,
   output wire [4:0] RS1_NUM,
   output wire [4:0] RS2_NUM,

   // イミデート
   output reg [31:0] IMM,

   // 命令
   output reg 	     INST_LUI,
   output reg 	     INST_AUIPC,
   output reg 	     INST_JAL,
   output reg 	     INST_JALR,
   output reg 	     INST_BEQ,
   output reg 	     INST_BNE,
   output reg 	     INST_BLT,
   output reg 	     INST_BGE,
   output reg 	     INST_BLTU,
   output reg 	     INST_BGEU,
   output reg 	     INST_LB,
   output reg 	     INST_LH,
   output reg 	     INST_LW,
   output reg 	     INST_LBU,
   output reg 	     INST_LHU,
   output reg 	     INST_SB,
   output reg 	     INST_SH,
   output reg 	     INST_SW,
   output reg 	     INST_ADDI,
   output reg 	     INST_SLTI,
   output reg 	     INST_SLTIU,
   output reg 	     INST_XORI,
   output reg 	     INST_ORI,
   output reg 	     INST_ANDI,
   output reg 	     INST_SLLI,
   output reg 	     INST_SRLI,
   output reg 	     INST_SRAI,
   output reg 	     INST_ADD,
   output reg 	     INST_SUB,
   output reg 	     INST_SLL,
   output reg 	     INST_SLT,
   output reg 	     INST_SLTU,
   output reg 	     INST_XOR,
   output reg 	     INST_SRL,
   output reg 	     INST_SRA,
   output reg 	     INST_OR,
   output reg 	     INST_AND,
   output reg 	     INST_FENCE,
   output reg 	     INST_FENCEI,
   output reg 	     INST_ECALL,
   output reg 	     INST_EBREAK,
   output reg 	     INST_MRET,
   output reg 	     INST_CSRRW,
   output reg 	     INST_CSRRS,
   output reg 	     INST_CSRRC,
   output reg 	     INST_CSRRWI,
   output reg 	     INST_CSRRSI,
   output reg 	     INST_CSRRCI,
   output reg 	     INST_MUL,
   output reg 	     INST_MULH,
   output reg 	     INST_MULHSU,
   output reg 	     INST_MULHU,
   output reg 	     INST_DIV,
   output reg 	     INST_DIVU,
   output reg 	     INST_REM,
   output reg 	     INST_REMU,

	 output reg        INST_CUSTOM0,

   output wire 	     ILL_INST

   );


   // タイプ(イミデート)判別
   reg 		     r_type, i_type, s_type, b_type, u_type, j_type;
	 reg         c0_type; // custom0
   always @(*) begin
      r_type <= (INST_CODE[6:5] == 2'b01) && (INST_CODE[4:2] == 3'b100);
      i_type <= ((INST_CODE[6:5] == 2'b00) && ((INST_CODE[4:2] == 3'b000) ||
					       (INST_CODE[4:2] == 3'b011) ||
					       (INST_CODE[4:2] == 3'b100))) ||
		((INST_CODE[6:5] == 2'b11) && ((INST_CODE[4:2] == 3'b001) ||
					       (INST_CODE[4:2] == 3'b100)));
      s_type <= (INST_CODE[6:5] == 2'b01) && (INST_CODE[4:2] == 3'b000);
      b_type <= (INST_CODE[6:5] == 2'b11) && (INST_CODE[4:2] == 3'b000);
      u_type <= ((INST_CODE[6:5] == 2'b00) || (INST_CODE[6:5] == 2'b01)) &&
		(INST_CODE[4:2] == 3'b101);
      j_type <= (INST_CODE[6:5] == 2'b11) && (INST_CODE[4:2] == 3'b011);
			c0_type <= (INST_CODE[6:5] == 2'b00) && (INST_CODE[4:2] == 3'b010);
   end

   // イミデート生成
   always @(posedge CLK) begin
      if(!RST_N) begin
         IMM <= 0;
      end else begin
	 IMM <= (i_type)?{{21{INST_CODE[31]}},
			  INST_CODE[30:20]}:
		(s_type)?{{21{INST_CODE[31]}},
			  INST_CODE[30:25], INST_CODE[11:7]}:
		(b_type)?{{20{INST_CODE[31]}},
			  INST_CODE[7], INST_CODE[30:25], INST_CODE[11:8], 1'b0}:
		(u_type)?{INST_CODE[31:12], 12'b0000_0000_0000}:
		(j_type)?{{12{INST_CODE[31]}},
			  INST_CODE[19:12], INST_CODE[20], INST_CODE[30:21], 1'b0}:
		32'd0; // Illigal Code
      end
   end

   // レジスタ番号生成
   assign RD_NUM  = (r_type | i_type | u_type | j_type | c0_type)?INST_CODE[11:7]:5'd0;
   assign RS1_NUM = (r_type | i_type | s_type | b_type)?INST_CODE[19:15]:5'd0;
   assign RS2_NUM = (r_type | s_type | b_type)?INST_CODE[24:20]:5'd0;


   // 各種ファンクション生成
   wire [2:0] func3;
   wire [6:0] func7;
   assign func3 = INST_CODE[14:12];
   assign func7 = INST_CODE[31:25];

   // 命令判別
   always @(posedge CLK) begin
      if(!RST_N) begin
	 INST_LUI    <= 1'b0;
	 INST_AUIPC  <= 1'b0;
	 INST_JAL    <= 1'b0;
	 INST_JALR   <= 1'b0;
	 INST_BEQ    <= 1'b0;
	 INST_BNE    <= 1'b0;
	 INST_BLT    <= 1'b0;
	 INST_BGE    <= 1'b0;
	 INST_BLTU   <= 1'b0;
	 INST_BGEU   <= 1'b0;
	 INST_LB     <= 1'b0;
	 INST_LH     <= 1'b0;
	 INST_LW     <= 1'b0;
	 INST_LBU    <= 1'b0;
	 INST_LHU    <= 1'b0;
	 INST_SB     <= 1'b0;
	 INST_SH     <= 1'b0;
	 INST_SW     <= 1'b0;
	 INST_ADDI   <= 1'b0;
	 INST_SLTI   <= 1'b0;
	 INST_SLTIU  <= 1'b0;
	 INST_XORI   <= 1'b0;
	 INST_ORI    <= 1'b0;
	 INST_ANDI   <= 1'b0;
	 INST_SLLI   <= 1'b0;
	 INST_SRLI   <= 1'b0;
	 INST_SRAI   <= 1'b0;
	 INST_ADD    <= 1'b0;
	 INST_SUB    <= 1'b0;
	 INST_SLL    <= 1'b0;
	 INST_SLT    <= 1'b0;
	 INST_SLTU   <= 1'b0;
	 INST_XOR    <= 1'b0;
	 INST_SRL    <= 1'b0;
	 INST_SRA    <= 1'b0;
	 INST_OR     <= 1'b0;
	 INST_AND    <= 1'b0;
	 INST_FENCE  <= 1'b0;
	 INST_FENCEI <= 1'b0;
	 INST_ECALL  <= 1'b0;
	 INST_EBREAK <= 1'b0;
	 INST_MRET   <= 1'b0;
	 INST_CSRRW  <= 1'b0;
	 INST_CSRRS  <= 1'b0;
	 INST_CSRRC  <= 1'b0;
	 INST_CSRRWI <= 1'b0;
	 INST_CSRRSI <= 1'b0;
	 INST_CSRRCI <= 1'b0;
	 INST_MUL    <= 1'b0;
	 INST_MULH   <= 1'b0;
	 INST_MULHSU <= 1'b0;
	 INST_MULHU  <= 1'b0;
	 INST_DIV    <= 1'b0;
	 INST_DIVU   <= 1'b0;
	 INST_REM    <= 1'b0;
	 INST_REMU   <= 1'b0;
	 INST_CUSTOM0 <= 1'b0;
      end else begin
	 INST_LUI    <= (INST_CODE[6:0] == 7'b0110111);
	 INST_AUIPC  <= (INST_CODE[6:0] == 7'b0010111);
	 INST_JAL    <= (INST_CODE[6:0] == 7'b1101111);
	 INST_JALR   <= (INST_CODE[6:0] == 7'b1100111);
	 INST_BEQ    <= (INST_CODE[6:0] == 7'b1100011) && (func3 == 3'b000);
	 INST_BNE    <= (INST_CODE[6:0] == 7'b1100011) && (func3 == 3'b001);
	 INST_BLT    <= (INST_CODE[6:0] == 7'b1100011) && (func3 == 3'b100);
	 INST_BGE    <= (INST_CODE[6:0] == 7'b1100011) && (func3 == 3'b101);
	 INST_BLTU   <= (INST_CODE[6:0] == 7'b1100011) && (func3 == 3'b110);
	 INST_BGEU   <= (INST_CODE[6:0] == 7'b1100011) && (func3 == 3'b111);
	 INST_LB     <= (INST_CODE[6:0] == 7'b0000011) && (func3 == 3'b000);
	 INST_LH     <= (INST_CODE[6:0] == 7'b0000011) && (func3 == 3'b001);
	 INST_LW     <= (INST_CODE[6:0] == 7'b0000011) && (func3 == 3'b010);
	 INST_LBU    <= (INST_CODE[6:0] == 7'b0000011) && (func3 == 3'b100);
	 INST_LHU    <= (INST_CODE[6:0] == 7'b0000011) && (func3 == 3'b101);
	 INST_SB     <= (INST_CODE[6:0] == 7'b0100011) && (func3 == 3'b000);
	 INST_SH     <= (INST_CODE[6:0] == 7'b0100011) && (func3 == 3'b001);
	 INST_SW     <= (INST_CODE[6:0] == 7'b0100011) && (func3 == 3'b010);
	 INST_ADDI   <= (INST_CODE[6:0] == 7'b0010011) && (func3 == 3'b000);
	 INST_SLTI   <= (INST_CODE[6:0] == 7'b0010011) && (func3 == 3'b010);
	 INST_SLTIU  <= (INST_CODE[6:0] == 7'b0010011) && (func3 == 3'b011);
	 INST_XORI   <= (INST_CODE[6:0] == 7'b0010011) && (func3 == 3'b100);
	 INST_ORI    <= (INST_CODE[6:0] == 7'b0010011) && (func3 == 3'b110);
	 INST_ANDI   <= (INST_CODE[6:0] == 7'b0010011) && (func3 == 3'b111);
	 INST_SLLI   <= (INST_CODE[6:0] == 7'b0010011) && (func3 == 3'b001) &&
			(func7 == 7'b0000000);
	 INST_SRLI   <= (INST_CODE[6:0] == 7'b0010011) && (func3 == 3'b101) &&
			(func7 == 7'b0000000);
	 INST_SRAI   <= (INST_CODE[6:0] == 7'b0010011) && (func3 == 3'b101) &&
			(func7 == 7'b0100000);
	 INST_ADD    <= (INST_CODE[6:0] == 7'b0110011) && (func3 == 3'b000) &&
			(func7 == 7'b0000000);
	 INST_SUB    <= (INST_CODE[6:0] == 7'b0110011) && (func3 == 3'b000) &&
			(func7 == 7'b0100000);
	 INST_SLL    <= (INST_CODE[6:0] == 7'b0110011) && (func3 == 3'b001) &&
			(func7 == 7'b0000000);
	 INST_SLT    <= (INST_CODE[6:0] == 7'b0110011) && (func3 == 3'b010) &&
			(func7 == 7'b0000000);
	 INST_SLTU   <= (INST_CODE[6:0] == 7'b0110011) && (func3 == 3'b011) &&
			(func7 == 7'b0000000);
	 INST_XOR    <= (INST_CODE[6:0] == 7'b0110011) && (func3 == 3'b100) &&
			(func7 == 7'b0000000);
	 INST_SRL    <= (INST_CODE[6:0] == 7'b0110011) && (func3 == 3'b101) &&
			(func7 == 7'b0000000);
	 INST_SRA    <= (INST_CODE[6:0] == 7'b0110011) && (func3 == 3'b101) &&
			(func7 == 7'b0100000);
	 INST_OR     <= (INST_CODE[6:0] == 7'b0110011) && (func3 == 3'b110) &&
			(func7 == 7'b0000000);
	 INST_AND    <= (INST_CODE[6:0] == 7'b0110011) && (func3 == 3'b111) &&
			(func7 == 7'b0000000);
	 INST_FENCE  <= (INST_CODE[6:0] == 7'b0001111) && (func3 == 3'b000);
	 INST_FENCEI <= (INST_CODE[6:0] == 7'b0001111) && (func3 == 3'b001);
	 INST_ECALL  <= (INST_CODE[6:0] == 7'b1110011) && (func3 == 3'b000) &&
			(INST_CODE[31:20] == 12'b0000_0000_0000);
	 INST_EBREAK <= (INST_CODE[6:0] == 7'b1110011) && (func3 == 3'b000) &&
			(INST_CODE[31:20] == 12'b0000_0000_0001);
	 INST_MRET   <= (INST_CODE[6:0] == 7'b1110011) && (func3 == 3'b000) &&
			(INST_CODE[31:20] == 12'b0011_0000_0010);
	 INST_CSRRW  <= (INST_CODE[6:0] == 7'b1110011) && (func3 == 3'b001);
	 INST_CSRRS  <= (INST_CODE[6:0] == 7'b1110011) && (func3 == 3'b010);
	 INST_CSRRC  <= (INST_CODE[6:0] == 7'b1110011) && (func3 == 3'b011);
	 INST_CSRRWI <= (INST_CODE[6:0] == 7'b1110011) && (func3 == 3'b101);
	 INST_CSRRSI <= (INST_CODE[6:0] == 7'b1110011) && (func3 == 3'b110);
	 INST_CSRRCI <= (INST_CODE[6:0] == 7'b1110011) && (func3 == 3'b111);
	 INST_MUL    <= (INST_CODE[6:0] == 7'b0110011) && (func3 == 3'b000) &&
			(func7 == 7'b0000001);
	 INST_MULH   <= (INST_CODE[6:0] == 7'b0110011) && (func3 == 3'b001) &&
			(func7 == 7'b0000001);
	 INST_MULHSU <= (INST_CODE[6:0] == 7'b0110011) && (func3 == 3'b010) &&
			(func7 == 7'b0000001);
	 INST_MULHU  <= (INST_CODE[6:0] == 7'b0110011) && (func3 == 3'b011) &&
			(func7 == 7'b0000001);
	 INST_DIV    <= (INST_CODE[6:0] == 7'b0110011) && (func3 == 3'b100) &&
			(func7 == 7'b0000001);
	 INST_DIVU   <= (INST_CODE[6:0] == 7'b0110011) && (func3 == 3'b101) &&
			(func7 == 7'b0000001);
	 INST_REM    <= (INST_CODE[6:0] == 7'b0110011) && (func3 == 3'b110) &&
			(func7 == 7'b0000001);
	 INST_REMU   <= (INST_CODE[6:0] == 7'b0110011) && (func3 == 3'b111) &&
			(func7 == 7'b0000001);
	 INST_CUSTOM0 <= (INST_CODE[6:0] == 7'b0001011);
      end
   end

   assign ILL_INST = ~(
                       INST_LUI | INST_AUIPC | INST_JAL | INST_JALR |
                       INST_BEQ | INST_BNE | INST_BLT | INST_BGE |
                       INST_BLTU | INST_BGEU |
                       INST_LB | INST_LH | INST_LW | INST_LBU | INST_LHU |
                       INST_SB | INST_SH | INST_SW |
                       INST_ADDI | INST_SLTI | INST_SLTIU |
                       INST_XORI | INST_ORI | INST_ANDI |
                       INST_SLLI | INST_SRLI | INST_SRAI |
                       INST_ADD | INST_SUB |
                       INST_SLL | INST_SLT | INST_SLTU |
                       INST_XOR | INST_SRL | INST_SRA |
                       INST_OR | INST_AND |
                       INST_FENCE | INST_FENCEI |
                       INST_ECALL | INST_EBREAK |
                       INST_MRET |
                       INST_CSRRW | INST_CSRRS | INST_CSRRC |
                       INST_CSRRWI | INST_CSRRSI | INST_CSRRCI |
                       INST_MUL | INST_MULH | INST_MULHSU | INST_MULHU |
                       INST_DIV | INST_DIVU | INST_REM | INST_REMU |
											 INST_CUSTOM0
                       );

endmodule // fmrv32im_decoder
