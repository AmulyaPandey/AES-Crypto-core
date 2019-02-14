module AEScntx(
//from testbench
input  clk,
input  start,
input  rstn,
//to AEScore
output  accept,
output  [3:0] rndNo,
output  reg enbSB,
output  reg enbSR,
output  reg enbMC,
output  reg enbAR,
output  reg enbKS,
//to testbench
output  reg done,
output  reg [9:0] completed_round
);

reg [3:0] rndNo_reg;

// round counter manager
always @(posedge clk or negedge rstn)
    begin
        if(~rstn)
            rndNo_reg <= 4'h0;
        else if(~start)
            rndNo_reg <= 4'h0;
        else
            rndNo_reg <= rndNo + 4'h1;
    end
 
 
 always @(posedge clk or negedge rstn)
        begin
            if(~rstn)
                completed_round <= 4'h0;
            else if((rndNo>4'h0) && (rndNo<=4'ha) )
                completed_round <= completed_round + 4'h1;
            else
                completed_round <= completed_round;
        end


always @(*)
begin   

//Assign the signals for the AES FSM flow
//Assign the initial signals
if( rndNo_reg == 4'h0 )
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
else if(rndNo_reg == 4'h1)
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
else if( rndNo_reg == 4'hb)
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

assign rndNo = rndNo_reg;
assign accept = start; 

endmodule
