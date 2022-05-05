onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /top_tb/generic_sc_fifo/clk_i
add wave -noupdate /top_tb/generic_sc_fifo/data_i
add wave -noupdate /top_tb/generic_sc_fifo/rd_en_i
add wave -noupdate /top_tb/generic_sc_fifo/rst_i
add wave -noupdate /top_tb/generic_sc_fifo/wr_en_i
add wave -noupdate /top_tb/generic_sc_fifo/data_o
add wave -noupdate /top_tb/generic_sc_fifo/empty_o
add wave -noupdate /top_tb/generic_sc_fifo/full_o
add wave -noupdate /top_tb/generic_sc_fifo/usedw_o
add wave -noupdate /top_tb/generic_sc_fifo/empty
add wave -noupdate /top_tb/generic_sc_fifo/full
add wave -noupdate /top_tb/generic_sc_fifo/mem
add wave -noupdate /top_tb/generic_sc_fifo/prefetch_data
add wave -noupdate /top_tb/generic_sc_fifo/rd_addr
add wave -noupdate /top_tb/generic_sc_fifo/rd_data
add wave -noupdate /top_tb/generic_sc_fifo/rd_en
add wave -noupdate /top_tb/generic_sc_fifo/usedw
add wave -noupdate /top_tb/generic_sc_fifo/wr_addr
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
quietly wave cursor active 0
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {130 ns}
