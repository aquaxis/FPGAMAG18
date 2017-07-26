//`define MOD_LED
`define MOD_UART
`define MOD_OSRAM

module fmrv32im_artya7
#(
    parameter MEM_FILE = "../../../src/imem.hex"
)
(
    input CLK100MHZ,

    input  uart_txd_in,
    output uart_rxd_out,

    output [3:0] led
);

    // クロック信号
    wire CLK;
    assign CLK = CLK100MHZ;

    // リセット信号
    wire RST_N;
    assign RST_N = 1'b1;

    // 割込信号
    wire [31:0] INTERRUPT;
//    assign INTERRUPT = 32'd0;

   // Write Address Channel
   wire [15:0] IM_AXI_AWADDR;
   wire [3:0]  IM_AXI_AWCACHE;
   wire [2:0]  IM_AXI_AWPROT;
   wire        IM_AXI_AWVALID;
   wire        IM_AXI_AWREADY;

   // Write Data Channel
   wire [31:0] IM_AXI_WDATA;
   wire [3:0]  IM_AXI_WSTRB;
   wire        IM_AXI_WVALID;
   wire        IM_AXI_WREADY;

   // Write Response Channel
   wire        IM_AXI_BVALID;
   wire        IM_AXI_BREADY;
   wire [1:0]  IM_AXI_BRESP;

   // Read Address Channel
   wire [15:0] IM_AXI_ARADDR;
   wire [3:0]  IM_AXI_ARCACHE;
   wire [2:0]  IM_AXI_ARPROT;
   wire        IM_AXI_ARVALID;
   wire        IM_AXI_ARREADY;

   // Read Data Channel
   wire [31:0] IM_AXI_RDATA;
   wire [1:0]  IM_AXI_RRESP;
   wire        IM_AXI_RVALID;
   wire        IM_AXI_RREADY;

   // --------------------------------------------------
   // AXI4 Interface(Master)
   // --------------------------------------------------

   // Master Write Address
   wire [0:0]  MM_AXI_AWID;
   wire [31:0] MM_AXI_AWADDR;
   wire [7:0]  MM_AXI_AWLEN;
   wire [2:0]  MM_AXI_AWSIZE;
   wire [1:0]  MM_AXI_AWBURST;
   wire        MM_AXI_AWLOCK;
   wire [3:0]  MM_AXI_AWCACHE;
   wire [2:0]  MM_AXI_AWPROT;
   wire [3:0]  MM_AXI_AWQOS;
   wire [0:0]  MM_AXI_AWUSER;
   wire        MM_AXI_AWVALID;
   wire        MM_AXI_AWREADY;

   // Master Write Data
   wire [31:0] MM_AXI_WDATA;
   wire [3:0]  MM_AXI_WSTRB;
   wire        MM_AXI_WLAST;
   wire [0:0]  MM_AXI_WUSER;
   wire        MM_AXI_WVALID;
   wire        MM_AXI_WREADY;

   // Master Write Response
   wire [0:0]  MM_AXI_BID;
   wire [1:0]  MM_AXI_BRESP;
   wire [0:0]  MM_AXI_BUSER;
   wire        MM_AXI_BVALID;
   wire        MM_AXI_BREADY;

   // Master Read Address
   wire [0:0]  MM_AXI_ARID;
   wire [31:0] MM_AXI_ARADDR;
   wire [7:0]  MM_AXI_ARLEN;
   wire [2:0]  MM_AXI_ARSIZE;
   wire [1:0]  MM_AXI_ARBURST;
   wire [1:0]  MM_AXI_ARLOCK;
   wire [3:0]  MM_AXI_ARCACHE;
   wire [2:0]  MM_AXI_ARPROT;
   wire [3:0]  MM_AXI_ARQOS;
   wire [0:0]  MM_AXI_ARUSER;
   wire        MM_AXI_ARVALID;
   wire        MM_AXI_ARREADY;

   // Master Read Data
   wire [0:0]  MM_AXI_RID;
   wire [31:0] MM_AXI_RDATA;
   wire [1:0]  MM_AXI_RRESP;
   wire        MM_AXI_RLAST;
   wire [0:0]  MM_AXI_RUSER;
   wire        MM_AXI_RVALID;
   wire        MM_AXI_RREADY;

   // Interrupt
   wire        INTERRUPT_UART;

   wire [31:0] gpio_i, gpio_ot;

   assign INTERRUPT = {31'd0, INTERRUPT_UART};

    fmrv32im_core
    #(
     .MEM_FILE       (MEM_FILE)
    )
    u_fmrv32im_core
     (
      .RST_N          (RST_N),
      .CLK            (CLK),

      .INTERRUPT      (INTERRUPT),

      // ------------------------------------------------------------
      // Master Write Address
      .MM_AXI_AWID    (MM_AXI_AWID),
      .MM_AXI_AWADDR  (MM_AXI_AWADDR),
      .MM_AXI_AWLEN   (MM_AXI_AWLEN),
      .MM_AXI_AWSIZE  (MM_AXI_AWSIZE),
      .MM_AXI_AWBURST (MM_AXI_AWBURST),
      .MM_AXI_AWLOCK  (MM_AXI_AWLOCK),
      .MM_AXI_AWCACHE (MM_AXI_AWCACHE),
      .MM_AXI_AWPROT  (MM_AXI_AWPROT),
      .MM_AXI_AWQOS   (MM_AXI_AWQOS),
      .MM_AXI_AWUSER  (MM_AXI_AWUSER),
      .MM_AXI_AWVALID (MM_AXI_AWVALID),
      .MM_AXI_AWREADY (MM_AXI_AWREADY),

      // Master Write Data
      .MM_AXI_WDATA   (MM_AXI_WDATA),
      .MM_AXI_WSTRB   (MM_AXI_WSTRB),
      .MM_AXI_WLAST   (MM_AXI_WLAST),
      .MM_AXI_WUSER   (MM_AXI_WUSER),
      .MM_AXI_WVALID  (MM_AXI_WVALID),
      .MM_AXI_WREADY  (MM_AXI_WREADY),

      // Master Write Response
      .MM_AXI_BID     (MM_AXI_BID),
      .MM_AXI_BRESP   (MM_AXI_BRESP),
      .MM_AXI_BUSER   (MM_AXI_BUSER),
      .MM_AXI_BVALID  (MM_AXI_BVALID),
      .MM_AXI_BREADY  (MM_AXI_BREADY),

      // Master Read Address
      .MM_AXI_ARID    (MM_AXI_ARID),
      .MM_AXI_ARADDR  (MM_AXI_ARADDR),
      .MM_AXI_ARLEN   (MM_AXI_ARLEN),
      .MM_AXI_ARSIZE  (MM_AXI_ARSIZE),
      .MM_AXI_ARBURST (MM_AXI_ARBURST),
      .MM_AXI_ARLOCK  (MM_AXI_ARLOCK),
      .MM_AXI_ARCACHE (MM_AXI_ARCACHE),
      .MM_AXI_ARPROT  (MM_AXI_ARPROT),
      .MM_AXI_ARQOS   (MM_AXI_ARQOS),
      .MM_AXI_ARUSER  (MM_AXI_ARUSER),
      .MM_AXI_ARVALID (MM_AXI_ARVALID),
      .MM_AXI_ARREADY (MM_AXI_ARREADY),

      // Master Read Data
      .MM_AXI_RID     (MM_AXI_RID),
      .MM_AXI_RDATA   (MM_AXI_RDATA),
      .MM_AXI_RRESP   (MM_AXI_RRESP),
      .MM_AXI_RLAST   (MM_AXI_RLAST),
      .MM_AXI_RUSER   (MM_AXI_RUSER),
      .MM_AXI_RVALID  (MM_AXI_RVALID),
      .MM_AXI_RREADY  (MM_AXI_RREADY),

      // ------------------------------------------------------------
      // Write Address Channel
      .IM_AXI_AWADDR  (IM_AXI_AWADDR),
      .IM_AXI_AWCACHE (IM_AXI_AWCACHE),
      .IM_AXI_AWPROT  (IM_AXI_AWPROT),
      .IM_AXI_AWVALID (IM_AXI_AWVALID),
      .IM_AXI_AWREADY (IM_AXI_AWREADY),

      // Write Data Channel
      .IM_AXI_WDATA   (IM_AXI_WDATA),
      .IM_AXI_WSTRB   (IM_AXI_WSTRB),
      .IM_AXI_WVALID  (IM_AXI_WVALID),
      .IM_AXI_WREADY  (IM_AXI_WREADY),

      // Write Response Channel
      .IM_AXI_BVALID  (IM_AXI_BVALID),
      .IM_AXI_BREADY  (IM_AXI_BREADY),
      .IM_AXI_BRESP   (IM_AXI_BRESP),

      // Read Address Channel
      .IM_AXI_ARADDR  (IM_AXI_ARADDR),
      .IM_AXI_ARCACHE (IM_AXI_ARCACHE),
      .IM_AXI_ARPROT  (IM_AXI_ARPROT),
      .IM_AXI_ARVALID (IM_AXI_ARVALID),
      .IM_AXI_ARREADY (IM_AXI_ARREADY),

      // Read Data Channel
      .IM_AXI_RDATA   (IM_AXI_RDATA),
      .IM_AXI_RRESP   (IM_AXI_RRESP),
      .IM_AXI_RVALID  (IM_AXI_RVALID),
      .IM_AXI_RREADY  (IM_AXI_RREADY)
   );

