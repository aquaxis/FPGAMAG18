module fmrv32im_cache
  #(
    parameter INTEL = 0,
    parameter OSRAM = 0,
    parameter MEM_FILE = ""
  )
  (
   input             RST_N,
   input             CLK,

   // Instruction Memory
   output            I_MEM_WAIT,
   input             I_MEM_ENA,
   input [31:0]      I_MEM_ADDR,
   output [31:0]     I_MEM_RDATA,
   output            I_MEM_BADMEM_EXCPT,

   // Data Memory
   output            D_MEM_WAIT,
   input             D_MEM_ENA,
   input [3:0]       D_MEM_WSTB,
   input [31:0]      D_MEM_ADDR,
   input [31:0]      D_MEM_WDATA,
   output [31:0]     D_MEM_RDATA,
   output            D_MEM_BADMEM_EXCPT,

   // Local Control for AXI4 Master
   output            WR_REQ_START,
   output [31:0]     WR_REQ_ADDR,
   output [15:0]     WR_REQ_LEN,
   input             WR_REQ_READY,
   input [9:0]       WR_REQ_MEM_ADDR,
   output [31:0]     WR_REQ_MEM_WDATA,

   output            RD_REQ_START,
   output [31:0]     RD_REQ_ADDR,
   output [15:0]     RD_REQ_LEN,
   input             RD_REQ_READY,
   input             RD_REQ_MEM_WE,
   input [9:0]       RD_REQ_MEM_ADDR,
   input [31:0]      RD_REQ_MEM_RDATA

   );

   // メモリマップ判定
   wire              isel_ram, isel_illegal;
   assign isel_ram     = (I_MEM_ENA & (I_MEM_ADDR[31:30] == 2'b00));
   assign isel_illegal = (I_MEM_ENA & (I_MEM_ADDR[31:30] != 2'b00));

   wire              dsel_ram, dsel_illegal;
   assign dsel_ram     = (D_MEM_ENA & (D_MEM_ADDR[31:30] == 2'b00));
   assign dsel_illegal = (D_MEM_ENA & (D_MEM_ADDR[31:30] != 2'b00));

   // I-Cache, D-Cache
   reg [31:0]    imem [0:1023];
   reg [31:0]    dmem [0:1023];

   reg [31:0]    i_base, d_base;

   // キャッシュ判定
   wire          I_MEM_miss, D_MEM_miss;
   reg           i_valid, d_valid;
generate 
if( OSRAM == 0 ) begin
   assign I_MEM_miss = I_MEM_ENA & isel_ram &
                      ~(|(I_MEM_ADDR[29:12] == i_base[29:12]));
   assign D_MEM_miss = D_MEM_ENA & dsel_ram &
                      ~(|(D_MEM_ADDR[29:12] == d_base[29:12]));
end else begin
   assign I_MEM_miss = I_MEM_ENA & isel_ram &
                      ~(|(I_MEM_ADDR[29:12] == i_base[29:12])) | ~i_valid;
   assign D_MEM_miss = D_MEM_ENA & dsel_ram &
                      ~(|(D_MEM_ADDR[29:12] == d_base[29:12])) | ~d_valid;
end
endgenerate

   assign I_MEM_WAIT = I_MEM_miss;
   assign D_MEM_WAIT = D_MEM_miss;
   assign I_MEM_BADMEM_EXCPT = isel_illegal & ~I_MEM_miss;
   assign D_MEM_BADMEM_EXCPT = dsel_illegal & ~D_MEM_miss;

   localparam S_IDLE = 4'd0;
   localparam S_W_REQ = 4'd1;
   localparam S_W_WAIT = 4'd2;
   localparam S_R_REQ = 4'd3;
   localparam S_R_WAIT = 4'd4;

   reg [3:0]     state;
   reg [15:0]    leng;
   reg           channel;
   reg [31:0]    req_base;

   // 簡易キャッシュ管理
   always @(posedge CLK) begin
      if(!RST_N) begin
         state    <= S_IDLE;
         channel  <= 0;
         leng     <= 0;
         req_base <= 0;
         i_base   <= 0;
         d_base   <= 0;
         i_valid  <= 0;
         d_valid  <= 0;
      end else begin
         case(state)
           S_IDLE:
             begin
                if(I_MEM_miss) begin
                   if(RD_REQ_READY) begin
                      state    <= S_R_REQ;
                      channel  <= 1'b0;
                      leng     <= 16'd4096;
                      req_base <= {I_MEM_ADDR[31:12], 12'd0};
                   end
                end else if(D_MEM_miss) begin
                   if(WR_REQ_READY & d_valid) begin
                      state    <= S_W_REQ;
                      channel  <= 1'b1;
                      leng     <= 16'd4096;
                      req_base <= {d_base[31:12], 12'd0};
                   end else if(RD_REQ_READY & ~d_valid) begin
                      state    <= S_R_REQ;
                      channel  <= 1'b1;
                      leng     <= 16'd4096;
                      req_base <= {D_MEM_ADDR[31:12], 12'd0};
                   end
                end
             end
           S_W_REQ:
             begin
                state <= S_W_WAIT;
             end
           S_W_WAIT:
             begin
                if(WR_REQ_READY) begin
                      state    <= S_R_REQ;
                      channel  <= 1'b1;
                      leng     <= 16'd4096;
                      req_base <= {D_MEM_ADDR[31:12], 12'd0};
                end
             end
           S_R_REQ:
             begin
                state <= S_R_WAIT;
             end
           S_R_WAIT:
             begin
                if(RD_REQ_READY) begin
                   state <= S_IDLE;
                   if(channel) begin
                      d_base <= req_base;
                      d_valid <= 1;
                   end else begin
                      i_base <= req_base;
                      i_valid <= 1;
                   end
                end
             end
         endcase
      end
   end

   assign WR_REQ_START = (state == S_W_REQ);
   assign WR_REQ_ADDR  = req_base;
   assign WR_REQ_LEN   = leng;
   assign RD_REQ_START = (state == S_R_REQ);
   assign RD_REQ_ADDR  = req_base;
   assign RD_REQ_LEN   = leng;

   wire [9:0] mem_addr;
   assign mem_addr = WR_REQ_MEM_ADDR | RD_REQ_MEM_ADDR;
generate
if( INTEL == 0 ) begin
  // for non Verndor Lock
   // I-Cache Memory
	reg [31:0] I_MEM_rdata_out;
   always @(posedge CLK) begin
      if(!channel & RD_REQ_MEM_WE) imem[mem_addr] <= RD_REQ_MEM_RDATA;
   end
   always @(posedge CLK) begin
      I_MEM_rdata_out <= imem[I_MEM_ADDR[11:2]];
   end
	assign I_MEM_RDATA = I_MEM_rdata_out;

   // D-Cache Memory
	reg [31:0] WR_REQ_MEM_WDATA_out, D_MEM_rdata_out;
   always @(posedge CLK) begin
      if(channel & RD_REQ_MEM_WE) dmem[mem_addr] <= RD_REQ_MEM_RDATA;
      WR_REQ_MEM_WDATA_out <= dmem[mem_addr];
   end
	assign WR_REQ_MEM_WDATA = WR_REQ_MEM_WDATA_out;
   always @(posedge CLK) begin
      if(~D_MEM_miss & D_MEM_WSTB[0]) dmem[D_MEM_ADDR[11:2]][7:0]   <= D_MEM_WDATA[7:0];
      if(~D_MEM_miss & D_MEM_WSTB[1]) dmem[D_MEM_ADDR[11:2]][15:8]  <= D_MEM_WDATA[15:8];
      if(~D_MEM_miss & D_MEM_WSTB[2]) dmem[D_MEM_ADDR[11:2]][23:16] <= D_MEM_WDATA[23:16];
      if(~D_MEM_miss & D_MEM_WSTB[3]) dmem[D_MEM_ADDR[11:2]][31:24] <= D_MEM_WDATA[31:24];
      D_MEM_rdata_out <= dmem[D_MEM_ADDR[11:2]];
   end
	assign D_MEM_RDATA = D_MEM_rdata_out;

   initial $readmemh(MEM_FILE, imem, 0, 1023);
   initial $readmemh(MEM_FILE, dmem, 0, 1023);
end else begin
  // for Intel FPGA
	fmrv32im_intel_cram
	#(
	   .MEM_FILE( MEM_FILE )
	)
	u_icache_cram
	  (
		.clock_a   ( CLK ),
		.address_a ( mem_addr ),
		.wren_a    ( !channel & RD_REQ_MEM_WE ),
		.data_a    ( RD_REQ_MEM_RDATA ),
		.q_a       (  ),
		.clock_b   ( CLK ),
		.address_b ( I_MEM_ADDR[11:2] ),
		.byteena_b ( 4'd0 ),
		.data_b    ( 32'd0 ),
		.wren_b    ( 1'b0 ),
		.q_b       ( I_MEM_RDATA )
	);
	fmrv32im_intel_cram
	#(
	   .MEM_FILE( MEM_FILE )
	)
	u_dcache_cram
	  (
		.clock_a   ( CLK ),
		.address_a ( mem_addr ),
		.wren_a    ( channel & RD_REQ_MEM_WE ),
		.data_a    ( RD_REQ_MEM_RDATA ),
		.q_a       ( WR_REQ_MEM_WDATA ),
		.clock_b   ( CLK ),
		.address_b ( D_MEM_ADDR[11:2] ),
		.byteena_b ( D_MEM_WSTB ),
		.data_b    ( D_MEM_WDATA ),
		.wren_b    ( D_MEM_WSTB[3] | D_MEM_WSTB[2] | D_MEM_WSTB[1] | D_MEM_WSTB[0] ),
		.q_b       ( D_MEM_RDATA )
	);
end
endgenerate

endmodule
