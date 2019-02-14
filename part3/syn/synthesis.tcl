read_verilog AES_top.v
current_design AES_top
link

#enter the files to be analyzed
analyze -format verilog /class2/ug15/a152643j/A0152643J/part1/src/AddRndKey_top.v
analyze -format verilog /class2/ug15/a152643j/A0152643J/part1/src/AEScntx.v
analyze -format verilog /class2/ug15/a152643j/A0152643J/part1/src/AESCore.v
analyze -format verilog /class2/ug15/a152643j/A0152643J/part1/src/aes_sbox.v
analyze -format verilog /class2/ug15/a152643j/A0152643J/part1/src/AES_top.v
analyze -format verilog /class2/ug15/a152643j/A0152643J/part1/src/KeySchedule.v
analyze -format verilog /class2/ug15/a152643j/A0152643J/part1/src/matrix_mult.v
analyze -format verilog /class2/ug15/a152643j/A0152643J/part1/src/MixCol_top.v
analyze -format verilog /class2/ug15/a152643j/A0152643J/part1/src/shiftRows_top.v
analyze -format verilog /class2/ug15/a152643j/A0152643J/part1/src/subBytes_top.v

#elaborate top
elaborate AES_top

current_design AES_top
link

#source constraint file
source constraint.tcl

#compile the top module
compile

#retiming
optimize_registers

#report critical path
report_timing 

#report area
report_area








