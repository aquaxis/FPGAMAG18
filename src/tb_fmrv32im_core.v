`timescale 1ns / 1ps
module tb_fmrv32im_core;

   reg sim_end;

   reg RST_N;
   reg CLK;

   reg [31:0] INTERRUPT;

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

   initial begin
      sim_end = 1'b0;

      RST_N = 1'b0;
      CLK   = 1'b0;

      INTERRUPT = 0;

      #100;

      @(posedge CLK);
      RST_N = 1'b1;
      $display("============================================================");
      $display("Simulatin Start");
      $display("============================================================");
   end

   // Clock
   localparam CLK100M = 10;
   always begin
      #(CLK100M/2) CLK <= ~CLK;
   end

   reg [31:0] rslt;
   always @(posedge CLK) begin
      if((u_fmrv32im_core.dbus_addr == 32'h0000_0800) &
	 (u_fmrv32im_core.dbus_wstb == 4'hF))
	begin
	   rslt <= u_fmrv32im_core.dbus_wdata;
	end
   end
   
   // Sinario
   initial begin
      wait(CLK);

      @(posedge CLK);

      $display("============================================================");
      $display("Process Start");
      $display("============================================================");

      wait((u_fmrv32im_core.dbus_addr == 32'h0000_0800) & 
	   (u_fmrv32im_core.dbus_wstb == 4'hF));
	
      repeat(10) @(posedge CLK);
      sim_end = 1;
   end


   initial begin
      wait(sim_end);
      $display("============================================================");
      $display("Simulatin Finish");
      $display("============================================================");
      $display("Result: %8x\n", rslt);
      
      $finish();
   end

//   initial $readmemh("../../../../src/imem.hex", u_fmrv32im_core.u_fmrv32im_cache.imem);
//   initial $readmemh("../../../../src/imem.hex", u_fmrv32im_core.u_fmrv32im_cache.dmem);

   fmrv32im_core 
    #(
      .MEM_FILE ("../../../../src/imem.hex")
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


   tb_axi_slave_model u_axi_slave
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

   tb_axil_slave_model u_axil_slave
     (
      // Reset, Clock
      .ARESETN       ( RST_N          ),
      .ACLK          ( CLK            ),

      // Master Write Address
      .M_AXI_AWADDR  ( IM_AXI_AWADDR  ),
      .M_AXI_AWCACHE ( IM_AXI_AWCACHE ),
      .M_AXI_AWPROT  ( IM_AXI_AWPROT  ),
      .M_AXI_AWVALID ( IM_AXI_AWVALID ),
      .M_AXI_AWREADY ( IM_AXI_AWREADY ),

      // Master Write Data
      .M_AXI_WDATA   ( IM_AXI_WDATA   ),
      .M_AXI_WSTRB   ( IM_AXI_WSTRB   ),
      .M_AXI_WVALID  ( IM_AXI_WVALID  ),
      .M_AXI_WREADY  ( IM_AXI_WREADY  ),

      // Master Write Response
      .M_AXI_BRESP   ( IM_AXI_BRESP   ),
      .M_AXI_BVALID  ( IM_AXI_BVALID  ),
      .M_AXI_BREADY  ( IM_AXI_BREADY  ),

      // Master Read Address
      .M_AXI_ARADDR  ( IM_AXI_ARADDR  ),
      .M_AXI_ARCACHE ( IM_AXI_ARCACHE ),
      .M_AXI_ARPROT  ( IM_AXI_ARPROT  ),
      .M_AXI_ARVALID ( IM_AXI_ARVALID ),
      .M_AXI_ARREADY ( IM_AXI_ARREADY ),

      // Master Read Data
      .M_AXI_RDATA   ( IM_AXI_RDATA   ),
      .M_AXI_RRESP   ( IM_AXI_RRESP   ),
      .M_AXI_RVALID  ( IM_AXI_RVALID  ),
      .M_AXI_RREADY  ( IM_AXI_RREADY  )
      );

endmodule // tb_fmrv32im_core
