#create a clock with given constrained clock period
create_clock -period 2 [get_ports clk]

#create input delay on all inputs except clock
set_input_delay -max 0.2 -clock clk [remove_from_collection [all_inputs] [get_ports clk]]

#create output delay on all outputs
set_output_delay -max 0.2 -clock clk [all_outputs]

#set given load capacitance on all output pins
set_load 5 [all_outputs]
