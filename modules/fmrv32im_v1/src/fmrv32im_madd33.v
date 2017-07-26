module fmrv32im_madd33
  (
   input        RST_N,
   input        CLK,

   input        INST_MADD33,

   input [31:0] RS1,
   input [31:0] RS2,
   input [31:0] RS3,
   input [31:0] RS4,
   input [31:0] RS5,
   input [31:0] RS6,

   output       WAIT,
   output       READY,
   output [31:0] RD
   );

   reg rslt_active;
   reg [31:0] rslt;

    always @(posedge CLK) begin
      if(!RST_N) begin
         rslt_active <= 0;
      end else begin
         rslt_active <= INST_MADD33;
      end
    end

    always @(posedge CLK) begin
      if(!RST_N) begin
         rslt <= 0;
      end else begin
         rslt <= ($signed(RS1) * $signed(RS2)) + 
                 ($signed(RS3) * $signed(RS4)) + 
                 ($signed(RS5) * $signed(RS6));
      end
    end

    assign RD    = (rslt_active)?rslt:32'd0;
    assign READY = rslt_active;
    assign WAIT  = 0;
endmodule