`ifndef MOD_OSRAM
   fmrv32im_axis_dummy u_fmrv32im_axis_dummy
     (
      // Reset, Clock
      .ARESETN       ( RST_N          ),
      .ACLK          ( CLK            ),

      // Master Write Address
      .M_AXI_AWID    ( MM_AXI_AWID    ),
      .M_AXI_AWADDR  ( MM_AXI_AWADDR  ),
      .M_AXI_AWLEN   ( MM_AXI_AWLEN   ),
      .M_AXI_AWSIZE  ( MM_AXI_AWSIZE  ),
      .M_AXI_AWBURST ( MM_AXI_AWBURST ),
      .M_AXI_AWLOCK  ( MM_AXI_AWLOCK  ),
      .M_AXI_AWCACHE ( MM_AXI_AWCACHE ),
      .M_AXI_AWPROT  ( MM_AXI_AWPROT  ),
      .M_AXI_AWQOS   ( MM_AXI_AWQOS   ),
      .M_AXI_AWUSER  ( MM_AXI_AWUSER  ),
      .M_AXI_AWVALID ( MM_AXI_AWVALID ),
      .M_AXI_AWREADY ( MM_AXI_AWREADY ),

      // Master Write Data
      .M_AXI_WDATA   ( MM_AXI_WDATA   ),
      .M_AXI_WSTRB   ( MM_AXI_WSTRB   ),
      .M_AXI_WLAST   ( MM_AXI_WLAST   ),
      .M_AXI_WUSER   ( MM_AXI_WUSER   ),
      .M_AXI_WVALID  ( MM_AXI_WVALID  ),
      .M_AXI_WREADY  ( MM_AXI_WREADY  ),

      // Master Write Response
      .M_AXI_BID     ( MM_AXI_BID     ),
      .M_AXI_BRESP   ( MM_AXI_BRESP   ),
      .M_AXI_BUSER   ( MM_AXI_BUSER   ),
      .M_AXI_BVALID  ( MM_AXI_BVALID  ),
      .M_AXI_BREADY  ( MM_AXI_BREADY  ),

      // Master Read Address
      .M_AXI_ARID    ( MM_AXI_ARID    ),
      .M_AXI_ARADDR  ( MM_AXI_ARADDR  ),
      .M_AXI_ARLEN   ( MM_AXI_ARLEN   ),
      .M_AXI_ARSIZE  ( MM_AXI_ARSIZE  ),
      .M_AXI_ARBURST ( MM_AXI_ARBURST ),
      // .M_AXI_ARLOCK(),
      .M_AXI_ARLOCK  ( MM_AXI_ARLOCK  ),
      .M_AXI_ARCACHE ( MM_AXI_ARCACHE ),
      .M_AXI_ARPROT  ( MM_AXI_ARPROT  ),
      .M_AXI_ARQOS   ( MM_AXI_ARQOS   ),
      .M_AXI_ARUSER  ( MM_AXI_ARUSER  ),
      .M_AXI_ARVALID ( MM_AXI_ARVALID ),
      .M_AXI_ARREADY ( MM_AXI_ARREADY ),

      // Master Read Data
      .M_AXI_RID     ( MM_AXI_RID     ),
      .M_AXI_RDATA   ( MM_AXI_RDATA   ),
      .M_AXI_RRESP   ( MM_AXI_RRESP   ),
      .M_AXI_RLAST   ( MM_AXI_RLAST   ),
      .M_AXI_RUSER   ( MM_AXI_RUSER   ),
      .M_AXI_RVALID  ( MM_AXI_RVALID  ),
      .M_AXI_RREADY  ( MM_AXI_RREADY  )
      );
`else
fmrv32im_axi_osram u_fmrv32im_axi_osram (
  .s_aclk       (CLK),                // input wire s_aclk
  .s_aresetn    (RST_N),          // input wire s_aresetn
  .s_axi_awid   (MM_AXI_AWID),        // input wire [3 : 0] s_axi_awid
  .s_axi_awaddr (MM_AXI_AWADDR),    // input wire [31 : 0] s_axi_awaddr
  .s_axi_awlen  (MM_AXI_AWLEN),      // input wire [7 : 0] s_axi_awlen
  .s_axi_awsize (MM_AXI_AWSIZE),    // input wire [2 : 0] s_axi_awsize
  .s_axi_awburst(MM_AXI_AWBURST),  // input wire [1 : 0] s_axi_awburst
  .s_axi_awvalid(MM_AXI_AWVALID),  // input wire s_axi_awvalid
  .s_axi_awready(MM_AXI_AWREADY),  // output wire s_axi_awready
  .s_axi_wdata  (MM_AXI_WDATA),      // input wire [31 : 0] s_axi_wdata
  .s_axi_wstrb  (MM_AXI_WSTRB),      // input wire [3 : 0] s_axi_wstrb
  .s_axi_wlast  (MM_AXI_WLAST),      // input wire s_axi_wlast
  .s_axi_wvalid (MM_AXI_WVALID),    // input wire s_axi_wvalid
  .s_axi_wready (MM_AXI_WREADY),    // output wire s_axi_wready
  .s_axi_bid    (MM_AXI_BID),          // output wire [3 : 0] s_axi_bid
  .s_axi_bresp  (MM_AXI_BRESP),      // output wire [1 : 0] s_axi_bresp
  .s_axi_bvalid (MM_AXI_BVALID),    // output wire s_axi_bvalid
  .s_axi_bready (MM_AXI_BREADY),    // input wire s_axi_bready
  .s_axi_arid   (MM_AXI_ARID),        // input wire [3 : 0] s_axi_arid
  .s_axi_araddr (MM_AXI_ARADDR),    // input wire [31 : 0] s_axi_araddr
  .s_axi_arlen  (MM_AXI_ARLEN),      // input wire [7 : 0] s_axi_arlen
  .s_axi_arsize (MM_AXI_ARSIZE),    // input wire [2 : 0] s_axi_arsize
  .s_axi_arburst(MM_AXI_ARBURST),  // input wire [1 : 0] s_axi_arburst
  .s_axi_arvalid(MM_AXI_ARVALID),  // input wire s_axi_arvalid
  .s_axi_arready(MM_AXI_ARREADY),  // output wire s_axi_arready
  .s_axi_rid    (MM_AXI_RID),          // output wire [3 : 0] s_axi_rid
  .s_axi_rdata  (MM_AXI_RDATA),      // output wire [31 : 0] s_axi_rdata
  .s_axi_rresp  (MM_AXI_RRESP),      // output wire [1 : 0] s_axi_rresp
  .s_axi_rlast  (MM_AXI_RLAST),      // output wire s_axi_rlast
  .s_axi_rvalid (MM_AXI_RVALID),    // output wire s_axi_rvalid
  .s_axi_rready (MM_AXI_RREADY)    // input wire s_axi_rready
);
`endif

`ifdef MOD_LED
   fmrv32im_axi_gpio u_fmrv32im_axi_gpio
     (
      // Reset, Clock
      .RST_N         ( RST_N          ),
      .CLK           ( CLK            ),

      // Master Write Address
      .S_AXI_AWADDR  ( IM_AXI_AWADDR  ),
      .S_AXI_AWCACHE ( IM_AXI_AWCACHE ),
      .S_AXI_AWPROT  ( IM_AXI_AWPROT  ),
      .S_AXI_AWVALID ( IM_AXI_AWVALID ),
      .S_AXI_AWREADY ( IM_AXI_AWREADY ),

      // Master Write Data
      .S_AXI_WDATA   ( IM_AXI_WDATA   ),
      .S_AXI_WSTRB   ( IM_AXI_WSTRB   ),
      .S_AXI_WVALID  ( IM_AXI_WVALID  ),
      .S_AXI_WREADY  ( IM_AXI_WREADY  ),

      // Master Write Response
      .S_AXI_BRESP   ( IM_AXI_BRESP   ),
      .S_AXI_BVALID  ( IM_AXI_BVALID  ),
      .S_AXI_BREADY  ( IM_AXI_BREADY  ),

      // Master Read Address
      .S_AXI_ARADDR  ( IM_AXI_ARADDR  ),
      .S_AXI_ARCACHE ( IM_AXI_ARCACHE ),
      .S_AXI_ARPROT  ( IM_AXI_ARPROT  ),
      .S_AXI_ARVALID ( IM_AXI_ARVALID ),
      .S_AXI_ARREADY ( IM_AXI_ARREADY ),

      // Master Read Data
      .S_AXI_RDATA   ( IM_AXI_RDATA   ),
      .S_AXI_RRESP   ( IM_AXI_RRESP   ),
      .S_AXI_RVALID  ( IM_AXI_RVALID  ),
      .S_AXI_RREADY  ( IM_AXI_RREADY  ),

      // GPIO
      .GPIO_I        ( gpio_i         ),
      .GPIO_OT       ( gpio_ot        )
      );

    assign led[2:0] = gpio_ot[2:0];

    reg [31:0] count;
    reg data;
    always @(posedge CLK) begin
      if(count >= 100000000) begin
        count <= 0;
        data <= ~data;
      end else begin
        count <= count +1;
      end
    end
    assign led[3] = data;
