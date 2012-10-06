module SW_Reg_4col(clk,WE,AddrIn,DataIn,AddrOut,DataOut);
input clk;
input [10:0] AddrOut;
input [8:0] AddrIn;
input [31:0] DataIn;
input WE;

output [7:0] DataOut;

reg [8:0] dump;

reg [7:0] reg_file[0:351];

assign DataOut = reg_file[dump];
 
always @(posedge clk)
begin
   dump <= AddrOut;
   if (WE)
   begin
      reg_file[AddrIn*4+3] <= DataIn[31:24];
      reg_file[AddrIn*4+2] <= DataIn[23:16];
      reg_file[AddrIn*4+1] <= DataIn[15:8];
      reg_file[AddrIn*4] <= DataIn[7:0];
   end
end




endmodule
