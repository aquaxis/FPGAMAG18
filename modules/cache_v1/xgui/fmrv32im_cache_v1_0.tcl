# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "MEM_FILE" -parent ${Page_0}


}

proc update_PARAM_VALUE.INTEL { PARAM_VALUE.INTEL } {
	# Procedure called to update INTEL when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.INTEL { PARAM_VALUE.INTEL } {
	# Procedure called to validate INTEL
	return true
}

proc update_PARAM_VALUE.MEM_FILE { PARAM_VALUE.MEM_FILE } {
	# Procedure called to update MEM_FILE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MEM_FILE { PARAM_VALUE.MEM_FILE } {
	# Procedure called to validate MEM_FILE
	return true
}

proc update_PARAM_VALUE.OSRAM { PARAM_VALUE.OSRAM } {
	# Procedure called to update OSRAM when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.OSRAM { PARAM_VALUE.OSRAM } {
	# Procedure called to validate OSRAM
	return true
}


proc update_MODELPARAM_VALUE.MEM_FILE { MODELPARAM_VALUE.MEM_FILE PARAM_VALUE.MEM_FILE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MEM_FILE}] ${MODELPARAM_VALUE.MEM_FILE}
}

proc update_MODELPARAM_VALUE.INTEL { MODELPARAM_VALUE.INTEL PARAM_VALUE.INTEL } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.INTEL}] ${MODELPARAM_VALUE.INTEL}
}

proc update_MODELPARAM_VALUE.OSRAM { MODELPARAM_VALUE.OSRAM PARAM_VALUE.OSRAM } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.OSRAM}] ${MODELPARAM_VALUE.OSRAM}
}

