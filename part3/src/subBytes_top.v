module subBytes_top(
input [127:0] ip,
input enable,
output [127:0] op
);

wire [127:0] state_in;
wire[127:0] enc_data;
 
 //input is stored in reg state_in
 assign state_in = ip;
 
 //This losboxs generates the SubBytes and stores result in local variable
  
  genvar i;
  
   generate for (i = 0; i < 16; i = i + 1) 
   begin 
        aes_sbox sbox(.ip (state_in[((i + 1) * 8) - 1:(i * 8)]),
                       .op (enc_data[((i + 1) * 8) - 1:(i * 8)]));
   end
   endgenerate

    // move enc_data to output
    assign op = enable ? enc_data:ip;
endmodule
