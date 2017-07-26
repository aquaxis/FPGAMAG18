
################################################################
# This is a generated script based on design: fmrv32im_artya7
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2017.2
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_msg_id "BD_TCL-109" "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source fmrv32im_artya7_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xc7a35ticsg324-1L
}


# CHANGE DESIGN NAME HERE
set design_name fmrv32im_artya7

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_msg_id "BD_TCL-001" "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_msg_id "BD_TCL-002" "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_msg_id "BD_TCL-003" "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_msg_id "BD_TCL-004" "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_msg_id "BD_TCL-005" "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_msg_id "BD_TCL-114" "ERROR" $errMsg}
   return $nRet
}

##################################################################
# DESIGN PROCs
##################################################################


# Hierarchical cell: fmrv32im_core
proc create_hier_cell_fmrv32im_core { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_fmrv32im_core() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv user.org:user:PERIPHERAL_BUS_rtl:1.0 PERIPHERAL
  create_bd_intf_pin -mode Master -vlnv user.org:user:REQ_BUS_rtl:1.0 RD_REQ
  create_bd_intf_pin -mode Master -vlnv user.org:user:REQ_BUS_rtl:1.0 WR_REQ

  # Create pins
  create_bd_pin -dir I -type clk CLK
  create_bd_pin -dir I -from 0 -to 0 INT_IN
  create_bd_pin -dir I -type rst RST_N

  # Create instance: cache, and set properties
  set cache [ create_bd_cell -type ip -vlnv user.org:user:fmrv32im_cache:1.0 cache ]
  set_property -dict [ list \
CONFIG.MEM_FILE {/home/hidemi/workspace/FPGAMAG18/FPGA/romdata/artya7.hex} \
CONFIG.OSRAM {0} \
 ] $cache

  # Create instance: dbussel, and set properties
  set dbussel [ create_bd_cell -type ip -vlnv user.org:user:fmrv32im_dbussel:1.0 dbussel ]

  # Create instance: fmrv32im, and set properties
  set fmrv32im [ create_bd_cell -type ip -vlnv user.org:user:fmrv32im:1.0 fmrv32im ]
  set_property -dict [ list \
CONFIG.MADD33_ADDON {1} \
 ] $fmrv32im

  # Create instance: plic, and set properties
  set plic [ create_bd_cell -type ip -vlnv user.org:user:fmrv32im_plic:1.0 plic ]

  # Create instance: timer, and set properties
  set timer [ create_bd_cell -type ip -vlnv user.org:user:fmrv32im_timer:1.0 timer ]

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins RD_REQ] [get_bd_intf_pins cache/RD_REQ]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins WR_REQ] [get_bd_intf_pins cache/WR_REQ]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins PERIPHERAL] [get_bd_intf_pins dbussel/PERIPHERAL]
  connect_bd_intf_net -intf_net dbussel_upgraded_ipi_C_MEM_BUS [get_bd_intf_pins cache/D_MEM_BUS] [get_bd_intf_pins dbussel/C_MEM_BUS]
  connect_bd_intf_net -intf_net dbussel_upgraded_ipi_PLIC [get_bd_intf_pins dbussel/PLIC] [get_bd_intf_pins plic/SYS_BUS]
  connect_bd_intf_net -intf_net dbussel_upgraded_ipi_TIMER [get_bd_intf_pins dbussel/TIMER] [get_bd_intf_pins timer/SYS_BUS]
  connect_bd_intf_net -intf_net fmrv32im_D_MEM_BUS [get_bd_intf_pins dbussel/D_MEM_BUS] [get_bd_intf_pins fmrv32im/D_MEM_BUS]
  connect_bd_intf_net -intf_net fmrv32im_I_MEM_BUS [get_bd_intf_pins cache/I_MEM_BUS] [get_bd_intf_pins fmrv32im/I_MEM_BUS]

  # Create port connections
  connect_bd_net -net CLK_1 [get_bd_pins CLK] [get_bd_pins cache/CLK] [get_bd_pins fmrv32im/CLK] [get_bd_pins plic/CLK] [get_bd_pins timer/CLK]
  connect_bd_net -net INT_IN_1 [get_bd_pins INT_IN] [get_bd_pins plic/INT_IN]
  connect_bd_net -net RST_N_1 [get_bd_pins RST_N] [get_bd_pins cache/RST_N] [get_bd_pins fmrv32im/RST_N] [get_bd_pins plic/RST_N] [get_bd_pins timer/RST_N]
  connect_bd_net -net fmrv32im_plic_0_INT_OUT [get_bd_pins fmrv32im/EXT_INTERRUPT] [get_bd_pins plic/INT_OUT]
  connect_bd_net -net timer_EXPIRED [get_bd_pins fmrv32im/TIMER_EXPIRED] [get_bd_pins timer/EXPIRED]

  # Restore current instance
  current_bd_instance $oldCurInst
}


# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set GPIO [ create_bd_intf_port -mode Master -vlnv user.org:user:GPIO_rtl:1.0 GPIO ]
  set UART [ create_bd_intf_port -mode Master -vlnv user.org:user:UART_rtl:1.0 UART ]

  # Create ports
  set CLK100MHZ [ create_bd_port -dir I -type clk CLK100MHZ ]

  # Create instance: High, and set properties
  set High [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 High ]

  # Create instance: axi_lite_master, and set properties
  set axi_lite_master [ create_bd_cell -type ip -vlnv user.org:user:fmrv32im_axilm:1.0 axi_lite_master ]

  # Create instance: concat, and set properties
  set concat [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 concat ]
  set_property -dict [ list \
CONFIG.NUM_PORTS {1} \
 ] $concat

  # Create instance: fmrv32im_core
  create_hier_cell_fmrv32im_core [current_bd_instance .] fmrv32im_core

  # Create instance: uart, and set properties
  set uart [ create_bd_cell -type ip -vlnv user.org:user:fmrv32im_axis_uart:1.0 uart ]

  # Create interface connections
  connect_bd_intf_net -intf_net axilm_M_AXI [get_bd_intf_pins axi_lite_master/M_AXI] [get_bd_intf_pins uart/S_AXI]
  connect_bd_intf_net -intf_net fmrv32im_axis_uart_0_GPIO [get_bd_intf_ports GPIO] [get_bd_intf_pins uart/GPIO]
  connect_bd_intf_net -intf_net fmrv32im_axis_uart_0_UART [get_bd_intf_ports UART] [get_bd_intf_pins uart/UART]
  connect_bd_intf_net -intf_net fmrv32im_core_PERIPHERAL [get_bd_intf_pins axi_lite_master/PERIPHERAL_BUS] [get_bd_intf_pins fmrv32im_core/PERIPHERAL]

  # Create port connections
  connect_bd_net -net CLK_1 [get_bd_ports CLK100MHZ] [get_bd_pins axi_lite_master/CLK] [get_bd_pins fmrv32im_core/CLK] [get_bd_pins uart/CLK]
  connect_bd_net -net High_dout [get_bd_pins High/dout] [get_bd_pins axi_lite_master/RST_N] [get_bd_pins fmrv32im_core/RST_N] [get_bd_pins uart/RST_N]
  connect_bd_net -net concat_dout [get_bd_pins concat/dout] [get_bd_pins fmrv32im_core/INT_IN]
  connect_bd_net -net fmrv32im_axis_uart_0_INTERRUPT [get_bd_pins concat/In0] [get_bd_pins uart/INTERRUPT]

  # Create address segments
  create_bd_addr_seg -range 0x00010000 -offset 0x80000000 [get_bd_addr_spaces axi_lite_master/M_AXI] [get_bd_addr_segs uart/S_AXI/reg0] SEG_fmrv32im_axis_uart_0_reg0


  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


