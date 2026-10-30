QUESTA_DIR = /usr/local/questasim/bin

VLOG = $(QUESTA_DIR)/vlog -sv -cover sbct
VSIM = $(QUESTA_DIR)/vsim -coverage
VLIB = $(QUESTA_DIR)/vlib

SRC_RTL = rtl/fifo_sync.sv
SRC_TB  = tb/tb_fifo_sync_pkg.sv \
          tb/tb_fifo_sync_inf.sv \
          tc/tc_pkg.sv \
          tb/tb_fifo_sync.sv

TOP_TB  = tb_fifo_sync

.PHONY: all compile sim gui clean

all: sim

compile:
	@if [ ! -d "work" ]; then $(VLIB) work; fi
	$(VLOG) $(SRC_RTL) $(SRC_TB)

sim: compile
	$(VSIM) -c -do "run -all; coverage save coverage.ucdb; coverage report -detail; quit" $(TOP_TB)

gui: compile
	$(VSIM) -do "add wave -r /*; run -all" $(TOP_TB)

clean:
	rm -rf work transcript *.wlf *.ucdb