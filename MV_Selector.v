module MV_Selector(clk,reset,WE,SADin,MVin,MVSelected,done_out,MVwait);
input clk,reset,WE,MVwait;
input [15:0] SADin;
input [13:0] MVin;
reg [15:0] SADSelected;
output reg [13:0] MVSelected;

reg [15:0] SADmin;
reg [13:0] MVmin;

reg [15:0] SADs0, SADs1, SADs2;
reg [13:0] MVs0, MVs1, MVs2;
reg [1:0] count;

reg WE_delay1, WE_delay2, WE_delay3,MVwait_delay1,MVwait_delay2;
reg [13:0] MV_delay1, MV_delay2, MV_delay3;
reg done;
output reg done_out;

integer i;

always @(posedge clk, posedge reset)
begin
    if (reset)
    begin
        WE_delay1 <= 0;
        WE_delay2 <= 0;
        WE_delay3 <= 0;
        MV_delay1 <= 0;
        MV_delay2 <= 0;
        MV_delay3 <= 0;
		MVwait_delay1 <= 0;
		MVwait_delay2 <= 0;
    end
    else
    begin
       WE_delay1 <= WE;
       WE_delay2 <= WE_delay1;
       WE_delay3 <= WE_delay2;
	   MVwait_delay1 <= MVwait;
	   MVwait_delay2 <= MVwait_delay1;
       MV_delay1 <= MVin;
       MV_delay2 <= MV_delay1;
       MV_delay3 <= MV_delay2;       
    end
end


always @(posedge clk, posedge reset)
begin
   if (reset)
   begin
		SADs0 <= 16'hFFFF;
        MVs0 <= 14'b0;
		SADs1 <= 16'hFFFF;
        MVs1 <= 14'b0;
		SADs2 <= 16'hFFFF;
        MVs2 <= 14'b0;
		done <= 1'b0;
	end
   else if (WE_delay3)
   begin
		case (count)
		0:
		begin
			SADs0 <= SADin;
			MVs0 <= MV_delay2;
		end
		1:
		begin
			SADs1 <= SADin;
			MVs1 <= MV_delay2;
			if (MVwait_delay2)
				SADs2 <= 16'hFFFF;
		end
		2:
		begin
			SADs2 <= SADin;
			MVs2 <= MV_delay2;
		end
		endcase
		//SADs[count] <= SADin;
		//MVs[count] <= MV_delay2;
		//if (WE_delay2)
		//count <= count + 1;
		//else
		//begin
			if (MVwait_delay2)
			begin
				done <= 1'b1;
			end
		//end 
   end
   else
      done <= 1'b0;
end

always @(posedge clk, posedge reset)
begin
	if(reset)
		count <= 3;
	else if (WE_delay2)
	begin
		count <= count + 1;
	end
	else if (WE_delay3 && MVwait)
	begin
		count <= 3;
	end
end

always @(posedge clk, posedge reset)
begin
    if (reset)
    begin
        SADSelected <= 0;
        MVSelected <= 0;
		done_out <= 0;
    end
    //else if (count == 2)
    else if (done)
    begin
        SADSelected <= SADmin;
        MVSelected <= MVmin;
		done_out <= 1;
    end
	else
		done_out <= 0;
end

always @(*)
begin
    if (SADs0 <= SADs1)
       if (SADs0 <= SADs2)
          begin
              SADmin = SADs0;
              MVmin = MVs0;
          end
       else
          begin
              SADmin = SADs2;
              MVmin = MVs2;
          end
    else
       if (SADs1<=SADs2)
       begin
              SADmin = SADs1;
              MVmin = MVs1;
       end
       else
       begin
           SADmin = SADs2;
           MVmin = MVs2;
       end
end

endmodule
