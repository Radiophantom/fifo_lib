vlib work

vlog -sv ../generic_sc_fifo.sv \
         top_tb.sv

vopt +acc -o top_tb_opt top_tb

vsim top_tb_opt

if { [file exists "wave.do"] } {
  do wave.do
}

run -all
