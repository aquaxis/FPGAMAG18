module fmrv32im_csr
  (
   input              RST_N,
   input              CLK,

   input [11:0]       CSR_ADDR,
   input              CSR_WE,
   input [31:0]       CSR_WDATA,
   input [31:0]       CSR_WMASK,
   output reg [31:0]  CSR_RDATA,

   input              EXT_INTERRUPT,
   input              SW_INTERRUPT,
   input [31:0]       SW_INTERRUPT_PC,
   input              EXCEPTION,
   input [11:0]       EXCEPTION_CODE,
   input [31:0]       EXCEPTION_ADDR,
   input [31:0]       EXCEPTION_PC,
   input              TIMER_EXPIRED,
   input              RETIRE,

   output wire [31:0] HANDLER_PC,
   output wire [31:0] EPC,
   output wire        INTERRUPT_PENDING,
   output wire        INTERRUPT,

   output             ILLEGAL_ACCESS
   );

   /* ------------------------------------------------------------ *
	* Machine mode register                                        *
	* ------------------------------------------------------------ */
   // Machine Information Register
   wire [31:0]        mvendorid;
   wire [31:0]        marchid;
   wire [31:0]        mimpid;
   wire [31:0]        mhartid;
   // Machine Trap Setup
   wire [31:0]        mstatus;
   wire [31:0]        misa;
   reg [31:0]         medeleg;
   reg [31:0]         mideleg;
   wire [31:0]         mie;
   reg [31:0]         mtvec;
   // Machine Trap Handlling
   reg [31:0]         mscratch;
   reg [31:0]         mepc;
   reg [31:0]         mcause;
   reg [31:0]         mbadaddr;
   wire [31:0]         mip;
   // Machine Protction and Trnslation
   wire [31:0]         mbase;
   wire [31:0]         mbound;
   wire [31:0]         mibase;
   wire [31:0]         mibound;
   wire [31:0]         mdbase;
   wire [31:0]         mdbound;
   // Machine Counter/Timer
   reg [63:0]         mcycle;
   reg [63:0]         minstret;
   wire [63:0]         mhpmcounter3;
   wire [63:0]         mhpmcounter4;
   wire [63:0]         mhpmcounter5;
   wire [63:0]         mhpmcounter6;
   wire [63:0]         mhpmcounter7;
   wire [63:0]         mhpmcounter8;
   wire [63:0]         mhpmcounter9;
   wire [63:0]         mhpmcounter10;
   wire [63:0]         mhpmcounter11;
   wire [63:0]         mhpmcounter12;
   wire [63:0]         mhpmcounter13;
   wire [63:0]         mhpmcounter14;
   wire [63:0]         mhpmcounter15;
   wire [63:0]         mhpmcounter16;
   wire [63:0]         mhpmcounter17;
   wire [63:0]         mhpmcounter18;
   wire [63:0]         mhpmcounter19;
   wire [63:0]         mhpmcounter20;
   wire [63:0]         mhpmcounter21;
   wire [63:0]         mhpmcounter22;
   wire [63:0]         mhpmcounter23;
   wire [63:0]         mhpmcounter24;
   wire [63:0]         mhpmcounter25;
   wire [63:0]         mhpmcounter26;
   wire [63:0]         mhpmcounter27;
   wire [63:0]         mhpmcounter28;
   wire [63:0]         mhpmcounter29;
   wire [63:0]         mhpmcounter30;
   wire [63:0]         mhpmcounter31;
   // Machine Counter Setup
   wire [31:0]         mucounteren;
   wire [31:0]         mscounteren;
   wire [31:0]         mhcounteren;
   wire [31:0]         mhpmevent3;
   wire [31:0]         mhpmevent4;
   wire [31:0]         mhpmevent5;
   wire [31:0]         mhpmevent6;
   wire [31:0]         mhpmevent7;
   wire [31:0]         mhpmevent8;
   wire [31:0]         mhpmevent9;
   wire [31:0]         mhpmevent10;
   wire [31:0]         mhpmevent11;
   wire [31:0]         mhpmevent12;
   wire [31:0]         mhpmevent13;
   wire [31:0]         mhpmevent14;
   wire [31:0]         mhpmevent15;
   wire [31:0]         mhpmevent16;
   wire [31:0]         mhpmevent17;
   wire [31:0]         mhpmevent18;
   wire [31:0]         mhpmevent19;
   wire [31:0]         mhpmevent20;
   wire [31:0]         mhpmevent21;
   wire [31:0]         mhpmevent22;
   wire [31:0]         mhpmevent23;
   wire [31:0]         mhpmevent24;
   wire [31:0]         mhpmevent25;
   wire [31:0]         mhpmevent26;
   wire [31:0]         mhpmevent27;
   wire [31:0]         mhpmevent28;
   wire [31:0]         mhpmevent29;
   wire [31:0]         mhpmevent30;
   wire [31:0]         mhpmevent31;
   // Debug/Trace Register
   wire [31:0]         tselect;
   wire [31:0]         tdata1;
   wire [31:0]         tdata2;
   wire [31:0]         tdata3;
   // Debug Mode Register
   wire [31:0]         dcsr;
   wire [31:0]         dpc;
   wire [31:0]         dscratch;

   // mvendorid(F11h), marchid(F12h), mimpid(F13h), mhartid(F14h)
   assign mvendorid = 32'd0;
   assign marchid   = 32'd0;
   assign mimpid    = 32'd0;
   assign mhartid   = 32'd0;

   // mstatus(300h)
   reg [1:0]           ms_mpp;
   reg                 ms_mpie;
   reg                 ms_mie;
   always @(posedge CLK) begin
      if(!RST_N) begin
         ms_mpp  <= 0;
         ms_mpie <= 0;
         ms_mie  <= 0;
      end else begin
         if(CSR_WE & (CSR_ADDR == 12'h300)) begin
            ms_mpp[1:0] <= CSR_WDATA[12:11]; // MPP[1:0]
            ms_mpie     <= CSR_WDATA[7];     // MPIE
            ms_mie      <= CSR_WDATA[3];     // MIE
         end
      end
   end // always @ (posedge CLK)
   assign mstatus = {19'd0, ms_mpp[1:0], 3'd0, ms_mpie, 3'd0, ms_mie, 3'd0};


   // misa(301h)
   assign misa = {2'b01,   // base 32bit
                  4'b0000, // WIRI
                  26'b00_0000_0000_0001_0000_0001_0000}; // E,M

   // medeleg(302h), mideleg(303h)
   always @(posedge CLK) begin
      if(!RST_N) begin
         mideleg <= 0;
         medeleg <= 0;
      end else begin
         if(CSR_WE & (CSR_ADDR == 12'h302)) begin
            medeleg <= CSR_WDATA;
         end
         if(CSR_WE & (CSR_ADDR == 12'h303)) begin
            mideleg <= CSR_WDATA;
         end
      end
   end

   // mie(304h)
   reg meie, mtie, msie;
   always @(posedge CLK) begin
      if(!RST_N) begin
         meie <= 0;
         mtie <= 0;
         msie <= 0;
      end else begin
         if(CSR_WE & (CSR_ADDR == 12'h304)) begin
            meie <= CSR_WDATA[11]; // MEIE(M-mode Exception Interrupt Enablee)
            mtie <= CSR_WDATA[7];  // MTIE(M-mode Timer Interrupt Enable)
            msie <= CSR_WDATA[3];  // MSIE(M-mode Software Interrupt Enable)
         end
      end
   end // always @ (posedge CLK)
   assign mie = {20'd0, meie, 3'd0, mtie, 3'd0, msie, 3'd0};

   // mtvec(305h)
   always @(posedge CLK) begin
      if(!RST_N) begin
         mtvec <= 0;
      end else begin
         if(CSR_WE & (CSR_ADDR == 12'h305)) begin
            mtvec <= CSR_WDATA;
         end
      end
   end
   assign HANDLER_PC = mtvec;

   // mscratch(340h)
   always @(posedge CLK) begin
      if(!RST_N) begin
         mscratch <= 0;
      end else begin
         if(CSR_WE & (CSR_ADDR == 12'h340)) begin
            mscratch <= CSR_WDATA;
         end
      end
   end

   // mepc(341h)
   always @(posedge CLK) begin
      if(!RST_N) begin
         mepc <= 0;
      end else begin
         if(INTERRUPT) begin
            mepc <= (EXCEPTION_PC & {{30{1'b1}},2'b0}) + 32'd4;
         end else if(SW_INTERRUPT) begin
            mepc <= (SW_INTERRUPT_PC & {{30{1'b1}},2'b0}) + 32'd4;
         end else if(EXCEPTION) begin
            mepc <= (EXCEPTION_PC & {{30{1'b1}},2'b0});
         end else if(CSR_WE & (CSR_ADDR == 12'h341)) begin
            mepc <= (CSR_WDATA & {{30{1'b1}},2'b0});
         end
      end
   end
   assign EPC = mepc;

   // mcause(342h)
   always @(posedge CLK) begin
      if(!RST_N) begin
         mcause <= 0;
      end else begin
         if(INTERRUPT) begin
            mcause[31]   <= 1'b1;
            mcause[11]   <= EXT_INTERRUPT;
            mcause[10:8] <= 3'd0;
            mcause[7]    <= TIMER_EXPIRED;
            mcause[6:4]  <= 3'd0;
            mcause[3]    <= 1'b0;
            mcause[2:0]  <= 3'd0;
         end else if(EXCEPTION) begin
            mcause[31]   <= 1'b0;
            mcause[11:0] <= EXCEPTION_CODE;
         end else if(CSR_WE & (CSR_ADDR == 12'h342)) begin
            mcause[31]   <= CSR_WDATA[31];
            mcause[11:0] <= CSR_WDATA[11:0];
         end
      end
   end

   // mbadaddr(343h)
   always @(posedge CLK) begin
      if(!RST_N) begin
         mbadaddr <= 0;
      end else begin
         if(EXCEPTION) begin
            mbadaddr <= (|EXCEPTION_CODE[3:0])?EXCEPTION_PC:EXCEPTION_ADDR;
         end else if(CSR_WE & (CSR_ADDR == 12'h343)) begin
            mbadaddr <= CSR_WDATA;
         end
      end
   end

   // mip(344h)
   reg meip, mtip, msip;
   always @(posedge CLK) begin
      if(!RST_N) begin
         meip <= 0;
         mtip <= 0;
         msip <= 0;
      end else begin
         // MEIP
         if(EXT_INTERRUPT) begin
            meip <= 1'b1;
         end else if(CSR_WE & (CSR_ADDR == 12'h344)) begin
            meip <= CSR_WDATA[11];
         end
         // MTIP
         if(TIMER_EXPIRED) begin
            mtip <= 1'b1;
         end else if(CSR_WE & (CSR_ADDR == 12'h344)) begin
            mtip <= CSR_WDATA[7];
         end
         // MSIP
         if(SW_INTERRUPT) begin
            msip <= 1'b1;
         end else if(CSR_WE & (CSR_ADDR == 12'h344)) begin
            msip <= CSR_WDATA[3];
         end
      end
   end // always @ (posedge CLK)
   assign mip = {20'd0, meip, 3'd0, mtip, 3'd0, msip, 3'd0};
   assign INTERRUPT = mstatus[3] & (|(mie & mip));
   assign INTERRUPT_PENDING = |mip;

   // mbase(380h), mbound(381h), mibase(382h), mibound(383h), mdbase(384h), mdbound(385h)
   assign mbase   = 32'd0;
   assign mbound  = 32'd0;
   assign mibase  = 32'd0;
   assign mibound = 32'd0;
   assign mdbase  = 32'd0;
   assign mdbound = 32'd0;

   // mcycle(B00h,B20h)
   always @(posedge CLK) begin
      if(!RST_N) begin
         mcycle <= 0;
      end else begin
         if(CSR_WE & (CSR_ADDR == 12'hB00)) begin
            mcycle[31:0]  <= CSR_WDATA;
         end else if(CSR_WE & (CSR_ADDR == 12'hB20)) begin
            mcycle[63:32] <= CSR_WDATA;
         end else begin
            mcycle <= mcycle + 64'd1;
         end
      end
   end

   // minstret(B02h, B22h)
   always @(posedge CLK) begin
      if(!RST_N) begin
         minstret <= 0;
      end else begin
         if(CSR_WE & (CSR_ADDR == 12'hB02)) begin
            minstret[31:0]  <= CSR_WDATA;
         end else if(CSR_WE & (CSR_ADDR == 12'hB20)) begin
            minstret[63:32] <= CSR_WDATA;
         end else begin
            if(RETIRE) begin
               minstret <= minstret + 64'd1;
            end
         end
      end
   end

   // mucounteren(320h), mscounteren(321h), mhcounteren(322h)
   assign mucounteren = 32'd0;
   assign mscounteren = 32'd0;
   assign mhcounteren = 32'd0;

   // mhpmcounter3-31(B803h-B1Fh), mhpmevent3-31(323h-33Fh)
   assign mhpmcounter3 = 64'd0;
   assign mhpmcounter4 = 64'd0;
   assign mhpmcounter5 = 64'd0;
   assign mhpmcounter6 = 64'd0;
   assign mhpmcounter7 = 64'd0;
   assign mhpmcounter8 = 64'd0;
   assign mhpmcounter9 = 64'd0;
   assign mhpmcounter10 = 64'd0;
   assign mhpmcounter11 = 64'd0;
   assign mhpmcounter12 = 64'd0;
   assign mhpmcounter13 = 64'd0;
   assign mhpmcounter14 = 64'd0;
   assign mhpmcounter15 = 64'd0;
   assign mhpmcounter16 = 64'd0;
   assign mhpmcounter17 = 64'd0;
   assign mhpmcounter18 = 64'd0;
   assign mhpmcounter19 = 64'd0;
   assign mhpmcounter20 = 64'd0;
   assign mhpmcounter21 = 64'd0;
   assign mhpmcounter22 = 64'd0;
   assign mhpmcounter23 = 64'd0;
   assign mhpmcounter24 = 64'd0;
   assign mhpmcounter25 = 64'd0;
   assign mhpmcounter26 = 64'd0;
   assign mhpmcounter27 = 64'd0;
   assign mhpmcounter28 = 64'd0;
   assign mhpmcounter29 = 64'd0;
   assign mhpmcounter30 = 64'd0;
   assign mhpmcounter31 = 64'd0;
   assign mhpmevent3 = 32'd0;
   assign mhpmevent4 = 32'd0;
   assign mhpmevent5 = 32'd0;
   assign mhpmevent6 = 32'd0;
   assign mhpmevent7 = 32'd0;
   assign mhpmevent8 = 32'd0;
   assign mhpmevent9 = 32'd0;
   assign mhpmevent10 = 32'd0;
   assign mhpmevent11 = 32'd0;
   assign mhpmevent12 = 32'd0;
   assign mhpmevent13 = 32'd0;
   assign mhpmevent14 = 32'd0;
   assign mhpmevent15 = 32'd0;
   assign mhpmevent16 = 32'd0;
   assign mhpmevent17 = 32'd0;
   assign mhpmevent18 = 32'd0;
   assign mhpmevent19 = 32'd0;
   assign mhpmevent20 = 32'd0;
   assign mhpmevent21 = 32'd0;
   assign mhpmevent22 = 32'd0;
   assign mhpmevent23 = 32'd0;
   assign mhpmevent24 = 32'd0;
   assign mhpmevent25 = 32'd0;
   assign mhpmevent26 = 32'd0;
   assign mhpmevent27 = 32'd0;
   assign mhpmevent28 = 32'd0;
   assign mhpmevent29 = 32'd0;
   assign mhpmevent30 = 32'd0;
   assign mhpmevent31 = 32'd0;

   // Debug/Trace Register
   assign tselect  = 32'd0;
   assign tdata1   = 32'd0;
   assign tdata2   = 32'd0;
   assign tdata3   = 32'd0;
   // Debug Mode Register
   assign dcsr     = 32'd0;
   assign dpc      = 32'd0;
   assign dscratch = 32'd0;

   //
   always @(*) begin
      case(CSR_ADDR)
        // Machine Information
        12'hF11: CSR_RDATA <= mvendorid;
        12'hF12: CSR_RDATA <= marchid;
        12'hF13: CSR_RDATA <= mimpid;
        12'hF14: CSR_RDATA <= mhartid;
        // Machine Trap Setup
        12'h300: CSR_RDATA <= mstatus;
        12'h301: CSR_RDATA <= misa;
        12'h302: CSR_RDATA <= medeleg;
        12'h303: CSR_RDATA <= mideleg;
        12'h304: CSR_RDATA <= mie;
        12'h305: CSR_RDATA <= mtvec;
        // Machine Trap Handling
        12'h340: CSR_RDATA <= mscratch;
        12'h341: CSR_RDATA <= mepc;
        12'h342: CSR_RDATA <= mcause;
        12'h343: CSR_RDATA <= mbadaddr;
        12'h344: CSR_RDATA <= mip;
        // Machine Protection and Translation
        12'h380: CSR_RDATA <= mbase;
        12'h381: CSR_RDATA <= mbound;
        12'h382: CSR_RDATA <= mibase;
        12'h383: CSR_RDATA <= mibound;
        12'h384: CSR_RDATA <= mdbase;
        12'h385: CSR_RDATA <= mdbound;
        // Machine Counter/Timer
        12'hB00: CSR_RDATA <= mcycle[31:0];
        12'hB02: CSR_RDATA <= minstret[31:0];
        12'hB03: CSR_RDATA <= mhpmcounter3[31:0];
        12'hB04: CSR_RDATA <= mhpmcounter4[31:0];
        12'hB05: CSR_RDATA <= mhpmcounter5[31:0];
        12'hB06: CSR_RDATA <= mhpmcounter6[31:0];
        12'hB07: CSR_RDATA <= mhpmcounter7[31:0];
        12'hB08: CSR_RDATA <= mhpmcounter8[31:0];
        12'hB09: CSR_RDATA <= mhpmcounter9[31:0];
        12'hB0A: CSR_RDATA <= mhpmcounter10[31:0];
        12'hB0B: CSR_RDATA <= mhpmcounter11[31:0];
        12'hB0C: CSR_RDATA <= mhpmcounter12[31:0];
        12'hB0D: CSR_RDATA <= mhpmcounter13[31:0];
        12'hB0E: CSR_RDATA <= mhpmcounter14[31:0];
        12'hB0F: CSR_RDATA <= mhpmcounter15[31:0];
        12'hB10: CSR_RDATA <= mhpmcounter16[31:0];
        12'hB11: CSR_RDATA <= mhpmcounter17[31:0];
        12'hB12: CSR_RDATA <= mhpmcounter18[31:0];
        12'hB13: CSR_RDATA <= mhpmcounter19[31:0];
        12'hB14: CSR_RDATA <= mhpmcounter20[31:0];
        12'hB15: CSR_RDATA <= mhpmcounter21[31:0];
        12'hB16: CSR_RDATA <= mhpmcounter22[31:0];
        12'hB17: CSR_RDATA <= mhpmcounter23[31:0];
        12'hB18: CSR_RDATA <= mhpmcounter24[31:0];
        12'hB19: CSR_RDATA <= mhpmcounter25[31:0];
        12'hB1A: CSR_RDATA <= mhpmcounter26[31:0];
        12'hB1B: CSR_RDATA <= mhpmcounter27[31:0];
        12'hB1C: CSR_RDATA <= mhpmcounter28[31:0];
        12'hB1D: CSR_RDATA <= mhpmcounter29[31:0];
        12'hB1E: CSR_RDATA <= mhpmcounter30[31:0];
        12'hB1F: CSR_RDATA <= mhpmcounter31[31:0];
        12'hB20: CSR_RDATA <= mcycle[63:32];
        12'hB22: CSR_RDATA <= minstret[63:32];
        12'hB23: CSR_RDATA <= mhpmcounter3[63:32];
        12'hB24: CSR_RDATA <= mhpmcounter4[63:32];
        12'hB25: CSR_RDATA <= mhpmcounter5[63:32];
        12'hB26: CSR_RDATA <= mhpmcounter6[63:32];
        12'hB27: CSR_RDATA <= mhpmcounter7[63:32];
        12'hB28: CSR_RDATA <= mhpmcounter8[63:32];
        12'hB29: CSR_RDATA <= mhpmcounter9[63:32];
        12'hB2A: CSR_RDATA <= mhpmcounter10[63:32];
        12'hB2B: CSR_RDATA <= mhpmcounter11[63:32];
        12'hB2C: CSR_RDATA <= mhpmcounter12[63:32];
        12'hB2D: CSR_RDATA <= mhpmcounter13[63:32];
        12'hB2E: CSR_RDATA <= mhpmcounter14[63:32];
        12'hB2F: CSR_RDATA <= mhpmcounter15[63:32];
        12'hB30: CSR_RDATA <= mhpmcounter16[63:32];
        12'hB31: CSR_RDATA <= mhpmcounter17[63:32];
        12'hB32: CSR_RDATA <= mhpmcounter18[63:32];
        12'hB33: CSR_RDATA <= mhpmcounter19[63:32];
        12'hB34: CSR_RDATA <= mhpmcounter20[63:32];
        12'hB35: CSR_RDATA <= mhpmcounter21[63:32];
        12'hB36: CSR_RDATA <= mhpmcounter22[63:32];
        12'hB37: CSR_RDATA <= mhpmcounter23[63:32];
        12'hB38: CSR_RDATA <= mhpmcounter24[63:32];
        12'hB39: CSR_RDATA <= mhpmcounter25[63:32];
        12'hB3A: CSR_RDATA <= mhpmcounter26[63:32];
        12'hB3B: CSR_RDATA <= mhpmcounter27[63:32];
        12'hB3C: CSR_RDATA <= mhpmcounter28[63:32];
        12'hB3D: CSR_RDATA <= mhpmcounter29[63:32];
        12'hB3E: CSR_RDATA <= mhpmcounter30[63:32];
        12'hB3F: CSR_RDATA <= mhpmcounter31[63:32];
        // Machine Counter Setup
        12'h320: CSR_RDATA <= mucounteren;
        12'h321: CSR_RDATA <= mscounteren;
        12'h322: CSR_RDATA <= mhcounteren;
        12'h323: CSR_RDATA <= mhpmevent3;
        12'h324: CSR_RDATA <= mhpmevent4;
        12'h325: CSR_RDATA <= mhpmevent5;
        12'h326: CSR_RDATA <= mhpmevent6;
        12'h327: CSR_RDATA <= mhpmevent7;
        12'h328: CSR_RDATA <= mhpmevent8;
        12'h329: CSR_RDATA <= mhpmevent9;
        12'h32A: CSR_RDATA <= mhpmevent10;
        12'h32B: CSR_RDATA <= mhpmevent11;
        12'h32C: CSR_RDATA <= mhpmevent12;
        12'h32D: CSR_RDATA <= mhpmevent13;
        12'h32E: CSR_RDATA <= mhpmevent14;
        12'h32F: CSR_RDATA <= mhpmevent15;
        12'h330: CSR_RDATA <= mhpmevent16;
        12'h331: CSR_RDATA <= mhpmevent17;
        12'h332: CSR_RDATA <= mhpmevent18;
        12'h333: CSR_RDATA <= mhpmevent19;
        12'h334: CSR_RDATA <= mhpmevent20;
        12'h335: CSR_RDATA <= mhpmevent21;
        12'h336: CSR_RDATA <= mhpmevent22;
        12'h337: CSR_RDATA <= mhpmevent23;
        12'h338: CSR_RDATA <= mhpmevent24;
        12'h339: CSR_RDATA <= mhpmevent25;
        12'h33A: CSR_RDATA <= mhpmevent26;
        12'h33B: CSR_RDATA <= mhpmevent27;
        12'h33C: CSR_RDATA <= mhpmevent28;
        12'h33D: CSR_RDATA <= mhpmevent29;
        12'h33E: CSR_RDATA <= mhpmevent30;
        12'h33F: CSR_RDATA <= mhpmevent31;
        // Debug/Trace Register
        12'h7A0: CSR_RDATA <= tselect;
        12'h7A1: CSR_RDATA <= tdata1;
        12'h7A2: CSR_RDATA <= tdata2;
        12'h7A3: CSR_RDATA <= tdata3;
        // D7bug Mode Register
        12'h7B0: CSR_RDATA <= dcsr;
        12'h7B1: CSR_RDATA <= dpc;
        12'h7B2: CSR_RDATA <= dscratch;
        default: CSR_RDATA <= 32'd0;
      endcase
   end

endmodule // fmrv32im_csr
