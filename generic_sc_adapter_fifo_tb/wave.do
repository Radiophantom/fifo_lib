onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /top_tb/rst
add wave -noupdate /top_tb/clk
add wave -noupdate /top_tb/rd_data
add wave -noupdate /top_tb/rd_empty
add wave -noupdate /top_tb/rd_en
add wave -noupdate /top_tb/rd_full
add wave -noupdate /top_tb/rd_usedw
add wave -noupdate /top_tb/wr_data
add wave -noupdate /top_tb/wr_empty
add wave -noupdate /top_tb/wr_en
add wave -noupdate /top_tb/wr_full
add wave -noupdate /top_tb/wr_usedw
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
WaveRestoreZoom {842 ns} {909 ns}
