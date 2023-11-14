# Este makefile correrá dc_shell y limpiará los archivos generados

.PHONY: run
run:
	@echo "Ejecutando dc_shell con logic_synthesis.tcl"
	dc_shell -f compile_clock_gen.tcl
	dc_shell -f orca_top_read_hdl.tcl
	dc_shell -f orca_top_dc_compile.tcl
	rm -f *.log *.svf *.pvl *.syn *.mr
	rm -r ARCH ENTI BODY CONF PACK

.PHONY: compile
compile:
	@echo "Ejecutando dc_shell"
	dc_shell -f orca_top_dc_compile.tcl

.PHONY: scandef
scandef:
	@echo "Ejecutando dc_shell"
	dc_shell -f orca_top_scan.tcl

.PHONY: clock
clock:
	@echo "Ejecutando dc_shell"
	dc_shell -f compile_clock_gen.tcl

.PHONY: read
read:
	@echo "Ejecutando dc_shell read hdl"
	dc_shell -f orca_top_read_hdl.tcl

.PHONY: clean
clean:
	@echo "Limpiando archivos .log, .svf, .pvl, .syn, .mr"
	rm -f *.log *.svf *.pvl *.syn *.mr
	rm -r ARCH ENTI BODY CONF PACK