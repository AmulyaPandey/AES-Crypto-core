module AES_top #(parameter N=4)(
//from testbench
input clk,
input start,
input rstn,
input [127:0] plain_text,
input [127:0] cipher_key,
//to testbench
output done,
output [127:0] cipher_text
);

wire accept;
wire [3:0] rndNo ;
wire enbSB ;
wire enbSR ;
wire enbMC ;
wire enbAR ;
wire enbKS ;

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
.done(done)
);

//instantiation of AESCore module
AESCore inst_AESCore(
.clk(clk),
.rstn(rstn),
.plain_text(plain_text),
.cipher_key(cipher_key),
.accept(accept),
.rndNo(rndNo),
.enbSB(enbSB),
.enbSR(enbSR),
.enbMC(enbMC),
.enbAR(enbAR),
.enbKS(enbKS),
.cipher_text(cipher_text)
);

endmodule
