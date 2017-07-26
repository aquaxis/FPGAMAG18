module MAX10
(
  input CLK48MHZ,

  output TXD,
  input RXD,

  output [3:0] LED

);
  wire RST_N;
  assign RST_N = 1'b1;

  wire [31:0] gpio_i, gpio_o;
  wire  gpio_ot;
  assign LED = (gpio_ot)?gpio_o[3:0]:4'dz;

    fmrv32im_max10 u_fmrv32im_max10 (
        .clk_clk       (CLK48MHZ),
        .reset_reset_n (RST_N),
        .uart_gpio_i   (32'd0),
        .uart_gpio_o   (gpio_o),
        .uart_gpio_ot  (gpio_ot),
        .uart_uart_txd (TXD),
        .uart_uart_rxd (RXD)
    );
endmodule
