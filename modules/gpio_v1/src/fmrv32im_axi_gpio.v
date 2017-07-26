module fmrv32im_axi_gpio
(
   // AXI4 Lite Interface
   input         RST_N,
   input         CLK,

    // Write Address Channel
   input [15:0]  S_AXI_AWADDR,
   input [3:0]   S_AXI_AWCACHE,
   input [2:0]   S_AXI_AWPROT,
   input         S_AXI_AWVALID,
   output        S_AXI_AWREADY,

   // Write Data Channel
   input [31:0]  S_AXI_WDATA,
   input [3:0]   S_AXI_WSTRB,
   input         S_AXI_WVALID,
   output        S_AXI_WREADY,

   // Write Response Channel
   output        S_AXI_BVALID,
   input         S_AXI_BREADY,
   output [1:0]  S_AXI_BRESP,

   // Read Address Channel
   input [15:0]  S_AXI_ARADDR,
   input [3:0]   S_AXI_ARCACHE,
   input [2:0]   S_AXI_ARPROT,
   input         S_AXI_ARVALID,
   output        S_AXI_ARREADY,

   // Read Data Channel
   output [31:0] S_AXI_RDATA,
   output [1:0]  S_AXI_RRESP,
   output        S_AXI_RVALID,
   input         S_AXI_RREADY,

   // GPIO
   input [31:0]  GPIO_I,
   output [31:0] GPIO_OT
);

   // Local Interface
   wire        local_cs;
   wire        local_rnw;
   wire        local_ack;
   wire [31:0] local_addr;
   wire [3:0]  local_be;
   wire [31:0] local_wdata;
   wire [31:0] local_rdata;

   fmrv32im_axi_gpio_ls u_fmrv32im_axi_gpio_ls
     (
      // Reset, Clock
      .ARESETN       ( RST_N          ),
      .ACLK          ( CLK            ),

      // Master Write Address
      .S_AXI_AWADDR  ( S_AXI_AWADDR  ),
      .S_AXI_AWCACHE ( S_AXI_AWCACHE ),
      .S_AXI_AWPROT  ( S_AXI_AWPROT  ),
      .S_AXI_AWVALID ( S_AXI_AWVALID ),
      .S_AXI_AWREADY ( S_AXI_AWREADY ),

      // Master Write Data
      .S_AXI_WDATA   ( S_AXI_WDATA   ),
      .S_AXI_WSTRB   ( S_AXI_WSTRB   ),
      .S_AXI_WVALID  ( S_AXI_WVALID  ),
      .S_AXI_WREADY  ( S_AXI_WREADY  ),

      // Master Write Response
      .S_AXI_BRESP   ( S_AXI_BRESP   ),
      .S_AXI_BVALID  ( S_AXI_BVALID  ),
      .S_AXI_BREADY  ( S_AXI_BREADY  ),

      // Master Read Address
      .S_AXI_ARADDR  ( S_AXI_ARADDR  ),
      .S_AXI_ARCACHE ( S_AXI_ARCACHE ),
      .S_AXI_ARPROT  ( S_AXI_ARPROT  ),
      .S_AXI_ARVALID ( S_AXI_ARVALID ),
      .S_AXI_ARREADY ( S_AXI_ARREADY ),

      // Master Read Data
      .S_AXI_RDATA   ( S_AXI_RDATA   ),
      .S_AXI_RRESP   ( S_AXI_RRESP   ),
      .S_AXI_RVALID  ( S_AXI_RVALID  ),
      .S_AXI_RREADY  ( S_AXI_RREADY  ),

     // Local Interface
     .LOCAL_CS    ( local_cs),
     .LOCAL_RNW   ( local_rnw),
     .LOCAL_ACK   ( local_ack),
     .LOCAL_ADDR  ( local_addr),
     .LOCAL_BE    ( local_be),
     .LOCAL_WDATA ( local_wdata),
     .LOCAL_RDATA ( local_rdata)

      );

    fmrv32im_axi_gpio_ctrl u_fmrv32im_axi_gpio_ctrl
      (
        .RST_N       ( RST_N),
        .CLK         ( CLK),

        .LOCAL_CS    ( local_cs),
        .LOCAL_RNW   ( local_rnw),
        .LOCAL_ACK   ( local_ack),
        .LOCAL_ADDR  ( local_addr),
        .LOCAL_BE    ( local_be),
        .LOCAL_WDATA ( local_wdata),
        .LOCAL_RDATA ( local_rdata),

        .GPIO_I      ( GPIO_I),
        .GPIO_OT     ( GPIO_OT)
    );

endmodule

