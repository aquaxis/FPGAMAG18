module fmrv32im_axis_uart
  (
    input RST_N,
    input CLK,

   // --------------------------------------------------
   // AXI4 Lite Interface
   // --------------------------------------------------
   // Write Address Channel
   input [15:0]  S_AXI_AWADDR,
   input [3:0]   S_AXI_AWCACHE,
   input [2:0]   S_AXI_AWPROT,
   input         S_AXI_AWVALID,
   output        S_AXI_AWREADY,

   // Write Data Channel
   input [31:0]  S_AXI_WDATA,
   input [3:0]   S_AXI_WSTRB,
   input         S_AXI_WVALID,
   output        S_AXI_WREADY,

   // Write Response Channel
   output        S_AXI_BVALID,
   input         S_AXI_BREADY,
   output [1:0]  S_AXI_BRESP,

   // Read Address Channel
   input [15:0]  S_AXI_ARADDR,
   input [3:0]   S_AXI_ARCACHE,
   input [2:0]   S_AXI_ARPROT,
   input         S_AXI_ARVALID,
   output        S_AXI_ARREADY,

   // Read Data Channel
   output [31:0] S_AXI_RDATA,
   output [1:0]  S_AXI_RRESP,
   output        S_AXI_RVALID,
   input         S_AXI_RREADY,

   output        INTERRUPT,

   input         RXD,
   output        TXD,

   input [31:0] GPIO_I,
   output [31:0] GPIO_O,
   output [31:0] GPIO_OT
   );

   wire          local_clk;
   wire          local_cs;
   wire          local_rnw;
   wire          local_ack;
   wire [15:0]   local_addr;
   wire [3:0]    local_be;
   wire [31:0]   local_wdata;
   wire [31:0]   local_rdata;

   // AXI Lite Slave Interface
   fmrv32im_axis_uart_axils u_fmrv32im_axis_uart_axils
     (
      // AXI4 Lite Interface
      .ARESETN        ( RST_N  ),
      .ACLK           ( CLK    ),

      // Write Address Channel
      .S_AXI_AWADDR   ( S_AXI_AWADDR   ),
      .S_AXI_AWCACHE  ( S_AXI_AWCACHE  ),
      .S_AXI_AWPROT   ( S_AXI_AWPROT   ),
      .S_AXI_AWVALID  ( S_AXI_AWVALID  ),
      .S_AXI_AWREADY  ( S_AXI_AWREADY  ),

      // Write Data Channel
      .S_AXI_WDATA    ( S_AXI_WDATA    ),
      .S_AXI_WSTRB    ( S_AXI_WSTRB    ),
      .S_AXI_WVALID   ( S_AXI_WVALID   ),
      .S_AXI_WREADY   ( S_AXI_WREADY   ),

      // Write Response Channel
      .S_AXI_BVALID   ( S_AXI_BVALID   ),
      .S_AXI_BREADY   ( S_AXI_BREADY   ),
      .S_AXI_BRESP    ( S_AXI_BRESP    ),

      // Read Address Channel
      .S_AXI_ARADDR   ( S_AXI_ARADDR   ),
      .S_AXI_ARCACHE  ( S_AXI_ARCACHE  ),
      .S_AXI_ARPROT   ( S_AXI_ARPROT   ),
      .S_AXI_ARVALID  ( S_AXI_ARVALID  ),
      .S_AXI_ARREADY  ( S_AXI_ARREADY  ),

      // Read Data Channel
      .S_AXI_RDATA    ( S_AXI_RDATA    ),
      .S_AXI_RRESP    ( S_AXI_RRESP    ),
      .S_AXI_RVALID   ( S_AXI_RVALID   ),
      .S_AXI_RREADY   ( S_AXI_RREADY   ),

      // Local Interface
      .LOCAL_CLK   ( local_clk   ),
      .LOCAL_CS    ( local_cs    ),
      .LOCAL_RNW   ( local_rnw   ),
      .LOCAL_ACK   ( local_ack   ),
      .LOCAL_ADDR  ( local_addr  ),
      .LOCAL_BE    ( local_be    ),
      .LOCAL_WDATA ( local_wdata ),
      .LOCAL_RDATA ( local_rdata )
      );

   // Tx FIFO
   wire        tx_write;
   wire [7:0]  tx_wdata;
   wire         tx_full;
   wire         tx_afull;
   wire         tx_empty;

   // Rx FIFO
   wire        rx_read;
   wire [7:0]   rx_rdata;
   wire         rx_empty;
   wire         rx_aempty;

   fmrv32im_axis_uart_ctl u_fmrv32im_axis_uart_ctl
	 (
  	  .RST_N       ( RST_N     ),
      .CLK         ( CLK       ),

  	  .LOCAL_CS    ( local_cs          ),
  	  .LOCAL_RNW   ( local_rnw         ),
   	  .LOCAL_ACK   ( local_ack         ),
      .LOCAL_ADDR  ( local_addr[15:0]  ),
   	  .LOCAL_BE    ( local_be[3:0]     ),
      .LOCAL_WDATA ( local_wdata[31:0] ),
      .LOCAL_RDATA ( local_rdata[31:0] ),

      // Tx FIFO
      .TX_WRITE  ( tx_write  ),
      .TX_WDATA  ( tx_wdata  ),
      .TX_FULL   ( tx_full   ),
      .TX_AFULL  ( tx_afull  ),
      .TX_EMPTY  ( tx_empty  ),

      // Rx FIFO
      .RX_READ   ( rx_read   ),
      .RX_RDATA  ( rx_rdata  ),
      .RX_EMPTY  ( rx_empty  ),
      .RX_AEMPTY ( rx_aempty ),

	    .INTERRUPT ( INTERRUPT ),

      .GPIO_I      ( GPIO_I      ),
      .GPIO_O      ( GPIO_O      ),
      .GPIO_OT     ( GPIO_OT      )
   );

  uartcon_top u_uart_top
    (
      .rst_n        ( RST_N ),
      .clk          ( CLK   ),
      .refclk       ( CLK   ),

      .txd          ( TXD   ),
      .rxd          ( RXD   ),

      // Tx FIFO
      .write        ( tx_write  ),
      .wdata        ( tx_wdata  ),
      .full         ( tx_full   ),
      .almost_full  ( tx_afull  ),
      .wempty       ( tx_empty  ),

      // Rx FIFO
      .read         ( rx_read   ),
      .rdata        ( rx_rdata  ),
      .empty        ( rx_empty  ),
      .almost_empty ( rx_aempty )
    );
