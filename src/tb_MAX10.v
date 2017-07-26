`timescale 1ns / 1ps
module tb_MAX10;

   reg sim_end;

   reg RST_N;
   reg CLK;

   wire [3:0] led;


   initial begin
      sim_end = 1'b0;

      RST_N = 1'b0;
      CLK   = 1'b0;
      force u_MAX10.RST_N = 1'b0;

      #100;

      @(posedge CLK);
      RST_N = 1'b1;
      force u_MAX10.RST_N = 1'b1;
      $display("============================================================");
      $display("Simulatin Start");
      $display("============================================================");
   end

   // Clock
   localparam CLK100M = 10;
   always begin
      #(CLK100M/2) CLK <= ~CLK;
   end
/*
   reg [31:0] rslt;
   always @(posedge CLK) begin
      if((u_fmrv32im_max10.u_fmrv32im_core.dbus_addr == 32'h0000_0800) &
	 (u_fmrv32im_max10.u_fmrv32im_core.dbus_wstb == 4'hF))
	begin
	   rslt <= u_fmrv32im_max10.u_fmrv32im_core.dbus_wdata;
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
      wait((u_fmrv32im_max10.u_fmrv32im_core.dbus_addr == 32'h0000_0800) & 
	   (u_fmrv32im_max10.u_fmrv32im_core.dbus_wstb == 4'hF));
	*/

    wait(led == 4'hF);

      repeat(10) @(posedge CLK);
      sim_end = 1;
   end


   initial begin
      wait(sim_end);
      $display("============================================================");
      $display("Simulatin Finish");
      $display("============================================================");
//      $display("Result: %8x\n", rslt);
      
      $finish();
   end

//   initial $readmemh("../../../../src/imem.hex", u_fmrv32im_core.u_fmrv32im_cache.imem);
//   initial $readmemh("../../../../src/imem.hex", u_fmrv32im_core.u_fmrv32im_cache.dmem);

   MAX10
    u_MAX10
     (
      .CLK48MHZ      (CLK),

      .TXD          (txd),
      .RXD          (rxd),

      .LED            (led)
   );

  task_uart u_task_uart(
    .tx(rxd),
    .rx(txd)
  );

endmodule

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

