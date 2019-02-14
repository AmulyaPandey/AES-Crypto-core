create_clock -period 0.5 [get_ports clk]

set_input_delay -max 0.1 -clock clk [remove_from_collection [all_inputs] [get_ports clk]]

set_output_delay -max 0.1 -clock clk [all_outputs]

set_load 5 [all_outputs]
