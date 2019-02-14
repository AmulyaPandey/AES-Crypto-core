module AES_top #(parameter N=4)(
//from testbench
input  clk,
input  start,
input  rstn,
input  [128*N-1:0] plain_text,
input  [128*N-1:0] cipher_key,
//to testbench
output  done,
output  [9:0] completed_round,
output  [128*N-1:0] cipher_text
);

wire accept;
wire [3:0] rndNo ;
wire enbSB ;
wire enbSR ;
wire enbMC ;
wire enbAR ;
wire enbKS ;

genvar j;

//instantiation of AEScntx module
AEScntx inst_AEScntx(
.clk(clk), 
.start(start),
.rstn(rstn),
.accept(accept),
.rndNo(rndNo),
.enbSB(enbSB),
.enbSR(enbSR),
.enbMC(enbMC),
.enbAR(enbAR),
.enbKS(enbKS),
.done(done),
.completed_round(completed_round)
);


//Instantiate core module N times

generate for(j=0; j<N; j=j+1)
begin

//instantiation of AESCore module
AESCore inst_AESCore(
.clk(clk),
.rstn(rstn),
.plain_text(plain_text[(j+1)*128-1:j*128]),
.cipher_key(cipher_key[(j+1)*128-1:j*128]),
.accept(accept),
.rndNo(rndNo),
.enbSB(enbSB),
.enbSR(enbSR),
.enbMC(enbMC),
.enbAR(enbAR),
.enbKS(enbKS),
.cipher_text (cipher_text[(j+1)*128-1:j*128])
);
end
endgenerate

endmodule
