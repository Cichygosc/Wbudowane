crc8: crc8.vhd crc8_tb.vhd pack.vhd rom.vhd
		ghdl -a pack.vhd
		ghdl -a rom.vhd
		ghdl -a crc8.vhd
		ghdl -a --ieee=synopsys crc8_tb.vhd
		ghdl -e --ieee=synopsys crc8_tb