module fmrv32im_mul
  (
   input        RST_N,
   input        CLK,

   input        INST_MUL,
   input        INST_MULH,
   input        INST_MULHSU,
   input        INST_MULHU,

   input [31:0] RS1,
   input [31:0] RS2,

   output       WAIT,
   output       READY,
   output [31:0] RD
   );

   wire         inst_mul, inst_mulh;
   wire         inst_rs1_signed, inst_rs2_signed;

   reg [32:0]  w_rs1, w_rs2;
   reg [63:0]   rslt;
   reg          rslt_high, rslt_active;

   assign inst_mul        = INST_MUL | INST_MULH | INST_MULHSU | INST_MULHU;
   assign inst_mulh       = INST_MULH | INST_MULHSU | INST_MULHU;
   assign inst_rs1_signed = INST_MULH | INST_MULHSU;
   assign inst_rs2_signed = INST_MULH;

   always @(*) begin
      if(inst_rs1_signed) begin
         w_rs1 <= $signed(RS1);
      end else begin
         w_rs1 <= $unsigned(RS1);
      end
      if(inst_rs2_signed) begin
         w_rs2 <= $signed(RS2);
      end else begin
         w_rs2 <= $unsigned(RS2);
      end
   end

   always @(posedge CLK) begin
      if(!RST_N) begin
         rslt_high   <= 0;
         rslt_active <= 0;
      end else begin
         rslt_high   <= inst_mulh;
         rslt_active <= inst_mul;
      end
   end

   always @(posedge CLK) begin
      if(!RST_N) begin
         rslt <= 0;
      end else begin
         rslt <= $signed(w_rs1) * $signed(w_rs2);
      end
   end

   assign RD    = (rslt_high)?rslt[63:32]:rslt[31:0];
   assign READY = rslt_active;
   assign WAIT  = 0;

endmodule // fmrv32im_mul
