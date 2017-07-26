module fmrv32im_plic
  (
   input             RST_N,
   input             CLK,

   input             BUS_WE,
   input [3:0]       BUS_ADDR,
   input [31:0]      BUS_WDATA,
   output reg [31:0] BUS_RDATA,

   input [31:0]      INT_IN,
   output wire       INT_OUT
   );

   // Interrupt Mask
   reg [31:0]         int_reg, int_mask;
   always @(posedge CLK) begin
      if(!RST_N) begin
         int_mask <= 0;
      end else begin
         if(BUS_WE & (BUS_ADDR == 4'h1)) begin
            int_mask <= BUS_WDATA;
         end
      end
   end

   wire BUS_WE_reg;
   assign BUS_WE_reg = BUS_WE & (BUS_ADDR == 4'h0);
   // Interrupt Register
   always @(posedge CLK) begin
      if(!RST_N) begin
         int_reg <= 0;
      end else begin
         int_reg[00] <= INT_IN[00] | (BUS_WE_reg & BUS_WDATA[00])?1'b0:int_reg[00];
         int_reg[01] <= INT_IN[01] | (BUS_WE_reg & BUS_WDATA[01])?1'b0:int_reg[01];
         int_reg[02] <= INT_IN[02] | (BUS_WE_reg & BUS_WDATA[02])?1'b0:int_reg[02];
         int_reg[03] <= INT_IN[03] | (BUS_WE_reg & BUS_WDATA[03])?1'b0:int_reg[03];
         int_reg[04] <= INT_IN[04] | (BUS_WE_reg & BUS_WDATA[04])?1'b0:int_reg[04];
         int_reg[05] <= INT_IN[05] | (BUS_WE_reg & BUS_WDATA[05])?1'b0:int_reg[05];
         int_reg[06] <= INT_IN[06] | (BUS_WE_reg & BUS_WDATA[06])?1'b0:int_reg[06];
         int_reg[07] <= INT_IN[07] | (BUS_WE_reg & BUS_WDATA[07])?1'b0:int_reg[07];
         int_reg[08] <= INT_IN[08] | (BUS_WE_reg & BUS_WDATA[08])?1'b0:int_reg[08];
         int_reg[09] <= INT_IN[09] | (BUS_WE_reg & BUS_WDATA[09])?1'b0:int_reg[09];
         int_reg[10] <= INT_IN[10] | (BUS_WE_reg & BUS_WDATA[10])?1'b0:int_reg[10];
         int_reg[11] <= INT_IN[11] | (BUS_WE_reg & BUS_WDATA[11])?1'b0:int_reg[11];
         int_reg[12] <= INT_IN[12] | (BUS_WE_reg & BUS_WDATA[12])?1'b0:int_reg[12];
         int_reg[13] <= INT_IN[13] | (BUS_WE_reg & BUS_WDATA[13])?1'b0:int_reg[13];
         int_reg[14] <= INT_IN[14] | (BUS_WE_reg & BUS_WDATA[14])?1'b0:int_reg[14];
         int_reg[15] <= INT_IN[15] | (BUS_WE_reg & BUS_WDATA[15])?1'b0:int_reg[15];
         int_reg[16] <= INT_IN[16] | (BUS_WE_reg & BUS_WDATA[16])?1'b0:int_reg[16];
         int_reg[17] <= INT_IN[17] | (BUS_WE_reg & BUS_WDATA[17])?1'b0:int_reg[17];
         int_reg[18] <= INT_IN[18] | (BUS_WE_reg & BUS_WDATA[18])?1'b0:int_reg[18];
         int_reg[19] <= INT_IN[19] | (BUS_WE_reg & BUS_WDATA[19])?1'b0:int_reg[19];
         int_reg[20] <= INT_IN[20] | (BUS_WE_reg & BUS_WDATA[20])?1'b0:int_reg[20];
         int_reg[21] <= INT_IN[21] | (BUS_WE_reg & BUS_WDATA[21])?1'b0:int_reg[21];
         int_reg[22] <= INT_IN[22] | (BUS_WE_reg & BUS_WDATA[22])?1'b0:int_reg[22];
         int_reg[23] <= INT_IN[23] | (BUS_WE_reg & BUS_WDATA[23])?1'b0:int_reg[23];
         int_reg[24] <= INT_IN[24] | (BUS_WE_reg & BUS_WDATA[24])?1'b0:int_reg[24];
         int_reg[25] <= INT_IN[25] | (BUS_WE_reg & BUS_WDATA[25])?1'b0:int_reg[25];
         int_reg[26] <= INT_IN[26] | (BUS_WE_reg & BUS_WDATA[26])?1'b0:int_reg[26];
         int_reg[27] <= INT_IN[27] | (BUS_WE_reg & BUS_WDATA[27])?1'b0:int_reg[27];
         int_reg[28] <= INT_IN[28] | (BUS_WE_reg & BUS_WDATA[28])?1'b0:int_reg[28];
         int_reg[29] <= INT_IN[29] | (BUS_WE_reg & BUS_WDATA[29])?1'b0:int_reg[29];
         int_reg[30] <= INT_IN[30] | (BUS_WE_reg & BUS_WDATA[30])?1'b0:int_reg[30];
         int_reg[31] <= INT_IN[31] | (BUS_WE_reg & BUS_WDATA[31])?1'b0:int_reg[31];
      end // else: !if(!RST_N)
   end

   assign INT_OUT = |(int_reg  & (~(int_mask)));

   always @(*) begin
      case(BUS_ADDR)
        4'h0:
          begin
             BUS_RDATA <= int_reg;
          end
        4'h1:
          begin
             BUS_RDATA <= int_mask;
          end
        default:
          begin
             BUS_RDATA <= 32'd0;
          end
      endcase
   end

endmodule // fmrv32im_plic
