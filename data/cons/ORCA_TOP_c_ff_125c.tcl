set_parasitic_parameters -early_spec minTLU -late_spec minTLU
set_temperature 125
set_process_number 1.01
set_process_label fast
set_voltage 0.95  -object_list VDD
set_voltage 1.16  -object_list VDDH
set_voltage 0.00  -object_list VSS

set_timing_derate -late 1.05 -cell_delay -net_delay

set_load 100 $orca_ports(pci_outputs)
set_load 10 $orca_ports(sdram_outputs)
set_load 10 $orca_ports(sd_ddr_outputs)
set_load 30 $orca_ports(test_so)
