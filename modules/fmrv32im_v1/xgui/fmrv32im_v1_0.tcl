# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  ipgui::add_page $IPINST -name "Page 0"


}

proc update_PARAM_VALUE.MADD33_ADDON { PARAM_VALUE.MADD33_ADDON } {
	# Procedure called to update MADD33_ADDON when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MADD33_ADDON { PARAM_VALUE.MADD33_ADDON } {
	# Procedure called to validate MADD33_ADDON
	return true
}


proc update_MODELPARAM_VALUE.MADD33_ADDON { MODELPARAM_VALUE.MADD33_ADDON PARAM_VALUE.MADD33_ADDON } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MADD33_ADDON}] ${MODELPARAM_VALUE.MADD33_ADDON}
}

