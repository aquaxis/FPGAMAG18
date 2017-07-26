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


// IP VLNV: user.org:user:fmrv32im_dbussel:1.0
// IP Revision: 4

(* X_CORE_INFO = "fmrv32im_BADMEM_sel,Vivado 2017.2" *)
(* CHECK_LICENSE_TYPE = "fmrv32im_artya7_dbussel_upgraded_ipi_0,fmrv32im_BADMEM_sel,{}" *)
(* DowngradeIPIdentifiedWarnings = "yes" *)
module fmrv32im_artya7_dbussel_upgraded_ipi_0 (
  D_MEM_WAIT,
  D_MEM_ENA,
  D_MEM_WSTB,
  D_MEM_ADDR,
  D_MEM_WDATA,
  D_MEM_RDATA,
  D_MEM_BADMEM_EXCPT,
  C_MEM_WAIT,
  C_MEM_ENA,
  C_MEM_WSTB,
  C_MEM_ADDR,
  C_MEM_WDATA,
  C_MEM_RDATA,
  C_MEM_BADMEM_EXCPT,
  PERIPHERAL_BUS_WAIT,
  PERIPHERAL_BUS_ENA,
  PERIPHERAL_BUS_WSTB,
  PERIPHERAL_BUS_ADDR,
  PERIPHERAL_BUS_WDATA,
  PERIPHERAL_BUS_RDATA,
  PLIC_BUS_WE,
  PLIC_BUS_ADDR,
  PLIC_BUS_WDATA,
  PLIC_BUS_RDATA,
  TIMER_BUS_WE,
  TIMER_BUS_ADDR,
  TIMER_BUS_WDATA,
  TIMER_BUS_RDATA
);

