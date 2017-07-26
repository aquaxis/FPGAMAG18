// Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2017.2 (lin64) Build 1909853 Thu Jun 15 18:39:10 MDT 2017
// Date        : Fri Jun 23 10:19:57 2017
// Host        : dshwdev running 64-bit Ubuntu 16.04.2 LTS
// Command     : write_verilog -force -mode synth_stub
//               /home/h-ishihara/workspace/FPGAMAG18/FPGA/fmrv32im-artya7.madd33/fmrv32im-artya7.srcs/sources_1/bd/fmrv32im_artya7/fmrv32im_artya7_stub.v
// Design      : fmrv32im_artya7
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a35ticsg324-1L
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module fmrv32im_artya7(CLK100MHZ, GPIO_i, GPIO_o, GPIO_ot, UART_rx, 
  UART_tx)
/* synthesis syn_black_box black_box_pad_pin="CLK100MHZ,GPIO_i[31:0],GPIO_o[31:0],GPIO_ot[31:0],UART_rx,UART_tx" */;
  input CLK100MHZ;
  input [31:0]GPIO_i;
  output [31:0]GPIO_o;
  output [31:0]GPIO_ot;
  input UART_rx;
  output UART_tx;
endmodule
