module fmrv32im_max10
#(
    parameter MEM_FILE = "../../src/imem.mif"
)
(
    input CLK48MHZ,

    output [3:0] led
);

    // クロック信号
    wire CLK;
    assign CLK = CLK48MHZ;

    // リセット信号
    wire RST_N;
    assign RST_N = 1'b1;

    // 割込信号
    wire [31:0] INTERRUPT;
    assign INTERRUPT = 32'd0;

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

   wire [31:0] gpio_i, gpio_ot;

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

    assign led[2:0] = ~gpio_ot[2:0];

    reg [31:0] count;
    reg data;
    always @(posedge CLK) begin
      if(count >= 48000000) begin
        count <= 0;
        data <= ~data;
      end else begin
        count <= count +1;
      end
    end
    assign led[3] = ~data;

endmodule