(* X_INTERFACE_INFO = "user.org:user:MEM_BUS:1.0 D_MEM_BUS MEM_WAIT" *)
output wire D_MEM_WAIT;
(* X_INTERFACE_INFO = "user.org:user:MEM_BUS:1.0 D_MEM_BUS MEM_ENA" *)
input wire D_MEM_ENA;
(* X_INTERFACE_INFO = "user.org:user:MEM_BUS:1.0 D_MEM_BUS MEM_WSTB" *)
input wire [3 : 0] D_MEM_WSTB;
(* X_INTERFACE_INFO = "user.org:user:MEM_BUS:1.0 D_MEM_BUS MEM_ADDR" *)
input wire [31 : 0] D_MEM_ADDR;
(* X_INTERFACE_INFO = "user.org:user:MEM_BUS:1.0 D_MEM_BUS MEM_WDATA" *)
input wire [31 : 0] D_MEM_WDATA;
(* X_INTERFACE_INFO = "user.org:user:MEM_BUS:1.0 D_MEM_BUS MEM_RDATA" *)
output wire [31 : 0] D_MEM_RDATA;
(* X_INTERFACE_INFO = "user.org:user:MEM_BUS:1.0 D_MEM_BUS MEM_BADMEM_EXCPT" *)
output wire D_MEM_BADMEM_EXCPT;
(* X_INTERFACE_INFO = "user.org:user:MEM_BUS:1.0 C_MEM_BUS MEM_WAIT" *)
input wire C_MEM_WAIT;
(* X_INTERFACE_INFO = "user.org:user:MEM_BUS:1.0 C_MEM_BUS MEM_ENA" *)
output wire C_MEM_ENA;
(* X_INTERFACE_INFO = "user.org:user:MEM_BUS:1.0 C_MEM_BUS MEM_WSTB" *)
output wire [3 : 0] C_MEM_WSTB;
(* X_INTERFACE_INFO = "user.org:user:MEM_BUS:1.0 C_MEM_BUS MEM_ADDR" *)
output wire [31 : 0] C_MEM_ADDR;
(* X_INTERFACE_INFO = "user.org:user:MEM_BUS:1.0 C_MEM_BUS MEM_WDATA" *)
output wire [31 : 0] C_MEM_WDATA;
(* X_INTERFACE_INFO = "user.org:user:MEM_BUS:1.0 C_MEM_BUS MEM_RDATA" *)
input wire [31 : 0] C_MEM_RDATA;
(* X_INTERFACE_INFO = "user.org:user:MEM_BUS:1.0 C_MEM_BUS MEM_BADMEM_EXCPT" *)
input wire C_MEM_BADMEM_EXCPT;
(* X_INTERFACE_INFO = "user.org:user:PERIPHERAL_BUS:1.0 PERIPHERAL BUS_WAIT" *)
input wire PERIPHERAL_BUS_WAIT;
(* X_INTERFACE_INFO = "user.org:user:PERIPHERAL_BUS:1.0 PERIPHERAL BUS_ENA" *)
output wire PERIPHERAL_BUS_ENA;
(* X_INTERFACE_INFO = "user.org:user:PERIPHERAL_BUS:1.0 PERIPHERAL BUS_WSTB" *)
output wire [3 : 0] PERIPHERAL_BUS_WSTB;
(* X_INTERFACE_INFO = "user.org:user:PERIPHERAL_BUS:1.0 PERIPHERAL BUS_ADDR" *)
output wire [31 : 0] PERIPHERAL_BUS_ADDR;
(* X_INTERFACE_INFO = "user.org:user:PERIPHERAL_BUS:1.0 PERIPHERAL BUS_WDATA" *)
output wire [31 : 0] PERIPHERAL_BUS_WDATA;
(* X_INTERFACE_INFO = "user.org:user:PERIPHERAL_BUS:1.0 PERIPHERAL BUS_RDATA" *)
input wire [31 : 0] PERIPHERAL_BUS_RDATA;
(* X_INTERFACE_INFO = "user.org:user:SYS_BUS:1.0 PLIC BUS_WE" *)
output wire PLIC_BUS_WE;
(* X_INTERFACE_INFO = "user.org:user:SYS_BUS:1.0 PLIC BUS_ADDR" *)
output wire [3 : 0] PLIC_BUS_ADDR;
(* X_INTERFACE_INFO = "user.org:user:SYS_BUS:1.0 PLIC BUS_WDATA" *)
output wire [31 : 0] PLIC_BUS_WDATA;
(* X_INTERFACE_INFO = "user.org:user:SYS_BUS:1.0 PLIC BUS_RDATA" *)
input wire [31 : 0] PLIC_BUS_RDATA;
(* X_INTERFACE_INFO = "user.org:user:SYS_BUS:1.0 TIMER BUS_WE" *)
output wire TIMER_BUS_WE;
(* X_INTERFACE_INFO = "user.org:user:SYS_BUS:1.0 TIMER BUS_ADDR" *)
output wire [3 : 0] TIMER_BUS_ADDR;
(* X_INTERFACE_INFO = "user.org:user:SYS_BUS:1.0 TIMER BUS_WDATA" *)
output wire [31 : 0] TIMER_BUS_WDATA;
(* X_INTERFACE_INFO = "user.org:user:SYS_BUS:1.0 TIMER BUS_RDATA" *)
input wire [31 : 0] TIMER_BUS_RDATA;

  fmrv32im_BADMEM_sel inst (
    .D_MEM_WAIT(D_MEM_WAIT),
    .D_MEM_ENA(D_MEM_ENA),
    .D_MEM_WSTB(D_MEM_WSTB),
    .D_MEM_ADDR(D_MEM_ADDR),
    .D_MEM_WDATA(D_MEM_WDATA),
    .D_MEM_RDATA(D_MEM_RDATA),
    .D_MEM_BADMEM_EXCPT(D_MEM_BADMEM_EXCPT),
    .C_MEM_WAIT(C_MEM_WAIT),
    .C_MEM_ENA(C_MEM_ENA),
    .C_MEM_WSTB(C_MEM_WSTB),
    .C_MEM_ADDR(C_MEM_ADDR),
    .C_MEM_WDATA(C_MEM_WDATA),
    .C_MEM_RDATA(C_MEM_RDATA),
    .C_MEM_BADMEM_EXCPT(C_MEM_BADMEM_EXCPT),
    .PERIPHERAL_BUS_WAIT(PERIPHERAL_BUS_WAIT),
    .PERIPHERAL_BUS_ENA(PERIPHERAL_BUS_ENA),
    .PERIPHERAL_BUS_WSTB(PERIPHERAL_BUS_WSTB),
    .PERIPHERAL_BUS_ADDR(PERIPHERAL_BUS_ADDR),
    .PERIPHERAL_BUS_WDATA(PERIPHERAL_BUS_WDATA),
    .PERIPHERAL_BUS_RDATA(PERIPHERAL_BUS_RDATA),
    .PLIC_BUS_WE(PLIC_BUS_WE),
    .PLIC_BUS_ADDR(PLIC_BUS_ADDR),
    .PLIC_BUS_WDATA(PLIC_BUS_WDATA),
    .PLIC_BUS_RDATA(PLIC_BUS_RDATA),
    .TIMER_BUS_WE(TIMER_BUS_WE),
    .TIMER_BUS_ADDR(TIMER_BUS_ADDR),
    .TIMER_BUS_WDATA(TIMER_BUS_WDATA),
    .TIMER_BUS_RDATA(TIMER_BUS_RDATA)
  );
endmodule
