`timescale 1ns / 1ns

`define MOD_OSRAM

module tb_ArtyA7;

   reg sim_end;

   reg RST_N;
   reg CLK;

   wire uart_txd_in;
   wire uart_rxd_out;

   wire [3:0] led;


   initial begin
      sim_end = 1'b0;

      RST_N = 1'b0;
      CLK   = 1'b0;
      force u_ArtyA7.u_fmrv32im_artya7_wrapper.fmrv32im_artya7_i.High_dout = 1'b0;
/*
`ifdef MOD_OSRAM
      force u_ArtyA7.u_fmrv32im_artya7_wrapper.u_fmrv32im_core.u_fmrv32im_cache.i_base = 32'h2000_0000;
      force u_ArtyA7.u_fmrv32im_artya7_wrapper.u_fmrv32im_core.u_fmrv32im_cache.d_base = 32'h2000_0000;
`endif
*/
      #100;

      @(posedge CLK);
      RST_N = 1'b1;
      force u_ArtyA7.u_fmrv32im_artya7_wrapper.fmrv32im_artya7_i.High_dout = 1'b1;
/*
`ifdef MOD_OSRAM
      release u_ArtyA7.u_fmrv32im_artya7_wrapper.u_fmrv32im_core.u_fmrv32im_cache.i_base;
      release u_ArtyA7.u_fmrv32im_artya7_wrapper.u_fmrv32im_core.u_fmrv32im_cache.d_base;
`endif
*/
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
/*
   always @(posedge CLK) begin
      if((u_ArtyA7.u_fmrv32im_artya7_wrapper.u_fmrv32im_core.dbus_addr == 32'h0000_0800) &
	 (u_ArtyA7.u_fmrv32im_artya7_wrapper.u_fmrv32im_core.dbus_wstb == 4'hF))
	begin
	   rslt <= u_ArtyA7.u_fmrv32im_artya7_wrapper.u_fmrv32im_core.dbus_wdata;
	end
   end
*/
   // Sinario
   initial begin
      wait(CLK);

      @(posedge CLK);

      $display("============================================================");
      $display("Process Start");
      $display("============================================================");
/*
      wait((u_ArtyA7.u_fmrv32im_artya7_wrapper.u_fmrv32im_core.dbus_addr == 32'h0000_0800) &
	   (u_ArtyA7.u_fmrv32im_artya7_wrapper.u_fmrv32im_core.dbus_wstb == 4'hF));
*/

    #(2000000);

      u_task_uart.write("e");
      u_task_uart.write("c");
      u_task_uart.write("h");
      u_task_uart.write("o");
      u_task_uart.write("b");
      u_task_uart.write("a");
      u_task_uart.write("c");
      u_task_uart.write("k");
      u_task_uart.write("\r");
      u_task_uart.write("\n");

      wait(led==4'hF);

      repeat(10) @(posedge CLK);

      sim_end = 1;
   end


   integer iena_count;
   initial begin
      wait(sim_end);
      $display("============================================================");
      $display("Simulatin Finish");
      $display("============================================================");
      $display("Result: %8x", rslt);
      $display("Inst Count: %d", iena_count);

      $finish();
   end

//   initial $readmemh("../../../../src/imem.hex", u_fmrv32im_core.u_fmrv32im_cache.imem);
//   initial $readmemh("../../../../src/imem.hex", u_fmrv32im_core.u_fmrv32im_cache.dmem);

   ArtyA7
   #(
     .MEM_FILE ("../../../../src/imem.hex")
   )
    u_ArtyA7
     (
      .CLK100MHZ      (CLK),

      .uart_txd_in    (uart_txd_in),
      .uart_rxd_out   (uart_rxd_out),

      .led            (led)
   );
/*
   always @(posedge CLK) begin
    if(!RST_N) begin
      iena_count <= 0;
    end else begin
      if(u_ArtyA7.u_fmrv32im_artya7_wrapper.u_fmrv32im_core.ibus_ena) begin
        iena_count <= iena_count +1;
      end
    end
   end
*/
  task_uart u_task_uart(
    .tx(uart_txd_in),
    .rx(uart_rxd_out)
  );
endmodule // tb_fmrv32im_core

`timescale 1ns / 1ps

module task_uart(
    tx,
    rx
);

    output tx;
    input  rx;

    reg tx;

    reg clk, clk2;
    reg [7:0] rdata;

    reg rx_valid;
    wire [7:0] rx_char;

    initial begin
        clk     <= 1'b0;
        clk2    <= 1'b0;
        tx      <= 1'b1;
    end

    always begin
        #(1000000000/115200/2) clk <= ~clk;
    end
    always begin
        #(1000000000/115200/2/2) clk2 <= ~clk2;
    end

    task write;
        input [7:0] data;
        begin
            @(posedge clk);
            tx <= 1'b1;
            @(posedge clk);
            tx <= 1'b0;
            @(posedge clk);
            tx <= data[0];
            @(posedge clk);
            tx <= data[1];
            @(posedge clk);
            tx <= data[2];
            @(posedge clk);
            tx <= data[3];
            @(posedge clk);
            tx <= data[4];
            @(posedge clk);
            tx <= data[5];
            @(posedge clk);
            tx <= data[6];
            @(posedge clk);
            tx <= data[7];
            @(posedge clk);
            tx <= 1'b1;
            @(posedge clk);
            tx <= 1'b1;
            @(posedge clk);
        end
    endtask

    // Receive
    always begin
        rx_valid <= 0;
        @(posedge clk2);
        if(rx == 1'b0) begin
            repeat (2) @(posedge clk2);
            rdata[0] <= rx;
            repeat (2) @(posedge clk2);
            rdata[1] <= rx;
            repeat (2) @(posedge clk2);
            rdata[2] <= rx;
            repeat (2) @(posedge clk2);
            rdata[3] <= rx;
            repeat (2) @(posedge clk2);
            rdata[4] <= rx;
            repeat (2) @(posedge clk2);
            rdata[5] <= rx;
            repeat (2) @(posedge clk2);
            rdata[6] <= rx;
            repeat (2) @(posedge clk2);
            rdata[7] <= rx;
            repeat (2) @(posedge clk2);
            if(rx == 1'b1) begin
//                $display("%s", rdata[7:0]);
                rx_valid <= 1;
                $write("%s", rdata[7:0]);
            end
            repeat (2) @(posedge clk2);
        end
    end
    assign rx_char = (rx_valid)?rdata:8'd0;

endmodule

