module AEScntx #(parameter N=4)(
//from testbench
input clk,
input start,
input rstn,
//to AEScore
output accept,
output [3:0] rndNo,
output reg enbSB,
output reg enbSR,
output reg enbMC,
output reg enbAR,
output reg enbKS,
//to testbench
output reg done
);

reg [3:0] rndNo_reg[N:1];

genvar j;

generate for(j=1; j<=N; j=j+1)
begin

// round counter manager
always @(posedge clk or negedge rstn)
    begin
        if(~rstn)
            rndNo_reg[j] <= 4'h0;
        else if(~start)
            rndNo_reg[j] <= 4'h0;
        else
	begin
		if(j==1)
			begin
				if(rndNo_reg[N]==4'hb)
					rndNo_reg[j] <= 4'h1;
				else if(rndNo_reg[N]==rndNo_reg[j])
					rndNo_reg[j] <= rndNo_reg[j]+4'h1;
			end
		else
            		rndNo_reg[j] <= rndNo_reg[j-1];
    	end
    end

end 
endgenerate

always @(*)
begin   

//Assign the signals for the AES FSM flow
//Assign the initial signals
if( rndNo_reg[N] == 4'h0 )
    begin
        //accept = 1'b1;
        enbSB = 1'b0;
        enbSR = 1'b0;
        enbMC = 1'b0;
        enbAR = 1'b0;
        enbKS = 1'b0;
        done = 1'b0;    
    end
 
//First round of AES   
else if(rndNo_reg[N] == 4'h1)
    begin
        //accept = 1'b1;
        enbSB = 1'b0;
        enbSR = 1'b0;
        enbMC = 1'b0;
        enbAR = 1'b1;
        enbKS = 1'b0;
        done = 1'b0;
    end
    
//final round of AES  
else if( rndNo_reg[N] == 4'hb)
    begin
        //accept = 1'b1;
        enbSB = 1'b1;
        enbSR = 1'b1;
        enbMC = 1'b0;
        enbAR = 1'b1;
        enbKS = 1'b1;
        done = 1'b1;
    end
          
//9 main rounds of AES
else 
    begin
        //accept = 1'b1;
        enbSB = 1'b1;
        enbSR = 1'b1;
        enbMC = 1'b1;
        enbAR = 1'b1;
        enbKS = 1'b1;
        done = 1'b0;
    end       
end  

assign rndNo = rndNo_reg[N];
assign accept = start; 

endmodule
