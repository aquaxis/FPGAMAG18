`timescale 1ns / 1ps
module tb_fmrv32im_max10;

   reg sim_end;

   reg RST_N;
   reg CLK;

   wire [3:0] led;


   initial begin
      sim_end = 1'b0;

      RST_N = 1'b0;
      CLK   = 1'b0;
      force u_fmrv32im_max10.RST_N = 1'b0;

      #100;

      @(posedge CLK);
      RST_N = 1'b1;
      force u_fmrv32im_max10.RST_N = 1'b1;
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
      if((u_fmrv32im_max10.u_fmrv32im_core.dbus_addr == 32'h0000_0800) &
	 (u_fmrv32im_max10.u_fmrv32im_core.dbus_wstb == 4'hF))
	begin
	   rslt <= u_fmrv32im_max10.u_fmrv32im_core.dbus_wdata;
	end
   end
   
   // Sinario
   initial begin
      wait(CLK);

      @(posedge CLK);

      $display("============================================================");
      $display("Process Start");
      $display("============================================================");

      wait((u_fmrv32im_max10.u_fmrv32im_core.dbus_addr == 32'h0000_0800) & 
	   (u_fmrv32im_max10.u_fmrv32im_core.dbus_wstb == 4'hF));
	
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

   fmrv32im_max10
   #(
     .MEM_FILE ("../../../../src/imem.mif")
   )
    u_fmrv32im_max10
     (
      .CLK48MHZ      (CLK),

      .led            (led)
   );

endmodule // tb_fmrv32im_core
