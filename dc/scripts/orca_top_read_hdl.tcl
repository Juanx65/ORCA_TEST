#
# Read ORCA_TOP source files and save as unmapped DDC
#
set synthetic_library dw_foundation.sldb
set_app_var target_library {"../models/saed32io_ss0p95v125c_2p25v.db" "../models/saed32pll_ff1p16v125c_2p75v.db" "../models/saed32pll_ss0p95v125c_2p25v.db" "../models/saed32pll_ss0p95v125c_2p25v.db" "../models/saed32rvt_ff0p85v125c.db" "../models/saed32rvt_ff1p16v125c.db" "../models/saed32rvt_ss0p95v125c.db"}
set_app_var link_library "* $target_library $synthetic_library"

# Let's use the Presto VHDL reader
set hdlin_enable_presto_for_vhdl true
# This enables the use of configurations - necessary for ORCA 2.4 and up!
set hdlin_enable_configurations true


# Read the entire vhdl tree:
acs_read_hdl -no_elaborate -hdl_source ../rtl ORCA_TOP
elaborate orca_config

current_design ORCA_TOP
link

set directoryName "../output/unmapped/"

if {[file isdirectory $directoryName] == 0} {
    if {[file mkdir $directoryName] == 1} {
        puts "Directory created successfully: $directoryName"
    } else {
        puts "Failed to create directory: $directoryName"
    }
} else {
    puts "Directory already exists: $directoryName"
}

write -format ddc -h -o ../output/unmapped/ORCA_TOP.ddc
#read_ddc unmapped/ORCA_TOP_hier.ddc

exit
