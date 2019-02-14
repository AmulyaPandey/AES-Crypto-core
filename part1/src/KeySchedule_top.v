module KeySchedule_top(
input  [127:0] ip_key,
input  enable,
input  [3:0] rndNo,
output  [127:0] op_key
);

wire [7:0] d0;
wire [7:0] d1;
wire [7:0] d2;
wire [7:0] d3;
wire [31:0] temp;
wire [127:0] key_out;
wire [31:0] Rc;

                //Do s-box substitution and store in temp variable
                aes_sbox sbox_1(.ip (ip_key[31:24]),
                                .op (d0));
                aes_sbox sbox_2(.ip (ip_key[23:16]),
                               .op (d1));
                aes_sbox sbox_3(.ip (ip_key[15:8]),
                                .op (d2));
                aes_sbox sbox_4(.ip (ip_key[7:0]),
                                .op(d3));
                
                //Store the result in temp variable 
                assign temp = {d1,d2,d3,d0};    
                assign Rc = Rcon(rndNo-4'h1);

                //Xor the vectors to obtain output_key
                assign key_out[127:96] = ip_key[127:96]^temp^Rc;
                assign key_out[95:64] = key_out[127:96]^ip_key[95:64];
                assign key_out[63:32] = key_out[95:64]^ip_key[63:32];
                assign key_out[31:0] = key_out[63:32]^ip_key[31:0];
                                     
            //Assign output key for the given round                                                      
            assign op_key = enable? key_out:ip_key;


//The Rcon function stores the "Round Constants"
  function [31:0] Rcon;
    input[3:0] x;
    
    begin
      case(x)	
      4'h1: Rcon = 32'h01000000;
      4'h2: Rcon = 32'h02000000;
      4'h3: Rcon = 32'h04000000;
      4'h4: Rcon = 32'h08000000;
      4'h5: Rcon = 32'h10000000;
      4'h6: Rcon = 32'h20000000;
      4'h7: Rcon = 32'h40000000;
      4'h8: Rcon = 32'h80000000;
      4'h9: Rcon = 32'h1b000000;
      4'ha: Rcon = 32'h36000000;
      default:Rcon = 32'h00;
    endcase
    end
  endfunction

endmodule
