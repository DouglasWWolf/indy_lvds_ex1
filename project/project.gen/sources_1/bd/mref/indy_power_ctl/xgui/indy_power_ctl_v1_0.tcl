# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "AW" -parent ${Page_0}
  ipgui::add_param $IPINST -name "FREQ_HZ" -parent ${Page_0}
  ipgui::add_param $IPINST -name "VDDA_FALL_MS" -parent ${Page_0}
  ipgui::add_param $IPINST -name "VDDA_RISE_MS" -parent ${Page_0}
  ipgui::add_param $IPINST -name "VDDIO_FALL_MS" -parent ${Page_0}
  ipgui::add_param $IPINST -name "VDDIO_RISE_MS" -parent ${Page_0}
  ipgui::add_param $IPINST -name "VDDLVDS_FALL_MS" -parent ${Page_0}
  ipgui::add_param $IPINST -name "VDDLVDS_RISE_MS" -parent ${Page_0}
  ipgui::add_param $IPINST -name "VDD_FALL_MS" -parent ${Page_0}
  ipgui::add_param $IPINST -name "VDD_RISE_MS" -parent ${Page_0}


}

proc update_PARAM_VALUE.AW { PARAM_VALUE.AW } {
	# Procedure called to update AW when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.AW { PARAM_VALUE.AW } {
	# Procedure called to validate AW
	return true
}

proc update_PARAM_VALUE.FREQ_HZ { PARAM_VALUE.FREQ_HZ } {
	# Procedure called to update FREQ_HZ when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.FREQ_HZ { PARAM_VALUE.FREQ_HZ } {
	# Procedure called to validate FREQ_HZ
	return true
}

proc update_PARAM_VALUE.VDDA_FALL_MS { PARAM_VALUE.VDDA_FALL_MS } {
	# Procedure called to update VDDA_FALL_MS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.VDDA_FALL_MS { PARAM_VALUE.VDDA_FALL_MS } {
	# Procedure called to validate VDDA_FALL_MS
	return true
}

proc update_PARAM_VALUE.VDDA_RISE_MS { PARAM_VALUE.VDDA_RISE_MS } {
	# Procedure called to update VDDA_RISE_MS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.VDDA_RISE_MS { PARAM_VALUE.VDDA_RISE_MS } {
	# Procedure called to validate VDDA_RISE_MS
	return true
}

proc update_PARAM_VALUE.VDDIO_FALL_MS { PARAM_VALUE.VDDIO_FALL_MS } {
	# Procedure called to update VDDIO_FALL_MS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.VDDIO_FALL_MS { PARAM_VALUE.VDDIO_FALL_MS } {
	# Procedure called to validate VDDIO_FALL_MS
	return true
}

proc update_PARAM_VALUE.VDDIO_RISE_MS { PARAM_VALUE.VDDIO_RISE_MS } {
	# Procedure called to update VDDIO_RISE_MS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.VDDIO_RISE_MS { PARAM_VALUE.VDDIO_RISE_MS } {
	# Procedure called to validate VDDIO_RISE_MS
	return true
}

proc update_PARAM_VALUE.VDDLVDS_FALL_MS { PARAM_VALUE.VDDLVDS_FALL_MS } {
	# Procedure called to update VDDLVDS_FALL_MS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.VDDLVDS_FALL_MS { PARAM_VALUE.VDDLVDS_FALL_MS } {
	# Procedure called to validate VDDLVDS_FALL_MS
	return true
}

proc update_PARAM_VALUE.VDDLVDS_RISE_MS { PARAM_VALUE.VDDLVDS_RISE_MS } {
	# Procedure called to update VDDLVDS_RISE_MS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.VDDLVDS_RISE_MS { PARAM_VALUE.VDDLVDS_RISE_MS } {
	# Procedure called to validate VDDLVDS_RISE_MS
	return true
}

proc update_PARAM_VALUE.VDD_FALL_MS { PARAM_VALUE.VDD_FALL_MS } {
	# Procedure called to update VDD_FALL_MS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.VDD_FALL_MS { PARAM_VALUE.VDD_FALL_MS } {
	# Procedure called to validate VDD_FALL_MS
	return true
}

proc update_PARAM_VALUE.VDD_RISE_MS { PARAM_VALUE.VDD_RISE_MS } {
	# Procedure called to update VDD_RISE_MS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.VDD_RISE_MS { PARAM_VALUE.VDD_RISE_MS } {
	# Procedure called to validate VDD_RISE_MS
	return true
}


proc update_MODELPARAM_VALUE.AW { MODELPARAM_VALUE.AW PARAM_VALUE.AW } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.AW}] ${MODELPARAM_VALUE.AW}
}

proc update_MODELPARAM_VALUE.FREQ_HZ { MODELPARAM_VALUE.FREQ_HZ PARAM_VALUE.FREQ_HZ } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.FREQ_HZ}] ${MODELPARAM_VALUE.FREQ_HZ}
}

proc update_MODELPARAM_VALUE.VDDIO_RISE_MS { MODELPARAM_VALUE.VDDIO_RISE_MS PARAM_VALUE.VDDIO_RISE_MS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.VDDIO_RISE_MS}] ${MODELPARAM_VALUE.VDDIO_RISE_MS}
}

proc update_MODELPARAM_VALUE.VDD_RISE_MS { MODELPARAM_VALUE.VDD_RISE_MS PARAM_VALUE.VDD_RISE_MS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.VDD_RISE_MS}] ${MODELPARAM_VALUE.VDD_RISE_MS}
}

proc update_MODELPARAM_VALUE.VDDLVDS_RISE_MS { MODELPARAM_VALUE.VDDLVDS_RISE_MS PARAM_VALUE.VDDLVDS_RISE_MS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.VDDLVDS_RISE_MS}] ${MODELPARAM_VALUE.VDDLVDS_RISE_MS}
}

proc update_MODELPARAM_VALUE.VDDA_RISE_MS { MODELPARAM_VALUE.VDDA_RISE_MS PARAM_VALUE.VDDA_RISE_MS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.VDDA_RISE_MS}] ${MODELPARAM_VALUE.VDDA_RISE_MS}
}

proc update_MODELPARAM_VALUE.VDDIO_FALL_MS { MODELPARAM_VALUE.VDDIO_FALL_MS PARAM_VALUE.VDDIO_FALL_MS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.VDDIO_FALL_MS}] ${MODELPARAM_VALUE.VDDIO_FALL_MS}
}

proc update_MODELPARAM_VALUE.VDD_FALL_MS { MODELPARAM_VALUE.VDD_FALL_MS PARAM_VALUE.VDD_FALL_MS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.VDD_FALL_MS}] ${MODELPARAM_VALUE.VDD_FALL_MS}
}

proc update_MODELPARAM_VALUE.VDDLVDS_FALL_MS { MODELPARAM_VALUE.VDDLVDS_FALL_MS PARAM_VALUE.VDDLVDS_FALL_MS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.VDDLVDS_FALL_MS}] ${MODELPARAM_VALUE.VDDLVDS_FALL_MS}
}

proc update_MODELPARAM_VALUE.VDDA_FALL_MS { MODELPARAM_VALUE.VDDA_FALL_MS PARAM_VALUE.VDDA_FALL_MS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.VDDA_FALL_MS}] ${MODELPARAM_VALUE.VDDA_FALL_MS}
}

