module MixCol_top(
input [127:0] ip,
input enable,
output [127:0] op
);
   
   wire [31:0] d0;
   wire [31:0] d1;
   wire [31:0] d2;
   wire [31:0] d3;
   wire [127:0] temp;
    
        //store the input in temporary variable array
             assign d0 = ip[127:96];
             assign d1 = ip[95:64];
             assign d2 = ip[63:32];
             assign d3 = ip[31:0];
             
             //First column
              matrix_mult inst_multi_1(.ip (d0),
                                    .op (temp[127:96]) );
              
             //Second column
              matrix_mult inst_multi_2(.ip (d1),
                                    .op (temp[95:64]) );
              
             //Third column
              matrix_mult inst_multi_3(.ip (d2),
                                    .op (temp[63:32]) );
                                    
             //Fourth column
              matrix_mult inst_multi_4(.ip (d3),
                                    .op (temp[31:0]) );             

             //assign the result to the ouput, when block is enabled 
             assign op = enable? temp[127:0]:ip;
endmodule
