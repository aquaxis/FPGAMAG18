module fmrv32im
  #(
    parameter MADD33_ADDON = 0
  )
  (
   input         RST_N,
   input         CLK,

   input         I_MEM_WAIT,
   output        I_MEM_ENA,
   output [31:0] I_MEM_ADDR,
   input [31:0]  I_MEM_RDATA,
   input         I_MEM_BADMEM_EXCPT,

   input         D_MEM_WAIT,
   output        D_MEM_ENA,
   output [3:0]  D_MEM_WSTB,
   output [31:0] D_MEM_ADDR,
   output [31:0] D_MEM_WDATA,
   input [31:0]  D_MEM_RDATA,
   input         D_MEM_BADMEM_EXCPT,

   input         EXT_INTERRUPT,
   input         TIMER_EXPIRED
   );

   // Program Counter
   wire [31:0] 	 pc;

   wire [4:0] 	 id_rd_num, id_rs1_num, id_rs2_num;
   wire [31:0] 	 id_rs1, id_rs2, id_imm;
   wire [31:0]   id_x10, id_x11, id_x12, id_x13, id_x14, id_x15;

   wire 		 id_inst_lui, id_inst_auipc,
				 id_inst_jal, id_inst_jalr,
				 id_inst_beq, id_inst_bne,
				 id_inst_blt, id_inst_bge,
				 id_inst_bltu, id_inst_bgeu,
				 id_inst_lb, id_inst_lh, id_inst_lw,
				 id_inst_lbu, id_inst_lhu,
				 id_inst_sb, id_inst_sh, id_inst_sw,
				 id_inst_addi, id_inst_slti, id_inst_sltiu,
				 id_inst_xori, id_inst_ori, id_inst_andi,
				 id_inst_slli, id_inst_srli, id_inst_srai,
				 id_inst_add, id_inst_sub,
				 id_inst_sll, id_inst_slt, id_inst_sltu,
				 id_inst_xor, id_inst_srl, id_inst_sra,
				 id_inst_or, id_inst_and,
				 id_inst_fence, id_inst_fencei,
				 id_inst_ecall, id_inst_ebreak, id_inst_mret,
				 id_inst_csrrw, id_inst_csrrs, id_inst_csrrc,
				 id_inst_csrrwi, id_inst_csrrsi, id_inst_csrrci,
				 id_inst_mul, id_inst_mulh,
				 id_inst_mulhsu, id_inst_mulhu,
				 id_inst_div, id_inst_divu,
				 id_inst_rem, id_inst_remu,
				 id_ill_inst;
   wire id_inst_madd33;

   wire          retire;
   assign retire = 1'b0;

   /* ------------------------------------------------------------ *
	* CPU State                                                    *
	* ------------------------------------------------------------ */
   reg [7:0]     cpu_state;
   localparam S_IDLE      = 8'b0000_0001;
   localparam S_FETCH     = 8'b0000_0010;
   localparam S_DECODE    = 8'b0000_0100;
   localparam S_EXECUTE   = 8'b0000_1000;
   localparam S_MEMORY    = 8'b0001_0000;
   localparam S_WRITEBACK = 8'b0010_0000;
   localparam S_TRAP      = 8'b0100_0000;

   wire          ex_wait;
   wire          ex_ready;
   reg           cpu_state_wait;

   always @(posedge CLK) begin
      if(!RST_N) begin
         cpu_state <= S_IDLE;
         cpu_state_wait <= 1'b0;
      end else begin
         case(cpu_state)
           S_IDLE:
             begin
                if(!I_MEM_WAIT) begin
                  cpu_state <= S_FETCH;
                end
             end
           S_FETCH:
             begin
               cpu_state <= S_DECODE;
             end
           S_DECODE:
             begin
                cpu_state <= S_EXECUTE;
             end
           S_EXECUTE:
             begin
                if(!ex_wait) begin
                   cpu_state <= S_MEMORY;
                end
             end
           S_MEMORY:
             begin
                if(!D_MEM_WAIT) begin
                   cpu_state <= S_WRITEBACK;
                end
             end
           S_WRITEBACK:
             begin
                if(!I_MEM_WAIT) begin
                  cpu_state <= S_FETCH;
                end
             end
           S_TRAP:
             begin
                cpu_state <= S_FETCH;
             end
         endcase
         cpu_state_wait <= ((cpu_state == S_IDLE) & I_MEM_WAIT) |
                           ((cpu_state == S_EXECUTE) & ex_wait) |
                           ((cpu_state == S_MEMORY) & D_MEM_WAIT) |
                           ((cpu_state == S_WRITEBACK) & I_MEM_WAIT);
      end
   end

   /* ------------------------------------------------------------ *
	* Stage.1(IF:Instruction Fetch)                                *
	* ------------------------------------------------------------ */
   assign I_MEM_ENA  = (cpu_state == S_WRITEBACK) | (cpu_state == S_IDLE);
   assign I_MEM_ADDR = pc;

   /* ------------------------------------------------------------ *
	* Stage.2(ID:Instruction Decode)                               *
	* ------------------------------------------------------------ */
   fmrv32im_decode u_fmrv32im_decode
	 (
      .RST_N       ( RST_N),
      .CLK         ( CLK),

	  // インストラクションコード
      .INST_CODE   ( I_MEM_RDATA),

	  // レジスタ番号
      .RD_NUM      ( id_rd_num),
      .RS1_NUM     ( id_rs1_num),
      .RS2_NUM     ( id_rs2_num),

	  // イミデート
      .IMM         ( id_imm),

	  // 命令
      .INST_LUI    ( id_inst_lui),
      .INST_AUIPC  ( id_inst_auipc),
      .INST_JAL    ( id_inst_jal),
      .INST_JALR   ( id_inst_jalr),
      .INST_BEQ    ( id_inst_beq),
      .INST_BNE    ( id_inst_bne),
      .INST_BLT    ( id_inst_blt),
      .INST_BGE    ( id_inst_bge),
      .INST_BLTU   ( id_inst_bltu),
      .INST_BGEU   ( id_inst_bgeu),
      .INST_LB     ( id_inst_lb),
      .INST_LH     ( id_inst_lh),
      .INST_LW     ( id_inst_lw),
      .INST_LBU    ( id_inst_lbu),
      .INST_LHU    ( id_inst_lhu),
      .INST_SB     ( id_inst_sb),
      .INST_SH     ( id_inst_sh),
      .INST_SW     ( id_inst_sw),
      .INST_ADDI   ( id_inst_addi),
      .INST_SLTI   ( id_inst_slti),
      .INST_SLTIU  ( id_inst_sltiu),
      .INST_XORI   ( id_inst_xori),
      .INST_ORI    ( id_inst_ori),
      .INST_ANDI   ( id_inst_andi),
      .INST_SLLI   ( id_inst_slli),
      .INST_SRLI   ( id_inst_srli),
      .INST_SRAI   ( id_inst_srai),
      .INST_ADD    ( id_inst_add),
      .INST_SUB    ( id_inst_sub),
      .INST_SLL    ( id_inst_sll),
      .INST_SLT    ( id_inst_slt),
      .INST_SLTU   ( id_inst_sltu),
      .INST_XOR    ( id_inst_xor),
      .INST_SRL    ( id_inst_srl),
      .INST_SRA    ( id_inst_sra),
      .INST_OR     ( id_inst_or),
      .INST_AND    ( id_inst_and),
      .INST_FENCE  ( id_inst_fence),
      .INST_FENCEI ( id_inst_fencei),
      .INST_ECALL  ( id_inst_ecall),
      .INST_EBREAK ( id_inst_ebreak),
      .INST_MRET   ( id_inst_mret),
      .INST_CSRRW  ( id_inst_csrrw),
      .INST_CSRRS  ( id_inst_csrrs),
      .INST_CSRRC  ( id_inst_csrrc),
      .INST_CSRRWI ( id_inst_csrrwi),
      .INST_CSRRSI ( id_inst_csrrsi),
      .INST_CSRRCI ( id_inst_csrrci),
      .INST_MUL    ( id_inst_mul),
      .INST_MULH   ( id_inst_mulh),
      .INST_MULHSU ( id_inst_mulhsu),
      .INST_MULHU  ( id_inst_mulhu),
      .INST_DIV    ( id_inst_div),
      .INST_DIVU   ( id_inst_divu),
      .INST_REM    ( id_inst_rem),
      .INST_REMU   ( id_inst_remu),

      .INST_CUSTOM0 ( id_inst_madd33),

      .ILL_INST    ( id_ill_inst)

	  );

   /* ------------------------------------------------------------ *
	* Stage.3(EX:Excute)                                           *
	* ------------------------------------------------------------ */
   wire [31:0] ex_alu_rslt;
   wire        is_ex_alu_rslt;
   wire        ex_mul_wait;
   wire        ex_mul_ready;
   wire [31:0] ex_mul_rd;
   wire        ex_div_wait;
   wire        ex_div_ready;
   wire [31:0] ex_div_rd;

    wire ex_madd33_wait;
    wire ex_madd33_ready;
    wire [31:0] ex_madd33_rd;

   fmrv32im_alu u_fmrv32im_alu
	 (
      .RST_N      ( RST_N),
      .CLK        ( CLK),

      .INST_ADDI  ( id_inst_addi),
      .INST_SLTI  ( id_inst_slti),
      .INST_SLTIU ( id_inst_sltiu),
      .INST_XORI  ( id_inst_xori),
      .INST_ORI   ( id_inst_ori),
      .INST_ANDI  ( id_inst_andi),
      .INST_SLLI  ( id_inst_slli),
      .INST_SRLI  ( id_inst_srli),
      .INST_SRAI  ( id_inst_srai),
      .INST_ADD   ( id_inst_add),
      .INST_SUB   ( id_inst_sub),
      .INST_SLL   ( id_inst_sll),
      .INST_SLT   ( id_inst_slt),
      .INST_SLTU  ( id_inst_sltu),
      .INST_XOR   ( id_inst_xor),
      .INST_SRL   ( id_inst_srl),
      .INST_SRA   ( id_inst_sra),
      .INST_OR    ( id_inst_or),
      .INST_AND   ( id_inst_and),

      .INST_BEQ   ( id_inst_beq),
      .INST_BNE   ( id_inst_bne),
      .INST_BLT   ( id_inst_blt),
      .INST_BGE   ( id_inst_bge),
      .INST_BLTU  ( id_inst_bltu),
      .INST_BGEU  ( id_inst_bgeu),

      .INST_LB    ( id_inst_lb),
      .INST_LH    ( id_inst_lh),
      .INST_LW    ( id_inst_lw),
      .INST_LBU   ( id_inst_lbu),
      .INST_LHU   ( id_inst_lhu),
      .INST_SB    ( id_inst_sb),
      .INST_SH    ( id_inst_sh),
      .INST_SW    ( id_inst_sw),

   	  .RS1        ( id_rs1),
      .RS2        ( id_rs2),
      .IMM        ( id_imm),

      .RSLT_VALID ( is_ex_alu_rslt),
      .RSLT       ( ex_alu_rslt)
	  );

   fmrv32im_mul u_fmrc32em_mul
     (
      .RST_N       ( RST_N),
      .CLK         ( CLK),

      .INST_MUL    ( id_inst_mul    & (cpu_state == S_EXECUTE)),
      .INST_MULH   ( id_inst_mulh   & (cpu_state == S_EXECUTE)),
      .INST_MULHSU ( id_inst_mulhsu & (cpu_state == S_EXECUTE)),
      .INST_MULHU  ( id_inst_mulhu  & (cpu_state == S_EXECUTE)),

      .RS1         ( id_rs1),
      .RS2         ( id_rs2),

      .WAIT        ( ex_mul_wait),
      .READY       ( ex_mul_ready),
      .RD          ( ex_mul_rd)
   );

   fmrv32im_div u_fmrv32im_div
     (
      .RST_N     ( RST_N),
      .CLK       ( CLK),

      .INST_DIV  ( id_inst_div  & (cpu_state == S_EXECUTE)),
      .INST_DIVU ( id_inst_divu & (cpu_state == S_EXECUTE)),
      .INST_REM  ( id_inst_rem  & (cpu_state == S_EXECUTE)),
      .INST_REMU ( id_inst_remu & (cpu_state == S_EXECUTE)),

      .RS1       ( id_rs1),
      .RS2       ( id_rs2),

      .WAIT      ( ex_div_wait),
      .READY     ( ex_div_ready),
      .RD        ( ex_div_rd)
   );

  generate
    if(MADD33_ADDON) begin
      fmrv32im_madd33 u_fmrv32im_madd33
      (
        .RST_N ( RST_N ),
        .CLK   ( CLK   ),

        .INST_MADD33 ( id_inst_madd33 & (cpu_state == S_EXECUTE)),

        .RS1 ( id_x10 ),
        .RS2 ( id_x11 ),
        .RS3 ( id_x12 ),
        .RS4 ( id_x13 ),
        .RS5 ( id_x14 ),
        .RS6 ( id_x15 ),

        .WAIT  ( ex_madd33_wait  ),
        .READY ( ex_madd44_ready ),
        .RD    ( ex_madd33_rd    )
      );
     end else begin
       assign ex_madd33_wait = 1'b0;
       assign ex_madd33_ready = 1'b0;
       assign ex_madd33_rd = 32'd0;
     end
  endgenerate

   assign ex_wait = ex_mul_wait |
                    ex_madd33_wait |
		    (!ex_div_ready & (ex_div_wait |
				      ((cpu_state == S_EXECUTE) &
				       (
					id_inst_div | id_inst_divu |
					id_inst_rem | id_inst_remu
					)))
		     );

   // add PC
   reg [31:0] ex_pc_add_imm, ex_pc_add_4, ex_pc_jalr;
   always @(posedge CLK) begin
      ex_pc_add_imm <= pc + id_imm;  // AUIPC for rd, BRANCH, JAL for pc
      ex_pc_jalr    <= id_rs1 + id_imm; // for JALR
      ex_pc_add_4   <= pc + 4;       // Normal
   end

   reg [11:0] ex_csr_addr;
   reg        ex_csr_we;
   reg [31:0] ex_csr_wdata;
   reg [31:0] ex_csr_wmask;
   always @(posedge CLK) begin
      if(!RST_N) begin
         ex_csr_addr  <= 0;
         ex_csr_we    <= 0;
         ex_csr_wdata <= 0;
         ex_csr_wmask <= 0;
      end else begin
	 ex_csr_addr  <= id_imm[11:0];
	 ex_csr_we    <= (id_inst_csrrw | id_inst_csrrs | id_inst_csrrc) |
			 ((id_inst_csrrwi | id_inst_csrrsi | id_inst_csrrci) &
			  (id_rs1_num == 5'd0));
	 ex_csr_wdata <= (id_inst_csrrw)?id_rs1:
			 (id_inst_csrrs)?~id_rs1:
			 (id_inst_csrrc)?32'd0:
			 (id_inst_csrrwi)?(32'b1 << id_rs1_num):
			 (id_inst_csrrsi)?(32'b1 << id_rs1_num):
			 (id_inst_csrrci)?32'd0:
			 32'd0;
	 ex_csr_wmask <= (id_inst_csrrw)?32'hffff_ffff:
			 (id_inst_csrrs)?id_rs1:
			 (id_inst_csrrc)?id_rs1:
			 (id_inst_csrrwi)?~(32'b1 << id_rs1_num):
			 (id_inst_csrrsi)?~(32'b1 << id_rs1_num):
			 (id_inst_csrrci)?~(32'b1 << id_rs1_num):
			 32'd0;
      end
   end // always @ (posedge CLK)
//   assign CSR_ADDR  = ex_csr_addr;
//   assign CSR_WE    = ex_csr_we;
//   assign CSR_WDATA = ex_csr_wdata;
//   assign CSR_WMASK = ex_csr_wmask;

   reg [31:0] ex_rs2, ex_imm;
   reg [4:0]  ex_rd_num;
   reg        ex_inst_sb, ex_inst_sh, ex_inst_sw;
   reg        ex_inst_lbu, ex_inst_lhu, ex_inst_lb,
	      ex_inst_lh, ex_inst_lw;
   reg        ex_inst_lui, is_ex_load, ex_inst_auipc, ex_inst_jal, ex_inst_jalr;
   reg        is_ex_csr;
   reg        ex_inst_beq, ex_inst_bne, ex_inst_blt,
              ex_inst_bge, ex_inst_bltu, ex_inst_bgeu;
   reg        ex_inst_mret;
   reg 	      ex_inst_ecall, ex_inst_ebreak;
   reg 	      is_ex_mul, is_ex_div;
   reg        is_ex_madd33;
   always @(posedge CLK) begin
      if(!RST_N) begin
         ex_rs2        <= 0;
         ex_imm        <= 0;
         ex_rd_num     <= 0;
         ex_inst_sb    <= 0;
         ex_inst_sh    <= 0;
         ex_inst_sw    <= 0;
         ex_inst_lbu   <= 0;
         ex_inst_lhu   <= 0;
         ex_inst_lb    <= 0;
         ex_inst_lh    <= 0;
         ex_inst_lw    <= 0;
         is_ex_load    <= 0;
         ex_inst_lui   <= 0;
         ex_inst_auipc <= 0;
         ex_inst_jal   <= 0;
         ex_inst_jalr  <= 0;
         is_ex_csr     <= 0;
         ex_inst_beq   <= 0;
         ex_inst_bne   <= 0;
         ex_inst_blt   <= 0;
         ex_inst_bge   <= 0;
         ex_inst_bltu  <= 0;
         ex_inst_bgeu  <= 0;
         ex_inst_mret  <= 0;
	       ex_inst_ecall <= 0;
	       ex_inst_ebreak <= 0;
	       is_ex_mul     <= 0;
	       is_ex_div     <= 0;
         is_ex_madd33 <= 0;
      end else begin
         ex_rs2        <= id_rs2;
         ex_imm        <= id_imm;
         ex_rd_num     <= id_rd_num;
         ex_inst_sb    <= id_inst_sb;
         ex_inst_sh    <= id_inst_sh;
         ex_inst_sw    <= id_inst_sw;
         ex_inst_lbu   <= id_inst_lbu;
         ex_inst_lhu   <= id_inst_lhu;
         ex_inst_lb    <= id_inst_lb;
         ex_inst_lh    <= id_inst_lh;
         ex_inst_lw    <= id_inst_lw;
         is_ex_load    <= id_inst_lb | id_inst_lh | id_inst_lw |
                          id_inst_lbu | id_inst_lhu;
         ex_inst_lui   <= id_inst_lui;
         ex_inst_auipc <= id_inst_auipc;
         ex_inst_jal   <= id_inst_jal;
         ex_inst_jalr  <= id_inst_jalr;
         is_ex_csr     <= id_inst_csrrw | id_inst_csrrs | id_inst_csrrc |
                          id_inst_csrrwi | id_inst_csrrsi | id_inst_csrrci;
         ex_inst_beq   <= id_inst_beq;
         ex_inst_bne   <= id_inst_bne;
         ex_inst_blt   <= id_inst_blt;
         ex_inst_bge   <= id_inst_bge;
         ex_inst_bltu  <= id_inst_bltu;
         ex_inst_bgeu  <= id_inst_bgeu;
         ex_inst_mret  <= id_inst_mret;
	       ex_inst_ecall <= id_inst_ecall;
	       ex_inst_ebreak <= id_inst_ebreak;
	       is_ex_mul     <= id_inst_mul | id_inst_mulh |
			   id_inst_mulhsu | id_inst_mulhu;
	       is_ex_div     <= id_inst_div | id_inst_divu |
			   id_inst_rem | id_inst_remu;
         is_ex_madd33 <= id_inst_madd33;
      end
   end

   /* ------------------------------------------------------------ *
	* Stage.4(MA:Memory Access)                                    *
	* ------------------------------------------------------------ */
   assign D_MEM_ADDR  = ex_alu_rslt;
   // for Store instruction
   assign D_MEM_WDATA = (ex_inst_sb)?{4{ex_rs2[7:0]}}:
		       (ex_inst_sh)?{2{ex_rs2[15:0]}}:
		       (ex_inst_sw)?{ex_rs2}:
		       32'd0;
   wire [3:0] w_dmem_wstb;

   assign w_dmem_wstb[0] = (ex_inst_sb & (ex_alu_rslt[1:0] == 2'b00)) |
			   (ex_inst_sh & (ex_alu_rslt[1] == 1'b0)) |
			   (ex_inst_sw);
   assign w_dmem_wstb[1] = (ex_inst_sb & (ex_alu_rslt[1:0] == 2'b01)) |
			   (ex_inst_sh & (ex_alu_rslt[1] == 1'b0)) |
			   (ex_inst_sw);
   assign w_dmem_wstb[2] = (ex_inst_sb & (ex_alu_rslt[1:0] == 2'b10)) |
			   (ex_inst_sh & (ex_alu_rslt[1] == 1'b1)) |
			   (ex_inst_sw);
   assign w_dmem_wstb[3] = (ex_inst_sb & (ex_alu_rslt[1:0] == 2'b11)) |
			   (ex_inst_sh & (ex_alu_rslt[1] == 1'b1)) |
			   (ex_inst_sw);
   assign D_MEM_WSTB = (cpu_state == S_MEMORY)?w_dmem_wstb:4'd0;
   assign D_MEM_ENA = (cpu_state == S_MEMORY) &
                     (ex_inst_sb | ex_inst_sh | ex_inst_sw |
                      ex_inst_lbu | ex_inst_lb |
                      ex_inst_lb | ex_inst_lh | ex_inst_lhu | ex_inst_lw);

   // Delay Buffer
   reg [4:0] ma_rd_num;
   reg [31:0] ma_alu_rslt, ma_imm;
   reg        ma_inst_lbu, ma_inst_lhu, ma_inst_lb, ma_inst_lh, ma_inst_lw;
   reg        ma_inst_lui, is_ma_load, ma_inst_auipc;
   reg        ma_inst_jal, ma_inst_jalr;
   reg        is_ma_csr, is_ma_alu_rslt;
   reg [31:0] ma_pc_add_imm, ma_pc_add_4;
   always @(posedge CLK) begin
      if(!RST_N) begin
         ma_rd_num      <= 0;
         is_ma_alu_rslt <= 0;
         ma_alu_rslt    <= 0;
         ma_imm         <= 0;
         ma_inst_lbu    <= 0;
         ma_inst_lhu    <= 0;
         ma_inst_lb     <= 0;
         ma_inst_lh     <= 0;
         ma_inst_lw     <= 0;
         is_ma_load     <= 0;
         ma_inst_lui    <= 0;
         ma_inst_auipc  <= 0;
         ma_inst_jal    <= 0;
         ma_inst_jalr   <= 0;
         is_ma_csr      <= 0;
         ma_pc_add_imm  <= 0;
         ma_pc_add_4    <= 0;
      end else begin
         ma_rd_num      <= ex_rd_num;
         is_ma_alu_rslt <= is_ex_alu_rslt | is_ex_mul | is_ex_div | is_ex_madd33;
         ma_alu_rslt    <= (is_ex_alu_rslt)?ex_alu_rslt:
                           (is_ex_mul)?ex_mul_rd:
                           (is_ex_div)?ex_div_rd:
                           (is_ex_madd33)?ex_madd33_rd:
                           32'd0;
         ma_imm         <= ex_imm;
         ma_inst_lbu    <= ex_inst_lbu;
         ma_inst_lhu    <= ex_inst_lhu;
         ma_inst_lb     <= ex_inst_lb;
         ma_inst_lh     <= ex_inst_lh;
         ma_inst_lw     <= ex_inst_lw;
         is_ma_load     <= is_ex_load;
         ma_inst_lui    <= ex_inst_lui;
         ma_inst_auipc  <= ex_inst_auipc;
         ma_inst_jal    <= ex_inst_jal;
         ma_inst_jalr   <= ex_inst_jalr;
         is_ma_csr      <= is_ex_csr;
         ma_pc_add_imm  <= ex_pc_add_imm;
         ma_pc_add_4    <= ex_pc_add_4;
      end
   end

   reg [11:0] ma_csr_addr;
   reg        ma_csr_we;
   reg [31:0] ma_csr_wdata;
   reg [31:0] ma_csr_wmask;
   always @(posedge CLK) begin
      if(!RST_N) begin
         ma_csr_addr  <= 0;
         ma_csr_we    <= 0;
         ma_csr_wdata <= 0;
         ma_csr_wmask <= 0;
      end else begin
         ma_csr_addr  <= ex_csr_addr;
         ma_csr_we    <= ex_csr_we;
         ma_csr_wdata <= ex_csr_wdata;
	 ma_csr_wmask <= ex_csr_wmask;
      end
   end

   /* ------------------------------------------------------------ *
	* Stage.5(WB:Write Back)                                       *
	* ------------------------------------------------------------ */
   // for Load instruction
   wire [31:0] ma_load;
   assign ma_load[7:0] = ((ma_inst_lb | ma_inst_lbu) & (ma_alu_rslt[1:0] == 2'b00))?D_MEM_RDATA[7:0]:
			 ((ma_inst_lb | ma_inst_lbu) & (ma_alu_rslt[1:0] == 2'b01))?D_MEM_RDATA[15:8]:
			 ((ma_inst_lb | ma_inst_lbu) & (ma_alu_rslt[1:0] == 2'b10))?D_MEM_RDATA[23:16]:
			 ((ma_inst_lb | ma_inst_lbu) & (ma_alu_rslt[1:0] == 2'b11))?D_MEM_RDATA[31:24]:
			 ((ma_inst_lh | ma_inst_lhu) & (ma_alu_rslt[1] == 1'b0))?D_MEM_RDATA[7:0]:
			 ((ma_inst_lh | ma_inst_lhu) & (ma_alu_rslt[1] == 1'b1))?D_MEM_RDATA[23:16]:
			 (ma_inst_lw)?D_MEM_RDATA[7:0]:
			 8'd0;
   assign ma_load[15:8] = (ma_inst_lb & (ma_alu_rslt[1:0] == 2'b00))?{8{D_MEM_RDATA[7]}}:
			  (ma_inst_lb & (ma_alu_rslt[1:0] == 2'b01))?{8{D_MEM_RDATA[15]}}:
			  (ma_inst_lb & (ma_alu_rslt[1:0] == 2'b10))?{8{D_MEM_RDATA[23]}}:
			  (ma_inst_lb & (ma_alu_rslt[1:0] == 2'b11))?{8{D_MEM_RDATA[31]}}:
			  ((ma_inst_lh | ma_inst_lhu) & (ma_alu_rslt[1] == 1'b0))?D_MEM_RDATA[15:8]:
			  ((ma_inst_lh | ma_inst_lhu) & (ma_alu_rslt[1] == 1'b1))?D_MEM_RDATA[31:24]:
			  (ma_inst_lw)?D_MEM_RDATA[15:8]:
			  8'd0;
   assign ma_load[31:16] = (ma_inst_lb & (ma_alu_rslt[1:0] == 2'b00))?{16{D_MEM_RDATA[7]}}:
			   (ma_inst_lb & (ma_alu_rslt[1:0] == 2'b01))?{16{D_MEM_RDATA[15]}}:
			   (ma_inst_lb & (ma_alu_rslt[1:0] == 2'b10))?{16{D_MEM_RDATA[23]}}:
			   (ma_inst_lb & (ma_alu_rslt[1:0] == 2'b11))?{16{D_MEM_RDATA[31]}}:
			   (ma_inst_lh & (ma_alu_rslt[1] == 1'b0))?{16{D_MEM_RDATA[15]}}:
			   (ma_inst_lh & (ma_alu_rslt[1] == 1'b1))?{16{D_MEM_RDATA[31]}}:
			   (ma_inst_lw)?D_MEM_RDATA[31:16]:
			   16'd0;

   wire [4:0]  wb_rd_num;
   wire        wb_we;
   wire [31:0] wb_rd;
   wire [31:0] ma_csr_rdata;

   assign wb_rd_num = ma_rd_num;
   assign wb_we = (cpu_state == S_WRITEBACK) & ~cpu_state_wait;
   assign wb_rd = (is_ma_load)?ma_load:
		  (is_ma_alu_rslt)?ma_alu_rslt:
		  (ma_inst_lui)?ma_imm:
		  (ma_inst_auipc)?ma_pc_add_imm:
		  (ma_inst_jal | ma_inst_jalr)?ma_pc_add_4:
		  (is_ma_csr)?ma_csr_rdata:
		  32'd0;

   // PCのWrite BackはInstruction Memoryのタイミング調整のため
   // Executeの結果でMemory Accessで書き込みを実施する
   wire        wb_pc_we;
   wire [31:0] wb_pc;
   wire        interrupt;
   wire [31:0] epc;
   wire [31:0] handler_pc;
   wire        exception;
   wire [11:0] exception_code;
   wire [31:0] exception_addr;
   wire [31:0] exception_pc;
   wire        sw_interrupt;
   wire [31:0] sw_interrupt_pc;

//   assign exception_break = id_inst_ecall | id_inst_ebreak;
   assign exception_break = (cpu_state == S_MEMORY) & ex_inst_ebreak;
   assign exception       = (cpu_state == S_MEMORY) & (
                             I_MEM_BADMEM_EXCPT | D_MEM_BADMEM_EXCPT |
                             (id_ill_inst & ~I_MEM_WAIT) | exception_break);
   assign exception_code  = {7'd0, D_MEM_BADMEM_EXCPT,
                             exception_break, id_ill_inst, 1'b0, I_MEM_BADMEM_EXCPT};
   assign exception_addr  = I_MEM_ADDR;
   assign exception_pc    = pc;
   assign sw_interrupt    = (cpu_state == S_MEMORY) & ex_inst_ecall;
   assign sw_interrupt_pc = pc;
/*
   assign wb_pc_we = ((cpu_state == S_MEMORY) & (!D_MEM_WAIT)) &
                     (((ex_inst_beq | ex_inst_bne | ex_inst_blt |
					    ex_inst_bge | ex_inst_bltu | ex_inst_bgeu) &
					   (ex_alu_rslt == 32'd1)) |
					  ex_inst_jal |
                      ex_inst_jalr |
                      ex_inst_mret |
                      exception | interrupt
                      );
*/
   assign wb_pc_we = ((cpu_state == S_MEMORY) &
		                  (
		                    !D_MEM_WAIT |
                        exception |
		                    interrupt |
                        sw_interrupt
                      ));

   assign wb_pc = (((ex_inst_beq | ex_inst_bne | ex_inst_blt |
        	           ex_inst_bge | ex_inst_bltu | ex_inst_bgeu) &
                    (ex_alu_rslt == 32'd1)) |
                    ex_inst_jal
                   )?ex_pc_add_imm:
                   (ex_inst_jalr)?ex_pc_jalr:
                  (ex_inst_mret)?epc:
                  (exception | interrupt | sw_interrupt)?handler_pc:
//                  (exception | interrupt)?handler_pc:
                  ex_pc_add_4;

   /* ------------------------------------------------------------ *
	* Register                                                     *
	* ------------------------------------------------------------ */
   fmrv32im_reg u_fmrv32im_reg
	 (
      .RST_N    ( RST_N      ),
      .CLK      ( CLK        ),

      .WADDR    ( wb_rd_num  ),
      .WE       ( wb_we      ),
      .WDATA    ( wb_rd      ),

      .RS1ADDR  ( id_rs1_num ),
      .RS1      ( id_rs1     ),
      .RS2ADDR  ( id_rs2_num ),
      .RS2      ( id_rs2     ),

      .x10      ( id_x10     ),
      .x11      ( id_x11     ),
      .x12      ( id_x12     ),
      .x13      ( id_x13     ),
      .x14      ( id_x14     ),
      .x15      ( id_x15     ),

      .PC_WE    ( wb_pc_we   ),
      .PC_WDATA ( wb_pc      ),
	  .PC       ( pc         )
   );

   /* ------------------------------------------------------------ *
	* CSR                                                          *
	* ------------------------------------------------------------ */
   fmrv32im_csr u_fmrv32im_csr
     (
      .RST_N             ( RST_N),
      .CLK               ( CLK),

      .CSR_ADDR          ( ma_csr_addr ),
      .CSR_WE            ( ma_csr_we & (cpu_state == S_WRITEBACK)),
      .CSR_WDATA         ( ma_csr_wdata ),
      .CSR_WMASK         ( ma_csr_wmask ),
      .CSR_RDATA         ( ma_csr_rdata),

      .EXT_INTERRUPT     ( EXT_INTERRUPT   ),
      .SW_INTERRUPT      ( sw_interrupt    ),
      .SW_INTERRUPT_PC   ( sw_interrupt_pc ),
      .EXCEPTION         ( exception       ),
      .EXCEPTION_CODE    ( exception_code  ),
      .EXCEPTION_ADDR    ( exception_addr  ),
      .EXCEPTION_PC      ( exception_pc    ),
      .TIMER_EXPIRED     ( TIMER_EXPIRED   ),
      .RETIRE            ( retire          ),

      .HANDLER_PC        ( handler_pc      ),
      .EPC               ( epc             ),
      .INTERRUPT_PENDING (),
      .INTERRUPT         ( interrupt ),

      .ILLEGAL_ACCESS    ()
   );

   /* ------------------------------------------------------------ *
	* Register                                                     *
	* ------------------------------------------------------------ */

endmodule // fmrv32im_pipeline
