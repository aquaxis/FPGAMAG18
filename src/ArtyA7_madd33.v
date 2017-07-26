module ArtyA7
(
    input CLK100MHZ,

    input  uart_txd_in,
    output uart_rxd_out,

    output [3:0] led
);

wire CLK;

clk_wiz_0 u_clk_wiz_0
(
  .clk_in1(CLK100MHZ),
  .clk_out1(CLK)
);

wire [31:0] gpio_i, gpio_o, gpio_ot, gpio;

assign gpio = (gpio_ot)?gpio_o:32'hZZZZZZZZ;

assign led = gpio[3:0];

fmrv32im_artya7_wrapper u_fmrv32im_artya7_wrapper
(
  .CLK100MHZ(CLK100MHZ),
  .GPIO_ot(gpio_ot),
  .UART_rx(uart_txd_in),
  .UART_tx(uart_rxd_out),
  .gpio_i(gpio_i),
  .gpio_o(gpio_o)
);
endmodule