endmodule
module fmrv32im_axis_uart_axils
  (
   // AXI4 Lite Interface
   input         ARESETN,
   input         ACLK,

    // Write Address Channel
   input [15:0]  S_AXI_AWADDR,
   input [3:0]   S_AXI_AWCACHE,
   input [2:0]   S_AXI_AWPROT,
   input         S_AXI_AWVALID,
   output        S_AXI_AWREADY,

   // Write Data Channel
   input [31:0]  S_AXI_WDATA,
   input [3:0]   S_AXI_WSTRB,
   input         S_AXI_WVALID,
   output        S_AXI_WREADY,

   // Write Response Channel
   output        S_AXI_BVALID,
   input         S_AXI_BREADY,
   output [1:0]  S_AXI_BRESP,

   // Read Address Channel
   input [15:0]  S_AXI_ARADDR,
   input [3:0]   S_AXI_ARCACHE,
   input [2:0]   S_AXI_ARPROT,
   input         S_AXI_ARVALID,
   output        S_AXI_ARREADY,

   // Read Data Channel
   output [31:0] S_AXI_RDATA,
   output [1:0]  S_AXI_RRESP,
   output        S_AXI_RVALID,
   input         S_AXI_RREADY,

   // Local Interface
   output        LOCAL_CLK,
   output        LOCAL_CS,
   output        LOCAL_RNW,
   input         LOCAL_ACK,
   output [31:0] LOCAL_ADDR,
   output [3:0]  LOCAL_BE,
   output [31:0] LOCAL_WDATA,
   input [31:0]  LOCAL_RDATA
  );

   localparam S_IDLE   = 2'd0;
   localparam S_WRITE  = 2'd1;
   localparam S_WRITE2 = 2'd2;
   localparam S_READ   = 2'd3;

   reg [1:0]     state;
   reg           reg_rnw;
   reg [15:0]    reg_addr;
   reg [31:0]    reg_wdata;
   reg [3:0]     reg_be;

   always @( posedge ACLK or negedge ARESETN ) begin
      if( !ARESETN ) begin
         state     <= S_IDLE;
         reg_rnw   <= 1'b0;
         reg_addr  <= 16'd0;
         reg_wdata <= 32'd0;
         reg_be    <= 4'd0;
      end else begin
         case( state )
           S_IDLE: begin
              if( S_AXI_AWVALID ) begin
                 reg_rnw   <= 1'b0;
                 reg_addr  <= S_AXI_AWADDR;
                 state     <= S_WRITE;
              end else if( S_AXI_ARVALID ) begin
                 reg_rnw   <= 1'b1;
                 reg_addr  <= S_AXI_ARADDR;
                 state     <= S_READ;
              end
           end
           S_WRITE: begin
              if( S_AXI_WVALID ) begin
                 state     <= S_WRITE2;
                 reg_wdata <= S_AXI_WDATA;
                 reg_be    <= S_AXI_WSTRB;
              end
           end
           S_WRITE2: begin
              if( LOCAL_ACK & S_AXI_BREADY ) begin
                 state     <= S_IDLE;
              end
           end
           S_READ: begin
              if( LOCAL_ACK & S_AXI_RREADY ) begin
                 state     <= S_IDLE;
              end
           end
           default: begin
              state        <= S_IDLE;
           end
         endcase
      end
   end

   // Local Interface
   assign LOCAL_CLK      = ACLK;
   assign LOCAL_CS       = (( state == S_WRITE2 )?1'b1:1'b0) | (( state == S_READ )?1'b1:1'b0) | 1'b0;
   assign LOCAL_RNW      = reg_rnw;
   assign LOCAL_ADDR     = reg_addr;
   assign LOCAL_BE       = reg_be;
   assign LOCAL_WDATA    = reg_wdata;

   // Write Channel
   assign S_AXI_AWREADY  = ( state == S_WRITE || state == S_IDLE )?1'b1:1'b0;
   assign S_AXI_WREADY   = ( state == S_WRITE || state == S_IDLE )?1'b1:1'b0;
   assign S_AXI_BVALID   = ( state == S_WRITE2 )?LOCAL_ACK:1'b0;
   assign S_AXI_BRESP    = 2'b00;

   // Read Channel
   assign S_AXI_ARREADY  = ( state == S_READ  || state == S_IDLE )?1'b1:1'b0;
   assign S_AXI_RVALID   = ( state == S_READ )?LOCAL_ACK:1'b0;
   assign S_AXI_RRESP    = 2'b00;
   assign S_AXI_RDATA    = ( state == S_READ )?LOCAL_RDATA:32'd0;
