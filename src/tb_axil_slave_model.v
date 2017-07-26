// AXI Slave Model
module tb_axil_slave_model
  (
   // Reset, Clock
   input            ARESETN,
   input            ACLK,

   // Master Write Address
   input [31:0]     M_AXI_AWADDR,
   input [3:0]      M_AXI_AWCACHE,
   input [2:0]      M_AXI_AWPROT,
   input            M_AXI_AWVALID,
   output reg       M_AXI_AWREADY,

   // Master Write Data
   input [31:0]     M_AXI_WDATA,
   input [3:0]      M_AXI_WSTRB,
   input            M_AXI_WVALID,
   output reg       M_AXI_WREADY,

   // Master Write Response
   output reg [1:0] M_AXI_BRESP,
   output           M_AXI_BVALID,
   input            M_AXI_BREADY,

   // Master Read Address
   input [31:0]     M_AXI_ARADDR,
   input [3:0]      M_AXI_ARCACHE,
   input [2:0]      M_AXI_ARPROT,
   input            M_AXI_ARVALID,
   output reg       M_AXI_ARREADY,

   // Master Read Data
   output [31:0]    M_AXI_RDATA,
   output reg [1:0] M_AXI_RRESP,
   output           M_AXI_RVALID,
   input            M_AXI_RREADY
   );

   initial begin
      M_AXI_AWREADY  = 1;
      M_AXI_WREADY   = 1;
      M_AXI_BRESP    = 0;
      M_AXI_RRESP    = 0;
      M_AXI_ARREADY  = 1;
   end

   // AXI Read
   reg axi_rena;
   reg [7:0]  axi_length;
   always @(posedge ACLK or negedge ARESETN) begin
      if(!ARESETN) begin
         axi_rena <= 0;
         axi_length <= 0;
      end else begin
         if(M_AXI_RVALID & M_AXI_RREADY) begin
            axi_rena <= 0;
         end else if(M_AXI_ARVALID) begin
            axi_rena <= 1;
         end
      end
   end
   assign M_AXI_RDATA  = M_AXI_ARADDR;
   assign M_AXI_RVALID = axi_rena & M_AXI_RREADY;

   // AXI BResponse
   reg axi_wvalid;
   always @(posedge ACLK or negedge ARESETN)begin
      if(!ARESETN) begin
         axi_wvalid <= 0;
      end else begin
         if(M_AXI_BREADY) begin
            axi_wvalid <= 0;
         end else if (M_AXI_WVALID) begin
            axi_wvalid <= 1;
         end
      end
   end

   assign M_AXI_BVALID  = axi_wvalid;

endmodule
