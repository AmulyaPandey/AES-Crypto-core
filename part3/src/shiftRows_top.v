module shiftRows_top(
input [127:0] ip,
input enable,
output [127:0] op
);
wire [127:0] out;

            assign out[127:120] = ip[127:120];
            assign out[119:112] = ip[87:80];
            assign out[111:104] = ip[47:40];
            assign out[103:96] = ip[7:0];
                    
            assign out[95:88] = ip[95:88];
            assign out[87:80] = ip[55:48];
            assign out[79:72] = ip[15:8];
            assign out[71:64] = ip[103:96];
                    
            assign out[63:56] = ip[63:56];
            assign out[55:48] = ip[23:16];
            assign out[47:40] = ip[111:104];
            assign out[39:32] = ip[71:64];
                    
            assign out[31:24] = ip[31:24];
            assign out[23:16] = ip[119:112];
            assign out[15:8] = ip[79:72];
            assign out[7:0] = ip[39:32];
                    
        assign op = enable? out:ip;
endmodule
