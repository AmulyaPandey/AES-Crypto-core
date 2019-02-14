module AddRndKey_top(
input [127:0] ip,
input [127:0] ip_key,
input enable,
output [127:0] op
);

 wire[127:0] temp; //The data is stored here until 
                        //specified that it should be moved to the output
 
 
  //This step performs the XOR operation
   
    assign temp = ip ^ ip_key;
  
 
  //This block is used to move the data from temp to the output on the clock
   assign op = enable? temp:ip;
endmodule