endmodule
module fmrv32im_axis_uart_ctl
  (
   input 		 RST_N,
   input 		 CLK,

   input 		     LOCAL_CS,
   input 		     LOCAL_RNW,
   output 		   LOCAL_ACK,
   input [15:0]  LOCAL_ADDR,
   input [3:0] 	 LOCAL_BE,
   input [31:0]  LOCAL_WDATA,
   output [31:0] LOCAL_RDATA,

   // Tx FIFO
   output        TX_WRITE,
   output [7:0]  TX_WDATA,
   input         TX_FULL,
   input         TX_AFULL,
   input         TX_EMPTY,

   // Rx FIFO
   output        RX_READ,
   input [7:0]   RX_RDATA,
   input         RX_EMPTY,
   input         RX_AEMPTY,

	 output        INTERRUPT,

   input [31:0]  GPIO_I,
   output [31:0] GPIO_O,
   output [31:0] GPIO_OT
   );

   localparam A_STATUS = 16'h00;
   localparam A_INTENA = 16'h04;
   localparam A_TXD    = 16'h08;
   localparam A_RXD    = 16'h0C;
   localparam A_RATE   = 16'h10;
   localparam A_GPIO_O  = 16'h100;
   localparam A_GPIO_I  = 16'h104;
   localparam A_GPIO_OT = 16'h108;

   wire wr_ena, rd_ena, wr_ack;
   reg rd_ack;
   reg [31:0] reg_rdata;
   reg wr_ack_d;

   assign wr_ena = (LOCAL_CS & ~LOCAL_RNW)?1'b1:1'b0;
   assign rd_ena = (LOCAL_CS &  LOCAL_RNW)?1'b1:1'b0;
   assign wr_ack = wr_ena;

   reg reg_int_ena_tx, reg_int_ena_rx;
   reg [31:0] reg_gpio_o, reg_gpio_ot;

   always @(posedge CLK or negedge RST_N) begin
	  if(!RST_N) begin
	  wr_ack_d <= 1'b0;
			reg_int_ena_rx <= 1'b0;
			reg_int_ena_tx <= 1'b0;
      reg_gpio_o <= 32'd0;
      reg_gpio_ot <= 32'd0;
	  end else begin
	    wr_ack_d <= wr_ena;
		 if(wr_ena) begin
			case(LOCAL_ADDR[15:0] & 16'hFFFC)
			  A_INTENA:
				begin
				   reg_int_ena_tx <= LOCAL_WDATA[1];
				   reg_int_ena_rx <= LOCAL_WDATA[0];
				end
        A_GPIO_O:
        begin
          reg_gpio_o <= LOCAL_WDATA;
        end
        A_GPIO_OT:
        begin
          reg_gpio_ot <= LOCAL_WDATA;
        end
			  default:
				begin
				end
			endcase
		 end

	  end
   end

   reg rd_ack_d;

   always @(posedge CLK or negedge RST_N) begin
	  if(!RST_N) begin
		 rd_ack <= 1'b0;
		 rd_ack_d <= 1'b0;
		 reg_rdata[31:0] <= 32'd0;
	  end else begin
			rd_ack <= rd_ena;
			case(LOCAL_ADDR[15:0] & 16'hFFFC)
			  A_STATUS: reg_rdata[31:0] <= {16'd0, 5'd0, TX_EMPTY, TX_AFULL, TX_FULL, 6'd0, RX_AEMPTY, RX_EMPTY};
			  A_INTENA: reg_rdata[31:0] <= {30'd0, reg_int_ena_tx, reg_int_ena_rx};
			  A_TXD:    reg_rdata[31:0] <= 32'd0;
			  A_RXD:    reg_rdata[31:0] <= {24'd0, RX_RDATA};
        A_GPIO_O:  reg_rdata[31:0] <= reg_gpio_o;
        A_GPIO_I:  reg_rdata[31:0] <= GPIO_I;
        A_GPIO_OT: reg_rdata[31:0] <= reg_gpio_ot;
			  default:  reg_rdata[31:0]  <= 32'd0;
			endcase
	  end
   end

   assign LOCAL_ACK         = (wr_ack | rd_ack);
   assign LOCAL_RDATA[31:0] = reg_rdata[31:0];

	 assign TX_WRITE = wr_ena & ~wr_ack_d & ((LOCAL_ADDR[7:0] & 8'hFC) == A_TXD);
	 assign TX_WDATA = LOCAL_WDATA[7:0];

	 assign RX_READ  = rd_ena & ~rd_ack & ((LOCAL_ADDR[7:0] & 8'hFC) == A_RXD);

	 assign INTERRUPT = (reg_int_ena_tx & TX_FULL) | (reg_int_ena_rx & RX_EMPTY);

   assign GPIO_O  = reg_gpio_o;
   assign GPIO_OT = reg_gpio_ot;
endmodule
module uartcon_top
  (
   input        rst_n,
   input        clk,
   input        refclk,

   output       txd,
   input        rxd,

   // Tx FIFO
   input        write,
   input [7:0]  wdata,
   output       full,
   output       almost_full,
   output       wempty,

   // Rx FIFO
   input        read,
   output [7:0] rdata,
   output       empty,
   output       almost_empty
   );

   wire         uart_clk;

   wire [7:0]   tx_data;
   wire         tx_empty, tx_almost_empty;
   wire         load;

   wire [7:0]   rx_data;
   wire         rx_full, rx_almost_full;
   wire         save;

   reg			tx_empty_reg;
   reg			tx_empty_d1, tx_empty_d2;

   always @(posedge clk or negedge rst_n) begin
	  if(!rst_n) begin
		 tx_empty_reg <= 1'b1;
		 tx_empty_d1 <= 1'b0;
		 tx_empty_d2 <= 1'b0;
	  end else begin
		 tx_empty_d1 <= tx_empty;
		 tx_empty_d2 <= tx_empty_d1;
		 if((tx_empty_d2 == 1'b0) && (tx_empty_d1 == 1'b1)) begin
			tx_empty_reg <= 1'b1;
		 end else if(write == 1'b1) begin
			tx_empty_reg <= 1'b0;
		 end
	  end
   end
   assign wempty = tx_empty_reg;

   uartcon_clk u_uartcon_clk
     (
      .rst_n      ( rst_n     ),
      .clk        ( refclk    ),
      .out_clk    ( uart_clk  )
      );

   // Tx FIFO
   uartcon_fifo
     #(
       .FIFO_DEPTH(7), // 64depth
       .FIFO_WIDTH(8)  // 8bit
       )
   u_tx_fifo
     (
      .RST_N              ( rst_n             ),
      .FIFO_WR_CLK        ( clk               ),
      .FIFO_WR_ENA        ( write             ),
      .FIFO_WR_LAST       ( 1'b1              ),
      .FIFO_WR_DATA       ( wdata[7:0]        ),
      .FIFO_WR_FULL       ( full              ),
      .FIFO_WR_ALM_FULL   ( almost_full       ),
      .FIFO_WR_ALM_COUNT  ( 7'd1              ),
      .FIFO_RD_CLK        ( uart_clk          ),
      .FIFO_RD_ENA        ( load              ),
      .FIFO_RD_DATA       ( tx_data[7:0]      ),
      .FIFO_RD_EMPTY      ( tx_empty          ),
      .FIFO_RD_ALM_EMPTY  ( tx_almost_empty   ),
      .FIFO_RD_ALM_COUNT  ( 7'd1              )
      );

   // Rx FIFO
   uartcon_fifo
     #(
       .FIFO_DEPTH(7), // 64depth
       .FIFO_WIDTH(8)  // 8bit
       )
   u_rx_fifo
     (
      .RST_N              ( rst_n             ),
      .FIFO_WR_CLK        ( uart_clk          ),
      .FIFO_WR_ENA        ( save              ),
      .FIFO_WR_LAST       ( 1'b1              ),
      .FIFO_WR_DATA       ( rx_data[7:0]      ),
      .FIFO_WR_FULL       ( rx_full           ),
      .FIFO_WR_ALM_FULL   ( rx_almost_full    ),
      .FIFO_WR_ALM_COUNT  ( 7'd1              ),
      .FIFO_RD_CLK        ( clk               ),
      .FIFO_RD_ENA        ( read              ),
      .FIFO_RD_DATA       ( rdata[7:0]        ),
      .FIFO_RD_EMPTY      ( empty             ),
      .FIFO_RD_ALM_EMPTY  ( almost_empty      ),
      .FIFO_RD_ALM_COUNT  ( 7'd1              )
      );

    uartcon_tx u_uartcon_tx
      (
       .rst_n  ( rst_n         ),
       .clk    ( uart_clk      ),
       .txd    ( txd           ),
       .valid  ( ~tx_empty     ),
       .load   ( load          ),
       .data   ( tx_data[7:0]  )
    );

    uartcon_rx u_uartcon_rx
      (
       .rst_n  ( rst_n         ),
       .clk    ( uart_clk      ),
       .rxd    ( rxd           ),
       .valid  ( save          ),
       .data   ( rx_data[7:0]  )
       );

endmodule
module uartcon_clk
  (
   input  rst_n,
   input  clk,

   output reg out_clk
   );

   // out_clk = Rate x 16[Hz]

   reg [7:0] count;

   // RESET_COUNT
   //  RESET_COUNT = (Freq[Hz] / Rate[Hz]) / 8 - 1
   parameter RESET_COUNT = 8'd107;

   always @(posedge clk or negedge rst_n) begin
      if(!rst_n) begin
         count[7:0]  <= 8'd0;
         out_clk     <= 1'b0;
      end else begin
         if(count[7:0] == RESET_COUNT) begin
            count[7:0]  <= 8'd0;
            out_clk     <= ~out_clk;
         end else begin
            count[7:0]  <= count[7:0] + 8'd1;
         end
      end
   end

endmodule
module uartcon_rx
  (
   input        rst_n,
   input        clk,

   input        rxd,

   output       valid,
   output [7:0] data
   );

   reg [2:0]    reg_rxd;
   reg [1:0]    sample_count;
   reg [2:0]    bit_count;
   reg [7:0]    rx_data;
   reg [3:0]    state;

   localparam S_IDLE    = 4'd0;
   localparam S_START   = 4'd1;
   localparam S_DATA    = 4'd2;
   localparam S_STOP    = 4'd3;
   localparam S_LAST    = 4'd4;

   wire         detect_startbit, sample_point;

   // Free MetasTable
   always @(posedge clk or negedge rst_n) begin
      if(!rst_n) begin
         reg_rxd[2:0] <= 3'd0;
      end else begin
         reg_rxd[2:0] <= {reg_rxd[1:0], rxd};
      end
   end

   // Detect Start Bit
   assign detect_startbit = (state == S_IDLE) && (reg_rxd[2] == 1'b1) && (reg_rxd[1] == 1'b0);

   // Sample Counter
   always @(posedge clk or negedge rst_n) begin
      if(!rst_n) begin
         sample_count[1:0] <= 2'd0;
      end else begin
         if(detect_startbit == 1'b1) begin
            sample_count[1:0] <= 2'd0;
         end else begin
            sample_count[1:0] <= sample_count[1:0] + 2'd1;
         end
      end
   end

   // Sample Point
   assign sample_point = (sample_count[1:0] == 2'd0)?1'b1:1'b0;

   always @(posedge clk or negedge rst_n) begin
      if(!rst_n) begin
         state <= S_IDLE;
         bit_count[2:0] <= 3'd0;
         rx_data[7:0] <= 8'd0;
      end else begin
         case(state)
           S_IDLE: begin
              if(detect_startbit == 1'b1) begin
                 state <= S_START;
                 bit_count[2:0] <= 3'd0;
              end
           end
           S_START: begin
              if(sample_point == 1'b1) begin
                 if(reg_rxd[1] == 1'b0) begin
                    // Start Bit
                    state <= S_DATA;
                 end else begin
                    // MetasTable?
                    state <= S_IDLE;
                 end
              end
           end
           S_DATA: begin
              if(sample_point == 1'b1) begin
                 rx_data[7:0] <= {reg_rxd[1], rx_data[7:1]};
                 if(bit_count[2:0] == 3'd7) begin
                    state <= S_STOP;
                 end else begin
                    bit_count[2:0] <= bit_count[2:0] + 3'd1;
                 end
              end
           end
           S_STOP: begin
              if(sample_point == 1'b1) begin
                 if(reg_rxd[1] == 1'b1) begin
                    state <= S_LAST;
                 end else begin
                    // Receive Error?
                    state <= S_IDLE;
                 end
              end
           end
           S_LAST: begin
              state <= S_IDLE;
           end
         endcase
      end
   end

   assign valid = (state == S_LAST)?1'b1:1'b0;
   assign data[7:0] = rx_data[7:0];

endmodule
module uartcon_tx
  (
   input       rst_n,
   input       clk,

   output      txd,

   input       valid,
   output reg load,
   input [7:0] data
   );

   reg [1:0]   sample_count;
   reg [2:0]   bit_count;
   reg [7:0]   tx_data;

   wire        sample_point;

   reg [3:0]   state;

   localparam S_IDLE    = 4'd0;
   localparam S_START   = 4'd1;
   localparam S_DATA    = 4'd2;
   localparam S_STOP    = 4'd3;
   localparam S_LAST    = 4'd4;

   reg         out_data;

   always @(posedge clk or negedge rst_n) begin
      if(!rst_n) begin
         sample_count[1:0] <= 2'd0;
         bit_count[2:0] <= 3'd0;
      end else begin
         if(state != S_IDLE) begin
            sample_count[1:0] <= sample_count[1:0] + 2'd1;
         end else begin
            sample_count[1:0] <= 2'd0;
         end
         if(state == S_DATA) begin
            if(sample_point == 1'b1) begin
               bit_count[2:0] <= bit_count[2:0] + 3'd1;
            end
         end else begin
            bit_count[2:0] <= 3'd0;
         end
      end
   end

   assign sample_point = (sample_count[1:0] == 2'd3)?1'b1:1'b0;

   always @(posedge clk or negedge rst_n) begin
      if(!rst_n) begin
         state <= S_IDLE;
         tx_data[7:0] <= 8'd0;
         load <= 1'b0;
         out_data <= 1'b1;
      end else begin
         case(state)
           S_IDLE: begin
              if(valid == 1'b1) begin
                 state <= S_START;
                 tx_data[7:0] <= data[7:0];
                 load <= 1'b1;
              end
           end
           S_START: begin
              load <= 1'b0;
              out_data <= 1'b0;
              if(sample_point == 1'b1) begin
                 state <= S_DATA;
              end
           end
           S_DATA: begin
              out_data <= tx_data[0];
              if(sample_point == 1'b1) begin
                 tx_data[7:0] <= {1'b0, tx_data[7:1]};
                 if(bit_count[2:0] == 3'd7) begin
                    state <= S_STOP;
                 end
              end
           end
           S_STOP: begin
              out_data <= 1'b1;
              if(sample_point == 1'b1) begin
                 state <= S_LAST;
              end
           end
           S_LAST: begin
              out_data <= 1'b1;
              if(sample_point == 1'b1) begin
                 state <= S_IDLE;
              end
           end

         endcase
      end
   end

   assign txd = out_data;

endmodule

module uartcon_fifo
#(
	parameter FIFO_DEPTH	= 8,
	parameter FIFO_WIDTH	= 32
)
(
	input							RST_N,

	input							FIFO_WR_CLK,
	input							FIFO_WR_ENA,
	input [FIFO_WIDTH -1:0]		FIFO_WR_DATA,
	input							FIFO_WR_LAST,
	output 						FIFO_WR_FULL,
	output 						FIFO_WR_ALM_FULL,
	input [FIFO_DEPTH -1:0]		FIFO_WR_ALM_COUNT,

	input 							FIFO_RD_CLK,
	input 							FIFO_RD_ENA,
	output [FIFO_WIDTH -1:0]	FIFO_RD_DATA,
	output 						FIFO_RD_EMPTY,
	output 						FIFO_RD_ALM_EMPTY,
	input [FIFO_DEPTH -1:0]		FIFO_RD_ALM_COUNT
);
	reg [FIFO_DEPTH -1:0]	wr_adrs, wr_rd_count_d1r, wr_rd_count;
	reg 						wr_full, wr_alm_full;

	reg [FIFO_DEPTH -1:0]	rd_adrs, rd_wr_count_d1r, rd_wr_count;
	reg 						rd_empty, rd_alm_empty;

	wire 						wr_ena;
	reg 						wr_ena_req;
	reg [FIFO_DEPTH -1:0]	wr_adrs_req;
	wire 						rd_wr_ena, rd_wr_ena_ack;
	reg 						rd_wr_ena_d1r, rd_wr_ena_d2r, rd_wr_ena_d3r;
	reg							rd_wr_full_d1r, rd_wr_full;

	wire						rd_ena;
	reg 						rd_ena_req;
	reg [FIFO_DEPTH -1:0]	rd_adrs_req;
	wire 						wr_rd_ena, wr_rd_ena_ack;
	reg 						wr_rd_ena_d1r, wr_rd_ena_d2r, wr_rd_ena_d3r;
	reg							wr_rd_empty_d1r, wr_rd_empty;

	wire						reserve_ena;
	reg							reserve_empty, reserve_read;
	wire						reserve_alm_empty;
	reg [FIFO_WIDTH -1:0]	reserve_data;

	wire [FIFO_WIDTH -1:0]	rd_fifo;

	assign wr_ena = (!wr_full)?(FIFO_WR_ENA):1'b0;

	/////////////////////////////////////////////////////////////////////
	// Write Block

	// Write Address
	always @(posedge FIFO_WR_CLK or negedge RST_N) begin
		if(!RST_N) begin
			wr_adrs				<= 0;
		end else begin
			if(wr_ena) wr_adrs	<= wr_adrs + 1;
		end
	end

	wire [FIFO_DEPTH -1:0] wr_adrs_s1, wr_adrs_s2;
	assign wr_adrs_s1 = wr_rd_count;
	assign wr_adrs_s2 = wr_rd_count -1;

	// make a full and almost full signal
	always @(posedge FIFO_WR_CLK or negedge RST_N) begin
		if(!RST_N) begin
			wr_full			<= 1'b0;
			wr_alm_full		<= 1'b0;
		end else begin
			if(wr_ena & (wr_adrs == wr_adrs_s1)) begin
				wr_full		<= 1'b1;
			end else if(wr_rd_ena & !(wr_adrs == wr_adrs_s1)) begin
				wr_full		<= 1'b0;
			end
			if(wr_ena & ((wr_adrs == wr_adrs_s1) | (wr_adrs == wr_adrs_s2))) begin
				wr_alm_full	<= 1'b1;
			end else if(wr_rd_ena & !((wr_adrs == wr_adrs_s1) | (wr_adrs == wr_adrs_s2))) begin
				wr_alm_full	<= 1'b0;
			end
		end
	end
	// Read Control signal from Read Block
	always @(posedge FIFO_WR_CLK or negedge RST_N) begin
		if(!RST_N) begin
			wr_rd_count_d1r	<= {FIFO_DEPTH{1'b1}};
			wr_rd_count		<= {FIFO_DEPTH{1'b1}};
		end else begin
			wr_rd_ena_d1r		<= rd_ena_req;
			wr_rd_ena_d2r		<= wr_rd_ena_d1r;
			wr_rd_ena_d3r		<= wr_rd_ena_d2r;
			if(wr_rd_ena) begin
				wr_rd_count	<= rd_adrs_req;
				wr_rd_empty	<= rd_empty;
			end
		end
	end
	assign wr_rd_ena		= wr_rd_ena_d2r & ~wr_rd_ena_d3r;
	assign wr_rd_ena_ack	= wr_rd_ena_d2r & wr_rd_ena_d3r;

	wire [FIFO_DEPTH -1:0] wr_adrs_req_s1;
	assign wr_adrs_req_s1 = wr_adrs -1;

	// Send a write enable signal for Read Block
	always @(posedge FIFO_WR_CLK or negedge RST_N) begin
		if(!RST_N) begin
			wr_ena_req		<= 1'b0;
			wr_adrs_req		<= 0;
		end else begin
			if(wr_ena & FIFO_WR_LAST & ~rd_wr_ena_ack) begin
				wr_ena_req	<= 1'b1;
				wr_adrs_req	<= wr_adrs;
			end else if(rd_wr_ena_ack) begin
				wr_ena_req	<= 1'b0;
			end
		end
	end

	/////////////////////////////////////////////////////////////////////
	// Read Block
	reg rd_empty_d;

	// Read Address
	always @(posedge FIFO_RD_CLK or negedge RST_N) begin
		if(!RST_N) begin
			rd_adrs		<= 0;
		end else begin
			if(!rd_empty_d & rd_ena) begin
				rd_adrs	<= rd_adrs + 1;
			end
		end
	end

	wire [FIFO_DEPTH -1:0] rd_adrs_s1, rd_adrs_s2;
	assign rd_adrs_s1 = rd_wr_count;
	assign rd_adrs_s2 = rd_wr_count -1;

	// make a empty and almost empty signal
	always @(posedge FIFO_RD_CLK or negedge RST_N) begin
		if(!RST_N) begin
			rd_empty		<= 1'b1;
			rd_empty_d	<= 1'b1;
			rd_alm_empty	<= 1'b1;
		end else begin
			if(rd_ena & (rd_adrs == rd_adrs_s1)) begin
				rd_empty_d	<= 1'b1;
			end else if(rd_wr_ena & !(rd_adrs == rd_adrs_s1)) begin
				rd_empty_d	<= 1'b0;
			end
			rd_empty <= rd_empty_d;
			if(rd_ena & ((rd_adrs == rd_adrs_s1) | (rd_adrs == rd_adrs_s2))) begin
				rd_alm_empty	<= 1'b1;
			end else if(rd_wr_ena & !((rd_adrs == rd_adrs_s1) | (rd_adrs == rd_adrs_s2))) begin
				rd_alm_empty	<= 1'b0;
			end
		end
	end

	// Write Control signal from Write Block
	always @(posedge FIFO_RD_CLK or negedge RST_N) begin
		if(!RST_N) begin
			rd_wr_ena_d1r		<= 1'b0;
			rd_wr_ena_d2r		<= 1'b0;
			rd_wr_ena_d3r		<= 1'b0;
			rd_wr_count_d1r	<= {FIFO_DEPTH{1'b1}};
			rd_wr_count		<= {FIFO_DEPTH{1'b1}};
		end else begin
			rd_wr_ena_d1r		<= wr_ena_req;
			rd_wr_ena_d2r		<= rd_wr_ena_d1r;
			rd_wr_ena_d3r		<= rd_wr_ena_d2r;
			if(rd_wr_ena) begin
				rd_wr_count	<= wr_adrs_req;
				rd_wr_full	<= wr_full;
			end
		end
	end

	// Write enable signal from write block
	assign rd_wr_ena		= ~rd_wr_ena_d3r & rd_wr_ena_d2r;
	assign rd_wr_ena_ack	= rd_wr_ena_d3r & rd_wr_ena_d2r;

	wire [FIFO_DEPTH -1:0] rd_adrs_req_s1;
	assign rd_adrs_req_s1 = rd_adrs -1;

	// Send a read enable signal for Write Block
	always @(posedge FIFO_RD_CLK or negedge RST_N) begin
		if(!RST_N) begin
			rd_ena_req	<= 1'b0;
			rd_adrs_req	<= 0;
		end else begin
			if(~rd_ena_req & (rd_adrs_req != rd_adrs_req_s1) & ~wr_rd_ena_ack) begin
				rd_ena_req	<= 1'b1;
				rd_adrs_req	<= rd_adrs_req_s1;
			end else if(wr_rd_ena_ack) begin
				rd_ena_req	<= 1'b0;
			end
		end
	end

	/////////////////////////////////////////////////////////////////////
	// Reserve Block
	reg reserve_empty_d;
	reg reserve_rdena;
	assign reserve_ena = reserve_empty_d & ~rd_empty & ~FIFO_RD_ENA;
//	assign rd_ena = reserve_ena | FIFO_RD_ENA;
   assign rd_ena = reserve_ena;
	always @(posedge FIFO_RD_CLK or negedge RST_N) begin
		if(!RST_N) begin
			reserve_data			<= {FIFO_WIDTH{1'b0}};
			reserve_empty			<= 1'b1;
			reserve_rdena			<= 1'b0;
			reserve_empty_d		<= 1'b1;
		end else begin
			if(rd_ena) begin
				reserve_data		<= rd_fifo;
			end
			if(reserve_ena) begin
				reserve_empty_d	<= 1'b0;
			end else if(FIFO_RD_ENA) begin
				reserve_empty_d	<= 1'b1;
			end
			if(FIFO_RD_ENA) begin
				reserve_empty		<= 1'b1;
			end else begin
				reserve_empty		<= reserve_empty_d;
			end
			reserve_rdena			<= FIFO_RD_ENA;
		end
	end

	assign reserve_alm_empty = (rd_empty & ~reserve_empty);
	/////////////////////////////////////////////////////////////////////
	// output signals
	assign FIFO_WR_FULL			= wr_full;
	assign FIFO_WR_ALM_FULL		= wr_alm_full;
	assign FIFO_RD_EMPTY			= (FIFO_RD_ENA)?rd_empty:reserve_empty;
	assign FIFO_RD_ALM_EMPTY	= (FIFO_RD_ENA)?rd_alm_empty:reserve_alm_empty;
	assign FIFO_RD_DATA			= (reserve_empty)?rd_fifo:reserve_data;

	/////////////////////////////////////////////////////////////////////
	// RAM
	fifo_ram #(FIFO_DEPTH,FIFO_WIDTH) u_fifo_ram(
		.WR_CLK  ( FIFO_WR_CLK  ),
		.WR_ENA  ( wr_ena  ),
		.WR_ADRS ( wr_adrs ),
		.WR_DATA ( FIFO_WR_DATA ),

		.RD_CLK  ( FIFO_RD_CLK  ),
		.RD_ADRS ( rd_adrs ),
		.RD_DATA ( rd_fifo )
		);

endmodule

module fifo_ram
#(
	parameter DEPTH	= 12,
	parameter WIDTH	= 32
)
(
	input					WR_CLK,
	input					WR_ENA,
	input [DEPTH -1:0] 	WR_ADRS,
	input [WIDTH -1:0]	WR_DATA,

	input 					RD_CLK,
	input [DEPTH -1:0] 	RD_ADRS,
	output [WIDTH -1:0]	RD_DATA
);
	reg [WIDTH -1:0]		ram [0:(2**DEPTH) -1];
	reg [WIDTH -1:0]		rd_reg;

	always @(posedge WR_CLK) begin
		if(WR_ENA) ram[WR_ADRS] <= WR_DATA;
	end

	always @(posedge RD_CLK) begin
		rd_reg <= ram[RD_ADRS];
	end

	assign RD_DATA = rd_reg;
endmodule
