module AESCore(
//from testbench
input  clk,
input  rstn,
input  [127:0] plain_text,
input  [127:0] cipher_key,
//from controller
input  accept,
input  [3:0] rndNo,
input  enbSB,
input  enbSR,
input  enbMC,
input  enbAR,
input  enbKS,
//to testbench
output [127:0] cipher_text
);

wire [127:0] outSB;
wire [127:0] outSR;
wire [127:0] outMC;
wire [127:0] outAR;
wire [127:0] outKS;

reg [127:0] inp_text;
reg [127:0] inp_key;

reg [127:0] outAR_reg;
reg [127:0] outKS_reg;

wire [127:0] inpkey;
wire [127:0] inpSB;

always@(posedge clk or negedge rstn)
    begin
        if(~rstn)
        //input is reset
            begin
                inp_text <= 128'h0;
                inp_key <= 128'h0;
            end
        //accept input from the testbench
        else if(accept)
            begin
                inp_text <= plain_text;
                inp_key <= cipher_key;
            end
    end
  
//Store the previous values of KeySchedule and AddRoundKey block
always@(posedge clk, negedge rstn)
    begin
        if(~rstn)
            begin
                outAR_reg <= 128'h0;
                outKS_reg <= 128'h0;
            end  
        else 
            begin
                outAR_reg <= outAR;
                outKS_reg <= outKS;
            end
    end
   
   //If round=0, accept input from the testbench, else accept input from the output of previous rounds
   assign inpSB = (rndNo==4'h1)?inp_text:outAR_reg;
   //If round=0, accept the cipher key, else take key from KeySchedular
   assign inpkey = (rndNo==4'h1)?inp_key:outKS_reg;         
            
//Instantiate the blocks for AES encryption

//Performs substitution from Sbox
subBytes_top sub(
.enable (enbSB),
.ip (inpSB),
.op (outSB)
);

//Performs shifting of rows 
shiftRows_top shift(
.enable (enbSR),
.ip (outSB),
.op (outSR)
);

//Performs mix_column operation
MixCol_top Mix_col(
.enable (enbMC),
.ip (outSR),
.op (outMC)
);

//Performs add round key
AddRndKey_top Addrk(
.enable (enbAR),
.ip (outMC),
.op (outAR),
.ip_key (outKS)
);

//Expand cipher Key to obtain Key for all rounds 
KeySchedule_top KeyExp(
.enable (enbKS),
.rndNo (rndNo),
.ip_key (inpkey),
.op_key (outKS)
);

//Store the output of the AES block 
assign cipher_text = (rndNo==4'hb || rstn)? outAR:128'h0; 


endmodule