`else
/*
    reg [31:0] count;
    reg data;
    always @(posedge CLK) begin
      if(count >= 100000000) begin
        count <= 0;
        data <= ~data;
      end else begin
        count <= count +1;
      end
    end
    assign led[3] = data;
*/
`endif

`ifdef MOD_UART
    wire [31:0] gpio;
    //
    fmrv32im_axis_uart u_fmrv32im_axis_uart
    (
      .RST_N(RST_N),
      .CLK(CLK),

      // --------------------------------------------------
      // AXI4 Lite Interface
      // --------------------------------------------------
      // Write Address Channel
      .S_AXI_AWADDR(IM_AXI_AWADDR),
      .S_AXI_AWCACHE(IM_AXI_AWCACHE),
      .S_AXI_AWPROT(IM_AXI_AWPROT),
      .S_AXI_AWVALID(IM_AXI_AWVALID),
      .S_AXI_AWREADY(IM_AXI_AWREADY),

      // Write Data Channel
      .S_AXI_WDATA(IM_AXI_WDATA),
      .S_AXI_WSTRB(IM_AXI_WSTRB),
      .S_AXI_WVALID(IM_AXI_WVALID),
      .S_AXI_WREADY(IM_AXI_WREADY),

      // Write Response Channel
      .S_AXI_BVALID(IM_AXI_BVALID),
      .S_AXI_BREADY(IM_AXI_BREADY),
      .S_AXI_BRESP(IM_AXI_BRESP),

      // Read Address Channel
      .S_AXI_ARADDR(IM_AXI_ARADDR),
      .S_AXI_ARCACHE(IM_AXI_ARCACHE),
      .S_AXI_ARPROT(IM_AXI_ARPROT),
      .S_AXI_ARVALID(IM_AXI_ARVALID),
      .S_AXI_ARREADY(IM_AXI_ARREADY),

      // Read Data Channel
      .S_AXI_RDATA(IM_AXI_RDATA),
      .S_AXI_RRESP(IM_AXI_RRESP),
      .S_AXI_RVALID(IM_AXI_RVALID),
      .S_AXI_RREADY(IM_AXI_RREADY),

      .RXD(uart_txd_in),
      .TXD(uart_rxd_out),

      .INTERRUPT(INTERRUPT_UART),
      .GPIO(gpio)
   );
   assign led[3:0] = gpio[3:0];
  `else
    assign INTERRUPT_UART = 1'b0;
  `endif

endmodule