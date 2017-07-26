module fmrv32im_axim
  (
   // Reset, Clock
   input         RST_N,
   input         CLK,

   // Master Write Address
   output [0:0]  M_AXI_AWID,
   output [31:0] M_AXI_AWADDR,
   output [7:0]  M_AXI_AWLEN,
   output [2:0]  M_AXI_AWSIZE,
   output [1:0]  M_AXI_AWBURST,
   output        M_AXI_AWLOCK,
   output [3:0]  M_AXI_AWCACHE,
   output [2:0]  M_AXI_AWPROT,
   output [3:0]  M_AXI_AWQOS,
   output [0:0]  M_AXI_AWUSER,
   output        M_AXI_AWVALID,
   input         M_AXI_AWREADY,

   // Master Write Data
   output [31:0] M_AXI_WDATA,
   output [3:0]  M_AXI_WSTRB,
   output        M_AXI_WLAST,
   output [0:0]  M_AXI_WUSER,
   output        M_AXI_WVALID,
   input         M_AXI_WREADY,

   // Master Write Response
   input [0:0]   M_AXI_BID,
   input [1:0]   M_AXI_BRESP,
   input [0:0]   M_AXI_BUSER,
   input         M_AXI_BVALID,
   output        M_AXI_BREADY,

   // Master Read Address
   output [0:0]  M_AXI_ARID,
   output [31:0] M_AXI_ARADDR,
   output [7:0]  M_AXI_ARLEN,
   output [2:0]  M_AXI_ARSIZE,
   output [1:0]  M_AXI_ARBURST,
   output [1:0]  M_AXI_ARLOCK,
   output [3:0]  M_AXI_ARCACHE,
   output [2:0]  M_AXI_ARPROT,
   output [3:0]  M_AXI_ARQOS,
   output [0:0]  M_AXI_ARUSER,
   output        M_AXI_ARVALID,
   input         M_AXI_ARREADY,

   // Master Read Data
   input [0:0]   M_AXI_RID,
   input [31:0]  M_AXI_RDATA,
   input [1:0]   M_AXI_RRESP,
   input         M_AXI_RLAST,
   input [0:0]   M_AXI_RUSER,
   input         M_AXI_RVALID,
   output        M_AXI_RREADY,

   // Local Control
   input         WR_REQ_START,
   input [31:0]  WR_REQ_ADDR,
   input [15:0]  WR_REQ_LEN,
   output        WR_REQ_READY,
   output [9:0]  WR_REQ_MEM_ADDR,
   input [31:0]  WR_REQ_MEM_WDATA,

   input         RD_REQ_START,
   input [31:0]  RD_REQ_ADDR,
   input [15:0]  RD_REQ_LEN,
   output        RD_REQ_READY,
   output        RD_REQ_MEM_WE,
   output [9:0]  RD_REQ_MEM_ADDR,
   output [31:0] RD_REQ_MEM_RDATA
   );

   localparam S_WR_REQ_IDLE  = 3'd0;
   localparam S_WA_WAIT  = 3'd1;
   localparam S_WA_START = 3'd2;
   localparam S_WD_WAIT  = 3'd3;
   localparam S_WD_PROC  = 3'd4;
   localparam S_WR_REQ_WAIT  = 3'd5;

   reg [2:0]     WR_REQ_state;
   reg [31:0]    reg_WR_REQ_adrs;
   reg [15:0]    reg_WR_REQ_len;
   reg           reg_awvalid, reg_wvalid, reg_w_last;
   reg [7:0]     reg_w_len;
   reg [3:0]     reg_w_stb;
   reg           reg_w_delay;
   reg [31:0]    reg_w_data;
   reg [13:0]    reg_wmem_addr;

   // Write State
   always @(posedge CLK) begin
      if(!RST_N) begin
         WR_REQ_state            <= S_WR_REQ_IDLE;
         reg_WR_REQ_adrs[31:0]   <= 32'd0;
         reg_WR_REQ_len[15:0]    <= 16'd0;
         reg_awvalid         <= 1'b0;
         reg_wvalid          <= 1'b0;
         reg_w_last          <= 1'b0;
         reg_w_len[7:0]      <= 8'd0;
         reg_w_stb[3:0]      <= 4'd0;
         reg_wmem_addr       <= 13'd0;
		 reg_w_data          <= 1'b0;
		 reg_w_delay         <= 1'b0;
      end else begin
         case(WR_REQ_state)
           S_WR_REQ_IDLE: begin
              if(WR_REQ_START) begin
                 WR_REQ_state          <= S_WA_START;
                 reg_WR_REQ_adrs[31:0] <= WR_REQ_ADDR[31:0];
                 reg_WR_REQ_len[15:0]  <= WR_REQ_LEN[15:0] -16'd1;
              end
              reg_awvalid         <= 1'b0;
              reg_wvalid          <= 1'b0;
              reg_w_last          <= 1'b0;
              reg_w_len[7:0]      <= 8'd0;
              reg_w_stb[3:0]      <= 4'd0;
              reg_wmem_addr <= 13'd0;
           end
           S_WA_START: begin
              WR_REQ_state            <= S_WD_WAIT;
              reg_awvalid         <= 1'b1;
              reg_WR_REQ_len[15:10]    <= reg_WR_REQ_len[15:10] - 6'd1;
              if(reg_WR_REQ_len[15:10] != 6'd0) begin
                 reg_w_len[7:0]  <= 8'hFF;
                 reg_w_last      <= 1'b0;
                 reg_w_stb[3:0]  <= 4'hF;
              end else begin
                 reg_w_len[7:0]  <= reg_WR_REQ_len[9:2];
                 reg_w_last      <= 1'b1;
                 reg_w_stb[3:0]  <= 4'hF;
              end
           end
           S_WD_WAIT: begin
              if(M_AXI_AWREADY) begin
                 WR_REQ_state        <= S_WD_PROC;
                 reg_awvalid     <= 1'b0;
                 reg_wvalid      <= 1'b1;
                 reg_wmem_addr  <= reg_wmem_addr +13'd1;
              end
           end
           S_WD_PROC: begin
              if(M_AXI_WREADY) begin
                 if(reg_w_len[7:0] == 8'd0) begin
                    WR_REQ_state        <= S_WR_REQ_WAIT;
                    reg_wvalid      <= 1'b0;
                    reg_w_stb[3:0]  <= 4'h0;
                 end else begin
                    reg_w_len[7:0]  <= reg_w_len[7:0] -8'd1;
                    reg_wmem_addr  <= reg_wmem_addr +13'd1;
                 end
              end
           end
           S_WR_REQ_WAIT: begin
              if(M_AXI_BVALID) begin
                 if(reg_w_last) begin
                    WR_REQ_state          <= S_WR_REQ_IDLE;
                 end else begin
                    WR_REQ_state          <= S_WA_START;
                    reg_WR_REQ_adrs[31:0] <= reg_WR_REQ_adrs[31:0] + 32'd1024;
                 end
              end
           end
           default: begin
              WR_REQ_state <= S_WR_REQ_IDLE;
           end
         endcase
      end

      reg_w_delay <= M_AXI_WREADY;
      if((WR_REQ_state == S_WA_START) |
         ((WR_REQ_state == S_WD_PROC) & reg_w_delay)) begin
         reg_w_data <= WR_REQ_MEM_WDATA;
      end
   end

   assign M_AXI_AWID         = 1'b0;
   assign M_AXI_AWADDR[31:0] = reg_WR_REQ_adrs[31:0];
   assign M_AXI_AWLEN[7:0]   = reg_w_len[7:0];
   assign M_AXI_AWSIZE[2:0]  = 2'b010;
   assign M_AXI_AWBURST[1:0] = 2'b01;
   assign M_AXI_AWLOCK       = 1'b0;
   assign M_AXI_AWCACHE[3:0] = 4'b0011;
   assign M_AXI_AWPROT[2:0]  = 3'b000;
   assign M_AXI_AWQOS[3:0]   = 4'b0000;
   assign M_AXI_AWUSER[0]    = 1'b1;
   assign M_AXI_AWVALID      = reg_awvalid;

//   assign M_AXI_WDATA[31:0]  = RX_BUFF_DATA[31:0];
   assign M_AXI_WDATA[31:0]  = (reg_w_delay)?WR_REQ_MEM_WDATA:reg_w_data;
   assign M_AXI_WSTRB[3:0]   = (reg_wvalid)?reg_w_stb:4'h0;
   assign M_AXI_WLAST        = (reg_w_len[7:0] == 8'd0)?1'b1:1'b0;
   assign M_AXI_WUSER        = 1;
   assign M_AXI_WVALID       = reg_wvalid;

   assign M_AXI_BREADY       = (WR_REQ_state == S_WR_REQ_WAIT)?1'b1:1'b0;

   assign WR_REQ_READY           = (WR_REQ_state == S_WR_REQ_IDLE)?1'b1:1'b0;
   assign WR_REQ_MEM_ADDR        = reg_wmem_addr;

   localparam S_RD_REQ_IDLE    = 3'd0;
   localparam S_RS_REQUEST = 3'd1;
   localparam S_RA_WAIT    = 3'd2;
   localparam S_RA_START   = 3'd3;
   localparam S_RD_REQ_WAIT    = 3'd4;
   localparam S_RD_REQ_PROC    = 3'd5;

   reg [2:0]   RD_REQ_state;
   reg [31:0]  reg_RD_REQ_adrs;
   reg [15:0]  reg_RD_REQ_len;
   reg         reg_arvalid, reg_r_last;
   reg [7:0]   reg_r_len;
   reg [13:0]  reg_rmem_addr;

   // Read State
   always @(posedge CLK or negedge RST_N) begin
      if(!RST_N) begin
         RD_REQ_state          <= S_RD_REQ_IDLE;
         reg_RD_REQ_adrs[31:0] <= 32'd0;
         reg_RD_REQ_len[15:0]  <= 16'd0;
         reg_arvalid       <= 1'b0;
         reg_r_len[7:0]    <= 8'd0;
         reg_r_last        <= 1'b0;
         reg_rmem_addr     <= 13'd0;
      end else begin
         case(RD_REQ_state)
           S_RD_REQ_IDLE: begin
              if(RD_REQ_START) begin
                 RD_REQ_state          <= S_RA_START;
                 reg_RD_REQ_adrs[31:0] <= RD_REQ_ADDR[31:0];
                 reg_RD_REQ_len[15:0]  <= RD_REQ_LEN[15:0] -16'd1;
              end
              reg_arvalid     <= 1'b0;
              reg_r_len[7:0]  <= 8'd0;
              reg_rmem_addr   <= 13'd0;
           end
           S_RA_START: begin
              RD_REQ_state          <= S_RD_REQ_WAIT;
              reg_arvalid       <= 1'b1;
              reg_RD_REQ_len[15:10] <= reg_RD_REQ_len[15:10] -6'd1;
              if(reg_RD_REQ_len[15:10] != 16'd0) begin
                 reg_r_last      <= 1'b0;
                 reg_r_len[7:0]  <= 8'd255;
              end else begin
                 reg_r_last      <= 1'b1;
                 reg_r_len[7:0]  <= reg_RD_REQ_len[9:2];
              end
           end
           S_RD_REQ_WAIT: begin
              if(M_AXI_ARREADY) begin
                 RD_REQ_state        <= S_RD_REQ_PROC;
                 reg_arvalid     <= 1'b0;
              end
           end
           S_RD_REQ_PROC: begin
              if(M_AXI_RVALID) begin
                 reg_rmem_addr <= reg_rmem_addr +1;
                 if(M_AXI_RLAST) begin
                    if(reg_r_last) begin
                       RD_REQ_state          <= S_RD_REQ_IDLE;
                    end else begin
                       RD_REQ_state          <= S_RA_START;
                       reg_RD_REQ_adrs[31:0] <= reg_RD_REQ_adrs[31:0] + 32'd1024;
                    end
                 end else begin
                    reg_r_len[7:0] <= reg_r_len[7:0] -8'd1;
                 end
              end
           end
         endcase
      end
   end

   // Master Read Address
   assign M_AXI_ARID         = 1'b0;
   assign M_AXI_ARADDR[31:0] = reg_RD_REQ_adrs[31:0];
   assign M_AXI_ARLEN[7:0]   = reg_r_len[7:0];
   assign M_AXI_ARSIZE[2:0]  = 3'b010;
   assign M_AXI_ARBURST[1:0] = 2'b01;
   assign M_AXI_ARLOCK       = 1'b0;
   assign M_AXI_ARCACHE[3:0] = 4'b0011;
   assign M_AXI_ARPROT[2:0]  = 3'b000;
   assign M_AXI_ARQOS[3:0]   = 4'b0000;
   assign M_AXI_ARUSER[0]    = 1'b1;
   assign M_AXI_ARVALID      = reg_arvalid;

   assign M_AXI_RREADY       = 1'b1;

   assign RD_REQ_READY           = (RD_REQ_state == S_RD_REQ_IDLE)?1'b1:1'b0;
   assign RD_REQ_MEM_WE          = M_AXI_RVALID;
   assign RD_REQ_MEM_ADDR        = reg_rmem_addr;
   assign RD_REQ_MEM_RDATA        = M_AXI_RDATA[31:0];

endmodule
