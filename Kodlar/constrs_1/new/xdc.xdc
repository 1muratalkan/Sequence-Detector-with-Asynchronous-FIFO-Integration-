create_clock -period 10.000 -name WR_CLK -waveform {0.000 5.000}
create_clock -period 25.000 -name RD_CLK -waveform {0.000 12.500} [get_ports RD_CLK]

