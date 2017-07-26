-- Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2017.2 (lin64) Build 1909853 Thu Jun 15 18:39:10 MDT 2017
-- Date        : Fri Jun 23 10:19:58 2017
-- Host        : dshwdev running 64-bit Ubuntu 16.04.2 LTS
-- Command     : write_vhdl -force -mode synth_stub
--               /home/h-ishihara/workspace/FPGAMAG18/FPGA/fmrv32im-artya7.madd33/fmrv32im-artya7.srcs/sources_1/bd/fmrv32im_artya7/fmrv32im_artya7_stub.vhdl
-- Design      : fmrv32im_artya7
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7a35ticsg324-1L
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity fmrv32im_artya7 is
  Port ( 
    CLK100MHZ : in STD_LOGIC;
    GPIO_i : in STD_LOGIC_VECTOR ( 31 downto 0 );
    GPIO_o : out STD_LOGIC_VECTOR ( 31 downto 0 );
    GPIO_ot : out STD_LOGIC_VECTOR ( 31 downto 0 );
    UART_rx : in STD_LOGIC;
    UART_tx : out STD_LOGIC
  );

end fmrv32im_artya7;

architecture stub of fmrv32im_artya7 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "CLK100MHZ,GPIO_i[31:0],GPIO_o[31:0],GPIO_ot[31:0],UART_rx,UART_tx";
begin
end;
