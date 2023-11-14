# Script to pre-compile the clock_gen block

set synthetic_library dw_foundation.sldb

set_app_var target_library {"../models/saed32io_ss0p95v125c_2p25v.db" "../models/saed32pll_ff1p16v125c_2p75v.db" "../models/saed32pll_ss0p95v125c_2p25v.db" "../models/saed32pll_ss0p95v125c_2p25v.db" "../models/saed32rvt_ff0p85v125c.db" "../models/saed32rvt_ff1p16v125c.db" "../models/saed32rvt_ss0p95v125c.db"}
set_app_var link_library "* $target_library $synthetic_library"

read_vhdl ../rtl/CLOCK_GEN.vhd

create_clock -p 15 pclk
create_clock -p 7.5 sdram_clk
create_clock -p 4 sys_clk


set_propagated_clock [all_clocks]

compile -scan -exact_map

set directoryName "../output/mapped/"

if {[file isdirectory $directoryName] == 0} {
    if {[file mkdir $directoryName] == 1} {
        puts "Directory created successfully: $directoryName"
    } else {
        puts "Failed to create directory: $directoryName"
    }
} else {
    puts "Directory already exists: $directoryName"
}

write -f ddc -h -o ../output/mapped/CLOCK_GEN.ddc

exit
