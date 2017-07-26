//Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2017.2 (lin64) Build 1909853 Thu Jun 15 18:39:10 MDT 2017
//Date        : Fri Jun 23 10:19:08 2017
//Host        : dshwdev running 64-bit Ubuntu 16.04.2 LTS
//Command     : generate_target fmrv32im_artya7.bd
//Design      : fmrv32im_artya7
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "fmrv32im_artya7,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=fmrv32im_artya7,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=10,numReposBlks=9,numNonXlnxBlks=7,numHierBlks=1,maxHierDepth=1,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=0,numPkgbdBlks=0,bdsource=USER,da_bram_cntlr_cnt=1,synth_mode=OOC_per_BD}" *) (* HW_HANDOFF = "fmrv32im_artya7.hwdef" *) 
module fmrv32im_artya7
   (CLK100MHZ,
    GPIO_i,
    GPIO_o,
    GPIO_ot,
    UART_rx,
    UART_tx);
  input CLK100MHZ;
  input [31:0]GPIO_i;
  output [31:0]GPIO_o;
  output [31:0]GPIO_ot;
  input UART_rx;
  output UART_tx;

  wire CLK_1;
  wire [0:0]High_dout;
  wire [31:0]axilm_M_AXI_ARADDR;
  wire [3:0]axilm_M_AXI_ARCACHE;
  wire [2:0]axilm_M_AXI_ARPROT;
  wire axilm_M_AXI_ARREADY;
  wire axilm_M_AXI_ARVALID;
  wire [31:0]axilm_M_AXI_AWADDR;
  wire [3:0]axilm_M_AXI_AWCACHE;
  wire [2:0]axilm_M_AXI_AWPROT;
  wire axilm_M_AXI_AWREADY;
  wire axilm_M_AXI_AWVALID;
  wire axilm_M_AXI_BREADY;
  wire [1:0]axilm_M_AXI_BRESP;
  wire axilm_M_AXI_BVALID;
  wire [31:0]axilm_M_AXI_RDATA;
  wire axilm_M_AXI_RREADY;
  wire [1:0]axilm_M_AXI_RRESP;
  wire axilm_M_AXI_RVALID;
  wire [31:0]axilm_M_AXI_WDATA;
  wire axilm_M_AXI_WREADY;
  wire [3:0]axilm_M_AXI_WSTRB;
  wire axilm_M_AXI_WVALID;
  wire [0:0]concat_dout;
  wire [31:0]fmrv32im_axis_uart_0_GPIO_I;
  wire [31:0]fmrv32im_axis_uart_0_GPIO_O;
  wire [31:0]fmrv32im_axis_uart_0_GPIO_OT;
  wire fmrv32im_axis_uart_0_INTERRUPT;
  wire fmrv32im_axis_uart_0_UART_RX;
  wire fmrv32im_axis_uart_0_UART_TX;
  wire [31:0]fmrv32im_core_PERIPHERAL_BUS_ADDR;
  wire fmrv32im_core_PERIPHERAL_BUS_ENA;
  wire [31:0]fmrv32im_core_PERIPHERAL_BUS_RDATA;
  wire fmrv32im_core_PERIPHERAL_BUS_WAIT;
  wire [31:0]fmrv32im_core_PERIPHERAL_BUS_WDATA;
  wire [3:0]fmrv32im_core_PERIPHERAL_BUS_WSTB;

  assign CLK_1 = CLK100MHZ;
  assign GPIO_o[31:0] = fmrv32im_axis_uart_0_GPIO_O;
  assign GPIO_ot[31:0] = fmrv32im_axis_uart_0_GPIO_OT;
  assign UART_tx = fmrv32im_axis_uart_0_UART_TX;
  assign fmrv32im_axis_uart_0_GPIO_I = GPIO_i[31:0];
  assign fmrv32im_axis_uart_0_UART_RX = UART_rx;
  fmrv32im_artya7_xlconstant_0_0 High
       (.dout(High_dout));
  fmrv32im_artya7_fmrv32im_axilm_0_0 axi_lite_master
       (.BUS_ADDR(fmrv32im_core_PERIPHERAL_BUS_ADDR),
        .BUS_ENA(fmrv32im_core_PERIPHERAL_BUS_ENA),
        .BUS_RDATA(fmrv32im_core_PERIPHERAL_BUS_RDATA),
        .BUS_WAIT(fmrv32im_core_PERIPHERAL_BUS_WAIT),
        .BUS_WDATA(fmrv32im_core_PERIPHERAL_BUS_WDATA),
        .BUS_WSTB(fmrv32im_core_PERIPHERAL_BUS_WSTB),
        .CLK(CLK_1),
        .M_AXI_ARADDR(axilm_M_AXI_ARADDR),
        .M_AXI_ARCACHE(axilm_M_AXI_ARCACHE),
        .M_AXI_ARPROT(axilm_M_AXI_ARPROT),
        .M_AXI_ARREADY(axilm_M_AXI_ARREADY),
        .M_AXI_ARVALID(axilm_M_AXI_ARVALID),
        .M_AXI_AWADDR(axilm_M_AXI_AWADDR),
        .M_AXI_AWCACHE(axilm_M_AXI_AWCACHE),
        .M_AXI_AWPROT(axilm_M_AXI_AWPROT),
        .M_AXI_AWREADY(axilm_M_AXI_AWREADY),
        .M_AXI_AWVALID(axilm_M_AXI_AWVALID),
        .M_AXI_BREADY(axilm_M_AXI_BREADY),
        .M_AXI_BRESP(axilm_M_AXI_BRESP),
        .M_AXI_BVALID(axilm_M_AXI_BVALID),
        .M_AXI_RDATA(axilm_M_AXI_RDATA),
        .M_AXI_RREADY(axilm_M_AXI_RREADY),
        .M_AXI_RRESP(axilm_M_AXI_RRESP),
        .M_AXI_RVALID(axilm_M_AXI_RVALID),
        .M_AXI_WDATA(axilm_M_AXI_WDATA),
        .M_AXI_WREADY(axilm_M_AXI_WREADY),
        .M_AXI_WSTRB(axilm_M_AXI_WSTRB),
        .M_AXI_WVALID(axilm_M_AXI_WVALID),
        .RST_N(High_dout));
  fmrv32im_artya7_xlconcat_0_0 concat
       (.In0(fmrv32im_axis_uart_0_INTERRUPT),
        .dout(concat_dout));
  fmrv32im_core_imp_14DVYUT fmrv32im_core
       (.CLK(CLK_1),
        .INT_IN(concat_dout),
        .PERIPHERAL_bus_addr(fmrv32im_core_PERIPHERAL_BUS_ADDR),
        .PERIPHERAL_bus_ena(fmrv32im_core_PERIPHERAL_BUS_ENA),
        .PERIPHERAL_bus_rdata(fmrv32im_core_PERIPHERAL_BUS_RDATA),
        .PERIPHERAL_bus_wait(fmrv32im_core_PERIPHERAL_BUS_WAIT),
        .PERIPHERAL_bus_wdata(fmrv32im_core_PERIPHERAL_BUS_WDATA),
        .PERIPHERAL_bus_wstb(fmrv32im_core_PERIPHERAL_BUS_WSTB),
        .RD_REQ_req_mem_addr(1'b0),
        .RD_REQ_req_mem_rdata(1'b0),
        .RD_REQ_req_mem_we(1'b0),
        .RD_REQ_req_ready(1'b0),
        .RST_N(High_dout),
        .WR_REQ_req_mem_addr(1'b0),
        .WR_REQ_req_ready(1'b0));
  fmrv32im_artya7_fmrv32im_axis_uart_0_1 uart
       (.CLK(CLK_1),
        .GPIO_I(fmrv32im_axis_uart_0_GPIO_I),
        .GPIO_O(fmrv32im_axis_uart_0_GPIO_O),
        .GPIO_OT(fmrv32im_axis_uart_0_GPIO_OT),
        .INTERRUPT(fmrv32im_axis_uart_0_INTERRUPT),
        .RST_N(High_dout),
        .RXD(fmrv32im_axis_uart_0_UART_RX),
        .S_AXI_ARADDR(axilm_M_AXI_ARADDR[15:0]),
        .S_AXI_ARCACHE(axilm_M_AXI_ARCACHE),
        .S_AXI_ARPROT(axilm_M_AXI_ARPROT),
        .S_AXI_ARREADY(axilm_M_AXI_ARREADY),
        .S_AXI_ARVALID(axilm_M_AXI_ARVALID),
        .S_AXI_AWADDR(axilm_M_AXI_AWADDR[15:0]),
        .S_AXI_AWCACHE(axilm_M_AXI_AWCACHE),
        .S_AXI_AWPROT(axilm_M_AXI_AWPROT),
        .S_AXI_AWREADY(axilm_M_AXI_AWREADY),
        .S_AXI_AWVALID(axilm_M_AXI_AWVALID),
        .S_AXI_BREADY(axilm_M_AXI_BREADY),
        .S_AXI_BRESP(axilm_M_AXI_BRESP),
        .S_AXI_BVALID(axilm_M_AXI_BVALID),
        .S_AXI_RDATA(axilm_M_AXI_RDATA),
        .S_AXI_RREADY(axilm_M_AXI_RREADY),
        .S_AXI_RRESP(axilm_M_AXI_RRESP),
        .S_AXI_RVALID(axilm_M_AXI_RVALID),
        .S_AXI_WDATA(axilm_M_AXI_WDATA),
        .S_AXI_WREADY(axilm_M_AXI_WREADY),
        .S_AXI_WSTRB(axilm_M_AXI_WSTRB),
        .S_AXI_WVALID(axilm_M_AXI_WVALID),
        .TXD(fmrv32im_axis_uart_0_UART_TX));
endmodule

module fmrv32im_core_imp_14DVYUT
   (CLK,
    INT_IN,
    PERIPHERAL_bus_addr,
    PERIPHERAL_bus_ena,
    PERIPHERAL_bus_rdata,
    PERIPHERAL_bus_wait,
    PERIPHERAL_bus_wdata,
    PERIPHERAL_bus_wstb,
    RD_REQ_req_addr,
    RD_REQ_req_len,
    RD_REQ_req_mem_addr,
    RD_REQ_req_mem_rdata,
    RD_REQ_req_mem_we,
    RD_REQ_req_ready,
    RD_REQ_req_start,
    RST_N,
    WR_REQ_req_addr,
    WR_REQ_req_len,
    WR_REQ_req_mem_addr,
    WR_REQ_req_mem_wdata,
    WR_REQ_req_ready,
    WR_REQ_req_start);
  input CLK;
  input [0:0]INT_IN;
  output [31:0]PERIPHERAL_bus_addr;
  output PERIPHERAL_bus_ena;
  input [31:0]PERIPHERAL_bus_rdata;
  input PERIPHERAL_bus_wait;
  output [31:0]PERIPHERAL_bus_wdata;
  output [3:0]PERIPHERAL_bus_wstb;
  output RD_REQ_req_addr;
  output RD_REQ_req_len;
  input RD_REQ_req_mem_addr;
  input RD_REQ_req_mem_rdata;
  input RD_REQ_req_mem_we;
  input RD_REQ_req_ready;
  output RD_REQ_req_start;
  input RST_N;
  output WR_REQ_req_addr;
  output WR_REQ_req_len;
  input WR_REQ_req_mem_addr;
  output WR_REQ_req_mem_wdata;
  input WR_REQ_req_ready;
  output WR_REQ_req_start;

  wire CLK_1;
  wire [31:0]Conn1_REQ_ADDR;
  wire [15:0]Conn1_REQ_LEN;
  wire Conn1_REQ_MEM_ADDR;
  wire Conn1_REQ_MEM_RDATA;
  wire Conn1_REQ_MEM_WE;
  wire Conn1_REQ_READY;
  wire Conn1_REQ_START;
  wire [31:0]Conn2_REQ_ADDR;
  wire [15:0]Conn2_REQ_LEN;
  wire Conn2_REQ_MEM_ADDR;
  wire [31:0]Conn2_REQ_MEM_WDATA;
  wire Conn2_REQ_READY;
  wire Conn2_REQ_START;
  wire [31:0]Conn3_BUS_ADDR;
  wire Conn3_BUS_ENA;
  wire [31:0]Conn3_BUS_RDATA;
  wire Conn3_BUS_WAIT;
  wire [31:0]Conn3_BUS_WDATA;
  wire [3:0]Conn3_BUS_WSTB;
  wire [0:0]INT_IN_1;
  wire RST_N_1;
  wire [31:0]dbussel_upgraded_ipi_C_MEM_BUS_MEM_ADDR;
  wire dbussel_upgraded_ipi_C_MEM_BUS_MEM_BADMEM_EXCPT;
  wire dbussel_upgraded_ipi_C_MEM_BUS_MEM_ENA;
  wire [31:0]dbussel_upgraded_ipi_C_MEM_BUS_MEM_RDATA;
  wire dbussel_upgraded_ipi_C_MEM_BUS_MEM_WAIT;
  wire [31:0]dbussel_upgraded_ipi_C_MEM_BUS_MEM_WDATA;
  wire [3:0]dbussel_upgraded_ipi_C_MEM_BUS_MEM_WSTB;
  wire [3:0]dbussel_upgraded_ipi_PLIC_BUS_ADDR;
  wire [31:0]dbussel_upgraded_ipi_PLIC_BUS_RDATA;
  wire [31:0]dbussel_upgraded_ipi_PLIC_BUS_WDATA;
  wire dbussel_upgraded_ipi_PLIC_BUS_WE;
  wire [3:0]dbussel_upgraded_ipi_TIMER_BUS_ADDR;
  wire [31:0]dbussel_upgraded_ipi_TIMER_BUS_RDATA;
  wire [31:0]dbussel_upgraded_ipi_TIMER_BUS_WDATA;
  wire dbussel_upgraded_ipi_TIMER_BUS_WE;
  wire [31:0]fmrv32im_D_MEM_BUS_MEM_ADDR;
  wire fmrv32im_D_MEM_BUS_MEM_BADMEM_EXCPT;
  wire fmrv32im_D_MEM_BUS_MEM_ENA;
  wire [31:0]fmrv32im_D_MEM_BUS_MEM_RDATA;
  wire fmrv32im_D_MEM_BUS_MEM_WAIT;
  wire [31:0]fmrv32im_D_MEM_BUS_MEM_WDATA;
  wire [3:0]fmrv32im_D_MEM_BUS_MEM_WSTB;
  wire [31:0]fmrv32im_I_MEM_BUS_MEM_ADDR;
  wire fmrv32im_I_MEM_BUS_MEM_BADMEM_EXCPT;
  wire fmrv32im_I_MEM_BUS_MEM_ENA;
  wire [31:0]fmrv32im_I_MEM_BUS_MEM_RDATA;
  wire fmrv32im_I_MEM_BUS_MEM_WAIT;
  wire fmrv32im_plic_0_INT_OUT;
  wire timer_EXPIRED;

  assign CLK_1 = CLK;
  assign Conn1_REQ_MEM_ADDR = RD_REQ_req_mem_addr;
  assign Conn1_REQ_MEM_RDATA = RD_REQ_req_mem_rdata;
  assign Conn1_REQ_MEM_WE = RD_REQ_req_mem_we;
  assign Conn1_REQ_READY = RD_REQ_req_ready;
  assign Conn2_REQ_MEM_ADDR = WR_REQ_req_mem_addr;
  assign Conn2_REQ_READY = WR_REQ_req_ready;
  assign Conn3_BUS_RDATA = PERIPHERAL_bus_rdata[31:0];
  assign Conn3_BUS_WAIT = PERIPHERAL_bus_wait;
  assign INT_IN_1 = INT_IN[0];
  assign PERIPHERAL_bus_addr[31:0] = Conn3_BUS_ADDR;
  assign PERIPHERAL_bus_ena = Conn3_BUS_ENA;
  assign PERIPHERAL_bus_wdata[31:0] = Conn3_BUS_WDATA;
  assign PERIPHERAL_bus_wstb[3:0] = Conn3_BUS_WSTB;
  assign RD_REQ_req_addr = Conn1_REQ_ADDR[0];
  assign RD_REQ_req_len = Conn1_REQ_LEN[0];
  assign RD_REQ_req_start = Conn1_REQ_START;
  assign RST_N_1 = RST_N;
  assign WR_REQ_req_addr = Conn2_REQ_ADDR[0];
  assign WR_REQ_req_len = Conn2_REQ_LEN[0];
  assign WR_REQ_req_mem_wdata = Conn2_REQ_MEM_WDATA[0];
  assign WR_REQ_req_start = Conn2_REQ_START;
  fmrv32im_artya7_fmrv32im_cache_0_0 cache
       (.CLK(CLK_1),
        .D_MEM_ADDR(dbussel_upgraded_ipi_C_MEM_BUS_MEM_ADDR),
        .D_MEM_BADMEM_EXCPT(dbussel_upgraded_ipi_C_MEM_BUS_MEM_BADMEM_EXCPT),
        .D_MEM_ENA(dbussel_upgraded_ipi_C_MEM_BUS_MEM_ENA),
        .D_MEM_RDATA(dbussel_upgraded_ipi_C_MEM_BUS_MEM_RDATA),
        .D_MEM_WAIT(dbussel_upgraded_ipi_C_MEM_BUS_MEM_WAIT),
        .D_MEM_WDATA(dbussel_upgraded_ipi_C_MEM_BUS_MEM_WDATA),
        .D_MEM_WSTB(dbussel_upgraded_ipi_C_MEM_BUS_MEM_WSTB),
        .I_MEM_ADDR(fmrv32im_I_MEM_BUS_MEM_ADDR),
        .I_MEM_BADMEM_EXCPT(fmrv32im_I_MEM_BUS_MEM_BADMEM_EXCPT),
        .I_MEM_ENA(fmrv32im_I_MEM_BUS_MEM_ENA),
        .I_MEM_RDATA(fmrv32im_I_MEM_BUS_MEM_RDATA),
        .I_MEM_WAIT(fmrv32im_I_MEM_BUS_MEM_WAIT),
        .RD_REQ_ADDR(Conn1_REQ_ADDR),
        .RD_REQ_LEN(Conn1_REQ_LEN),
        .RD_REQ_MEM_ADDR({Conn1_REQ_MEM_ADDR,Conn1_REQ_MEM_ADDR,Conn1_REQ_MEM_ADDR,Conn1_REQ_MEM_ADDR,Conn1_REQ_MEM_ADDR,Conn1_REQ_MEM_ADDR,Conn1_REQ_MEM_ADDR,Conn1_REQ_MEM_ADDR,Conn1_REQ_MEM_ADDR,Conn1_REQ_MEM_ADDR}),
        .RD_REQ_MEM_RDATA({Conn1_REQ_MEM_RDATA,Conn1_REQ_MEM_RDATA,Conn1_REQ_MEM_RDATA,Conn1_REQ_MEM_RDATA,Conn1_REQ_MEM_RDATA,Conn1_REQ_MEM_RDATA,Conn1_REQ_MEM_RDATA,Conn1_REQ_MEM_RDATA,Conn1_REQ_MEM_RDATA,Conn1_REQ_MEM_RDATA,Conn1_REQ_MEM_RDATA,Conn1_REQ_MEM_RDATA,Conn1_REQ_MEM_RDATA,Conn1_REQ_MEM_RDATA,Conn1_REQ_MEM_RDATA,Conn1_REQ_MEM_RDATA,Conn1_REQ_MEM_RDATA,Conn1_REQ_MEM_RDATA,Conn1_REQ_MEM_RDATA,Conn1_REQ_MEM_RDATA,Conn1_REQ_MEM_RDATA,Conn1_REQ_MEM_RDATA,Conn1_REQ_MEM_RDATA,Conn1_REQ_MEM_RDATA,Conn1_REQ_MEM_RDATA,Conn1_REQ_MEM_RDATA,Conn1_REQ_MEM_RDATA,Conn1_REQ_MEM_RDATA,Conn1_REQ_MEM_RDATA,Conn1_REQ_MEM_RDATA,Conn1_REQ_MEM_RDATA,Conn1_REQ_MEM_RDATA}),
        .RD_REQ_MEM_WE(Conn1_REQ_MEM_WE),
        .RD_REQ_READY(Conn1_REQ_READY),
        .RD_REQ_START(Conn1_REQ_START),
        .RST_N(RST_N_1),
        .WR_REQ_ADDR(Conn2_REQ_ADDR),
        .WR_REQ_LEN(Conn2_REQ_LEN),
        .WR_REQ_MEM_ADDR({Conn2_REQ_MEM_ADDR,Conn2_REQ_MEM_ADDR,Conn2_REQ_MEM_ADDR,Conn2_REQ_MEM_ADDR,Conn2_REQ_MEM_ADDR,Conn2_REQ_MEM_ADDR,Conn2_REQ_MEM_ADDR,Conn2_REQ_MEM_ADDR,Conn2_REQ_MEM_ADDR,Conn2_REQ_MEM_ADDR}),
        .WR_REQ_MEM_WDATA(Conn2_REQ_MEM_WDATA),
        .WR_REQ_READY(Conn2_REQ_READY),
        .WR_REQ_START(Conn2_REQ_START));
  fmrv32im_artya7_dbussel_upgraded_ipi_0 dbussel
       (.C_MEM_ADDR(dbussel_upgraded_ipi_C_MEM_BUS_MEM_ADDR),
        .C_MEM_BADMEM_EXCPT(dbussel_upgraded_ipi_C_MEM_BUS_MEM_BADMEM_EXCPT),
        .C_MEM_ENA(dbussel_upgraded_ipi_C_MEM_BUS_MEM_ENA),
        .C_MEM_RDATA(dbussel_upgraded_ipi_C_MEM_BUS_MEM_RDATA),
        .C_MEM_WAIT(dbussel_upgraded_ipi_C_MEM_BUS_MEM_WAIT),
        .C_MEM_WDATA(dbussel_upgraded_ipi_C_MEM_BUS_MEM_WDATA),
        .C_MEM_WSTB(dbussel_upgraded_ipi_C_MEM_BUS_MEM_WSTB),
        .D_MEM_ADDR(fmrv32im_D_MEM_BUS_MEM_ADDR),
        .D_MEM_BADMEM_EXCPT(fmrv32im_D_MEM_BUS_MEM_BADMEM_EXCPT),
        .D_MEM_ENA(fmrv32im_D_MEM_BUS_MEM_ENA),
        .D_MEM_RDATA(fmrv32im_D_MEM_BUS_MEM_RDATA),
        .D_MEM_WAIT(fmrv32im_D_MEM_BUS_MEM_WAIT),
        .D_MEM_WDATA(fmrv32im_D_MEM_BUS_MEM_WDATA),
        .D_MEM_WSTB(fmrv32im_D_MEM_BUS_MEM_WSTB),
        .PERIPHERAL_BUS_ADDR(Conn3_BUS_ADDR),
        .PERIPHERAL_BUS_ENA(Conn3_BUS_ENA),
        .PERIPHERAL_BUS_RDATA(Conn3_BUS_RDATA),
        .PERIPHERAL_BUS_WAIT(Conn3_BUS_WAIT),
        .PERIPHERAL_BUS_WDATA(Conn3_BUS_WDATA),
        .PERIPHERAL_BUS_WSTB(Conn3_BUS_WSTB),
        .PLIC_BUS_ADDR(dbussel_upgraded_ipi_PLIC_BUS_ADDR),
        .PLIC_BUS_RDATA(dbussel_upgraded_ipi_PLIC_BUS_RDATA),
        .PLIC_BUS_WDATA(dbussel_upgraded_ipi_PLIC_BUS_WDATA),
        .PLIC_BUS_WE(dbussel_upgraded_ipi_PLIC_BUS_WE),
        .TIMER_BUS_ADDR(dbussel_upgraded_ipi_TIMER_BUS_ADDR),
        .TIMER_BUS_RDATA(dbussel_upgraded_ipi_TIMER_BUS_RDATA),
        .TIMER_BUS_WDATA(dbussel_upgraded_ipi_TIMER_BUS_WDATA),
        .TIMER_BUS_WE(dbussel_upgraded_ipi_TIMER_BUS_WE));
  fmrv32im_artya7_fmrv32im_0 fmrv32im
       (.CLK(CLK_1),
        .D_MEM_ADDR(fmrv32im_D_MEM_BUS_MEM_ADDR),
        .D_MEM_BADMEM_EXCPT(fmrv32im_D_MEM_BUS_MEM_BADMEM_EXCPT),
        .D_MEM_ENA(fmrv32im_D_MEM_BUS_MEM_ENA),
        .D_MEM_RDATA(fmrv32im_D_MEM_BUS_MEM_RDATA),
        .D_MEM_WAIT(fmrv32im_D_MEM_BUS_MEM_WAIT),
        .D_MEM_WDATA(fmrv32im_D_MEM_BUS_MEM_WDATA),
        .D_MEM_WSTB(fmrv32im_D_MEM_BUS_MEM_WSTB),
        .EXT_INTERRUPT(fmrv32im_plic_0_INT_OUT),
        .I_MEM_ADDR(fmrv32im_I_MEM_BUS_MEM_ADDR),
        .I_MEM_BADMEM_EXCPT(fmrv32im_I_MEM_BUS_MEM_BADMEM_EXCPT),
        .I_MEM_ENA(fmrv32im_I_MEM_BUS_MEM_ENA),
        .I_MEM_RDATA(fmrv32im_I_MEM_BUS_MEM_RDATA),
        .I_MEM_WAIT(fmrv32im_I_MEM_BUS_MEM_WAIT),
        .RST_N(RST_N_1),
        .TIMER_EXPIRED(timer_EXPIRED));
  fmrv32im_artya7_fmrv32im_plic_0_1 plic
       (.BUS_ADDR(dbussel_upgraded_ipi_PLIC_BUS_ADDR),
        .BUS_RDATA(dbussel_upgraded_ipi_PLIC_BUS_RDATA),
        .BUS_WDATA(dbussel_upgraded_ipi_PLIC_BUS_WDATA),
        .BUS_WE(dbussel_upgraded_ipi_PLIC_BUS_WE),
        .CLK(CLK_1),
        .INT_IN(INT_IN_1),
        .INT_OUT(fmrv32im_plic_0_INT_OUT),
        .RST_N(RST_N_1));
  fmrv32im_artya7_fmrv32im_timer_0_0 timer
       (.BUS_ADDR(dbussel_upgraded_ipi_TIMER_BUS_ADDR),
        .BUS_RDATA(dbussel_upgraded_ipi_TIMER_BUS_RDATA),
        .BUS_WDATA(dbussel_upgraded_ipi_TIMER_BUS_WDATA),
        .BUS_WE(dbussel_upgraded_ipi_TIMER_BUS_WE),
        .CLK(CLK_1),
        .EXPIRED(timer_EXPIRED),
        .RST_N(RST_N_1));
endmodule
