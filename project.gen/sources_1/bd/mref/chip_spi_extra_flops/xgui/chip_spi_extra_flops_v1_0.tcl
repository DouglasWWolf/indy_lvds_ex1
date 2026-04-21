# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "EXTRA_FLOPS" -parent ${Page_0}


}

proc update_PARAM_VALUE.EXTRA_FLOPS { PARAM_VALUE.EXTRA_FLOPS } {
	# Procedure called to update EXTRA_FLOPS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.EXTRA_FLOPS { PARAM_VALUE.EXTRA_FLOPS } {
	# Procedure called to validate EXTRA_FLOPS
	return true
}


proc update_MODELPARAM_VALUE.EXTRA_FLOPS { MODELPARAM_VALUE.EXTRA_FLOPS PARAM_VALUE.EXTRA_FLOPS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.EXTRA_FLOPS}] ${MODELPARAM_VALUE.EXTRA_FLOPS}
}