module fmrv32im_axi_gpio_ls
(
   // AXI4 Lite Interface
   input         ARESETN,
   input         ACLK,

    // Write Address Channel
   input [15:0]  S_AXI_AWADDR,
   input [3:0]   S_AXI_AWCACHE,
   input [2:0]   S_AXI_AWPROT,
   input         S_AXI_AWVALID,
   output        S_AXI_AWREADY,

   // Write Data Channel
   input [31:0]  S_AXI_WDATA,
   input [3:0]   S_AXI_WSTRB,
   input         S_AXI_WVALID,
   output        S_AXI_WREADY,

   // Write Response Channel
   output        S_AXI_BVALID,
   input         S_AXI_BREADY,
   output [1:0]  S_AXI_BRESP,

   // Read Address Channel
   input [15:0]  S_AXI_ARADDR,
   input [3:0]   S_AXI_ARCACHE,
   input [2:0]   S_AXI_ARPROT,
   input         S_AXI_ARVALID,
   output        S_AXI_ARREADY,

   // Read Data Channel
   output [31:0] S_AXI_RDATA,
   output [1:0]  S_AXI_RRESP,
   output        S_AXI_RVALID,
   input         S_AXI_RREADY,

   // Local Interface
   output        LOCAL_CS,
   output        LOCAL_RNW,
   input         LOCAL_ACK,
   output [31:0] LOCAL_ADDR,
   output [3:0]  LOCAL_BE,
   output [31:0] LOCAL_WDATA,
   input [31:0]  LOCAL_RDATA
  );


   localparam S_IDLE   = 2'd0;
   localparam S_WRITE  = 2'd1;
   localparam S_WRITE2 = 2'd2;
   localparam S_READ   = 2'd3;

   reg [1:0]     state;
   reg           reg_rnw;
   reg [15:0]    reg_addr;
   reg [31:0]    reg_wdata;
   reg [3:0]     reg_be;

   always @( posedge ACLK or negedge ARESETN ) begin
      if( !ARESETN ) begin
         state     <= S_IDLE;
         reg_rnw   <= 1'b0;
         reg_addr  <= 16'd0;
         reg_wdata <= 32'd0;
         reg_be    <= 4'd0;
      end else begin
         case( state )
           S_IDLE: begin
              if( S_AXI_AWVALID ) begin
                 reg_rnw   <= 1'b0;
                 reg_addr  <= S_AXI_AWADDR;
                 state     <= S_WRITE;
              end else if( S_AXI_ARVALID ) begin
                 reg_rnw   <= 1'b1;
                 reg_addr  <= S_AXI_ARADDR;
                 state     <= S_READ;
              end
           end
           S_WRITE: begin
              if( S_AXI_WVALID ) begin
                 state     <= S_WRITE2;
                 reg_wdata <= S_AXI_WDATA;
                 reg_be    <= S_AXI_WSTRB;
              end
           end
           S_WRITE2: begin
              if( LOCAL_ACK & S_AXI_BREADY ) begin
                 state     <= S_IDLE;
              end
           end
           S_READ: begin
              if( LOCAL_ACK & S_AXI_RREADY ) begin
                 state     <= S_IDLE;
              end
           end
           default: begin
              state        <= S_IDLE;
           end
         endcase
      end
   end

   // Local Interface
   assign LOCAL_CS       = (( state == S_WRITE2 )?1'b1:1'b0) | (( state == S_READ )?1'b1:1'b0) | 1'b0;
   assign LOCAL_RNW      = reg_rnw;
   assign LOCAL_ADDR     = reg_addr;
   assign LOCAL_BE       = reg_be;
   assign LOCAL_WDATA    = reg_wdata;

   // Write Channel
   assign S_AXI_AWREADY  = ( state == S_WRITE || state == S_IDLE )?1'b1:1'b0;
   assign S_AXI_WREADY   = ( state == S_WRITE || state == S_IDLE )?1'b1:1'b0;
   assign S_AXI_BVALID   = ( state == S_WRITE2 )?LOCAL_ACK:1'b0;
   assign S_AXI_BRESP    = 2'b00;

   // Read Channel
   assign S_AXI_ARREADY  = ( state == S_READ  || state == S_IDLE )?1'b1:1'b0;
   assign S_AXI_RVALID   = ( state == S_READ )?LOCAL_ACK:1'b0;
   assign S_AXI_RRESP    = 2'b00;
   assign S_AXI_RDATA    = ( state == S_READ )?LOCAL_RDATA:32'd0;

   
endmodule

module fmrv32im_axi_gpio_ctrl
(
   input         RST_N,
   input         CLK,

   input         LOCAL_CS,
   input         LOCAL_RNW,
   output        LOCAL_ACK,
   input [31:0]  LOCAL_ADDR,
   input [3:0]   LOCAL_BE,
   input [31:0]  LOCAL_WDATA,
   output [31:0] LOCAL_RDATA,

   input [31:0]  GPIO_I,
   output [31:0] GPIO_OT
);

   localparam A_OUT   = 8'h00;
   localparam A_IN    = 8'h04;

   wire          wr_ena, rd_ena, wr_ack;
   reg           rd_ack;

   reg [31:0]    reg_gpio_o;
   reg [31:0]    reg_rdata;

   assign wr_ena = (LOCAL_CS & ~LOCAL_RNW)?1'b1:1'b0;
   assign rd_ena = (LOCAL_CS &  LOCAL_RNW)?1'b1:1'b0;
   assign wr_ack = wr_ena;

   // Write Register
   always @(posedge CLK) begin
      if(!RST_N) begin
         reg_gpio_o <= 32'd0;
      end else begin
         if(wr_ena) begin
            case(LOCAL_ADDR[7:0] & 8'hFC)
              A_OUT: begin
                 reg_gpio_o <= LOCAL_WDATA;
              end
              default: begin
              end
            endcase
         end
      end
   end

   // Read Register
   always @(posedge CLK) begin
      if(!RST_N) begin
         reg_rdata[31:0] <= 32'd0;
         rd_ack <= 1'b0;
      end else begin
         rd_ack <= rd_ena;
         if(rd_ena) begin
            case(LOCAL_ADDR[7:0] & 8'hFC)
              A_OUT: begin
               reg_rdata[31:0] <= reg_gpio_o[31:0];
              end
              A_IN: begin
                 reg_rdata[31:0] <= GPIO_I;
              end
              default: begin
                 reg_rdata[31:0] <= 32'd0;
              end
            endcase
         end else begin
            reg_rdata[31:0] <= 32'd0;
         end
      end
   end

   assign LOCAL_ACK         = (wr_ack | rd_ack);
   assign LOCAL_RDATA[31:0] = reg_rdata[31:0];

   assign GPIO_OT           = reg_gpio_o;

endmodule
