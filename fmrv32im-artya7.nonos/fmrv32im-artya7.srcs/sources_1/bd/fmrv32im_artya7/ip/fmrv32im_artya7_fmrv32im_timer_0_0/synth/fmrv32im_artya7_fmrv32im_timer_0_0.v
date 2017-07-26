// (c) Copyright 1995-2017 Xilinx, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
// 
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
// 
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
// 
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
// 
// DO NOT MODIFY THIS FILE.


// IP VLNV: user.org:user:fmrv32im_timer:1.0
// IP Revision: 4

(* X_CORE_INFO = "fmrv32im_timer,Vivado 2017.2" *)
(* CHECK_LICENSE_TYPE = "fmrv32im_artya7_fmrv32im_timer_0_0,fmrv32im_timer,{}" *)
(* DowngradeIPIdentifiedWarnings = "yes" *)
module fmrv32im_artya7_fmrv32im_timer_0_0 (
  RST_N,
  CLK,
  BUS_WE,
  BUS_ADDR,
  BUS_WDATA,
  BUS_RDATA,
  EXPIRED
);

(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 RST_N RST" *)
input wire RST_N;
(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK CLK" *)
input wire CLK;
(* X_INTERFACE_INFO = "user.org:user:SYS_BUS:1.0 SYS_BUS BUS_WE" *)
input wire BUS_WE;
(* X_INTERFACE_INFO = "user.org:user:SYS_BUS:1.0 SYS_BUS BUS_ADDR" *)
input wire [3 : 0] BUS_ADDR;
(* X_INTERFACE_INFO = "user.org:user:SYS_BUS:1.0 SYS_BUS BUS_WDATA" *)
input wire [31 : 0] BUS_WDATA;
(* X_INTERFACE_INFO = "user.org:user:SYS_BUS:1.0 SYS_BUS BUS_RDATA" *)
output wire [31 : 0] BUS_RDATA;
output wire EXPIRED;

  fmrv32im_timer inst (
    .RST_N(RST_N),
    .CLK(CLK),
    .BUS_WE(BUS_WE),
    .BUS_ADDR(BUS_ADDR),
    .BUS_WDATA(BUS_WDATA),
    .BUS_RDATA(BUS_RDATA),
    .EXPIRED(EXPIRED)
  );
endmodule
