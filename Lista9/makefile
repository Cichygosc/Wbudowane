marie : filehandle.vhd ram.vhd pc.vhd register.vhd alu.vhd controller.vhd marie_tb.vhd
	ghdl -a --ieee=synopsys filehandle.vhd
	ghdl -a ram.vhd
	ghdl -a pc.vhd
	ghdl -a register.vhd
	ghdl -a alu.vhd
	ghdl -a --ieee=synopsys controller.vhd
	ghdl -a marie_tb.vhd
	ghdl -e --ieee=synopsys marie_tb
	ghdl -r marie_tb --vcd=marie.vcd --stop-time=5us
	gtkwave marie.vcd

filehandle : filehandle.vhd filehandle_tb.vhd
	ghdl -a --ieee=synopsys filehandle.vhd
	ghdl -a --ieee=synopsys filehandle_tb.vhd
	ghdl -e --ieee=synopsys filehandle_tb
	ghdl -r filehandle_tb --vcd=filehandle.vcd --stop-time=1us
	gtkwave filehandle.vcd

ram : filehandle.vhd ram.vhd ram_tb.vhd
	ghdl -a --ieee=synopsys filehandle.vhd
	ghdl -a ram.vhd
	ghdl -a --ieee=synopsys ram_tb.vhd
	ghdl -e --ieee=synopsys ram_tb
	ghdl -r ram_tb --vcd=ram.vcd --stop-time=1us
	gtkwave ram.vcd

pc : filehandle.vhd ram.vhd pc.vhd pc_tb.vhd
	ghdl -a --ieee=synopsys filehandle.vhd
	ghdl -a ram.vhd
	ghdl -a pc.vhd
	ghdl -a pc_tb.vhd
	ghdl -e --ieee=synopsys pc_tb
	ghdl -r pc_tb --vcd=pc.vcd --stop-time=2us
	gtkwave pc.vcd

register : filehandle.vhd ram.vhd pc.vhd register.vhd register_tb.vhd
	ghdl -a --ieee=synopsys filehandle.vhd
	ghdl -a ram.vhd
	ghdl -a pc.vhd
	ghdl -a register.vhd
	ghdl -a register_tb.vhd
	ghdl -e --ieee=synopsys register_tb
	ghdl -r register_tb --vcd=register.vcd --stop-time=2us
	gtkwave register.vcd

controller : filehandle.vhd ram.vhd pc.vhd register.vhd controller.vhd controller_tb.vhd
	ghdl -a --ieee=synopsys filehandle.vhd
	ghdl -a ram.vhd
	ghdl -a pc.vhd
	ghdl -a register.vhd
	ghdl -a --ieee=synopsys controller.vhd
	ghdl -a controller_tb.vhd
	ghdl -e --ieee=synopsys controller_tb
	ghdl -r controller_tb --vcd=controller.vcd --stop-time=5us
	gtkwave controller.vcd

alu : filehandle.vhd ram.vhd pc.vhd register.vhd alu.vhd alu_tb.vhd
	ghdl -a --ieee=synopsys filehandle.vhd
	ghdl -a ram.vhd
	ghdl -a pc.vhd
	ghdl -a register.vhd
	ghdl -a alu.vhd
	ghdl -a alu_tb.vhd
	ghdl -e --ieee=synopsys alu_tb
	ghdl -r alu_tb --vcd=alu.vcd --stop-time=5us
	gtkwave alu.vcd