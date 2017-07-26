//Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2017.2 (lin64) Build 1909853 Thu Jun 15 18:39:10 MDT 2017
//Date        : Wed Jul  5 01:27:13 2017
//Host        : saturn running 64-bit Ubuntu 16.10
//Command     : generate_target fmrv32im_artya7_wrapper.bd
//Design      : fmrv32im_artya7_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module fmrv32im_artya7_wrapper
   (CLK100MHZ,
    GPIO_ot,
    UART_rx,
    UART_tx,
    gpio_i,
    gpio_o);
  input CLK100MHZ;
  output [31:0]GPIO_ot;
  input UART_rx;
  output UART_tx;
  input [31:0]gpio_i;
  output [31:0]gpio_o;

  wire CLK100MHZ;
  wire [31:0]GPIO_ot;
  wire UART_rx;
  wire UART_tx;
  wire [31:0]gpio_i;
  wire [31:0]gpio_o;

  fmrv32im_artya7 fmrv32im_artya7_i
       (.CLK100MHZ(CLK100MHZ),
        .GPIO_i(gpio_i),
        .GPIO_o(gpio_o),
        .GPIO_ot(GPIO_ot),
        .UART_rx(UART_rx),
        .UART_tx(UART_tx));
endmodule
