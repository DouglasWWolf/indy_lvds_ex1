# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "FRAME_BYTES" -parent ${Page_0}
  ipgui::add_param $IPINST -name "LANE_COUNT" -parent ${Page_0}
  ipgui::add_param $IPINST -name "PIPE_LEN" -parent ${Page_0}


}

proc update_PARAM_VALUE.FRAME_BYTES { PARAM_VALUE.FRAME_BYTES } {
	# Procedure called to update FRAME_BYTES when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.FRAME_BYTES { PARAM_VALUE.FRAME_BYTES } {
	# Procedure called to validate FRAME_BYTES
	return true
}

proc update_PARAM_VALUE.LANE_COUNT { PARAM_VALUE.LANE_COUNT } {
	# Procedure called to update LANE_COUNT when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.LANE_COUNT { PARAM_VALUE.LANE_COUNT } {
	# Procedure called to validate LANE_COUNT
	return true
}

proc update_PARAM_VALUE.PIPE_LEN { PARAM_VALUE.PIPE_LEN } {
	# Procedure called to update PIPE_LEN when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.PIPE_LEN { PARAM_VALUE.PIPE_LEN } {
	# Procedure called to validate PIPE_LEN
	return true
}


proc update_MODELPARAM_VALUE.LANE_COUNT { MODELPARAM_VALUE.LANE_COUNT PARAM_VALUE.LANE_COUNT } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.LANE_COUNT}] ${MODELPARAM_VALUE.LANE_COUNT}
}

proc update_MODELPARAM_VALUE.PIPE_LEN { MODELPARAM_VALUE.PIPE_LEN PARAM_VALUE.PIPE_LEN } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PIPE_LEN}] ${MODELPARAM_VALUE.PIPE_LEN}
}

proc update_MODELPARAM_VALUE.FRAME_BYTES { MODELPARAM_VALUE.FRAME_BYTES PARAM_VALUE.FRAME_BYTES } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.FRAME_BYTES}] ${MODELPARAM_VALUE.FRAME_BYTES}
}

