module AESCore #(parameter N=4)(
input clk,
input rstn,
input [127:0] plain_text,
input [127:0] cipher_key,
//from controller
input accept,
input [3:0] rndNo,
input enbSB,
input enbSR,
input enbMC,
input enbAR,
input enbKS,
//to testbench
output [127:0] cipher_text
);

wire [127:0] outSB;
wire [127:0] outSR;
wire [127:0] outMC;
wire [127:0] outAR;
wire [127:0] outKS;

reg [127:0] inp_text[N:1];
reg [127:0] inp_key[N:1];

reg [127:0] outAR_reg[N:1];
reg [127:0] outKS_reg[N:1];

wire [127:0] inpkey;
wire [127:0] inpSB;

genvar j;

generate for(j=1; j<=N; j=j+1)
begin

always@(posedge clk or negedge rstn)
    begin
        if(~rstn)
        //input is reset
            begin
                inp_text[j] <= 128'h0;
                inp_key[j] <= 128'h0;
            end
        //accept input from the testbench
        else 
            begin
		if(j==1)
	     		begin
               			inp_text[j] <= plain_text;
               			inp_key[j] <= cipher_key;		
			end
		else
			begin
				//accept input from previous registers
				inp_text[j] <= inp_text[j-1];
				inp_key[j] <= inp_key[j-1];
			end
    	    end
	end
  
//Store the previous values of KeySchedule and AddRoundKey block
always@(posedge clk, negedge rstn)
    begin
        if(~rstn)
            begin
                outAR_reg[j] <= 128'h0;
                outKS_reg[j] <= 128'h0;
            end  
        else 
            begin
		if(j==1)
			begin
			//accept input from the testbench
                		outAR_reg[j] <= outAR;
                		outKS_reg[j] <= outKS;
            		end
		else
			begin
			//accept input from previous registers
				outAR_reg[j] <= outAR_reg[j-1];
				outKS_reg[j] <= outKS_reg[j-1];
			end
            end
    end

end 
endgenerate
   
   //If round=0, accept input from the testbench, else accept input from the output of previous rounds
   assign inpSB = (rndNo==4'h1)?inp_text[N]:outAR_reg[N];
   //If round=0, accept the cipher key, else take key from KeySchedular
   assign inpkey = (rndNo==4'h1)?inp_key[N]:outKS_reg[N];         
            
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
