module SW_AddrGen(clk,reset,enable,SW_WE,vecin,updatein,UWDATA_Out,UW_WE,MV_ready,outMV,InputDATA,InputADDR,done,UWaddress_out,UW_ROW,UW_COL,MVselect_WE,MVwait,Row_end,frame_end,feed,UW_sel_col);
input clk,reset,enable,SW_WE;
input wire [5:0] updatein;
input wire [13:0] vecin;
input wire MV_ready,Row_end,frame_end;
output reg [13:0] outMV;
output reg [(8*22)-1:0] UWDATA_Out;
output reg UW_WE;
output wire UW_sel_col;
input wire [0:63] InputDATA;
input wire [6:0] InputADDR;
output done,feed;
output reg MVselect_WE;
output wire [4:0] UWaddress_out;
output reg [4:0] UW_ROW,UW_COL;
output reg MVwait;
wire preMVwait;
reg MVselect_WEpre;
reg [13:0] preoutMV;
wire [31:0] inputpart1,inputpart2;
reg [1:0] feedcount;
reg [4:0] order;
reg [3:0] order11;
reg [7:0] packedInput [0:87];
reg [6:0] SWshift;
wire inside,within_reach, inside_row, inside_col;
reg [13:0] UWpos;
reg[13:0] out;
wire [1:0] pre_median;
reg [1:0] median;
wire pre_underTh;
reg underTh;
reg [2:0] State;
reg [2:0] SubState, SubState_d;
reg [13:0] vectors0,vectors1,vectors2;
reg [13:0] medianMV;
reg [5:0] UW_count_d;
reg [5:0] UWcount;
//reg [6:0] check_y_d;
//reg [6:0] check_x_d;
wire [7:0] howmany_row_signed, act_howmany_row_signed;
wire [7:0] howmany_col_signed, act_howmany_col_signed;
reg [7:0] withincheck,UWcount_col_value,UWcount_row_value;
wire [6:0] limited_out_x;
wire [6:0] limited_out_y;
//reg [6:0] neg_lim_out_x_reg ,neg_lim_out_y_reg;
wire [6:0] new_UWpos_x, new_UWpos_y;
reg [6:0] whichblock_x, whichblock_y;
reg [1:0] mod_x,mod_y;
reg [4:0] SWcoord_mod_x, SWcoord_mod_y;
wire [6:0] SWcoord_x, SWcoord_y, modSWcoord_x, premodSWcoord_x;
reg [6:0] SWcoord_x_reg, SWcoord_y_reg;
wire [7:0] preSWcoord_x, preSWcoord_y;
wire [8:0] addrrow,addrcol,addrcol2,addrcol3,addrcol4,addrcol5,addrcol6,addrcol7,addrcol8,addrcol9,addrcol10,addrcol11,
		addrcol12,addrcol13,addrcol14,addrcol15,addrcol16,addrcol17,addrcol18,addrcol19,addrcol20,addrcol21,addrcol22;
reg valid,UW_Filled;

reg [4:0] reference_block_x, reference_block_y;
reg [5:0] pre_new_ref_x, pre_new_ref_y, pre_new_ref_x_reg, pre_new_ref_y_reg;
wire [4:0] new_ref_x, new_ref_y, ref_x_minusone, ref_y_minusone, mod_ref_x_minusone, mod_ref_y_minusone;
reg [4:0] start_block_x, start_block_y;
wire [4:0] ref_check_x, ref_check_y;
//wire [5:0] howmany_signed_col, howmany_signed_row;
wire [6:0] howmany_col, howmany_row, act_howmany_row, act_howmany_col;
wire sign_howmany_row,sign_howmany_col;

reg [31:0] WDATA_S01, WDATA_S02, WDATA_S03, WDATA_S04, WDATA_S05, WDATA_S06, WDATA_S07, WDATA_S08, WDATA_S09, WDATA_S10, WDATA_S11, WDATA_S12, WDATA_S13, WDATA_S14, WDATA_S15, WDATA_S16, WDATA_S17, WDATA_S18, WDATA_S19, WDATA_S20, WDATA_S21, WDATA_S22;
	
reg [10:0] RADDR_S01, RADDR_S02, RADDR_S03, RADDR_S04, RADDR_S05, RADDR_S06, RADDR_S07, RADDR_S08, RADDR_S09, RADDR_S10, RADDR_S11, RADDR_S12, RADDR_S13, RADDR_S14, RADDR_S15, RADDR_S16, RADDR_S17, RADDR_S18, RADDR_S19, RADDR_S20, RADDR_S21, RADDR_S22;
reg [8:0] raddr1, raddr2, raddr3, raddr4, raddr5, raddr6, raddr7, raddr8, raddr9, raddr10, raddr11, raddr12, raddr13, raddr14, raddr15, raddr16, raddr17, raddr18, raddr19, raddr20, raddr21, raddr22;
wire [8:0] readaddr,readaddr2,readaddr3,readaddr4,readaddr5,readaddr6,readaddr7,readaddr8,readaddr9,readaddr10,readaddr11,
	readaddr12,readaddr13,readaddr14,readaddr15,readaddr16,readaddr17,readaddr18,readaddr19,readaddr20,readaddr21,readaddr22;
wire [5:0] whichRAM;
wire [6:0] prewhichRAM;
reg [4:0] whichRAM_d;
wire [7:0] RDATA_S01, RDATA_S02, RDATA_S03, RDATA_S04, RDATA_S05, RDATA_S06, RDATA_S07, RDATA_S08, RDATA_S09, RDATA_S10, RDATA_S11, RDATA_S12, RDATA_S13, RDATA_S14, RDATA_S15, RDATA_S16, RDATA_S17, RDATA_S18, RDATA_S19, RDATA_S20, RDATA_S21, RDATA_S22;
reg [8:0] WADDR_S;
wire [31:0] pack1,pack2,pack3,pack4,pack5,pack6,pack7,pack8,pack9,pack10,pack11,pack12,pack13,pack14,pack15,pack16,pack17,pack18,pack19,pack20,pack21,pack22;
reg WE_S01,WE_S02,WE_S03,WE_S04,WE_S05,WE_S06,WE_S07,WE_S08,WE_S09,WE_S10,WE_S11,WE_S12,WE_S13,WE_S14,WE_S15,WE_S16,WE_S17,WE_S18,WE_S19,WE_S20,WE_S21,WE_S22;
reg WEorder1,WEorder2,WEorder3,WEorder4,WEorder5,WEorder6,WEorder7,WEorder8,WEorder9,WEorder10,WEorder11;
//wire WE_S;
integer i;
wire [13:0] vecin1, vecin2, vecin3;
wire [5:0] preUWaddr_out;

parameter S_idle = 0, S_init = 1, S_Vector1 = 2, S_Vector2u = 3, S_Vector3 = 4, S_Wait = 5;
parameter Sub_Init = 0, Sub_Fill_UW_row_load = 3, Sub_Fill_UW_row = 4, Sub_Fill_UW_col_load = 1, Sub_Fill_UW_col = 2, Sub_Filled = 5;

assign preUWaddr_out = ((UW_sel_col) ? start_block_x : start_block_y) + UW_count_d;

assign UWaddress_out = ((preUWaddr_out > 22) ? ((preUWaddr_out > 42) ? (preUWaddr_out + 22) : (preUWaddr_out - 22)) : preUWaddr_out);

assign vecin1 = vectors0;
assign vecin2 = vectors1;
assign vecin3 = vectors2;

assign high = 1'b1;
assign low = 1'b0;

always @*
begin
	case (median)
	0: medianMV = vectors0;
	1: medianMV = vectors1;
	2: medianMV = vectors2;
	3: medianMV = 0;
	endcase
end
//assign medianMV = vectors[median];

//assign WE_S = SW_WE;
//assign UWpos_x = (limited_out_x > 33) ? ((limited_out_x <= 36) ? 33 : ((limited_out_x < 95) ? 95 : limited_out_x)) : limited_out_x;
//assign UWpos_y = (limited_out_y > 33) ? ((limited_out_y <= 36) ? 33 : ((limited_out_y < 95) ? 95 : limited_out_y)) : limited_out_y;
//assign UWpos_x = (neg_lim_out_x > 33) ? ((neg_lim_out_x <= 36) ? 33 : ((neg_lim_out_x < 95) ? 95 : neg_lim_out_x)) : neg_lim_out_x;
//assign UWpos_y = (neg_lim_out_y > 33) ? ((neg_lim_out_y <= 36) ? 33 : ((neg_lim_out_y < 95) ? 95 : neg_lim_out_y)) : neg_lim_out_y;

assign done = (State == S_Wait && MV_ready) ? 1'b1 : 1'b0;

assign howmany_row_signed = {{1 {limited_out_y[6]}}, limited_out_y} - {{1 {UWpos[13]}}, UWpos[13:7]};
assign howmany_col_signed = {{1 {limited_out_x[6]}}, limited_out_x} - {{1 {UWpos[6]}}, UWpos[6:0]};
assign sign_howmany_row = (howmany_row_signed > 127) ? 1'b1 : 1'b0;
assign sign_howmany_col = (howmany_col_signed > 127) ? 1'b1 : 1'b0;
assign howmany_row = (sign_howmany_row) ? (~howmany_row_signed + 1'b1) : (howmany_row_signed);  
assign howmany_col = (sign_howmany_col) ? (~howmany_col_signed + 1'b1) : (howmany_col_signed);
assign act_howmany_row = (inside_row) ? 0 : howmany_row - 3;
assign act_howmany_col = (inside_col) ? 0 : howmany_col - 3;
assign act_howmany_row_signed = (sign_howmany_row) ? (~act_howmany_row + 1'b1) : act_howmany_row;
assign act_howmany_col_signed = (sign_howmany_col) ? (~act_howmany_col + 1'b1) : act_howmany_col;
assign inside_row = (howmany_row <= 3) ? 1'b1 : 1'b0;
assign inside_col = (howmany_col <= 3) ? 1'b1 : 1'b0;
assign inside = valid ? ((inside_row && inside_col) ? 1'b1 : 1'b0) : 1'b0;

always @*
begin
	if (!inside_row)
		if (!inside_col)
			withincheck = act_howmany_row + act_howmany_col;
		else
			withincheck = act_howmany_row;
	else
		withincheck = act_howmany_col;
end


assign within_reach = valid ? ((withincheck <= 21) ? 1'b1 : 1'b0) : 1'b0;

assign new_UWpos_x = UWpos[6:0] + act_howmany_col_signed;
assign new_UWpos_y = UWpos[13:7] + act_howmany_row_signed;


assign new_ref_x = (pre_new_ref_x_reg > 21) ? ((pre_new_ref_x_reg > 42) ? (pre_new_ref_x_reg + 22) : (pre_new_ref_x_reg - 22)) : pre_new_ref_x_reg;
assign new_ref_y = (pre_new_ref_y_reg > 21) ? ((pre_new_ref_y_reg > 42) ? (pre_new_ref_y_reg + 22) : (pre_new_ref_y_reg - 22)) : pre_new_ref_y_reg;

//assign howmany_col = (howmany_signed_col > 32) ? (~howmany_signed_col + 1'b1) : howmany_signed_col;
//assign howmany_row = (howmany_signed_row > 32) ? (~howmany_signed_row + 1'b1) : howmany_signed_row;
assign ref_x_minusone = reference_block_x - 1;
assign ref_y_minusone = reference_block_y - 1;
assign mod_ref_x_minusone = (ref_x_minusone == 31) ? 21 : ref_x_minusone;
assign mod_ref_y_minusone = (ref_y_minusone == 31) ? 21 : ref_y_minusone;

always @*
begin
	if (within_reach)
	begin
		UWcount_col_value = act_howmany_col_signed;
		UWcount_row_value = act_howmany_row_signed;
		//howmany_signed_col = (UWcheck_col > 36) ? (UWcheck_col + 3) : (UWcheck_col -3);
		//howmany_signed_row = (UWcheck_row > 36) ? (UWcheck_row + 3) : (UWcheck_row -3);
		//start_block_x = (UWcheck_col > 36) ? ((reference_block_x == 0) ? 21 : 0) : reference_block_x;
		//start_block_y = (UWcheck_row > 36) ? ((reference_block_y == 0) ? 21 : 0) : reference_block_y;
		start_block_x = (sign_howmany_col) ? (mod_ref_x_minusone) : (reference_block_x);
		start_block_y = (sign_howmany_row) ? (mod_ref_y_minusone) : (reference_block_y);
		pre_new_ref_x = reference_block_x + act_howmany_col_signed;
		pre_new_ref_y = reference_block_y + act_howmany_row_signed;
	end
	else
	begin
		UWcount_col_value = (sign_howmany_col) ? 42 : 22;
		UWcount_row_value = 0;
		//howmany_col_signed = 22;
		//howmany_row_signed = 0;
		start_block_x = (sign_howmany_col) ? 21 : 0;
		start_block_y = (sign_howmany_row) ? 21 : 0;
		pre_new_ref_x = 0;
		pre_new_ref_y = 0;
	end
end

always @ (posedge clk)
begin
	if (reset)
	begin
		pre_new_ref_x_reg <=0;
		pre_new_ref_y_reg <=0;
	end
	else if (SubState == Sub_Init)
	begin
		pre_new_ref_x_reg <= pre_new_ref_x;
		pre_new_ref_y_reg <= pre_new_ref_y;
	end
end

assign ref_check_x = howmany_col_signed + reference_block_x;
assign ref_check_y = howmany_row_signed + reference_block_y;

always @(posedge clk, posedge reset)
begin
	if (reset)
	begin
		median <= 0;
		underTh <= 0;
	end
	else
	begin
		median <= pre_median;
		underTh <= pre_underTh;
	end
end

always @(posedge clk, posedge reset)
begin
	if (reset)
	begin
		UWcount <= 0;
	end
/*	else if (bi stateteyken)
	begin
		UWcount_col <= howmany_col;
		UWcount_row <= howmany_row;
	end*/
	else if (SubState == Sub_Fill_UW_col_load)
	begin
		if (sign_howmany_col)
			UWcount <= UWcount_col_value + 1;
		else
			UWcount <= UWcount_col_value - 1;
	end
	else if (SubState == Sub_Fill_UW_col)
	begin
		/*if (UWcount_col == act_howmany_col)
			UWcount_col <= 0;
		else*/
		if (sign_howmany_col)	
			UWcount <= UWcount + 1;
		else
			UWcount <= UWcount - 1;
	end
	else if (SubState == Sub_Fill_UW_row_load)
	begin
		if (sign_howmany_row)
			UWcount <= UWcount_row_value + 1;
		else
			UWcount <= UWcount_row_value - 1;
	end
	else if (SubState == Sub_Fill_UW_row)
		if (sign_howmany_row)	
			UWcount <= UWcount + 1;
		else
			UWcount <= UWcount - 1;
	else
	begin
		UWcount<= 0;
	end
end

/*always @*
begin
	if (inside)
	begin
		if (ref_check_y > 24)
			UW_ROW = ref_check_y + 22;
		else if (ref_check_y > 21)
			UW_ROW = ref_check_y - 22;
		else
			UW_ROW = ref_check_y;
		if (ref_check_x > 24)
			UW_COL = ref_check_x + 22;
		else if (ref_check_x > 21)
			UW_COL = ref_check_x - 22;
		else
			UW_COL = ref_check_x;
	end
	else
	begin
		UW_ROW = 0;
		UW_COL = 0;
	end

end*/

always @(posedge clk, posedge reset)
begin
	if (reset)
	begin
		UW_ROW <= 0;
		UW_COL <= 0;
	end
	else if (inside)
	begin
		if (ref_check_y > 24)
			UW_ROW <= ref_check_y + 22;
		else if (ref_check_y > 21)
			UW_ROW <= ref_check_y - 22;
		else
			UW_ROW <= ref_check_y;
		if (ref_check_x > 24)
			UW_COL <= ref_check_x + 22;
		else if (ref_check_x > 21)
			UW_COL <= ref_check_x - 22;
		else
			UW_COL <= ref_check_x;
	end
end


assign limited_out_x = (out[6:0] > 36) ? ((out[6:0] < 40) ? 36 : ((out[6:0] < (~7'd36 + 1'b1)) ? (~7'd36 + 1'b1) : out[6:0])) : out[6:0];
assign limited_out_y = (out[13:7] > 36) ? ((out[13:7] < 40) ? 36 : ((out[13:7] < (~7'd36 + 1'b1)) ? (~7'd36 + 1'b1) : out[13:7])) : out[13:7]; 
//assign neg_lim_out_x = (~limited_out_x+1'b1);
//assign neg_lim_out_y = (~limited_out_y+1'b1);

//assign premodSWcoord_y = SWcoord_y_reg + (sign_howmany_row ? (~UWcount_row +1'b1) : UWcount_row);
assign premodSWcoord_x = SWcoord_x + (UW_sel_col ? {{1 {UWcount[5]}},UWcount} : 0);
//assign modSWcoord_y = (premodSWcoord_y < 88) ? premodSWcoord_y : premodSWcoord_y - 88;
assign modSWcoord_x = (premodSWcoord_x < 88) ? premodSWcoord_x : (sign_howmany_col ? (premodSWcoord_x + 88) : (premodSWcoord_x - 88));

always @*
begin
	if (!within_reach)
	begin
		whichblock_x = sign_howmany_col ? (new_UWpos_x + 21) : new_UWpos_x ;
		whichblock_y = new_UWpos_y;
	end
	else if(SubState == Sub_Fill_UW_row || SubState == Sub_Fill_UW_row_load)
	begin
		whichblock_x = UWpos[6:0];
		whichblock_y = sign_howmany_row ? (UWpos[13:7]-1) : (UWpos[13:7] + 22);
	end
	else
	begin
		whichblock_y = UWpos[13:7];
		whichblock_x = sign_howmany_col ? (UWpos[6:0]-1) : (UWpos[6:0] + 22);
	end
end

assign preSWcoord_x = {{1 {whichblock_x[6]}},whichblock_x} + 33 + SWshift;
assign preSWcoord_y = {{1 {whichblock_y[6]}},whichblock_y} + 33;
assign SWcoord_x = (preSWcoord_x <88) ? preSWcoord_x : preSWcoord_x - 88;
assign SWcoord_y = (preSWcoord_y <88) ? preSWcoord_y : preSWcoord_y - 88;
assign prewhichRAM = SWcoord_mod_x + SWcoord_mod_y + {{1 {UWcount[5]}},UWcount};
assign whichRAM = (prewhichRAM < 22) ? prewhichRAM : ((prewhichRAM < 44) ? prewhichRAM - 22 : ((prewhichRAM < 66) ? prewhichRAM - 44 : prewhichRAM + 22));
//assign addrrow = modSWcoord_y << 2;
//assign readaddr = addrrow + mod_x;

assign UW_sel_col = (SubState_d == Sub_Fill_UW_col || SubState_d == Sub_Fill_UW_col_load  ) ? 1'b1 : 1'b0;


assign addrcol = modSWcoord_x << 2;
assign addrcol2 = (((modSWcoord_x +1) < 88) ? (modSWcoord_x +1) : ((modSWcoord_x +1) - 88)) << 2;
assign addrcol3 = (((modSWcoord_x +2) < 88) ? (modSWcoord_x +2) : ((modSWcoord_x +2) - 88)) << 2;
assign addrcol4 = (((modSWcoord_x +3) < 88) ? (modSWcoord_x +3) : ((modSWcoord_x +3) - 88)) << 2;
assign addrcol5 = (((modSWcoord_x +4) < 88) ? (modSWcoord_x +4) : ((modSWcoord_x +4) - 88)) << 2;
assign addrcol6 = (((modSWcoord_x +5) < 88) ? (modSWcoord_x +5) : ((modSWcoord_x +5) - 88)) << 2;
assign addrcol7 = (((modSWcoord_x +6) < 88) ? (modSWcoord_x +6) : ((modSWcoord_x +6) - 88)) << 2;
assign addrcol8 = (((modSWcoord_x +7) < 88) ? (modSWcoord_x +7) : ((modSWcoord_x +7) - 88)) << 2;
assign addrcol9 = (((modSWcoord_x +8) < 88) ? (modSWcoord_x +8) : ((modSWcoord_x +8) - 88)) << 2;
assign addrcol10 = (((modSWcoord_x +9) < 88) ? (modSWcoord_x +9) : ((modSWcoord_x +9) - 88)) << 2;
assign addrcol11 = (((modSWcoord_x +10) < 88) ? (modSWcoord_x +10) : ((modSWcoord_x +10) - 88)) << 2;
assign addrcol12 = (((modSWcoord_x +11) < 88) ? (modSWcoord_x +11) : ((modSWcoord_x +11) - 88)) << 2;
assign addrcol13 = (((modSWcoord_x +12) < 88) ? (modSWcoord_x +12) : ((modSWcoord_x +12) - 88)) << 2;
assign addrcol14 = (((modSWcoord_x +13) < 88) ? (modSWcoord_x +13) : ((modSWcoord_x +13) - 88)) << 2;
assign addrcol15 = (((modSWcoord_x +14) < 88) ? (modSWcoord_x +14) : ((modSWcoord_x +14) - 88)) << 2;
assign addrcol16 = (((modSWcoord_x +15) < 88) ? (modSWcoord_x +15) : ((modSWcoord_x +15) - 88)) << 2;
assign addrcol17 = (((modSWcoord_x +16) < 88) ? (modSWcoord_x +16) : ((modSWcoord_x +16) - 88)) << 2;
assign addrcol18 = (((modSWcoord_x +17) < 88) ? (modSWcoord_x +17) : ((modSWcoord_x +17) - 88)) << 2;
assign addrcol19 = (((modSWcoord_x +18) < 88) ? (modSWcoord_x +18) : ((modSWcoord_x +18) - 88)) << 2;
assign addrcol20 = (((modSWcoord_x +19) < 88) ? (modSWcoord_x +19) : ((modSWcoord_x +19) - 88)) << 2;
assign addrcol21 = (((modSWcoord_x +20) < 88) ? (modSWcoord_x +20) : ((modSWcoord_x +20) - 88)) << 2;
assign addrcol22 = (((modSWcoord_x +21) < 88) ? (modSWcoord_x +21) : ((modSWcoord_x +21) - 88)) << 2;

assign readaddr = addrcol + mod_y;
assign readaddr2 = addrcol2 + mod_y;
assign readaddr3 = addrcol3 + mod_y;
assign readaddr4 = addrcol4 + mod_y;
assign readaddr5 = addrcol5 + mod_y;
assign readaddr6 = addrcol6 + mod_y;
assign readaddr7 = addrcol7 + mod_y;
assign readaddr8 = addrcol8 + mod_y;
assign readaddr9 = addrcol9 + mod_y;
assign readaddr10 = addrcol10 + mod_y;
assign readaddr11 = addrcol11 + mod_y;
assign readaddr12 = addrcol12 + mod_y;
assign readaddr13 = addrcol13 + mod_y;
assign readaddr14 = addrcol14 + mod_y;
assign readaddr15 = addrcol15 + mod_y;
assign readaddr16 = addrcol16 + mod_y;
assign readaddr17 = addrcol17 + mod_y;
assign readaddr18 = addrcol18 + mod_y;
assign readaddr19 = addrcol19 + mod_y;
assign readaddr20 = addrcol20 + mod_y;
assign readaddr21 = addrcol21 + mod_y;
assign readaddr22 = addrcol22 + mod_y;

always @(posedge clk, posedge reset)
begin
	if (reset)
	begin
		SWcoord_x_reg <= 0;
		SWcoord_y_reg <= 0;
		//neg_lim_out_y_reg <= 0;
		//neg_lim_out_x_reg <= 0;
		//inside <= 0;
		//valid_d <= 0;
		//check_x_d <= 0;
		//check_y_d <= 0;
		MVwait <= 0;
	end
	else
	begin
		SWcoord_x_reg <= SWcoord_x;
		SWcoord_y_reg <= SWcoord_y;
		//neg_lim_out_x_reg <= neg_lim_out_x;
		//neg_lim_out_y_reg <= neg_lim_out_y;
		//inside <= pre_inside;
		//valid_d <= valid;
		//check_x_d <= check_x;
		//check_y_d <= check_y;
		MVwait <= preMVwait;
	end
end
always @(posedge clk, posedge reset)
begin
    if (reset)
    preoutMV <= 14'b0;
    else if (enable)
    preoutMV <= {limited_out_y,limited_out_x};
    
end

always @(posedge clk, posedge reset)
begin
	if (reset)
		outMV <= 14'b0;
	else
		outMV <= preoutMV;
end

always @(posedge clk, posedge reset)
begin
    if (reset)
    State <= S_idle;
    else
    begin
        case(State)
			S_idle:
				if(enable)
					State <= S_init;
			S_init: //buna gerek var mi ?
				if(feedcount == 3)
					State <= S_Vector1;
			S_Vector1:
				if (inside)
					State <= S_Vector2u;
			S_Vector2u:
				if (inside)
					if (underTh)
						State <= S_Wait;
					else
						State <= S_Vector3;
			S_Vector3:
				if (inside)
					State <= S_Wait;
			S_Wait:
				if (MV_ready)
					State <= S_idle;
			default: State <= S_idle;
		endcase
    end
end

assign preMVwait = (State == S_Wait) ? 1 : 0;
assign feed = (State == S_init) ? 1 : 0;

always @ (posedge clk, posedge reset)
begin
	if (reset)
		feedcount <= 0;
	else if (feed)
		feedcount <= feedcount + 1;
	else
		feedcount <= 0;
end

always @ (posedge clk, posedge reset)
begin
	if (reset)
	begin
		vectors0 <= 14'b0;
		vectors1 <= 14'b0;
		vectors2 <= 14'b0;
	end
	else
	begin
		case(feedcount)
		1: vectors0 <= vecin;
		2: vectors1 <= vecin;
		3: vectors2 <= vecin;
		endcase
	end
end



always@(posedge clk, posedge reset)
begin
	if (reset)
		SWshift <= 72;
	else if (Row_end)
		SWshift <= 72;
	else if (feedcount == 3)
	begin
		SWshift <= (SWshift > 71) ? SWshift - 72 : SWshift + 16;
	end
end


always @ (posedge clk, posedge reset)
begin
	if (reset)
	begin
		valid <= 0;
		//UWpos <= 0;
		//reference_block_x <= 0;
		//reference_block_y <= 0;
	end
	else if (State == S_Wait)
		valid <= 0;
	else if (UW_Filled)
	begin
		valid <= 1'b1;
		//UWpos <= {new_UWpos_y,new_UWpos_x};
		//reference_block_x <= new_ref_x;
		//reference_block_y <= new_ref_y;
	end
end

always @(*)
begin
    case(State)
        S_Vector1:
           out = medianMV;
        S_Vector2u:
        begin
           if (underTh)
              out = {medianMV[13:7]+{{4 {updatein[5]}},updatein[5:3]},medianMV[6:0] + {{4 {updatein[2]}},updatein[2:0]}};
           else   
              out = (median == 1) ? {vecin1[13:7]+{{4 {updatein[5]}},updatein[5:3]},vecin1[6:0] + {{4 {updatein[2]}},updatein[2:0]}} : {vecin2[13:7]+{{4 {updatein[5]}},updatein[5:3]},vecin2[6:0] + {{4 {updatein[2]}},updatein[2:0]}};
        end
        S_Vector3:
           out = (median == 2) ? vecin1 : vecin3;
        default:
           out = 14'b0;
    endcase
end

/*always @*
begin
    if (State == S_Vector1 || State == S_Vector2u || State == S_Vector3)
       FillSW = 1'b1;
    else
       FillSW = 1'b0;
end*/



always @(posedge clk, posedge reset)
begin
	if (reset)
	begin
		SubState <= Sub_Init; 
	end
	else
	case (SubState)
	Sub_Init:
		if (State == S_Vector1 || State == S_Vector2u || State == S_Vector3)
		begin
			if (!inside)
			begin
				if (inside_row || !within_reach)
					SubState <= Sub_Fill_UW_col_load;
				else
					SubState <= Sub_Fill_UW_row_load;
			end
		end
	Sub_Fill_UW_row_load:
		SubState <= Sub_Fill_UW_row;
	Sub_Fill_UW_row:
		if (UWcount == 0)
		begin
			if (inside_col)
				SubState <= Sub_Filled;
			else
				SubState <= Sub_Fill_UW_col_load;
			
		end
	Sub_Fill_UW_col_load:
		SubState <= Sub_Fill_UW_col;
	Sub_Fill_UW_col:
		if (UWcount == 0)
		begin
			SubState <= Sub_Filled;
			
		end
	Sub_Filled:
		SubState <= Sub_Init;
	default: SubState <= Sub_Init;
	endcase
	
end

always @(posedge clk, posedge reset)
begin
if (reset)
begin
	UWpos <=0;
	//reference_block_x <= 0;
	//reference_block_y <= 0;
end
else if (SubState_d == Sub_Fill_UW_row && UW_count_d == 0)
begin
	UWpos[13:7] <= new_UWpos_y;
	//reference_block_y <= new_ref_y;
	//reference_block_x <= new_ref_x;
end
else if (SubState_d == Sub_Fill_UW_col && UW_count_d == 0)
begin
	UWpos[6:0] <= new_UWpos_x;
	//reference_block_x <= new_ref_x;
	//reference_block_y <= new_ref_y;
end
//else if (SubState == Sub_Fill_UW_row && UWcount == 0)
	//reference_block_y <= new_ref_y;
//else if (SubState == Sub_Fill_UW_col && UWcount == 0)
	//reference_block_x <= new_ref_x;
end

always @ (posedge clk, posedge reset)
begin
	if (reset)
	begin
		reference_block_x <= 0;
		reference_block_y <= 0;
	end
	else if (SubState == Sub_Filled)
	begin
		reference_block_y <= new_ref_y;
		reference_block_x <= new_ref_x;
	end
end

always @*
begin
	if ((State == S_Vector1 || State == S_Vector2u || State == S_Vector3) && inside)
		MVselect_WEpre = 1;
	else
		MVselect_WEpre = 0;
end
always @(posedge clk, posedge reset)
begin
	if (reset)
		MVselect_WE <= 0;
	else
		MVselect_WE <= MVselect_WEpre;
end
always @(posedge clk, posedge reset)
begin
	if (reset)
	begin
		SubState_d <= 0;
		whichRAM_d <= 0;
	end
	else
	begin
		SubState_d <= SubState;
		whichRAM_d <= whichRAM;
	end
end

always @*
begin
	if (SubState == Sub_Filled)
		UW_Filled = 1'b1;
	else
		UW_Filled = 1'b0;
end


always @(posedge clk, posedge reset)
begin
if (reset)
	UW_count_d <= 0;
else if ((SubState == Sub_Fill_UW_col) || (SubState == Sub_Fill_UW_row))
	UW_count_d <= UWcount;
else
	UW_count_d <= 0;

end

always @(*)
begin
if ((SubState_d == Sub_Fill_UW_col) || (SubState_d == Sub_Fill_UW_row))
begin
	UW_WE = 1;
end
else
	UW_WE = 0;
end



/*always@*
begin
   for (i = 0; i < 88; i = i+1)
      packedInput[i] = InputDATA[i*8 +: 8];
end*/

assign inputpart1 = InputDATA[0:31];
assign inputpart2 = InputDATA[32:63];

/*assign pack1 ={packedInput[0],packedInput[22],packedInput[44],packedInput[66]};
assign pack2 ={packedInput[1],packedInput[23],packedInput[45],packedInput[67]};
assign pack3 ={packedInput[2],packedInput[24],packedInput[46],packedInput[68]};
assign pack4 ={packedInput[3],packedInput[25],packedInput[47],packedInput[69]};
assign pack5 ={packedInput[4],packedInput[26],packedInput[48],packedInput[70]};
assign pack6 ={packedInput[5],packedInput[27],packedInput[49],packedInput[71]};
assign pack7 ={packedInput[6],packedInput[28],packedInput[50],packedInput[72]};
assign pack8 ={packedInput[7],packedInput[29],packedInput[51],packedInput[73]};
assign pack9 ={packedInput[8],packedInput[30],packedInput[52],packedInput[74]};
assign pack10 ={packedInput[9],packedInput[31],packedInput[53],packedInput[75]};
assign pack11 ={packedInput[10],packedInput[32],packedInput[54],packedInput[76]};
assign pack12 ={packedInput[11],packedInput[33],packedInput[55],packedInput[77]};
assign pack13 ={packedInput[12],packedInput[34],packedInput[56],packedInput[78]};
assign pack14 ={packedInput[13],packedInput[35],packedInput[57],packedInput[79]};
assign pack15 ={packedInput[14],packedInput[36],packedInput[58],packedInput[80]};
assign pack16 ={packedInput[15],packedInput[37],packedInput[59],packedInput[81]};
assign pack17 ={packedInput[16],packedInput[38],packedInput[60],packedInput[82]};
assign pack18 ={packedInput[17],packedInput[39],packedInput[61],packedInput[83]};
assign pack19 ={packedInput[18],packedInput[40],packedInput[62],packedInput[84]};
assign pack20 ={packedInput[19],packedInput[41],packedInput[63],packedInput[85]};
assign pack21 ={packedInput[20],packedInput[42],packedInput[64],packedInput[86]};
assign pack22 ={packedInput[21],packedInput[43],packedInput[65],packedInput[87]};
*/

always @(posedge clk, posedge reset)
begin
	if (reset)
	begin
		order <= 1;
		WADDR_S <= 0;
		order11<=1;
	end
	/*else if (frame_end)
	begin
		order <= 1;
		order11 <=1;
		WADDR_S <= 0;
	end*/
	else if (Row_end)
	begin
		order <= 1;
		order11 <= 1;
		WADDR_S <= 0;
	end
	else if (SW_WE)
	begin
		//if(WADDR_S != 87)
		//begin
			if (order11 == 11)
			begin
				if (order != 22)
					order <= order + 1;
				else
					order <= 1;
				order11 <= 1;
				if (WADDR_S != 87)
					WADDR_S <=WADDR_S +1;
				else
					WADDR_S <= 0;
			end
			else
				order11 <= order11 + 1;
			
		//end
		//else
		//begin
		//	order <= 1;
		//	order11 <= 1;
		//	WADDR_S <= 0;
		//end
       
       
       
       /*if (order != 22 || WADDR_S != 87)
          order <= order + 1;
       else
          order <= 1;
       if (WADDR_S != 87)
          WADDR_S <= WADDR_S + 1;
       else
          WADDR_S <= 0;*/
   end
 //  else
//	order11 <= 0;
end

/*always @(posedge clk, posedge reset)
begin
	if (reset)
	begin
		order <= 1;
		WADDR_S <= 0;
	end
	else if (frame_end)
	begin
		order <= 1;
		WADDR_S <= 0;
	end
	else if (Row_end)
	begin
		order <= 0;
		WADDR_S <= 511;
	end
	else if (SW_WE)
	begin
		if(WADDR_S != 87)
		begin
			if (order != 22)
				order <= order + 1;
			else
				order <= 1; 
			WADDR_S <=WADDR_S +1;
		end
		else
		begin
			order <= 1;
			WADDR_S <= 0;
		end
 */  
       
       
       /*if (order != 22 || WADDR_S != 87)
          order <= order + 1;
       else
          order <= 1;
       if (WADDR_S != 87)
          WADDR_S <= WADDR_S + 1;
       else
          WADDR_S <= 0;*/
/*   end
end*/

/*always @(posedge clk, posedge reset)
begin
    if (reset)
		UWaddress <= 0;
	else if (SubState == Sub_Fill_UW)
	begin
		UWaddress <= UWaddress + 1;
	end
	else
		UWaddress <= 0;
end*/




always @*
begin
	if (SWcoord_x <22)
	begin
		mod_x = 0;
		SWcoord_mod_x = SWcoord_x;
	end
	else if (SWcoord_x < 44)
	begin
		mod_x = 1;
		SWcoord_mod_x = SWcoord_x - 22;
	end
	else if (SWcoord_x < 66)
	begin	
		mod_x = 2;
		SWcoord_mod_x = SWcoord_x - 44;
	end
	else
	begin
		mod_x = 3;
		SWcoord_mod_x = SWcoord_x - 66; //buna direk = 0 diyebilriz çünkü 66dan yukarý çýkamýyor sanýrým
	end
		
end

always @*
begin
	if (SWcoord_y <22)
	begin
		mod_y = 0;
		SWcoord_mod_y = SWcoord_y;
	end
	else if (SWcoord_y < 44)
	begin
		mod_y = 1;
		SWcoord_mod_y = SWcoord_y - 22;
	end
	else if (SWcoord_y < 66)
	begin	
		mod_y = 2;
		SWcoord_mod_y = SWcoord_y - 44;
	end
	else
	begin
		mod_y = 3;
		SWcoord_mod_y = SWcoord_y - 66; //buna direk = 0 diyebilriz çünkü 66dan yukarý çýkamýyor sanýrým
	end
		
end




always @*
begin
	case(SWcoord_mod_y)
		0:
		begin
			raddr1 = readaddr;
			raddr2 = readaddr;
			raddr3 = readaddr;
			raddr4 = readaddr;
			raddr5 = readaddr;
			raddr6 = readaddr;
			raddr7 = readaddr;
			raddr8 = readaddr;
			raddr9 = readaddr;
			raddr10 = readaddr;
			raddr11 = readaddr;
			raddr12 = readaddr;
			raddr13 = readaddr;
			raddr14 = readaddr;
			raddr15 = readaddr;
			raddr16 = readaddr;
			raddr17 = readaddr;
			raddr18 = readaddr;
			raddr19 = readaddr;
			raddr20 = readaddr;
			raddr21 = readaddr;
			raddr22 = readaddr;
		end
		1:
		begin
			raddr1 = readaddr;
			raddr2 = readaddr;
			raddr3 = readaddr;
			raddr4 = readaddr;
			raddr5 = readaddr;
			raddr6 = readaddr;
			raddr7 = readaddr;
			raddr8 = readaddr;
			raddr9 = readaddr;
			raddr10 = readaddr;
			raddr11 = readaddr;
			raddr12 = readaddr;
			raddr13 = readaddr;
			raddr14 = readaddr;
			raddr15 = readaddr;
			raddr16 = readaddr;
			raddr17 = readaddr;
			raddr18 = readaddr;
			raddr19 = readaddr;
			raddr20 = readaddr;
			raddr21 = readaddr;
			raddr22 = readaddr + 1;
		end
		2:
		begin
			raddr1 = readaddr;
			raddr2 = readaddr;
			raddr3 = readaddr;
			raddr4 = readaddr;
			raddr5 = readaddr;
			raddr6 = readaddr;
			raddr7 = readaddr;
			raddr8 = readaddr;
			raddr9 = readaddr;
			raddr10 = readaddr;
			raddr11 = readaddr;
			raddr12 = readaddr;
			raddr13 = readaddr;
			raddr14 = readaddr;
			raddr15 = readaddr;
			raddr16 = readaddr;
			raddr17 = readaddr;
			raddr18 = readaddr;
			raddr19 = readaddr;
			raddr20 = readaddr;
			raddr21 = readaddr + 1;
			raddr22 = readaddr + 1;
		end
		3:
		begin
			raddr1 = readaddr;
			raddr2 = readaddr;
			raddr3 = readaddr;
			raddr4 = readaddr;
			raddr5 = readaddr;
			raddr6 = readaddr;
			raddr7 = readaddr;
			raddr8 = readaddr;
			raddr9 = readaddr;
			raddr10 = readaddr;
			raddr11 = readaddr;
			raddr12 = readaddr;
			raddr13 = readaddr;
			raddr14 = readaddr;
			raddr15 = readaddr;
			raddr16 = readaddr;
			raddr17 = readaddr;
			raddr18 = readaddr;
			raddr19 = readaddr;
			raddr20 = readaddr + 1;
			raddr21 = readaddr + 1;
			raddr22 = readaddr + 1;
		end
		4:
		begin
			raddr1 = readaddr;
			raddr2 = readaddr;
			raddr3 = readaddr;
			raddr4 = readaddr;
			raddr5 = readaddr;
			raddr6 = readaddr;
			raddr7 = readaddr;
			raddr8 = readaddr;
			raddr9 = readaddr;
			raddr10 = readaddr;
			raddr11 = readaddr;
			raddr12 = readaddr;
			raddr13 = readaddr;
			raddr14 = readaddr;
			raddr15 = readaddr;
			raddr16 = readaddr;
			raddr17 = readaddr;
			raddr18 = readaddr;
			raddr19 = readaddr + 1;
			raddr20 = readaddr + 1;
			raddr21 = readaddr + 1;
			raddr22 = readaddr + 1;
		end
		5:
		begin
			raddr1 = readaddr;
			raddr2 = readaddr;
			raddr3 = readaddr;
			raddr4 = readaddr;
			raddr5 = readaddr;
			raddr6 = readaddr;
			raddr7 = readaddr;
			raddr8 = readaddr;
			raddr9 = readaddr;
			raddr10 = readaddr;
			raddr11 = readaddr;
			raddr12 = readaddr;
			raddr13 = readaddr;
			raddr14 = readaddr;
			raddr15 = readaddr;
			raddr16 = readaddr;
			raddr17 = readaddr;
			raddr18 = readaddr + 1;
			raddr19 = readaddr + 1;
			raddr20 = readaddr + 1;
			raddr21 = readaddr + 1;
			raddr22 = readaddr + 1;
		end
		6:
		begin
			raddr1 = readaddr;
			raddr2 = readaddr;
			raddr3 = readaddr;
			raddr4 = readaddr;
			raddr5 = readaddr;
			raddr6 = readaddr;
			raddr7 = readaddr;
			raddr8 = readaddr;
			raddr9 = readaddr;
			raddr10 = readaddr;
			raddr11 = readaddr;
			raddr12 = readaddr;
			raddr13 = readaddr;
			raddr14 = readaddr;
			raddr15 = readaddr;
			raddr16 = readaddr;
			raddr17 = readaddr + 1;
			raddr18 = readaddr + 1;
			raddr19 = readaddr + 1;
			raddr20 = readaddr + 1;
			raddr21 = readaddr + 1;
			raddr22 = readaddr + 1;
		end
		7:
		begin
			raddr1 = readaddr;
			raddr2 = readaddr;
			raddr3 = readaddr;
			raddr4 = readaddr;
			raddr5 = readaddr;
			raddr6 = readaddr;
			raddr7 = readaddr;
			raddr8 = readaddr;
			raddr9 = readaddr;
			raddr10 = readaddr;
			raddr11 = readaddr;
			raddr12 = readaddr;
			raddr13 = readaddr;
			raddr14 = readaddr;
			raddr15 = readaddr;
			raddr16 = readaddr + 1;
			raddr17 = readaddr + 1;
			raddr18 = readaddr + 1;
			raddr19 = readaddr + 1;
			raddr20 = readaddr + 1;
			raddr21 = readaddr + 1;
			raddr22 = readaddr + 1;
		end
		8:
		begin
			raddr1 = readaddr;
			raddr2 = readaddr;
			raddr3 = readaddr;
			raddr4 = readaddr;
			raddr5 = readaddr;
			raddr6 = readaddr;
			raddr7 = readaddr;
			raddr8 = readaddr;
			raddr9 = readaddr;
			raddr10 = readaddr;
			raddr11 = readaddr;
			raddr12 = readaddr;
			raddr13 = readaddr;
			raddr14 = readaddr;
			raddr15 = readaddr + 1;
			raddr16 = readaddr + 1;
			raddr17 = readaddr + 1;
			raddr18 = readaddr + 1;
			raddr19 = readaddr + 1;
			raddr20 = readaddr + 1;
			raddr21 = readaddr + 1;
			raddr22 = readaddr + 1;
		end
		9:
		begin
			raddr1 = readaddr;
			raddr2 = readaddr;
			raddr3 = readaddr;
			raddr4 = readaddr;
			raddr5 = readaddr;
			raddr6 = readaddr;
			raddr7 = readaddr;
			raddr8 = readaddr;
			raddr9 = readaddr;
			raddr10 = readaddr;
			raddr11 = readaddr;
			raddr12 = readaddr;
			raddr13 = readaddr;
			raddr14 = readaddr + 1;
			raddr15 = readaddr + 1;
			raddr16 = readaddr + 1;
			raddr17 = readaddr + 1;
			raddr18 = readaddr + 1;
			raddr19 = readaddr + 1;
			raddr20 = readaddr + 1;
			raddr21 = readaddr + 1;
			raddr22 = readaddr + 1;
		end
		10:
		begin
			raddr1 = readaddr;
			raddr2 = readaddr;
			raddr3 = readaddr;
			raddr4 = readaddr;
			raddr5 = readaddr;
			raddr6 = readaddr;
			raddr7 = readaddr;
			raddr8 = readaddr;
			raddr9 = readaddr;
			raddr10 = readaddr;
			raddr11 = readaddr;
			raddr12 = readaddr;
			raddr13 = readaddr + 1;
			raddr14 = readaddr + 1;
			raddr15 = readaddr + 1;
			raddr16 = readaddr + 1;
			raddr17 = readaddr + 1;
			raddr18 = readaddr + 1;
			raddr19 = readaddr + 1;
			raddr20 = readaddr + 1;
			raddr21 = readaddr + 1;
			raddr22 = readaddr + 1;
		end
		11:
		begin
			raddr1 = readaddr;
			raddr2 = readaddr;
			raddr3 = readaddr;
			raddr4 = readaddr;
			raddr5 = readaddr;
			raddr6 = readaddr;
			raddr7 = readaddr;
			raddr8 = readaddr;
			raddr9 = readaddr;
			raddr10 = readaddr;
			raddr11 = readaddr;
			raddr12 = readaddr + 1;
			raddr13 = readaddr + 1;
			raddr14 = readaddr + 1;
			raddr15 = readaddr + 1;
			raddr16 = readaddr + 1;
			raddr17 = readaddr + 1;
			raddr18 = readaddr + 1;
			raddr19 = readaddr + 1;
			raddr20 = readaddr + 1;
			raddr21 = readaddr + 1;
			raddr22 = readaddr + 1;
		end
		12:
		begin
			raddr1 = readaddr;
			raddr2 = readaddr;
			raddr3 = readaddr;
			raddr4 = readaddr;
			raddr5 = readaddr;
			raddr6 = readaddr;
			raddr7 = readaddr;
			raddr8 = readaddr;
			raddr9 = readaddr;
			raddr10 = readaddr;
			raddr11 = readaddr + 1;
			raddr12 = readaddr + 1;
			raddr13 = readaddr + 1;
			raddr14 = readaddr + 1;
			raddr15 = readaddr + 1;
			raddr16 = readaddr + 1;
			raddr17 = readaddr + 1;
			raddr18 = readaddr + 1;
			raddr19 = readaddr + 1;
			raddr20 = readaddr + 1;
			raddr21 = readaddr + 1;
			raddr22 = readaddr + 1;
		end
		13:
		begin
			raddr1 = readaddr;
			raddr2 = readaddr;
			raddr3 = readaddr;
			raddr4 = readaddr;
			raddr5 = readaddr;
			raddr6 = readaddr;
			raddr7 = readaddr;
			raddr8 = readaddr;
			raddr9 = readaddr;
			raddr10 = readaddr + 1;
			raddr11 = readaddr + 1;
			raddr12 = readaddr + 1;
			raddr13 = readaddr + 1;
			raddr14 = readaddr + 1;
			raddr15 = readaddr + 1;
			raddr16 = readaddr + 1;
			raddr17 = readaddr + 1;
			raddr18 = readaddr + 1;
			raddr19 = readaddr + 1;
			raddr20 = readaddr + 1;
			raddr21 = readaddr + 1;
			raddr22 = readaddr + 1;
		end
		14:
		begin
			raddr1 = readaddr;
			raddr2 = readaddr;
			raddr3 = readaddr;
			raddr4 = readaddr;
			raddr5 = readaddr;
			raddr6 = readaddr;
			raddr7 = readaddr;
			raddr8 = readaddr;
			raddr9 = readaddr + 1;
			raddr10 = readaddr + 1;
			raddr11 = readaddr + 1;
			raddr12 = readaddr + 1;
			raddr13 = readaddr + 1;
			raddr14 = readaddr + 1;
			raddr15 = readaddr + 1;
			raddr16 = readaddr + 1;
			raddr17 = readaddr + 1;
			raddr18 = readaddr + 1;
			raddr19 = readaddr + 1;
			raddr20 = readaddr + 1;
			raddr21 = readaddr + 1;
			raddr22 = readaddr + 1;
		end
		15:
		begin
			raddr1 = readaddr;
			raddr2 = readaddr;
			raddr3 = readaddr;
			raddr4 = readaddr;
			raddr5 = readaddr;
			raddr6 = readaddr;
			raddr7 = readaddr;
			raddr8 = readaddr +1;
			raddr9 = readaddr + 1;
			raddr10 = readaddr + 1;
			raddr11 = readaddr + 1;
			raddr12 = readaddr + 1;
			raddr13 = readaddr + 1;
			raddr14 = readaddr + 1;
			raddr15 = readaddr + 1;
			raddr16 = readaddr + 1;
			raddr17 = readaddr + 1;
			raddr18 = readaddr + 1;
			raddr19 = readaddr + 1;
			raddr20 = readaddr + 1;
			raddr21 = readaddr + 1;
			raddr22 = readaddr + 1;
		end
		16:
		begin
			raddr1 = readaddr;
			raddr2 = readaddr;
			raddr3 = readaddr;
			raddr4 = readaddr;
			raddr5 = readaddr;
			raddr6 = readaddr;
			raddr7 = readaddr + 1;
			raddr8 = readaddr + 1;
			raddr9 = readaddr + 1;
			raddr10 = readaddr + 1;
			raddr11 = readaddr + 1;
			raddr12 = readaddr + 1;
			raddr13 = readaddr + 1;
			raddr14 = readaddr + 1;
			raddr15 = readaddr + 1;
			raddr16 = readaddr + 1;
			raddr17 = readaddr + 1;
			raddr18 = readaddr + 1;
			raddr19 = readaddr + 1;
			raddr20 = readaddr + 1;
			raddr21 = readaddr + 1;
			raddr22 = readaddr + 1;
		end
		17:
		begin
			raddr1 = readaddr;
			raddr2 = readaddr;
			raddr3 = readaddr;
			raddr4 = readaddr;
			raddr5 = readaddr;
			raddr6 = readaddr + 1;
			raddr7 = readaddr + 1;
			raddr8 = readaddr + 1;
			raddr9 = readaddr + 1;
			raddr10 = readaddr + 1;
			raddr11 = readaddr + 1;
			raddr12 = readaddr + 1;
			raddr13 = readaddr + 1;
			raddr14 = readaddr + 1;
			raddr15 = readaddr + 1;
			raddr16 = readaddr + 1;
			raddr17 = readaddr + 1;
			raddr18 = readaddr + 1;
			raddr19 = readaddr + 1;
			raddr20 = readaddr + 1;
			raddr21 = readaddr + 1;
			raddr22 = readaddr + 1;
		end
		18:
		begin
			raddr1 = readaddr;
			raddr2 = readaddr;
			raddr3 = readaddr;
			raddr4 = readaddr;
			raddr5 = readaddr + 1;
			raddr6 = readaddr + 1;
			raddr7 = readaddr + 1;
			raddr8 = readaddr + 1;
			raddr9 = readaddr + 1;
			raddr10 = readaddr + 1;
			raddr11 = readaddr + 1;
			raddr12 = readaddr + 1;
			raddr13 = readaddr + 1;
			raddr14 = readaddr + 1;
			raddr15 = readaddr + 1;
			raddr16 = readaddr + 1;
			raddr17 = readaddr + 1;
			raddr18 = readaddr + 1;
			raddr19 = readaddr + 1;
			raddr20 = readaddr + 1;
			raddr21 = readaddr + 1;
			raddr22 = readaddr + 1;
		end
		19:
		begin
			raddr1 = readaddr;
			raddr2 = readaddr;
			raddr3 = readaddr;
			raddr4 = readaddr + 1;
			raddr5 = readaddr + 1;
			raddr6 = readaddr + 1;
			raddr7 = readaddr + 1;
			raddr8 = readaddr + 1;
			raddr9 = readaddr + 1;
			raddr10 = readaddr + 1;
			raddr11 = readaddr + 1;
			raddr12 = readaddr + 1;
			raddr13 = readaddr + 1;
			raddr14 = readaddr + 1;
			raddr15 = readaddr + 1;
			raddr16 = readaddr + 1;
			raddr17 = readaddr + 1;
			raddr18 = readaddr + 1;
			raddr19 = readaddr + 1;
			raddr20 = readaddr + 1;
			raddr21 = readaddr + 1;
			raddr22 = readaddr + 1;
		end
		20:
		begin
			raddr1 = readaddr;
			raddr2 = readaddr;
			raddr3 = readaddr + 1;
			raddr4 = readaddr + 1;
			raddr5 = readaddr + 1;
			raddr6 = readaddr + 1;
			raddr7 = readaddr + 1;
			raddr8 = readaddr + 1;
			raddr9 = readaddr + 1;
			raddr10 = readaddr + 1;
			raddr11 = readaddr + 1;
			raddr12 = readaddr + 1;
			raddr13 = readaddr + 1;
			raddr14 = readaddr + 1;
			raddr15 = readaddr + 1;
			raddr16 = readaddr + 1;
			raddr17 = readaddr + 1;
			raddr18 = readaddr + 1;
			raddr19 = readaddr + 1;
			raddr20 = readaddr + 1;
			raddr21 = readaddr + 1;
			raddr22 = readaddr + 1;
		end
		21:
		begin
			raddr1 = readaddr;
			raddr2 = readaddr + 1;
			raddr3 = readaddr + 1;
			raddr4 = readaddr + 1;
			raddr5 = readaddr + 1;
			raddr6 = readaddr + 1;
			raddr7 = readaddr + 1;
			raddr8 = readaddr + 1;
			raddr9 = readaddr + 1;
			raddr10 = readaddr + 1;
			raddr11 = readaddr + 1;
			raddr12 = readaddr + 1;
			raddr13 = readaddr + 1;
			raddr14 = readaddr + 1;
			raddr15 = readaddr + 1;
			raddr16 = readaddr + 1;
			raddr17 = readaddr + 1;
			raddr18 = readaddr + 1;
			raddr19 = readaddr + 1;
			raddr20 = readaddr + 1;
			raddr21 = readaddr + 1;
			raddr22 = readaddr + 1;
		end
		default:
		begin
			raddr1 = readaddr;
			raddr2 = readaddr;
			raddr3 = readaddr;
			raddr4 = readaddr;
			raddr5 = readaddr;
			raddr6 = readaddr;
			raddr7 = readaddr;
			raddr8 = readaddr;
			raddr9 = readaddr;
			raddr10 = readaddr;
			raddr11 = readaddr;
			raddr12 = readaddr;
			raddr13 = readaddr;
			raddr14 = readaddr;
			raddr15 = readaddr;
			raddr16 = readaddr;
			raddr17 = readaddr;
			raddr18 = readaddr;
			raddr19 = readaddr;
			raddr20 = readaddr;
			raddr21 = readaddr;
			raddr22 = readaddr;
		end
		
	endcase
end

always @*
begin
	case(whichRAM_d)
	0: UWDATA_Out = {RDATA_S01,RDATA_S02,RDATA_S03,RDATA_S04,RDATA_S05,RDATA_S06,RDATA_S07,RDATA_S08,RDATA_S09,RDATA_S10,RDATA_S11,
						RDATA_S12,RDATA_S13,RDATA_S14,RDATA_S15,RDATA_S16,RDATA_S17,RDATA_S18,RDATA_S19,RDATA_S20,RDATA_S21,RDATA_S22};
	1: UWDATA_Out = {RDATA_S02,RDATA_S03,RDATA_S04,RDATA_S05,RDATA_S06,RDATA_S07,RDATA_S08,RDATA_S09,RDATA_S10,RDATA_S11,RDATA_S12,
						RDATA_S13,RDATA_S14,RDATA_S15,RDATA_S16,RDATA_S17,RDATA_S18,RDATA_S19,RDATA_S20,RDATA_S21,RDATA_S22,RDATA_S01};
	2: UWDATA_Out = {RDATA_S03,RDATA_S04,RDATA_S05,RDATA_S06,RDATA_S07,RDATA_S08,RDATA_S09,RDATA_S10,RDATA_S11,RDATA_S12,RDATA_S13,
						RDATA_S14,RDATA_S15,RDATA_S16,RDATA_S17,RDATA_S18,RDATA_S19,RDATA_S20,RDATA_S21,RDATA_S22,RDATA_S01,RDATA_S02};
	3: UWDATA_Out = {RDATA_S04,RDATA_S05,RDATA_S06,RDATA_S07,RDATA_S08,RDATA_S09,RDATA_S10,RDATA_S11,RDATA_S12,RDATA_S13,RDATA_S14,
						RDATA_S15,RDATA_S16,RDATA_S17,RDATA_S18,RDATA_S19,RDATA_S20,RDATA_S21,RDATA_S22,RDATA_S01,RDATA_S02,RDATA_S03};
	4: UWDATA_Out = {RDATA_S05,RDATA_S06,RDATA_S07,RDATA_S08,RDATA_S09,RDATA_S10,RDATA_S11,RDATA_S12,RDATA_S13,RDATA_S14,RDATA_S15,
						RDATA_S16,RDATA_S17,RDATA_S18,RDATA_S19,RDATA_S20,RDATA_S21,RDATA_S22,RDATA_S01,RDATA_S02,RDATA_S03,RDATA_S04};
	5: UWDATA_Out = {RDATA_S06,RDATA_S07,RDATA_S08,RDATA_S09,RDATA_S10,RDATA_S11,RDATA_S12,RDATA_S13,RDATA_S14,RDATA_S15,RDATA_S16,
						RDATA_S17,RDATA_S18,RDATA_S19,RDATA_S20,RDATA_S21,RDATA_S22,RDATA_S01,RDATA_S02,RDATA_S03,RDATA_S04,RDATA_S05};
	6: UWDATA_Out = {RDATA_S07,RDATA_S08,RDATA_S09,RDATA_S10,RDATA_S11,RDATA_S12,RDATA_S13,RDATA_S14,RDATA_S15,RDATA_S16,RDATA_S17,
						RDATA_S18,RDATA_S19,RDATA_S20,RDATA_S21,RDATA_S22,RDATA_S01,RDATA_S02,RDATA_S03,RDATA_S04,RDATA_S05,RDATA_S06};
	7: UWDATA_Out = {RDATA_S08,RDATA_S09,RDATA_S10,RDATA_S11,RDATA_S12,RDATA_S13,RDATA_S14,RDATA_S15,RDATA_S16,RDATA_S17,RDATA_S18,
						RDATA_S19,RDATA_S20,RDATA_S21,RDATA_S22,RDATA_S01,RDATA_S02,RDATA_S03,RDATA_S04,RDATA_S05,RDATA_S06,RDATA_S07};
	8: UWDATA_Out = {RDATA_S09,RDATA_S10,RDATA_S11,RDATA_S12,RDATA_S13,RDATA_S14,RDATA_S15,RDATA_S16,RDATA_S17,RDATA_S18,RDATA_S19,
						RDATA_S20,RDATA_S21,RDATA_S22,RDATA_S01,RDATA_S02,RDATA_S03,RDATA_S04,RDATA_S05,RDATA_S06,RDATA_S07,RDATA_S08};
	9: UWDATA_Out = {RDATA_S10,RDATA_S11,RDATA_S12,RDATA_S13,RDATA_S14,RDATA_S15,RDATA_S16,RDATA_S17,RDATA_S18,RDATA_S19,RDATA_S20,
						RDATA_S21,RDATA_S22,RDATA_S01,RDATA_S02,RDATA_S03,RDATA_S04,RDATA_S05,RDATA_S06,RDATA_S07,RDATA_S08,RDATA_S09};
	10: UWDATA_Out = {RDATA_S11,RDATA_S12,RDATA_S13,RDATA_S14,RDATA_S15,RDATA_S16,RDATA_S17,RDATA_S18,RDATA_S19,RDATA_S20,RDATA_S21,
						RDATA_S22,RDATA_S01,RDATA_S02,RDATA_S03,RDATA_S04,RDATA_S05,RDATA_S06,RDATA_S07,RDATA_S08,RDATA_S09,RDATA_S10};
	11: UWDATA_Out = {RDATA_S12,RDATA_S13,RDATA_S14,RDATA_S15,RDATA_S16,RDATA_S17,RDATA_S18,RDATA_S19,RDATA_S20,RDATA_S21,RDATA_S22,
						RDATA_S01,RDATA_S02,RDATA_S03,RDATA_S04,RDATA_S05,RDATA_S06,RDATA_S07,RDATA_S08,RDATA_S09,RDATA_S10,RDATA_S11};
	12: UWDATA_Out = {RDATA_S13,RDATA_S14,RDATA_S15,RDATA_S16,RDATA_S17,RDATA_S18,RDATA_S19,RDATA_S20,RDATA_S21,RDATA_S22,RDATA_S01,
						RDATA_S02,RDATA_S03,RDATA_S04,RDATA_S05,RDATA_S06,RDATA_S07,RDATA_S08,RDATA_S09,RDATA_S10,RDATA_S11,RDATA_S12};
	13: UWDATA_Out = {RDATA_S14,RDATA_S15,RDATA_S16,RDATA_S17,RDATA_S18,RDATA_S19,RDATA_S20,RDATA_S21,RDATA_S22,RDATA_S01,RDATA_S02,
						RDATA_S03,RDATA_S04,RDATA_S05,RDATA_S06,RDATA_S07,RDATA_S08,RDATA_S09,RDATA_S10,RDATA_S11,RDATA_S12,RDATA_S13};
	14: UWDATA_Out = {RDATA_S15,RDATA_S16,RDATA_S17,RDATA_S18,RDATA_S19,RDATA_S20,RDATA_S21,RDATA_S22,RDATA_S01,RDATA_S02,RDATA_S03,
						RDATA_S04,RDATA_S05,RDATA_S06,RDATA_S07,RDATA_S08,RDATA_S09,RDATA_S10,RDATA_S11,RDATA_S12,RDATA_S13,RDATA_S14};
	15: UWDATA_Out = {RDATA_S16,RDATA_S17,RDATA_S18,RDATA_S19,RDATA_S20,RDATA_S21,RDATA_S22,RDATA_S01,RDATA_S02,RDATA_S03,RDATA_S04,
						RDATA_S05,RDATA_S06,RDATA_S07,RDATA_S08,RDATA_S09,RDATA_S10,RDATA_S11,RDATA_S12,RDATA_S13,RDATA_S14,RDATA_S15};
	16: UWDATA_Out = {RDATA_S17,RDATA_S18,RDATA_S19,RDATA_S20,RDATA_S21,RDATA_S22,RDATA_S01,RDATA_S02,RDATA_S03,RDATA_S04,RDATA_S05,
						RDATA_S06,RDATA_S07,RDATA_S08,RDATA_S09,RDATA_S10,RDATA_S11,RDATA_S12,RDATA_S13,RDATA_S14,RDATA_S15,RDATA_S16};
	17: UWDATA_Out = {RDATA_S18,RDATA_S19,RDATA_S20,RDATA_S21,RDATA_S22,RDATA_S01,RDATA_S02,RDATA_S03,RDATA_S04,RDATA_S05,RDATA_S06,
						RDATA_S07,RDATA_S08,RDATA_S09,RDATA_S10,RDATA_S11,RDATA_S12,RDATA_S13,RDATA_S14,RDATA_S15,RDATA_S16,RDATA_S17};
	18: UWDATA_Out = {RDATA_S19,RDATA_S20,RDATA_S21,RDATA_S22,RDATA_S01,RDATA_S02,RDATA_S03,RDATA_S04,RDATA_S05,RDATA_S06,RDATA_S07,
						RDATA_S08,RDATA_S09,RDATA_S10,RDATA_S11,RDATA_S12,RDATA_S13,RDATA_S14,RDATA_S15,RDATA_S16,RDATA_S17,RDATA_S18};
	19: UWDATA_Out = {RDATA_S20,RDATA_S21,RDATA_S22,RDATA_S01,RDATA_S02,RDATA_S03,RDATA_S04,RDATA_S05,RDATA_S06,RDATA_S07,RDATA_S08,
						RDATA_S09,RDATA_S10,RDATA_S11,RDATA_S12,RDATA_S13,RDATA_S14,RDATA_S15,RDATA_S16,RDATA_S17,RDATA_S18,RDATA_S19};
	20: UWDATA_Out = {RDATA_S21,RDATA_S22,RDATA_S01,RDATA_S02,RDATA_S03,RDATA_S04,RDATA_S05,RDATA_S06,RDATA_S07,RDATA_S08,RDATA_S09,
						RDATA_S10,RDATA_S11,RDATA_S12,RDATA_S13,RDATA_S14,RDATA_S15,RDATA_S16,RDATA_S17,RDATA_S18,RDATA_S19,RDATA_S20};
	21: UWDATA_Out = {RDATA_S22,RDATA_S01,RDATA_S02,RDATA_S03,RDATA_S04,RDATA_S05,RDATA_S06,RDATA_S07,RDATA_S08,RDATA_S09,RDATA_S10,
						RDATA_S11,RDATA_S12,RDATA_S13,RDATA_S14,RDATA_S15,RDATA_S16,RDATA_S17,RDATA_S18,RDATA_S19,RDATA_S20,RDATA_S21};
	default: UWDATA_Out = 0;
	endcase
end

always @*
begin
	if (UW_sel_col)
	begin
	case(whichRAM)
	0:
	begin
		RADDR_S01 = raddr1;
		RADDR_S02 = raddr2;
		RADDR_S03 = raddr3;
		RADDR_S04 = raddr4;
		RADDR_S05 = raddr5;
		RADDR_S06 = raddr6;
		RADDR_S07 = raddr7;
		RADDR_S08 = raddr8;
		RADDR_S09 = raddr9;
		RADDR_S10 = raddr10;
		RADDR_S11 = raddr11;
		RADDR_S12 = raddr12;
		RADDR_S13 = raddr13;
		RADDR_S14 = raddr14;
		RADDR_S15 = raddr15;
		RADDR_S16 = raddr16;
		RADDR_S17 = raddr17;
		RADDR_S18 = raddr18;
		RADDR_S19 = raddr19;
		RADDR_S20 = raddr20;
		RADDR_S21 = raddr21;
		RADDR_S22 = raddr22;
		
	end
	1:
	begin
		RADDR_S01 = raddr22;
		RADDR_S02 = raddr1;
		RADDR_S03 = raddr2;
		RADDR_S04 = raddr3;
		RADDR_S05 = raddr4;
		RADDR_S06 = raddr5;
		RADDR_S07 = raddr6;
		RADDR_S08 = raddr7;
		RADDR_S09 = raddr8;
		RADDR_S10 = raddr9;
		RADDR_S11 = raddr10;
		RADDR_S12 = raddr11;
		RADDR_S13 = raddr12;
		RADDR_S14 = raddr13;
		RADDR_S15 = raddr14;
		RADDR_S16 = raddr15;
		RADDR_S17 = raddr16;
		RADDR_S18 = raddr17;
		RADDR_S19 = raddr18;
		RADDR_S20 = raddr19;
		RADDR_S21 = raddr20;
		RADDR_S22 = raddr21;
		
	end
	2:
	begin
		RADDR_S01 = raddr21;
		RADDR_S02 = raddr22;
		RADDR_S03 = raddr1;
		RADDR_S04 = raddr2;
		RADDR_S05 = raddr3;
		RADDR_S06 = raddr4;
		RADDR_S07 = raddr5;
		RADDR_S08 = raddr6;
		RADDR_S09 = raddr7;
		RADDR_S10 = raddr8;
		RADDR_S11 = raddr9;
		RADDR_S12 = raddr10;
		RADDR_S13 = raddr11;
		RADDR_S14 = raddr12;
		RADDR_S15 = raddr13;
		RADDR_S16 = raddr14;
		RADDR_S17 = raddr15;
		RADDR_S18 = raddr16;
		RADDR_S19 = raddr17;
		RADDR_S20 = raddr18;
		RADDR_S21 = raddr19;
		RADDR_S22 = raddr20;
		
	end
	3:
	begin
		RADDR_S01 = raddr20;
		RADDR_S02 = raddr21;
		RADDR_S03 = raddr22;
		RADDR_S04 = raddr1;
		RADDR_S05 = raddr2;
		RADDR_S06 = raddr3;
		RADDR_S07 = raddr4;
		RADDR_S08 = raddr5;
		RADDR_S09 = raddr6;
		RADDR_S10 = raddr7;
		RADDR_S11 = raddr8;
		RADDR_S12 = raddr9;
		RADDR_S13 = raddr10;
		RADDR_S14 = raddr11;
		RADDR_S15 = raddr12;
		RADDR_S16 = raddr13;
		RADDR_S17 = raddr14;
		RADDR_S18 = raddr15;
		RADDR_S19 = raddr16;
		RADDR_S20 = raddr17;
		RADDR_S21 = raddr18;
		RADDR_S22 = raddr19;
		
	end
	4:
	begin
		RADDR_S01 = raddr19;
		RADDR_S02 = raddr20;
		RADDR_S03 = raddr21;
		RADDR_S04 = raddr22;
		RADDR_S05 = raddr1;
		RADDR_S06 = raddr2;
		RADDR_S07 = raddr3;
		RADDR_S08 = raddr4;
		RADDR_S09 = raddr5;
		RADDR_S10 = raddr6;
		RADDR_S11 = raddr7;
		RADDR_S12 = raddr8;
		RADDR_S13 = raddr9;
		RADDR_S14 = raddr10;
		RADDR_S15 = raddr11;
		RADDR_S16 = raddr12;
		RADDR_S17 = raddr13;
		RADDR_S18 = raddr14;
		RADDR_S19 = raddr15;
		RADDR_S20 = raddr16;
		RADDR_S21 = raddr17;
		RADDR_S22 = raddr18;
		
	end
	5:
	begin
		RADDR_S01 = raddr18;
		RADDR_S02 = raddr19;
		RADDR_S03 = raddr20;
		RADDR_S04 = raddr21;
		RADDR_S05 = raddr22;
		RADDR_S06 = raddr1;
		RADDR_S07 = raddr2;
		RADDR_S08 = raddr3;
		RADDR_S09 = raddr4;
		RADDR_S10 = raddr5;
		RADDR_S11 = raddr6;
		RADDR_S12 = raddr7;
		RADDR_S13 = raddr8;
		RADDR_S14 = raddr9;
		RADDR_S15 = raddr10;
		RADDR_S16 = raddr11;
		RADDR_S17 = raddr12;
		RADDR_S18 = raddr13;
		RADDR_S19 = raddr14;
		RADDR_S20 = raddr15;
		RADDR_S21 = raddr16;
		RADDR_S22 = raddr17;
		
	end
	6:
	begin
		RADDR_S01 = raddr17;
		RADDR_S02 = raddr18;
		RADDR_S03 = raddr19;
		RADDR_S04 = raddr20;
		RADDR_S05 = raddr21;
		RADDR_S06 = raddr22;
		RADDR_S07 = raddr1;
		RADDR_S08 = raddr2;
		RADDR_S09 = raddr3;
		RADDR_S10 = raddr4;
		RADDR_S11 = raddr5;
		RADDR_S12 = raddr6;
		RADDR_S13 = raddr7;
		RADDR_S14 = raddr8;
		RADDR_S15 = raddr9;
		RADDR_S16 = raddr10;
		RADDR_S17 = raddr11;
		RADDR_S18 = raddr12;
		RADDR_S19 = raddr13;
		RADDR_S20 = raddr14;
		RADDR_S21 = raddr15;
		RADDR_S22 = raddr16;
		
	end
	7:
	begin
		RADDR_S01 = raddr16;
		RADDR_S02 = raddr17;
		RADDR_S03 = raddr18;
		RADDR_S04 = raddr19;
		RADDR_S05 = raddr20;
		RADDR_S06 = raddr21;
		RADDR_S07 = raddr22;
		RADDR_S08 = raddr1;
		RADDR_S09 = raddr2;
		RADDR_S10 = raddr3;
		RADDR_S11 = raddr4;
		RADDR_S12 = raddr5;
		RADDR_S13 = raddr6;
		RADDR_S14 = raddr7;
		RADDR_S15 = raddr8;
		RADDR_S16 = raddr9;
		RADDR_S17 = raddr10;
		RADDR_S18 = raddr11;
		RADDR_S19 = raddr12;
		RADDR_S20 = raddr13;
		RADDR_S21 = raddr14;
		RADDR_S22 = raddr15;
		
	end
	8:
	begin
		RADDR_S01 = raddr15;
		RADDR_S02 = raddr16;
		RADDR_S03 = raddr17;
		RADDR_S04 = raddr18;
		RADDR_S05 = raddr19;
		RADDR_S06 = raddr20;
		RADDR_S07 = raddr21;
		RADDR_S08 = raddr22;
		RADDR_S09 = raddr1;
		RADDR_S10 = raddr2;
		RADDR_S11 = raddr3;
		RADDR_S12 = raddr4;
		RADDR_S13 = raddr5;
		RADDR_S14 = raddr6;
		RADDR_S15 = raddr7;
		RADDR_S16 = raddr8;
		RADDR_S17 = raddr9;
		RADDR_S18 = raddr10;
		RADDR_S19 = raddr11;
		RADDR_S20 = raddr12;
		RADDR_S21 = raddr13;
		RADDR_S22 = raddr14;
		
	end
	9:
	begin
		RADDR_S01 = raddr14;
		RADDR_S02 = raddr15;
		RADDR_S03 = raddr16;
		RADDR_S04 = raddr17;
		RADDR_S05 = raddr18;
		RADDR_S06 = raddr19;
		RADDR_S07 = raddr20;
		RADDR_S08 = raddr21;
		RADDR_S09 = raddr22;
		RADDR_S10 = raddr1;
		RADDR_S11 = raddr2;
		RADDR_S12 = raddr3;
		RADDR_S13 = raddr4;
		RADDR_S14 = raddr5;
		RADDR_S15 = raddr6;
		RADDR_S16 = raddr7;
		RADDR_S17 = raddr8;
		RADDR_S18 = raddr9;
		RADDR_S19 = raddr10;
		RADDR_S20 = raddr11;
		RADDR_S21 = raddr12;
		RADDR_S22 = raddr13;
		
	end
	10:
	begin
		RADDR_S01 = raddr13;
		RADDR_S02 = raddr14;
		RADDR_S03 = raddr15;
		RADDR_S04 = raddr16;
		RADDR_S05 = raddr17;
		RADDR_S06 = raddr18;
		RADDR_S07 = raddr19;
		RADDR_S08 = raddr20;
		RADDR_S09 = raddr21;
		RADDR_S10 = raddr22;
		RADDR_S11 = raddr1;
		RADDR_S12 = raddr2;
		RADDR_S13 = raddr3;
		RADDR_S14 = raddr4;
		RADDR_S15 = raddr5;
		RADDR_S16 = raddr6;
		RADDR_S17 = raddr7;
		RADDR_S18 = raddr8;
		RADDR_S19 = raddr9;
		RADDR_S20 = raddr10;
		RADDR_S21 = raddr11;
		RADDR_S22 = raddr12;
		
	end
	11:
	begin
		RADDR_S01 = raddr12;
		RADDR_S02 = raddr13;
		RADDR_S03 = raddr14;
		RADDR_S04 = raddr15;
		RADDR_S05 = raddr16;
		RADDR_S06 = raddr17;
		RADDR_S07 = raddr18;
		RADDR_S08 = raddr19;
		RADDR_S09 = raddr20;
		RADDR_S10 = raddr21;
		RADDR_S11 = raddr22;
		RADDR_S12 = raddr1;
		RADDR_S13 = raddr2;
		RADDR_S14 = raddr3;
		RADDR_S15 = raddr4;
		RADDR_S16 = raddr5;
		RADDR_S17 = raddr6;
		RADDR_S18 = raddr7;
		RADDR_S19 = raddr8;
		RADDR_S20 = raddr9;
		RADDR_S21 = raddr10;
		RADDR_S22 = raddr11;
		
	end
	12:
	begin
		RADDR_S01 = raddr11;
		RADDR_S02 = raddr12;
		RADDR_S03 = raddr13;
		RADDR_S04 = raddr14;
		RADDR_S05 = raddr15;
		RADDR_S06 = raddr16;
		RADDR_S07 = raddr17;
		RADDR_S08 = raddr18;
		RADDR_S09 = raddr19;
		RADDR_S10 = raddr20;
		RADDR_S11 = raddr21;
		RADDR_S12 = raddr22;
		RADDR_S13 = raddr1;
		RADDR_S14 = raddr2;
		RADDR_S15 = raddr3;
		RADDR_S16 = raddr4;
		RADDR_S17 = raddr5;
		RADDR_S18 = raddr6;
		RADDR_S19 = raddr7;
		RADDR_S20 = raddr8;
		RADDR_S21 = raddr9;
		RADDR_S22 = raddr10;
		
	end
	13:
	begin
		RADDR_S01 = raddr10;
		RADDR_S02 = raddr11;
		RADDR_S03 = raddr12;
		RADDR_S04 = raddr13;
		RADDR_S05 = raddr14;
		RADDR_S06 = raddr15;
		RADDR_S07 = raddr16;
		RADDR_S08 = raddr17;
		RADDR_S09 = raddr18;
		RADDR_S10 = raddr19;
		RADDR_S11 = raddr20;
		RADDR_S12 = raddr21;
		RADDR_S13 = raddr22;
		RADDR_S14 = raddr1;
		RADDR_S15 = raddr2;
		RADDR_S16 = raddr3;
		RADDR_S17 = raddr4;
		RADDR_S18 = raddr5;
		RADDR_S19 = raddr6;
		RADDR_S20 = raddr7;
		RADDR_S21 = raddr8;
		RADDR_S22 = raddr9;
		
	end
	14:
	begin
		RADDR_S01 = raddr9;
		RADDR_S02 = raddr10;
		RADDR_S03 = raddr11;
		RADDR_S04 = raddr12;
		RADDR_S05 = raddr13;
		RADDR_S06 = raddr14;
		RADDR_S07 = raddr15;
		RADDR_S08 = raddr16;
		RADDR_S09 = raddr17;
		RADDR_S10 = raddr18;
		RADDR_S11 = raddr19;
		RADDR_S12 = raddr20;
		RADDR_S13 = raddr21;
		RADDR_S14 = raddr22;
		RADDR_S15 = raddr1;
		RADDR_S16 = raddr2;
		RADDR_S17 = raddr3;
		RADDR_S18 = raddr4;
		RADDR_S19 = raddr5;
		RADDR_S20 = raddr6;
		RADDR_S21 = raddr7;
		RADDR_S22 = raddr8;
		
	end
	15:
	begin
		RADDR_S01 = raddr8;
		RADDR_S02 = raddr9;
		RADDR_S03 = raddr10;
		RADDR_S04 = raddr11;
		RADDR_S05 = raddr12;
		RADDR_S06 = raddr13;
		RADDR_S07 = raddr14;
		RADDR_S08 = raddr15;
		RADDR_S09 = raddr16;
		RADDR_S10 = raddr17;
		RADDR_S11 = raddr18;
		RADDR_S12 = raddr19;
		RADDR_S13 = raddr20;
		RADDR_S14 = raddr21;
		RADDR_S15 = raddr22;
		RADDR_S16 = raddr1;
		RADDR_S17 = raddr2;
		RADDR_S18 = raddr3;
		RADDR_S19 = raddr4;
		RADDR_S20 = raddr5;
		RADDR_S21 = raddr6;
		RADDR_S22 = raddr7;
		
	end
	16:
	begin
		RADDR_S01 = raddr7;
		RADDR_S02 = raddr8;
		RADDR_S03 = raddr9;
		RADDR_S04 = raddr10;
		RADDR_S05 = raddr11;
		RADDR_S06 = raddr12;
		RADDR_S07 = raddr13;
		RADDR_S08 = raddr14;
		RADDR_S09 = raddr15;
		RADDR_S10 = raddr16;
		RADDR_S11 = raddr17;
		RADDR_S12 = raddr18;
		RADDR_S13 = raddr19;
		RADDR_S14 = raddr20;
		RADDR_S15 = raddr21;
		RADDR_S16 = raddr22;
		RADDR_S17 = raddr1;
		RADDR_S18 = raddr2;
		RADDR_S19 = raddr3;
		RADDR_S20 = raddr4;
		RADDR_S21 = raddr5;
		RADDR_S22 = raddr6;
		
	end
	17:
	begin
		RADDR_S01 = raddr6;
		RADDR_S02 = raddr7;
		RADDR_S03 = raddr8;
		RADDR_S04 = raddr9;
		RADDR_S05 = raddr10;
		RADDR_S06 = raddr11;
		RADDR_S07 = raddr12;
		RADDR_S08 = raddr13;
		RADDR_S09 = raddr14;
		RADDR_S10 = raddr15;
		RADDR_S11 = raddr16;
		RADDR_S12 = raddr17;
		RADDR_S13 = raddr18;
		RADDR_S14 = raddr19;
		RADDR_S15 = raddr20;
		RADDR_S16 = raddr21;
		RADDR_S17 = raddr22;
		RADDR_S18 = raddr1;
		RADDR_S19 = raddr2;
		RADDR_S20 = raddr3;
		RADDR_S21 = raddr4;
		RADDR_S22 = raddr5;
		
	end
	18:
	begin
		RADDR_S01 = raddr5;
		RADDR_S02 = raddr6;
		RADDR_S03 = raddr7;
		RADDR_S04 = raddr8;
		RADDR_S05 = raddr9;
		RADDR_S06 = raddr10;
		RADDR_S07 = raddr11;
		RADDR_S08 = raddr12;
		RADDR_S09 = raddr13;
		RADDR_S10 = raddr14;
		RADDR_S11 = raddr15;
		RADDR_S12 = raddr16;
		RADDR_S13 = raddr17;
		RADDR_S14 = raddr18;
		RADDR_S15 = raddr19;
		RADDR_S16 = raddr20;
		RADDR_S17 = raddr21;
		RADDR_S18 = raddr22;
		RADDR_S19 = raddr1;
		RADDR_S20 = raddr2;
		RADDR_S21 = raddr3;
		RADDR_S22 = raddr4;
		
	end
	19:
	begin
		RADDR_S01 = raddr4;
		RADDR_S02 = raddr5;
		RADDR_S03 = raddr6;
		RADDR_S04 = raddr7;
		RADDR_S05 = raddr8;
		RADDR_S06 = raddr9;
		RADDR_S07 = raddr10;
		RADDR_S08 = raddr11;
		RADDR_S09 = raddr12;
		RADDR_S10 = raddr13;
		RADDR_S11 = raddr14;
		RADDR_S12 = raddr15;
		RADDR_S13 = raddr16;
		RADDR_S14 = raddr17;
		RADDR_S15 = raddr18;
		RADDR_S16 = raddr19;
		RADDR_S17 = raddr20;
		RADDR_S18 = raddr21;
		RADDR_S19 = raddr22;
		RADDR_S20 = raddr1;
		RADDR_S21 = raddr2;
		RADDR_S22 = raddr3;
		
	end
	20:
	begin
		RADDR_S01 = raddr3;
		RADDR_S02 = raddr4;
		RADDR_S03 = raddr5;
		RADDR_S04 = raddr6;
		RADDR_S05 = raddr7;
		RADDR_S06 = raddr8;
		RADDR_S07 = raddr9;
		RADDR_S08 = raddr10;
		RADDR_S09 = raddr11;
		RADDR_S10 = raddr12;
		RADDR_S11 = raddr13;
		RADDR_S12 = raddr14;
		RADDR_S13 = raddr15;
		RADDR_S14 = raddr16;
		RADDR_S15 = raddr17;
		RADDR_S16 = raddr18;
		RADDR_S17 = raddr19;
		RADDR_S18 = raddr20;
		RADDR_S19 = raddr21;
		RADDR_S20 = raddr22;
		RADDR_S21 = raddr1;
		RADDR_S22 = raddr2;
		
	end
	21:
	begin
		RADDR_S01 = raddr2;
		RADDR_S02 = raddr3;
		RADDR_S03 = raddr4;
		RADDR_S04 = raddr5;
		RADDR_S05 = raddr6;
		RADDR_S06 = raddr7;
		RADDR_S07 = raddr8;
		RADDR_S08 = raddr9;
		RADDR_S09 = raddr10;
		RADDR_S10 = raddr11;
		RADDR_S11 = raddr12;
		RADDR_S12 = raddr13;
		RADDR_S13 = raddr14;
		RADDR_S14 = raddr15;
		RADDR_S15 = raddr16;
		RADDR_S16 = raddr17;
		RADDR_S17 = raddr18;
		RADDR_S18 = raddr19;
		RADDR_S19 = raddr20;
		RADDR_S20 = raddr21;
		RADDR_S21 = raddr22;
		RADDR_S22 = raddr1;
		
	end
	default:
	begin
		RADDR_S01 = 0;
		RADDR_S02 = 0;
		RADDR_S03 = 0;
		RADDR_S04 = 0;
		RADDR_S05 = 0;
		RADDR_S06 = 0;
		RADDR_S07 = 0;
		RADDR_S08 = 0;
		RADDR_S09 = 0;
		RADDR_S10 = 0;
		RADDR_S11 = 0;
		RADDR_S12 = 0;
		RADDR_S13 = 0;
		RADDR_S14 = 0;
		RADDR_S15 = 0;
		RADDR_S16 = 0;
		RADDR_S17 = 0;
		RADDR_S18 = 0;
		RADDR_S19 = 0;
		RADDR_S20 = 0;
		RADDR_S21 = 0;
		RADDR_S22 = 0;
		
	end
	endcase
	end
	else
	begin
	case(whichRAM)
	0:
	begin
		RADDR_S01 = readaddr;
		RADDR_S02 = readaddr2;
		RADDR_S03 = readaddr3;
		RADDR_S04 = readaddr4;
		RADDR_S05 = readaddr5;
		RADDR_S06 = readaddr6;
		RADDR_S07 = readaddr7;
		RADDR_S08 = readaddr8;
		RADDR_S09 = readaddr9;
		RADDR_S10 = readaddr10;
		RADDR_S11 = readaddr11;
		RADDR_S12 = readaddr12;
		RADDR_S13 = readaddr13;
		RADDR_S14 = readaddr14;
		RADDR_S15 = readaddr15;
		RADDR_S16 = readaddr16;
		RADDR_S17 = readaddr17;
		RADDR_S18 = readaddr18;
		RADDR_S19 = readaddr19;
		RADDR_S20 = readaddr20;
		RADDR_S21 = readaddr21;
		RADDR_S22 = readaddr22;
		
	end
	1:
	begin
		RADDR_S01 = readaddr22;
		RADDR_S02 = readaddr;
		RADDR_S03 = readaddr2;
		RADDR_S04 = readaddr3;
		RADDR_S05 = readaddr4;
		RADDR_S06 = readaddr5;
		RADDR_S07 = readaddr6;
		RADDR_S08 = readaddr7;
		RADDR_S09 = readaddr8;
		RADDR_S10 = readaddr9;
		RADDR_S11 = readaddr10;
		RADDR_S12 = readaddr11;
		RADDR_S13 = readaddr12;
		RADDR_S14 = readaddr13;
		RADDR_S15 = readaddr14;
		RADDR_S16 = readaddr15;
		RADDR_S17 = readaddr16;
		RADDR_S18 = readaddr17;
		RADDR_S19 = readaddr18;
		RADDR_S20 = readaddr19;
		RADDR_S21 = readaddr20;
		RADDR_S22 = readaddr21;
		
	end
	2:
	begin
		RADDR_S01 = readaddr21;
		RADDR_S02 = readaddr22;
		RADDR_S03 = readaddr;
		RADDR_S04 = readaddr2;
		RADDR_S05 = readaddr3;
		RADDR_S06 = readaddr4;
		RADDR_S07 = readaddr5;
		RADDR_S08 = readaddr6;
		RADDR_S09 = readaddr7;
		RADDR_S10 = readaddr8;
		RADDR_S11 = readaddr9;
		RADDR_S12 = readaddr10;
		RADDR_S13 = readaddr11;
		RADDR_S14 = readaddr12;
		RADDR_S15 = readaddr13;
		RADDR_S16 = readaddr14;
		RADDR_S17 = readaddr15;
		RADDR_S18 = readaddr16;
		RADDR_S19 = readaddr17;
		RADDR_S20 = readaddr18;
		RADDR_S21 = readaddr19;
		RADDR_S22 = readaddr20;
		
	end
	3:
	begin
		RADDR_S01 = readaddr20;
		RADDR_S02 = readaddr21;
		RADDR_S03 = readaddr22;
		RADDR_S04 = readaddr;
		RADDR_S05 = readaddr2;
		RADDR_S06 = readaddr3;
		RADDR_S07 = readaddr4;
		RADDR_S08 = readaddr5;
		RADDR_S09 = readaddr6;
		RADDR_S10 = readaddr7;
		RADDR_S11 = readaddr8;
		RADDR_S12 = readaddr9;
		RADDR_S13 = readaddr10;
		RADDR_S14 = readaddr11;
		RADDR_S15 = readaddr12;
		RADDR_S16 = readaddr13;
		RADDR_S17 = readaddr14;
		RADDR_S18 = readaddr15;
		RADDR_S19 = readaddr16;
		RADDR_S20 = readaddr17;
		RADDR_S21 = readaddr18;
		RADDR_S22 = readaddr19;
		
	end
	4:
	begin
		RADDR_S01 = readaddr19;
		RADDR_S02 = readaddr20;
		RADDR_S03 = readaddr21;
		RADDR_S04 = readaddr22;
		RADDR_S05 = readaddr;
		RADDR_S06 = readaddr2;
		RADDR_S07 = readaddr3;
		RADDR_S08 = readaddr4;
		RADDR_S09 = readaddr5;
		RADDR_S10 = readaddr6;
		RADDR_S11 = readaddr7;
		RADDR_S12 = readaddr8;
		RADDR_S13 = readaddr9;
		RADDR_S14 = readaddr10;
		RADDR_S15 = readaddr11;
		RADDR_S16 = readaddr12;
		RADDR_S17 = readaddr13;
		RADDR_S18 = readaddr14;
		RADDR_S19 = readaddr15;
		RADDR_S20 = readaddr16;
		RADDR_S21 = readaddr17;
		RADDR_S22 = readaddr18;
		
	end
	5:
	begin
		RADDR_S01 = readaddr18;
		RADDR_S02 = readaddr19;
		RADDR_S03 = readaddr20;
		RADDR_S04 = readaddr21;
		RADDR_S05 = readaddr22;
		RADDR_S06 = readaddr;
		RADDR_S07 = readaddr2;
		RADDR_S08 = readaddr3;
		RADDR_S09 = readaddr4;
		RADDR_S10 = readaddr5;
		RADDR_S11 = readaddr6;
		RADDR_S12 = readaddr7;
		RADDR_S13 = readaddr8;
		RADDR_S14 = readaddr9;
		RADDR_S15 = readaddr10;
		RADDR_S16 = readaddr11;
		RADDR_S17 = readaddr12;
		RADDR_S18 = readaddr13;
		RADDR_S19 = readaddr14;
		RADDR_S20 = readaddr15;
		RADDR_S21 = readaddr16;
		RADDR_S22 = readaddr17;
		
	end
	6:
	begin
		RADDR_S01 = readaddr17;
		RADDR_S02 = readaddr18;
		RADDR_S03 = readaddr19;
		RADDR_S04 = readaddr20;
		RADDR_S05 = readaddr21;
		RADDR_S06 = readaddr22;
		RADDR_S07 = readaddr;
		RADDR_S08 = readaddr2;
		RADDR_S09 = readaddr3;
		RADDR_S10 = readaddr4;
		RADDR_S11 = readaddr5;
		RADDR_S12 = readaddr6;
		RADDR_S13 = readaddr7;
		RADDR_S14 = readaddr8;
		RADDR_S15 = readaddr9;
		RADDR_S16 = readaddr10;
		RADDR_S17 = readaddr11;
		RADDR_S18 = readaddr12;
		RADDR_S19 = readaddr13;
		RADDR_S20 = readaddr14;
		RADDR_S21 = readaddr15;
		RADDR_S22 = readaddr16;
		
	end
	7:
	begin
		RADDR_S01 = readaddr16;
		RADDR_S02 = readaddr17;
		RADDR_S03 = readaddr18;
		RADDR_S04 = readaddr19;
		RADDR_S05 = readaddr20;
		RADDR_S06 = readaddr21;
		RADDR_S07 = readaddr22;
		RADDR_S08 = readaddr;
		RADDR_S09 = readaddr2;
		RADDR_S10 = readaddr3;
		RADDR_S11 = readaddr4;
		RADDR_S12 = readaddr5;
		RADDR_S13 = readaddr6;
		RADDR_S14 = readaddr7;
		RADDR_S15 = readaddr8;
		RADDR_S16 = readaddr9;
		RADDR_S17 = readaddr10;
		RADDR_S18 = readaddr11;
		RADDR_S19 = readaddr12;
		RADDR_S20 = readaddr13;
		RADDR_S21 = readaddr14;
		RADDR_S22 = readaddr15;
		
	end
	8:
	begin
		RADDR_S01 = readaddr15;
		RADDR_S02 = readaddr16;
		RADDR_S03 = readaddr17;
		RADDR_S04 = readaddr18;
		RADDR_S05 = readaddr19;
		RADDR_S06 = readaddr20;
		RADDR_S07 = readaddr21;
		RADDR_S08 = readaddr22;
		RADDR_S09 = readaddr;
		RADDR_S10 = readaddr2;
		RADDR_S11 = readaddr3;
		RADDR_S12 = readaddr4;
		RADDR_S13 = readaddr5;
		RADDR_S14 = readaddr6;
		RADDR_S15 = readaddr7;
		RADDR_S16 = readaddr8;
		RADDR_S17 = readaddr9;
		RADDR_S18 = readaddr10;
		RADDR_S19 = readaddr11;
		RADDR_S20 = readaddr12;
		RADDR_S21 = readaddr13;
		RADDR_S22 = readaddr14;
		
	end
	9:
	begin
		RADDR_S01 = readaddr14;
		RADDR_S02 = readaddr15;
		RADDR_S03 = readaddr16;
		RADDR_S04 = readaddr17;
		RADDR_S05 = readaddr18;
		RADDR_S06 = readaddr19;
		RADDR_S07 = readaddr20;
		RADDR_S08 = readaddr21;
		RADDR_S09 = readaddr22;
		RADDR_S10 = readaddr;
		RADDR_S11 = readaddr2;
		RADDR_S12 = readaddr3;
		RADDR_S13 = readaddr4;
		RADDR_S14 = readaddr5;
		RADDR_S15 = readaddr6;
		RADDR_S16 = readaddr7;
		RADDR_S17 = readaddr8;
		RADDR_S18 = readaddr9;
		RADDR_S19 = readaddr10;
		RADDR_S20 = readaddr11;
		RADDR_S21 = readaddr12;
		RADDR_S22 = readaddr13;
		
	end
	10:
	begin
		RADDR_S01 = readaddr13;
		RADDR_S02 = readaddr14;
		RADDR_S03 = readaddr15;
		RADDR_S04 = readaddr16;
		RADDR_S05 = readaddr17;
		RADDR_S06 = readaddr18;
		RADDR_S07 = readaddr19;
		RADDR_S08 = readaddr20;
		RADDR_S09 = readaddr21;
		RADDR_S10 = readaddr22;
		RADDR_S11 = readaddr;
		RADDR_S12 = readaddr2;
		RADDR_S13 = readaddr3;
		RADDR_S14 = readaddr4;
		RADDR_S15 = readaddr5;
		RADDR_S16 = readaddr6;
		RADDR_S17 = readaddr7;
		RADDR_S18 = readaddr8;
		RADDR_S19 = readaddr9;
		RADDR_S20 = readaddr10;
		RADDR_S21 = readaddr11;
		RADDR_S22 = readaddr12;
		
	end
	11:
	begin
		RADDR_S01 = readaddr12;
		RADDR_S02 = readaddr13;
		RADDR_S03 = readaddr14;
		RADDR_S04 = readaddr15;
		RADDR_S05 = readaddr16;
		RADDR_S06 = readaddr17;
		RADDR_S07 = readaddr18;
		RADDR_S08 = readaddr19;
		RADDR_S09 = readaddr20;
		RADDR_S10 = readaddr21;
		RADDR_S11 = readaddr22;
		RADDR_S12 = readaddr;
		RADDR_S13 = readaddr2;
		RADDR_S14 = readaddr3;
		RADDR_S15 = readaddr4;
		RADDR_S16 = readaddr5;
		RADDR_S17 = readaddr6;
		RADDR_S18 = readaddr7;
		RADDR_S19 = readaddr8;
		RADDR_S20 = readaddr9;
		RADDR_S21 = readaddr10;
		RADDR_S22 = readaddr11;
		
	end
	12:
	begin
		RADDR_S01 = readaddr11;
		RADDR_S02 = readaddr12;
		RADDR_S03 = readaddr13;
		RADDR_S04 = readaddr14;
		RADDR_S05 = readaddr15;
		RADDR_S06 = readaddr16;
		RADDR_S07 = readaddr17;
		RADDR_S08 = readaddr18;
		RADDR_S09 = readaddr19;
		RADDR_S10 = readaddr20;
		RADDR_S11 = readaddr21;
		RADDR_S12 = readaddr22;
		RADDR_S13 = readaddr;
		RADDR_S14 = readaddr2;
		RADDR_S15 = readaddr3;
		RADDR_S16 = readaddr4;
		RADDR_S17 = readaddr5;
		RADDR_S18 = readaddr6;
		RADDR_S19 = readaddr7;
		RADDR_S20 = readaddr8;
		RADDR_S21 = readaddr9;
		RADDR_S22 = readaddr10;
		
	end
	13:
	begin
		RADDR_S01 = readaddr10;
		RADDR_S02 = readaddr11;
		RADDR_S03 = readaddr12;
		RADDR_S04 = readaddr13;
		RADDR_S05 = readaddr14;
		RADDR_S06 = readaddr15;
		RADDR_S07 = readaddr16;
		RADDR_S08 = readaddr17;
		RADDR_S09 = readaddr18;
		RADDR_S10 = readaddr19;
		RADDR_S11 = readaddr20;
		RADDR_S12 = readaddr21;
		RADDR_S13 = readaddr22;
		RADDR_S14 = readaddr;
		RADDR_S15 = readaddr2;
		RADDR_S16 = readaddr3;
		RADDR_S17 = readaddr4;
		RADDR_S18 = readaddr5;
		RADDR_S19 = readaddr6;
		RADDR_S20 = readaddr7;
		RADDR_S21 = readaddr8;
		RADDR_S22 = readaddr9;
		
	end
	14:
	begin
		RADDR_S01 = readaddr9;
		RADDR_S02 = readaddr10;
		RADDR_S03 = readaddr11;
		RADDR_S04 = readaddr12;
		RADDR_S05 = readaddr13;
		RADDR_S06 = readaddr14;
		RADDR_S07 = readaddr15;
		RADDR_S08 = readaddr16;
		RADDR_S09 = readaddr17;
		RADDR_S10 = readaddr18;
		RADDR_S11 = readaddr19;
		RADDR_S12 = readaddr20;
		RADDR_S13 = readaddr21;
		RADDR_S14 = readaddr22;
		RADDR_S15 = readaddr;
		RADDR_S16 = readaddr2;
		RADDR_S17 = readaddr3;
		RADDR_S18 = readaddr4;
		RADDR_S19 = readaddr5;
		RADDR_S20 = readaddr6;
		RADDR_S21 = readaddr7;
		RADDR_S22 = readaddr8;
		
	end
	15:
	begin
		RADDR_S01 = readaddr8;
		RADDR_S02 = readaddr9;
		RADDR_S03 = readaddr10;
		RADDR_S04 = readaddr11;
		RADDR_S05 = readaddr12;
		RADDR_S06 = readaddr13;
		RADDR_S07 = readaddr14;
		RADDR_S08 = readaddr15;
		RADDR_S09 = readaddr16;
		RADDR_S10 = readaddr17;
		RADDR_S11 = readaddr18;
		RADDR_S12 = readaddr19;
		RADDR_S13 = readaddr20;
		RADDR_S14 = readaddr21;
		RADDR_S15 = readaddr22;
		RADDR_S16 = readaddr;
		RADDR_S17 = readaddr2;
		RADDR_S18 = readaddr3;
		RADDR_S19 = readaddr4;
		RADDR_S20 = readaddr5;
		RADDR_S21 = readaddr6;
		RADDR_S22 = readaddr7;
		
	end
	16:
	begin
		RADDR_S01 = readaddr7;
		RADDR_S02 = readaddr8;
		RADDR_S03 = readaddr9;
		RADDR_S04 = readaddr10;
		RADDR_S05 = readaddr11;
		RADDR_S06 = readaddr12;
		RADDR_S07 = readaddr13;
		RADDR_S08 = readaddr14;
		RADDR_S09 = readaddr15;
		RADDR_S10 = readaddr16;
		RADDR_S11 = readaddr17;
		RADDR_S12 = readaddr18;
		RADDR_S13 = readaddr19;
		RADDR_S14 = readaddr20;
		RADDR_S15 = readaddr21;
		RADDR_S16 = readaddr22;
		RADDR_S17 = readaddr;
		RADDR_S18 = readaddr2;
		RADDR_S19 = readaddr3;
		RADDR_S20 = readaddr4;
		RADDR_S21 = readaddr5;
		RADDR_S22 = readaddr6;
		
	end
	17:
	begin
		RADDR_S01 = readaddr6;
		RADDR_S02 = readaddr7;
		RADDR_S03 = readaddr8;
		RADDR_S04 = readaddr9;
		RADDR_S05 = readaddr10;
		RADDR_S06 = readaddr11;
		RADDR_S07 = readaddr12;
		RADDR_S08 = readaddr13;
		RADDR_S09 = readaddr14;
		RADDR_S10 = readaddr15;
		RADDR_S11 = readaddr16;
		RADDR_S12 = readaddr17;
		RADDR_S13 = readaddr18;
		RADDR_S14 = readaddr19;
		RADDR_S15 = readaddr20;
		RADDR_S16 = readaddr21;
		RADDR_S17 = readaddr22;
		RADDR_S18 = readaddr;
		RADDR_S19 = readaddr2;
		RADDR_S20 = readaddr3;
		RADDR_S21 = readaddr4;
		RADDR_S22 = readaddr5;
		
	end
	18:
	begin
		RADDR_S01 = readaddr5;
		RADDR_S02 = readaddr6;
		RADDR_S03 = readaddr7;
		RADDR_S04 = readaddr8;
		RADDR_S05 = readaddr9;
		RADDR_S06 = readaddr10;
		RADDR_S07 = readaddr11;
		RADDR_S08 = readaddr12;
		RADDR_S09 = readaddr13;
		RADDR_S10 = readaddr14;
		RADDR_S11 = readaddr15;
		RADDR_S12 = readaddr16;
		RADDR_S13 = readaddr17;
		RADDR_S14 = readaddr18;
		RADDR_S15 = readaddr19;
		RADDR_S16 = readaddr20;
		RADDR_S17 = readaddr21;
		RADDR_S18 = readaddr22;
		RADDR_S19 = readaddr;
		RADDR_S20 = readaddr2;
		RADDR_S21 = readaddr3;
		RADDR_S22 = readaddr4;
		
	end
	19:
	begin
		RADDR_S01 = readaddr4;
		RADDR_S02 = readaddr5;
		RADDR_S03 = readaddr6;
		RADDR_S04 = readaddr7;
		RADDR_S05 = readaddr8;
		RADDR_S06 = readaddr9;
		RADDR_S07 = readaddr10;
		RADDR_S08 = readaddr11;
		RADDR_S09 = readaddr12;
		RADDR_S10 = readaddr13;
		RADDR_S11 = readaddr14;
		RADDR_S12 = readaddr15;
		RADDR_S13 = readaddr16;
		RADDR_S14 = readaddr17;
		RADDR_S15 = readaddr18;
		RADDR_S16 = readaddr19;
		RADDR_S17 = readaddr20;
		RADDR_S18 = readaddr21;
		RADDR_S19 = readaddr22;
		RADDR_S20 = readaddr;
		RADDR_S21 = readaddr2;
		RADDR_S22 = readaddr3;
		
	end
	20:
	begin
		RADDR_S01 = readaddr3;
		RADDR_S02 = readaddr4;
		RADDR_S03 = readaddr5;
		RADDR_S04 = readaddr6;
		RADDR_S05 = readaddr7;
		RADDR_S06 = readaddr8;
		RADDR_S07 = readaddr9;
		RADDR_S08 = readaddr10;
		RADDR_S09 = readaddr11;
		RADDR_S10 = readaddr12;
		RADDR_S11 = readaddr13;
		RADDR_S12 = readaddr14;
		RADDR_S13 = readaddr15;
		RADDR_S14 = readaddr16;
		RADDR_S15 = readaddr17;
		RADDR_S16 = readaddr18;
		RADDR_S17 = readaddr19;
		RADDR_S18 = readaddr20;
		RADDR_S19 = readaddr21;
		RADDR_S20 = readaddr22;
		RADDR_S21 = readaddr;
		RADDR_S22 = readaddr2;
		
	end
	21:
	begin
		RADDR_S01 = readaddr2;
		RADDR_S02 = readaddr3;
		RADDR_S03 = readaddr4;
		RADDR_S04 = readaddr5;
		RADDR_S05 = readaddr6;
		RADDR_S06 = readaddr7;
		RADDR_S07 = readaddr8;
		RADDR_S08 = readaddr9;
		RADDR_S09 = readaddr10;
		RADDR_S10 = readaddr11;
		RADDR_S11 = readaddr12;
		RADDR_S12 = readaddr13;
		RADDR_S13 = readaddr14;
		RADDR_S14 = readaddr15;
		RADDR_S15 = readaddr16;
		RADDR_S16 = readaddr17;
		RADDR_S17 = readaddr18;
		RADDR_S18 = readaddr19;
		RADDR_S19 = readaddr20;
		RADDR_S20 = readaddr21;
		RADDR_S21 = readaddr22;
		RADDR_S22 = readaddr;
		
	end
	default:
	begin
		RADDR_S01 = 0;
		RADDR_S02 = 0;
		RADDR_S03 = 0;
		RADDR_S04 = 0;
		RADDR_S05 = 0;
		RADDR_S06 = 0;
		RADDR_S07 = 0;
		RADDR_S08 = 0;
		RADDR_S09 = 0;
		RADDR_S10 = 0;
		RADDR_S11 = 0;
		RADDR_S12 = 0;
		RADDR_S13 = 0;
		RADDR_S14 = 0;
		RADDR_S15 = 0;
		RADDR_S16 = 0;
		RADDR_S17 = 0;
		RADDR_S18 = 0;
		RADDR_S19 = 0;
		RADDR_S20 = 0;
		RADDR_S21 = 0;
		RADDR_S22 = 0;
		
	end
	endcase
	end
	
end

always @*
begin
	if (order11 == 1)
		WEorder1 = 1;
	else
		WEorder1 = 0;
	if (order11 == 2)
		WEorder2 = 1;
	else
		WEorder2 = 0;
	if (order11 == 3)
		WEorder3 = 1;
	else
		WEorder3 = 0;
	if (order11 == 4)
		WEorder4 = 1;
	else
		WEorder4 = 0;
	if (order11 == 5)
		WEorder5 = 1;
	else
		WEorder5 = 0;
	if (order11 == 6)
		WEorder6 = 1;
	else
		WEorder6 = 0;
	if (order11 == 7)
		WEorder7 = 1;
	else
		WEorder7 = 0;
	if (order11 == 8)
		WEorder8 = 1;
	else
		WEorder8 = 0;
	if (order11 == 9)
		WEorder9 = 1;
	else
		WEorder9 = 0;
	if (order11 == 10)
		WEorder10 = 1;
	else
		WEorder10 = 0;
	if (order11 == 11)
		WEorder11 = 1;
	else
		WEorder11 = 0;

end

always @*
begin
case (order)
    1:
    begin
        WDATA_S01 = inputpart1;
        WDATA_S02 = inputpart2;
        WDATA_S03 = inputpart1;
        WDATA_S04 = inputpart2;
        WDATA_S05 = inputpart1;
        WDATA_S06 = inputpart2;
        WDATA_S07 = inputpart1;
        WDATA_S08 = inputpart2;
        WDATA_S09 = inputpart1;
        WDATA_S10 = inputpart2;
        WDATA_S11 = inputpart1;
        WDATA_S12 = inputpart2;
        WDATA_S13 = inputpart1;
        WDATA_S14 = inputpart2;
        WDATA_S15 = inputpart1;
        WDATA_S16 = inputpart2;
        WDATA_S17 = inputpart1;
        WDATA_S18 = inputpart2;
        WDATA_S19 = inputpart1;
        WDATA_S20 = inputpart2;
        WDATA_S21 = inputpart1;
        WDATA_S22 = inputpart2;       
    end
    2:
    begin
        WDATA_S02 = inputpart1;
        WDATA_S03 = inputpart2;
        WDATA_S04 = inputpart1;
        WDATA_S05 = inputpart2;
        WDATA_S06 = inputpart1;
        WDATA_S07 = inputpart2;
        WDATA_S08 = inputpart1;
        WDATA_S09 = inputpart2;
        WDATA_S10 = inputpart1;
        WDATA_S11 = inputpart2;
        WDATA_S12 = inputpart1;
        WDATA_S13 = inputpart2;
        WDATA_S14 = inputpart1;
        WDATA_S15 = inputpart2;
        WDATA_S16 = inputpart1;
        WDATA_S17 = inputpart2;
        WDATA_S18 = inputpart1;
        WDATA_S19 = inputpart2;
        WDATA_S20 = inputpart1;
        WDATA_S21 = inputpart2;
        WDATA_S22 = inputpart1;
        WDATA_S01 = inputpart2;       
    end
    3:
    begin
        WDATA_S03 = inputpart1;
        WDATA_S04 = inputpart2;
        WDATA_S05 = inputpart1;
        WDATA_S06 = inputpart2;
        WDATA_S07 = inputpart1;
        WDATA_S08 = inputpart2;
        WDATA_S09 = inputpart1;
        WDATA_S10 = inputpart2;
        WDATA_S11 = inputpart1;
        WDATA_S12 = inputpart2;
        WDATA_S13 = inputpart1;
        WDATA_S14 = inputpart2;
        WDATA_S15 = inputpart1;
        WDATA_S16 = inputpart2;
        WDATA_S17 = inputpart1;
        WDATA_S18 = inputpart2;
        WDATA_S19 = inputpart1;
        WDATA_S20 = inputpart2;
        WDATA_S21 = inputpart1;
        WDATA_S22 = inputpart2;
        WDATA_S01 = inputpart1;
        WDATA_S02 = inputpart2;       
    end
    4:
    begin
        WDATA_S04 = inputpart1;
        WDATA_S05 = inputpart2;
        WDATA_S06 = inputpart1;
        WDATA_S07 = inputpart2;
        WDATA_S08 = inputpart1;
        WDATA_S09 = inputpart2;
        WDATA_S10 = inputpart1;
        WDATA_S11 = inputpart2;
        WDATA_S12 = inputpart1;
        WDATA_S13 = inputpart2;
        WDATA_S14 = inputpart1;
        WDATA_S15 = inputpart2;
        WDATA_S16 = inputpart1;
        WDATA_S17 = inputpart2;
        WDATA_S18 = inputpart1;
        WDATA_S19 = inputpart2;
        WDATA_S20 = inputpart1;
        WDATA_S21 = inputpart2;
        WDATA_S22 = inputpart1;
        WDATA_S01 = inputpart2;
        WDATA_S02 = inputpart1;
        WDATA_S03 = inputpart2;       
    end
    5:
    begin
        WDATA_S05 = inputpart1;
        WDATA_S06 = inputpart2;
        WDATA_S07 = inputpart1;
        WDATA_S08 = inputpart2;
        WDATA_S09 = inputpart1;
        WDATA_S10 = inputpart2;
        WDATA_S11 = inputpart1;
        WDATA_S12 = inputpart2;
        WDATA_S13 = inputpart1;
        WDATA_S14 = inputpart2;
        WDATA_S15 = inputpart1;
        WDATA_S16 = inputpart2;
        WDATA_S17 = inputpart1;
        WDATA_S18 = inputpart2;
        WDATA_S19 = inputpart1;
        WDATA_S20 = inputpart2;
        WDATA_S21 = inputpart1;
        WDATA_S22 = inputpart2;
        WDATA_S01 = inputpart1;
        WDATA_S02 = inputpart2;
        WDATA_S03 = inputpart1;
        WDATA_S04 = inputpart2;       
    end
    6:
    begin
        WDATA_S06 = inputpart1;
        WDATA_S07 = inputpart2;
        WDATA_S08 = inputpart1;
        WDATA_S09 = inputpart2;
        WDATA_S10 = inputpart1;
        WDATA_S11 = inputpart2;
        WDATA_S12 = inputpart1;
        WDATA_S13 = inputpart2;
        WDATA_S14 = inputpart1;
        WDATA_S15 = inputpart2;
        WDATA_S16 = inputpart1;
        WDATA_S17 = inputpart2;
        WDATA_S18 = inputpart1;
        WDATA_S19 = inputpart2;
        WDATA_S20 = inputpart1;
        WDATA_S21 = inputpart2;
        WDATA_S22 = inputpart1;
        WDATA_S01 = inputpart2;
        WDATA_S02 = inputpart1;
        WDATA_S03 = inputpart2;
        WDATA_S04 = inputpart1;
        WDATA_S05 = inputpart2;       
    end
    7:
    begin
        WDATA_S07 = inputpart1;
        WDATA_S08 = inputpart2;
        WDATA_S09 = inputpart1;
        WDATA_S10 = inputpart2;
        WDATA_S11 = inputpart1;
        WDATA_S12 = inputpart2;
        WDATA_S13 = inputpart1;
        WDATA_S14 = inputpart2;
        WDATA_S15 = inputpart1;
        WDATA_S16 = inputpart2;
        WDATA_S17 = inputpart1;
        WDATA_S18 = inputpart2;
        WDATA_S19 = inputpart1;
        WDATA_S20 = inputpart2;
        WDATA_S21 = inputpart1;
        WDATA_S22 = inputpart2;
        WDATA_S01 = inputpart1;
        WDATA_S02 = inputpart2;
        WDATA_S03 = inputpart1;
        WDATA_S04 = inputpart2;
        WDATA_S05 = inputpart1;
        WDATA_S06 = inputpart2;       
    end
    8:
    begin
        WDATA_S08 = inputpart1;
        WDATA_S09 = inputpart2;
        WDATA_S10 = inputpart1;
        WDATA_S11 = inputpart2;
        WDATA_S12 = inputpart1;
        WDATA_S13 = inputpart2;
        WDATA_S14 = inputpart1;
        WDATA_S15 = inputpart2;
        WDATA_S16 = inputpart1;
        WDATA_S17 = inputpart2;
        WDATA_S18 = inputpart1;
        WDATA_S19 = inputpart2;
        WDATA_S20 = inputpart1;
        WDATA_S21 = inputpart2;
        WDATA_S22 = inputpart1;
        WDATA_S01 = inputpart2;
        WDATA_S02 = inputpart1;
        WDATA_S03 = inputpart2;
        WDATA_S04 = inputpart1;
        WDATA_S05 = inputpart2;
        WDATA_S06 = inputpart1;
        WDATA_S07 = inputpart2;       
    end
    9:
    begin
        WDATA_S09 = inputpart1;
        WDATA_S10 = inputpart2;
        WDATA_S11 = inputpart1;
        WDATA_S12 = inputpart2;
        WDATA_S13 = inputpart1;
        WDATA_S14 = inputpart2;
        WDATA_S15 = inputpart1;
        WDATA_S16 = inputpart2;
        WDATA_S17 = inputpart1;
        WDATA_S18 = inputpart2;
        WDATA_S19 = inputpart1;
        WDATA_S20 = inputpart2;
        WDATA_S21 = inputpart1;
        WDATA_S22 = inputpart2;
        WDATA_S01 = inputpart1;
        WDATA_S02 = inputpart2;
        WDATA_S03 = inputpart1;
        WDATA_S04 = inputpart2;
        WDATA_S05 = inputpart1;
        WDATA_S06 = inputpart2;
        WDATA_S07 = inputpart1;
        WDATA_S08 = inputpart2;       
    end
    10:
    begin
        WDATA_S10 = inputpart1;
        WDATA_S11 = inputpart2;
        WDATA_S12 = inputpart1;
        WDATA_S13 = inputpart2;
        WDATA_S14 = inputpart1;
        WDATA_S15 = inputpart2;
        WDATA_S16 = inputpart1;
        WDATA_S17 = inputpart2;
        WDATA_S18 = inputpart1;
        WDATA_S19 = inputpart2;
        WDATA_S20 = inputpart1;
        WDATA_S21 = inputpart2;
        WDATA_S22 = inputpart1;
        WDATA_S01 = inputpart2;
        WDATA_S02 = inputpart1;
        WDATA_S03 = inputpart2;
        WDATA_S04 = inputpart1;
        WDATA_S05 = inputpart2;
        WDATA_S06 = inputpart1;
        WDATA_S07 = inputpart2;
        WDATA_S08 = inputpart1;
        WDATA_S09 = inputpart2;       
    end
    11:
    begin
        WDATA_S11 = inputpart1;
        WDATA_S12 = inputpart2;
        WDATA_S13 = inputpart1;
        WDATA_S14 = inputpart2;
        WDATA_S15 = inputpart1;
        WDATA_S16 = inputpart2;
        WDATA_S17 = inputpart1;
        WDATA_S18 = inputpart2;
        WDATA_S19 = inputpart1;
        WDATA_S20 = inputpart2;
        WDATA_S21 = inputpart1;
        WDATA_S22 = inputpart2;
        WDATA_S01 = inputpart1;
        WDATA_S02 = inputpart2;
        WDATA_S03 = inputpart1;
        WDATA_S04 = inputpart2;
        WDATA_S05 = inputpart1;
        WDATA_S06 = inputpart2;
        WDATA_S07 = inputpart1;
        WDATA_S08 = inputpart2;
        WDATA_S09 = inputpart1;
        WDATA_S10 = inputpart2;       
    end
    12:
    begin
        WDATA_S12 = inputpart1;
        WDATA_S13 = inputpart2;
        WDATA_S14 = inputpart1;
        WDATA_S15 = inputpart2;
        WDATA_S16 = inputpart1;
        WDATA_S17 = inputpart2;
        WDATA_S18 = inputpart1;
        WDATA_S19 = inputpart2;
        WDATA_S20 = inputpart1;
        WDATA_S21 = inputpart2;
        WDATA_S22 = inputpart1;
        WDATA_S01 = inputpart2;
        WDATA_S02 = inputpart1;
        WDATA_S03 = inputpart2;
        WDATA_S04 = inputpart1;
        WDATA_S05 = inputpart2;
        WDATA_S06 = inputpart1;
        WDATA_S07 = inputpart2;
        WDATA_S08 = inputpart1;
        WDATA_S09 = inputpart2;
        WDATA_S10 = inputpart1;
        WDATA_S11 = inputpart2;       
    end
    13:
    begin
        WDATA_S13 = inputpart1;
        WDATA_S14 = inputpart2;
        WDATA_S15 = inputpart1;
        WDATA_S16 = inputpart2;
        WDATA_S17 = inputpart1;
        WDATA_S18 = inputpart2;
        WDATA_S19 = inputpart1;
        WDATA_S20 = inputpart2;
        WDATA_S21 = inputpart1;
        WDATA_S22 = inputpart2;
        WDATA_S01 = inputpart1;
        WDATA_S02 = inputpart2;
        WDATA_S03 = inputpart1;
        WDATA_S04 = inputpart2;
        WDATA_S05 = inputpart1;
        WDATA_S06 = inputpart2;
        WDATA_S07 = inputpart1;
        WDATA_S08 = inputpart2;
        WDATA_S09 = inputpart1;
        WDATA_S10 = inputpart2;
        WDATA_S11 = inputpart1;
        WDATA_S12 = inputpart2;       
    end
    14:
    begin
        WDATA_S14 = inputpart1;
        WDATA_S15 = inputpart2;
        WDATA_S16 = inputpart1;
        WDATA_S17 = inputpart2;
        WDATA_S18 = inputpart1;
        WDATA_S19 = inputpart2;
        WDATA_S20 = inputpart1;
        WDATA_S21 = inputpart2;
        WDATA_S22 = inputpart1;
        WDATA_S01 = inputpart2;
        WDATA_S02 = inputpart1;
        WDATA_S03 = inputpart2;
        WDATA_S04 = inputpart1;
        WDATA_S05 = inputpart2;
        WDATA_S06 = inputpart1;
        WDATA_S07 = inputpart2;
        WDATA_S08 = inputpart1;
        WDATA_S09 = inputpart2;
        WDATA_S10 = inputpart1;
        WDATA_S11 = inputpart2;
        WDATA_S12 = inputpart1;
        WDATA_S13 = inputpart2;       
    end
    15:
    begin
        WDATA_S15 = inputpart1;
        WDATA_S16 = inputpart2;
        WDATA_S17 = inputpart1;
        WDATA_S18 = inputpart2;
        WDATA_S19 = inputpart1;
        WDATA_S20 = inputpart2;
        WDATA_S21 = inputpart1;
        WDATA_S22 = inputpart2;
        WDATA_S01 = inputpart1;
        WDATA_S02 = inputpart2;
        WDATA_S03 = inputpart1;
        WDATA_S04 = inputpart2;
        WDATA_S05 = inputpart1;
        WDATA_S06 = inputpart2;
        WDATA_S07 = inputpart1;
        WDATA_S08 = inputpart2;
        WDATA_S09 = inputpart1;
        WDATA_S10 = inputpart2;
        WDATA_S11 = inputpart1;
        WDATA_S12 = inputpart2;
        WDATA_S13 = inputpart1;
        WDATA_S14 = inputpart2;       
    end
    16:
    begin
        WDATA_S16 = inputpart1;
        WDATA_S17 = inputpart2;
        WDATA_S18 = inputpart1;
        WDATA_S19 = inputpart2;
        WDATA_S20 = inputpart1;
        WDATA_S21 = inputpart2;
        WDATA_S22 = inputpart1;
        WDATA_S01 = inputpart2;
        WDATA_S02 = inputpart1;
        WDATA_S03 = inputpart2;
        WDATA_S04 = inputpart1;
        WDATA_S05 = inputpart2;
        WDATA_S06 = inputpart1;
        WDATA_S07 = inputpart2;
        WDATA_S08 = inputpart1;
        WDATA_S09 = inputpart2;
        WDATA_S10 = inputpart1;
        WDATA_S11 = inputpart2;
        WDATA_S12 = inputpart1;
        WDATA_S13 = inputpart2;
        WDATA_S14 = inputpart1;
        WDATA_S15 = inputpart2;       
    end
    17:
    begin
        WDATA_S17 = inputpart1;
        WDATA_S18 = inputpart2;
        WDATA_S19 = inputpart1;
        WDATA_S20 = inputpart2;
        WDATA_S21 = inputpart1;
        WDATA_S22 = inputpart2;
        WDATA_S01 = inputpart1;
        WDATA_S02 = inputpart2;
        WDATA_S03 = inputpart1;
        WDATA_S04 = inputpart2;
        WDATA_S05 = inputpart1;
        WDATA_S06 = inputpart2;
        WDATA_S07 = inputpart1;
        WDATA_S08 = inputpart2;
        WDATA_S09 = inputpart1;
        WDATA_S10 = inputpart2;
        WDATA_S11 = inputpart1;
        WDATA_S12 = inputpart2;
        WDATA_S13 = inputpart1;
        WDATA_S14 = inputpart2;
        WDATA_S15 = inputpart1;
        WDATA_S16 = inputpart2;       
    end
    18:
    begin
        WDATA_S18 = inputpart1;
        WDATA_S19 = inputpart2;
        WDATA_S20 = inputpart1;
        WDATA_S21 = inputpart2;
        WDATA_S22 = inputpart1;
        WDATA_S01 = inputpart2;
        WDATA_S02 = inputpart1;
        WDATA_S03 = inputpart2;
        WDATA_S04 = inputpart1;
        WDATA_S05 = inputpart2;
        WDATA_S06 = inputpart1;
        WDATA_S07 = inputpart2;
        WDATA_S08 = inputpart1;
        WDATA_S09 = inputpart2;
        WDATA_S10 = inputpart1;
        WDATA_S11 = inputpart2;
        WDATA_S12 = inputpart1;
        WDATA_S13 = inputpart2;
        WDATA_S14 = inputpart1;
        WDATA_S15 = inputpart2;
        WDATA_S16 = inputpart1;
        WDATA_S17 = inputpart2;       
    end
    19:
    begin
        WDATA_S19 = inputpart1;
        WDATA_S20 = inputpart2;
        WDATA_S21 = inputpart1;
        WDATA_S22 = inputpart2;
        WDATA_S01 = inputpart1;
        WDATA_S02 = inputpart2;
        WDATA_S03 = inputpart1;
        WDATA_S04 = inputpart2;
        WDATA_S05 = inputpart1;
        WDATA_S06 = inputpart2;
        WDATA_S07 = inputpart1;
        WDATA_S08 = inputpart2;
        WDATA_S09 = inputpart1;
        WDATA_S10 = inputpart2;
        WDATA_S11 = inputpart1;
        WDATA_S12 = inputpart2;
        WDATA_S13 = inputpart1;
        WDATA_S14 = inputpart2;
        WDATA_S15 = inputpart1;
        WDATA_S16 = inputpart2;
        WDATA_S17 = inputpart1;
        WDATA_S18 = inputpart2;       
    end
    20:
    begin
        WDATA_S20 = inputpart1;
        WDATA_S21 = inputpart2;
        WDATA_S22 = inputpart1;
        WDATA_S01 = inputpart2;
        WDATA_S02 = inputpart1;
        WDATA_S03 = inputpart2;
        WDATA_S04 = inputpart1;
        WDATA_S05 = inputpart2;
        WDATA_S06 = inputpart1;
        WDATA_S07 = inputpart2;
        WDATA_S08 = inputpart1;
        WDATA_S09 = inputpart2;
        WDATA_S10 = inputpart1;
        WDATA_S11 = inputpart2;
        WDATA_S12 = inputpart1;
        WDATA_S13 = inputpart2;
        WDATA_S14 = inputpart1;
        WDATA_S15 = inputpart2;
        WDATA_S16 = inputpart1;
        WDATA_S17 = inputpart2;
        WDATA_S18 = inputpart1;
        WDATA_S19 = inputpart2;       
    end
    21:
    begin
        WDATA_S21 = inputpart1;
        WDATA_S22 = inputpart2;
        WDATA_S01 = inputpart1;
        WDATA_S02 = inputpart2;
        WDATA_S03 = inputpart1;
        WDATA_S04 = inputpart2;
        WDATA_S05 = inputpart1;
        WDATA_S06 = inputpart2;
        WDATA_S07 = inputpart1;
        WDATA_S08 = inputpart2;
        WDATA_S09 = inputpart1;
        WDATA_S10 = inputpart2;
        WDATA_S11 = inputpart1;
        WDATA_S12 = inputpart2;
        WDATA_S13 = inputpart1;
        WDATA_S14 = inputpart2;
        WDATA_S15 = inputpart1;
        WDATA_S16 = inputpart2;
        WDATA_S17 = inputpart1;
        WDATA_S18 = inputpart2;
        WDATA_S19 = inputpart1;
        WDATA_S20 = inputpart2;       
    end
    22:
    begin
        WDATA_S22 = inputpart1;
        WDATA_S01 = inputpart2;
        WDATA_S02 = inputpart1;
        WDATA_S03 = inputpart2;
        WDATA_S04 = inputpart1;
        WDATA_S05 = inputpart2;
        WDATA_S06 = inputpart1;
        WDATA_S07 = inputpart2;
        WDATA_S08 = inputpart1;
        WDATA_S09 = inputpart2;
        WDATA_S10 = inputpart1;
        WDATA_S11 = inputpart2;
        WDATA_S12 = inputpart1;
        WDATA_S13 = inputpart2;
        WDATA_S14 = inputpart1;
        WDATA_S15 = inputpart2;
        WDATA_S16 = inputpart1;
        WDATA_S17 = inputpart2;
        WDATA_S18 = inputpart1;
        WDATA_S19 = inputpart2;
        WDATA_S20 = inputpart1;
        WDATA_S21 = inputpart2;       
    end
    default:
    begin
        WDATA_S02 = 0;
        WDATA_S03 = 0;
        WDATA_S04 = 0;
        WDATA_S05 = 0;
        WDATA_S06 = 0;
        WDATA_S07 = 0;
        WDATA_S08 = 0;
        WDATA_S09 = 0;
        WDATA_S10 = 0;
        WDATA_S11 = 0;
        WDATA_S12 = 0;
        WDATA_S13 = 0;
        WDATA_S14 = 0;
        WDATA_S15 = 0;
        WDATA_S16 = 0;
        WDATA_S17 = 0;
        WDATA_S18 = 0;
        WDATA_S19 = 0;
        WDATA_S20 = 0;
        WDATA_S21 = 0;
        WDATA_S22 = 0;
        WDATA_S01 = 0;       
    end
   endcase
 end   
always @*
begin
case (order)
    1:
    begin
        WE_S01 = WEorder1;
        WE_S02 = WEorder1;
        WE_S03 = WEorder2;
        WE_S04 = WEorder2;
        WE_S05 = WEorder3;
        WE_S06 = WEorder3;
        WE_S07 = WEorder4;
        WE_S08 = WEorder4;
        WE_S09 = WEorder5;
        WE_S10 = WEorder5;
        WE_S11 = WEorder6;
        WE_S12 = WEorder6;
        WE_S13 = WEorder7;
        WE_S14 = WEorder7;
        WE_S15 = WEorder8;
        WE_S16 = WEorder8;
        WE_S17 = WEorder9;
        WE_S18 = WEorder9;
        WE_S19 = WEorder10;
        WE_S20 = WEorder10;
        WE_S21 = WEorder11;
        WE_S22 = WEorder11;       
    end
    2:
    begin
        WE_S02 = WEorder1;
        WE_S03 = WEorder1;
        WE_S04 = WEorder2;
        WE_S05 = WEorder2;
        WE_S06 = WEorder3;
        WE_S07 = WEorder3;
        WE_S08 = WEorder4;
        WE_S09 = WEorder4;
        WE_S10 = WEorder5;
        WE_S11 = WEorder5;
        WE_S12 = WEorder6;
        WE_S13 = WEorder6;
        WE_S14 = WEorder7;
        WE_S15 = WEorder7;
        WE_S16 = WEorder8;
        WE_S17 = WEorder8;
        WE_S18 = WEorder9;
        WE_S19 = WEorder9;
        WE_S20 = WEorder10;
        WE_S21 = WEorder10;
        WE_S22 = WEorder11;
        WE_S01 = WEorder11;       
    end
    3:
    begin
        WE_S03 = WEorder1;
        WE_S04 = WEorder1;
        WE_S05 = WEorder2;
        WE_S06 = WEorder2;
        WE_S07 = WEorder3;
        WE_S08 = WEorder3;
        WE_S09 = WEorder4;
        WE_S10 = WEorder4;
        WE_S11 = WEorder5;
        WE_S12 = WEorder5;
        WE_S13 = WEorder6;
        WE_S14 = WEorder6;
        WE_S15 = WEorder7;
        WE_S16 = WEorder7;
        WE_S17 = WEorder8;
        WE_S18 = WEorder8;
        WE_S19 = WEorder9;
        WE_S20 = WEorder9;
        WE_S21 = WEorder10;
        WE_S22 = WEorder10;
        WE_S01 = WEorder11;
        WE_S02 = WEorder11;       
    end
    4:
    begin
        WE_S04 = WEorder1;
        WE_S05 = WEorder1;
        WE_S06 = WEorder2;
        WE_S07 = WEorder2;
        WE_S08 = WEorder3;
        WE_S09 = WEorder3;
        WE_S10 = WEorder4;
        WE_S11 = WEorder4;
        WE_S12 = WEorder5;
        WE_S13 = WEorder5;
        WE_S14 = WEorder6;
        WE_S15 = WEorder6;
        WE_S16 = WEorder7;
        WE_S17 = WEorder7;
        WE_S18 = WEorder8;
        WE_S19 = WEorder8;
        WE_S20 = WEorder9;
        WE_S21 = WEorder9;
        WE_S22 = WEorder10;
        WE_S01 = WEorder10;
        WE_S02 = WEorder11;
        WE_S03 = WEorder11;       
    end
    5:
    begin
        WE_S05 = WEorder1;
        WE_S06 = WEorder1;
        WE_S07 = WEorder2;
        WE_S08 = WEorder2;
        WE_S09 = WEorder3;
        WE_S10 = WEorder3;
        WE_S11 = WEorder4;
        WE_S12 = WEorder4;
        WE_S13 = WEorder5;
        WE_S14 = WEorder5;
        WE_S15 = WEorder6;
        WE_S16 = WEorder6;
        WE_S17 = WEorder7;
        WE_S18 = WEorder7;
        WE_S19 = WEorder8;
        WE_S20 = WEorder8;
        WE_S21 = WEorder9;
        WE_S22 = WEorder9;
        WE_S01 = WEorder10;
        WE_S02 = WEorder10;
        WE_S03 = WEorder11;
        WE_S04 = WEorder11;       
    end
    6:
    begin
        WE_S06 = WEorder1;
        WE_S07 = WEorder1;
        WE_S08 = WEorder2;
        WE_S09 = WEorder2;
        WE_S10 = WEorder3;
        WE_S11 = WEorder3;
        WE_S12 = WEorder4;
        WE_S13 = WEorder4;
        WE_S14 = WEorder5;
        WE_S15 = WEorder5;
        WE_S16 = WEorder6;
        WE_S17 = WEorder6;
        WE_S18 = WEorder7;
        WE_S19 = WEorder7;
        WE_S20 = WEorder8;
        WE_S21 = WEorder8;
        WE_S22 = WEorder9;
        WE_S01 = WEorder9;
        WE_S02 = WEorder10;
        WE_S03 = WEorder10;
        WE_S04 = WEorder11;
        WE_S05 = WEorder11;       
    end
    7:
    begin
        WE_S07 = WEorder1;
        WE_S08 = WEorder1;
        WE_S09 = WEorder2;
        WE_S10 = WEorder2;
        WE_S11 = WEorder3;
        WE_S12 = WEorder3;
        WE_S13 = WEorder4;
        WE_S14 = WEorder4;
        WE_S15 = WEorder5;
        WE_S16 = WEorder5;
        WE_S17 = WEorder6;
        WE_S18 = WEorder6;
        WE_S19 = WEorder7;
        WE_S20 = WEorder7;
        WE_S21 = WEorder8;
        WE_S22 = WEorder8;
        WE_S01 = WEorder9;
        WE_S02 = WEorder9;
        WE_S03 = WEorder10;
        WE_S04 = WEorder10;
        WE_S05 = WEorder11;
        WE_S06 = WEorder11;       
    end
    8:
    begin
        WE_S08 = WEorder1;
        WE_S09 = WEorder1;
        WE_S10 = WEorder2;
        WE_S11 = WEorder2;
        WE_S12 = WEorder3;
        WE_S13 = WEorder3;
        WE_S14 = WEorder4;
        WE_S15 = WEorder4;
        WE_S16 = WEorder5;
        WE_S17 = WEorder5;
        WE_S18 = WEorder6;
        WE_S19 = WEorder6;
        WE_S20 = WEorder7;
        WE_S21 = WEorder7;
        WE_S22 = WEorder8;
        WE_S01 = WEorder8;
        WE_S02 = WEorder9;
        WE_S03 = WEorder9;
        WE_S04 = WEorder10;
        WE_S05 = WEorder10;
        WE_S06 = WEorder11;
        WE_S07 = WEorder11;       
    end
    9:
    begin
        WE_S09 = WEorder1;
        WE_S10 = WEorder1;
        WE_S11 = WEorder2;
        WE_S12 = WEorder2;
        WE_S13 = WEorder3;
        WE_S14 = WEorder3;
        WE_S15 = WEorder4;
        WE_S16 = WEorder4;
        WE_S17 = WEorder5;
        WE_S18 = WEorder5;
        WE_S19 = WEorder6;
        WE_S20 = WEorder6;
        WE_S21 = WEorder7;
        WE_S22 = WEorder7;
        WE_S01 = WEorder8;
        WE_S02 = WEorder8;
        WE_S03 = WEorder9;
        WE_S04 = WEorder9;
        WE_S05 = WEorder10;
        WE_S06 = WEorder10;
        WE_S07 = WEorder11;
        WE_S08 = WEorder11;       
    end
    10:
    begin
        WE_S10 = WEorder1;
        WE_S11 = WEorder1;
        WE_S12 = WEorder2;
        WE_S13 = WEorder2;
        WE_S14 = WEorder3;
        WE_S15 = WEorder3;
        WE_S16 = WEorder4;
        WE_S17 = WEorder4;
        WE_S18 = WEorder5;
        WE_S19 = WEorder5;
        WE_S20 = WEorder6;
        WE_S21 = WEorder6;
        WE_S22 = WEorder7;
        WE_S01 = WEorder7;
        WE_S02 = WEorder8;
        WE_S03 = WEorder8;
        WE_S04 = WEorder9;
        WE_S05 = WEorder9;
        WE_S06 = WEorder10;
        WE_S07 = WEorder10;
        WE_S08 = WEorder11;
        WE_S09 = WEorder11;       
    end
    11:
    begin
        WE_S11 = WEorder1;
        WE_S12 = WEorder1;
        WE_S13 = WEorder2;
        WE_S14 = WEorder2;
        WE_S15 = WEorder3;
        WE_S16 = WEorder3;
        WE_S17 = WEorder4;
        WE_S18 = WEorder4;
        WE_S19 = WEorder5;
        WE_S20 = WEorder5;
        WE_S21 = WEorder6;
        WE_S22 = WEorder6;
        WE_S01 = WEorder7;
        WE_S02 = WEorder7;
        WE_S03 = WEorder8;
        WE_S04 = WEorder8;
        WE_S05 = WEorder9;
        WE_S06 = WEorder9;
        WE_S07 = WEorder10;
        WE_S08 = WEorder10;
        WE_S09 = WEorder11;
        WE_S10 = WEorder11;       
    end
    12:
    begin
        WE_S12 = WEorder1;
        WE_S13 = WEorder1;
        WE_S14 = WEorder2;
        WE_S15 = WEorder2;
        WE_S16 = WEorder3;
        WE_S17 = WEorder3;
        WE_S18 = WEorder4;
        WE_S19 = WEorder4;
        WE_S20 = WEorder5;
        WE_S21 = WEorder5;
        WE_S22 = WEorder6;
        WE_S01 = WEorder6;
        WE_S02 = WEorder7;
        WE_S03 = WEorder7;
        WE_S04 = WEorder8;
        WE_S05 = WEorder8;
        WE_S06 = WEorder9;
        WE_S07 = WEorder9;
        WE_S08 = WEorder10;
        WE_S09 = WEorder10;
        WE_S10 = WEorder11;
        WE_S11 = WEorder11;       
    end
    13:
    begin
        WE_S13 = WEorder1;
        WE_S14 = WEorder1;
        WE_S15 = WEorder2;
        WE_S16 = WEorder2;
        WE_S17 = WEorder3;
        WE_S18 = WEorder3;
        WE_S19 = WEorder4;
        WE_S20 = WEorder4;
        WE_S21 = WEorder5;
        WE_S22 = WEorder5;
        WE_S01 = WEorder6;
        WE_S02 = WEorder6;
        WE_S03 = WEorder7;
        WE_S04 = WEorder7;
        WE_S05 = WEorder8;
        WE_S06 = WEorder8;
        WE_S07 = WEorder9;
        WE_S08 = WEorder9;
        WE_S09 = WEorder10;
        WE_S10 = WEorder10;
        WE_S11 = WEorder11;
        WE_S12 = WEorder11;       
    end
    14:
    begin
        WE_S14 = WEorder1;
        WE_S15 = WEorder1;
        WE_S16 = WEorder2;
        WE_S17 = WEorder2;
        WE_S18 = WEorder3;
        WE_S19 = WEorder3;
        WE_S20 = WEorder4;
        WE_S21 = WEorder4;
        WE_S22 = WEorder5;
        WE_S01 = WEorder5;
        WE_S02 = WEorder6;
        WE_S03 = WEorder6;
        WE_S04 = WEorder7;
        WE_S05 = WEorder7;
        WE_S06 = WEorder8;
        WE_S07 = WEorder8;
        WE_S08 = WEorder9;
        WE_S09 = WEorder9;
        WE_S10 = WEorder10;
        WE_S11 = WEorder10;
        WE_S12 = WEorder11;
        WE_S13 = WEorder11;       
    end
    15:
    begin
        WE_S15 = WEorder1;
        WE_S16 = WEorder1;
        WE_S17 = WEorder2;
        WE_S18 = WEorder2;
        WE_S19 = WEorder3;
        WE_S20 = WEorder3;
        WE_S21 = WEorder4;
        WE_S22 = WEorder4;
        WE_S01 = WEorder5;
        WE_S02 = WEorder5;
        WE_S03 = WEorder6;
        WE_S04 = WEorder6;
        WE_S05 = WEorder7;
        WE_S06 = WEorder7;
        WE_S07 = WEorder8;
        WE_S08 = WEorder8;
        WE_S09 = WEorder9;
        WE_S10 = WEorder9;
        WE_S11 = WEorder10;
        WE_S12 = WEorder10;
        WE_S13 = WEorder11;
        WE_S14 = WEorder11;       
    end
    16:
    begin
        WE_S16 = WEorder1;
        WE_S17 = WEorder1;
        WE_S18 = WEorder2;
        WE_S19 = WEorder2;
        WE_S20 = WEorder3;
        WE_S21 = WEorder3;
        WE_S22 = WEorder4;
        WE_S01 = WEorder4;
        WE_S02 = WEorder5;
        WE_S03 = WEorder5;
        WE_S04 = WEorder6;
        WE_S05 = WEorder6;
        WE_S06 = WEorder7;
        WE_S07 = WEorder7;
        WE_S08 = WEorder8;
        WE_S09 = WEorder8;
        WE_S10 = WEorder9;
        WE_S11 = WEorder9;
        WE_S12 = WEorder10;
        WE_S13 = WEorder10;
        WE_S14 = WEorder11;
        WE_S15 = WEorder11;       
    end
    17:
    begin
        WE_S17 = WEorder1;
        WE_S18 = WEorder1;
        WE_S19 = WEorder2;
        WE_S20 = WEorder2;
        WE_S21 = WEorder3;
        WE_S22 = WEorder3;
        WE_S01 = WEorder4;
        WE_S02 = WEorder4;
        WE_S03 = WEorder5;
        WE_S04 = WEorder5;
        WE_S05 = WEorder6;
        WE_S06 = WEorder6;
        WE_S07 = WEorder7;
        WE_S08 = WEorder7;
        WE_S09 = WEorder8;
        WE_S10 = WEorder8;
        WE_S11 = WEorder9;
        WE_S12 = WEorder9;
        WE_S13 = WEorder10;
        WE_S14 = WEorder10;
        WE_S15 = WEorder11;
        WE_S16 = WEorder11;       
    end
    18:
    begin
        WE_S18 = WEorder1;
        WE_S19 = WEorder1;
        WE_S20 = WEorder2;
        WE_S21 = WEorder2;
        WE_S22 = WEorder3;
        WE_S01 = WEorder3;
        WE_S02 = WEorder4;
        WE_S03 = WEorder4;
        WE_S04 = WEorder5;
        WE_S05 = WEorder5;
        WE_S06 = WEorder6;
        WE_S07 = WEorder6;
        WE_S08 = WEorder7;
        WE_S09 = WEorder7;
        WE_S10 = WEorder8;
        WE_S11 = WEorder8;
        WE_S12 = WEorder9;
        WE_S13 = WEorder9;
        WE_S14 = WEorder10;
        WE_S15 = WEorder10;
        WE_S16 = WEorder11;
        WE_S17 = WEorder11;       
    end
    19:
    begin
        WE_S19 = WEorder1;
        WE_S20 = WEorder1;
        WE_S21 = WEorder2;
        WE_S22 = WEorder2;
        WE_S01 = WEorder3;
        WE_S02 = WEorder3;
        WE_S03 = WEorder4;
        WE_S04 = WEorder4;
        WE_S05 = WEorder5;
        WE_S06 = WEorder5;
        WE_S07 = WEorder6;
        WE_S08 = WEorder6;
        WE_S09 = WEorder7;
        WE_S10 = WEorder7;
        WE_S11 = WEorder8;
        WE_S12 = WEorder8;
        WE_S13 = WEorder9;
        WE_S14 = WEorder9;
        WE_S15 = WEorder10;
        WE_S16 = WEorder10;
        WE_S17 = WEorder11;
        WE_S18 = WEorder11;       
    end
    20:
    begin
        WE_S20 = WEorder1;
        WE_S21 = WEorder1;
        WE_S22 = WEorder2;
        WE_S01 = WEorder2;
        WE_S02 = WEorder3;
        WE_S03 = WEorder3;
        WE_S04 = WEorder4;
        WE_S05 = WEorder4;
        WE_S06 = WEorder5;
        WE_S07 = WEorder5;
        WE_S08 = WEorder6;
        WE_S09 = WEorder6;
        WE_S10 = WEorder7;
        WE_S11 = WEorder7;
        WE_S12 = WEorder8;
        WE_S13 = WEorder8;
        WE_S14 = WEorder9;
        WE_S15 = WEorder9;
        WE_S16 = WEorder10;
        WE_S17 = WEorder10;
        WE_S18 = WEorder11;
        WE_S19 = WEorder11;       
    end
    21:
    begin
        WE_S21 = WEorder1;
        WE_S22 = WEorder1;
        WE_S01 = WEorder2;
        WE_S02 = WEorder2;
        WE_S03 = WEorder3;
        WE_S04 = WEorder3;
        WE_S05 = WEorder4;
        WE_S06 = WEorder4;
        WE_S07 = WEorder5;
        WE_S08 = WEorder5;
        WE_S09 = WEorder6;
        WE_S10 = WEorder6;
        WE_S11 = WEorder7;
        WE_S12 = WEorder7;
        WE_S13 = WEorder8;
        WE_S14 = WEorder8;
        WE_S15 = WEorder9;
        WE_S16 = WEorder9;
        WE_S17 = WEorder10;
        WE_S18 = WEorder10;
        WE_S19 = WEorder11;
        WE_S20 = WEorder11;       
    end
    22:
    begin
        WE_S22 = WEorder1;
        WE_S01 = WEorder1;
        WE_S02 = WEorder2;
        WE_S03 = WEorder2;
        WE_S04 = WEorder3;
        WE_S05 = WEorder3;
        WE_S06 = WEorder4;
        WE_S07 = WEorder4;
        WE_S08 = WEorder5;
        WE_S09 = WEorder5;
        WE_S10 = WEorder6;
        WE_S11 = WEorder6;
        WE_S12 = WEorder7;
        WE_S13 = WEorder7;
        WE_S14 = WEorder8;
        WE_S15 = WEorder8;
        WE_S16 = WEorder9;
        WE_S17 = WEorder9;
        WE_S18 = WEorder10;
        WE_S19 = WEorder10;
        WE_S20 = WEorder11;
        WE_S21 = WEorder11;       
    end
    default:
    begin
        WE_S02 = 0;
        WE_S03 = 0;
        WE_S04 = 0;
        WE_S05 = 0;
        WE_S06 = 0;
        WE_S07 = 0;
        WE_S08 = 0;
        WE_S09 = 0;
        WE_S10 = 0;
        WE_S11 = 0;
        WE_S12 = 0;
        WE_S13 = 0;
        WE_S14 = 0;
        WE_S15 = 0;
        WE_S16 = 0;
        WE_S17 = 0;
        WE_S18 = 0;
        WE_S19 = 0;
        WE_S20 = 0;
        WE_S21 = 0;
        WE_S22 = 0;
        WE_S01 = 0;       
    end
   endcase
end   

/*always @*
begin
case (order)
    1:
    begin
        WDATA_S01 = pack1;
        WDATA_S02 = pack2;
        WDATA_S03 = pack3;
        WDATA_S04 = pack4;
        WDATA_S05 = pack5;
        WDATA_S06 = pack6;
        WDATA_S07 = pack7;
        WDATA_S08 = pack8;
        WDATA_S09 = pack9;
        WDATA_S10 = pack10;
        WDATA_S11 = pack11;
        WDATA_S12 = pack12;
        WDATA_S13 = pack13;
        WDATA_S14 = pack14;
        WDATA_S15 = pack15;
        WDATA_S16 = pack16;
        WDATA_S17 = pack17;
        WDATA_S18 = pack18;
        WDATA_S19 = pack19;
        WDATA_S20 = pack20;
        WDATA_S21 = pack21;
        WDATA_S22 = pack22;       
    end
    2:
    begin
        WDATA_S02 = pack1;
        WDATA_S03 = pack2;
        WDATA_S04 = pack3;
        WDATA_S05 = pack4;
        WDATA_S06 = pack5;
        WDATA_S07 = pack6;
        WDATA_S08 = pack7;
        WDATA_S09 = pack8;
        WDATA_S10 = pack9;
        WDATA_S11 = pack10;
        WDATA_S12 = pack11;
        WDATA_S13 = pack12;
        WDATA_S14 = pack13;
        WDATA_S15 = pack14;
        WDATA_S16 = pack15;
        WDATA_S17 = pack16;
        WDATA_S18 = pack17;
        WDATA_S19 = pack18;
        WDATA_S20 = pack19;
        WDATA_S21 = pack20;
        WDATA_S22 = pack21;
        WDATA_S01 = pack22;       
    end
    3:
    begin
        WDATA_S03 = pack1;
        WDATA_S04 = pack2;
        WDATA_S05 = pack3;
        WDATA_S06 = pack4;
        WDATA_S07 = pack5;
        WDATA_S08 = pack6;
        WDATA_S09 = pack7;
        WDATA_S10 = pack8;
        WDATA_S11 = pack9;
        WDATA_S12 = pack10;
        WDATA_S13 = pack11;
        WDATA_S14 = pack12;
        WDATA_S15 = pack13;
        WDATA_S16 = pack14;
        WDATA_S17 = pack15;
        WDATA_S18 = pack16;
        WDATA_S19 = pack17;
        WDATA_S20 = pack18;
        WDATA_S21 = pack19;
        WDATA_S22 = pack20;
        WDATA_S01 = pack21;
        WDATA_S02 = pack22;       
    end
    4:
    begin
        WDATA_S04 = pack1;
        WDATA_S05 = pack2;
        WDATA_S06 = pack3;
        WDATA_S07 = pack4;
        WDATA_S08 = pack5;
        WDATA_S09 = pack6;
        WDATA_S10 = pack7;
        WDATA_S11 = pack8;
        WDATA_S12 = pack9;
        WDATA_S13 = pack10;
        WDATA_S14 = pack11;
        WDATA_S15 = pack12;
        WDATA_S16 = pack13;
        WDATA_S17 = pack14;
        WDATA_S18 = pack15;
        WDATA_S19 = pack16;
        WDATA_S20 = pack17;
        WDATA_S21 = pack18;
        WDATA_S22 = pack19;
        WDATA_S01 = pack20;
        WDATA_S02 = pack21;
        WDATA_S03 = pack22;       
    end
    5:
    begin
        WDATA_S05 = pack1;
        WDATA_S06 = pack2;
        WDATA_S07 = pack3;
        WDATA_S08 = pack4;
        WDATA_S09 = pack5;
        WDATA_S10 = pack6;
        WDATA_S11 = pack7;
        WDATA_S12 = pack8;
        WDATA_S13 = pack9;
        WDATA_S14 = pack10;
        WDATA_S15 = pack11;
        WDATA_S16 = pack12;
        WDATA_S17 = pack13;
        WDATA_S18 = pack14;
        WDATA_S19 = pack15;
        WDATA_S20 = pack16;
        WDATA_S21 = pack17;
        WDATA_S22 = pack18;
        WDATA_S01 = pack19;
        WDATA_S02 = pack20;
        WDATA_S03 = pack21;
        WDATA_S04 = pack22;       
    end
    6:
    begin
        WDATA_S06 = pack1;
        WDATA_S07 = pack2;
        WDATA_S08 = pack3;
        WDATA_S09 = pack4;
        WDATA_S10 = pack5;
        WDATA_S11 = pack6;
        WDATA_S12 = pack7;
        WDATA_S13 = pack8;
        WDATA_S14 = pack9;
        WDATA_S15 = pack10;
        WDATA_S16 = pack11;
        WDATA_S17 = pack12;
        WDATA_S18 = pack13;
        WDATA_S19 = pack14;
        WDATA_S20 = pack15;
        WDATA_S21 = pack16;
        WDATA_S22 = pack17;
        WDATA_S01 = pack18;
        WDATA_S02 = pack19;
        WDATA_S03 = pack20;
        WDATA_S04 = pack21;
        WDATA_S05 = pack22;       
    end
    7:
    begin
        WDATA_S07 = pack1;
        WDATA_S08 = pack2;
        WDATA_S09 = pack3;
        WDATA_S10 = pack4;
        WDATA_S11 = pack5;
        WDATA_S12 = pack6;
        WDATA_S13 = pack7;
        WDATA_S14 = pack8;
        WDATA_S15 = pack9;
        WDATA_S16 = pack10;
        WDATA_S17 = pack11;
        WDATA_S18 = pack12;
        WDATA_S19 = pack13;
        WDATA_S20 = pack14;
        WDATA_S21 = pack15;
        WDATA_S22 = pack16;
        WDATA_S01 = pack17;
        WDATA_S02 = pack18;
        WDATA_S03 = pack19;
        WDATA_S04 = pack20;
        WDATA_S05 = pack21;
        WDATA_S06 = pack22;       
    end
    8:
    begin
        WDATA_S08 = pack1;
        WDATA_S09 = pack2;
        WDATA_S10 = pack3;
        WDATA_S11 = pack4;
        WDATA_S12 = pack5;
        WDATA_S13 = pack6;
        WDATA_S14 = pack7;
        WDATA_S15 = pack8;
        WDATA_S16 = pack9;
        WDATA_S17 = pack10;
        WDATA_S18 = pack11;
        WDATA_S19 = pack12;
        WDATA_S20 = pack13;
        WDATA_S21 = pack14;
        WDATA_S22 = pack15;
        WDATA_S01 = pack16;
        WDATA_S02 = pack17;
        WDATA_S03 = pack18;
        WDATA_S04 = pack19;
        WDATA_S05 = pack20;
        WDATA_S06 = pack21;
        WDATA_S07 = pack22;       
    end
    9:
    begin
        WDATA_S09 = pack1;
        WDATA_S10 = pack2;
        WDATA_S11 = pack3;
        WDATA_S12 = pack4;
        WDATA_S13 = pack5;
        WDATA_S14 = pack6;
        WDATA_S15 = pack7;
        WDATA_S16 = pack8;
        WDATA_S17 = pack9;
        WDATA_S18 = pack10;
        WDATA_S19 = pack11;
        WDATA_S20 = pack12;
        WDATA_S21 = pack13;
        WDATA_S22 = pack14;
        WDATA_S01 = pack15;
        WDATA_S02 = pack16;
        WDATA_S03 = pack17;
        WDATA_S04 = pack18;
        WDATA_S05 = pack19;
        WDATA_S06 = pack20;
        WDATA_S07 = pack21;
        WDATA_S08 = pack22;       
    end
    10:
    begin
        WDATA_S10 = pack1;
        WDATA_S11 = pack2;
        WDATA_S12 = pack3;
        WDATA_S13 = pack4;
        WDATA_S14 = pack5;
        WDATA_S15 = pack6;
        WDATA_S16 = pack7;
        WDATA_S17 = pack8;
        WDATA_S18 = pack9;
        WDATA_S19 = pack10;
        WDATA_S20 = pack11;
        WDATA_S21 = pack12;
        WDATA_S22 = pack13;
        WDATA_S01 = pack14;
        WDATA_S02 = pack15;
        WDATA_S03 = pack16;
        WDATA_S04 = pack17;
        WDATA_S05 = pack18;
        WDATA_S06 = pack19;
        WDATA_S07 = pack20;
        WDATA_S08 = pack21;
        WDATA_S09 = pack22;       
    end
    11:
    begin
        WDATA_S11 = pack1;
        WDATA_S12 = pack2;
        WDATA_S13 = pack3;
        WDATA_S14 = pack4;
        WDATA_S15 = pack5;
        WDATA_S16 = pack6;
        WDATA_S17 = pack7;
        WDATA_S18 = pack8;
        WDATA_S19 = pack9;
        WDATA_S20 = pack10;
        WDATA_S21 = pack11;
        WDATA_S22 = pack12;
        WDATA_S01 = pack13;
        WDATA_S02 = pack14;
        WDATA_S03 = pack15;
        WDATA_S04 = pack16;
        WDATA_S05 = pack17;
        WDATA_S06 = pack18;
        WDATA_S07 = pack19;
        WDATA_S08 = pack20;
        WDATA_S09 = pack21;
        WDATA_S10 = pack22;       
    end
    12:
    begin
        WDATA_S12 = pack1;
        WDATA_S13 = pack2;
        WDATA_S14 = pack3;
        WDATA_S15 = pack4;
        WDATA_S16 = pack5;
        WDATA_S17 = pack6;
        WDATA_S18 = pack7;
        WDATA_S19 = pack8;
        WDATA_S20 = pack9;
        WDATA_S21 = pack10;
        WDATA_S22 = pack11;
        WDATA_S01 = pack12;
        WDATA_S02 = pack13;
        WDATA_S03 = pack14;
        WDATA_S04 = pack15;
        WDATA_S05 = pack16;
        WDATA_S06 = pack17;
        WDATA_S07 = pack18;
        WDATA_S08 = pack19;
        WDATA_S09 = pack20;
        WDATA_S10 = pack21;
        WDATA_S11 = pack22;       
    end
    13:
    begin
        WDATA_S13 = pack1;
        WDATA_S14 = pack2;
        WDATA_S15 = pack3;
        WDATA_S16 = pack4;
        WDATA_S17 = pack5;
        WDATA_S18 = pack6;
        WDATA_S19 = pack7;
        WDATA_S20 = pack8;
        WDATA_S21 = pack9;
        WDATA_S22 = pack10;
        WDATA_S01 = pack11;
        WDATA_S02 = pack12;
        WDATA_S03 = pack13;
        WDATA_S04 = pack14;
        WDATA_S05 = pack15;
        WDATA_S06 = pack16;
        WDATA_S07 = pack17;
        WDATA_S08 = pack18;
        WDATA_S09 = pack19;
        WDATA_S10 = pack20;
        WDATA_S11 = pack21;
        WDATA_S12 = pack22;       
    end
    14:
    begin
        WDATA_S14 = pack1;
        WDATA_S15 = pack2;
        WDATA_S16 = pack3;
        WDATA_S17 = pack4;
        WDATA_S18 = pack5;
        WDATA_S19 = pack6;
        WDATA_S20 = pack7;
        WDATA_S21 = pack8;
        WDATA_S22 = pack9;
        WDATA_S01 = pack10;
        WDATA_S02 = pack11;
        WDATA_S03 = pack12;
        WDATA_S04 = pack13;
        WDATA_S05 = pack14;
        WDATA_S06 = pack15;
        WDATA_S07 = pack16;
        WDATA_S08 = pack17;
        WDATA_S09 = pack18;
        WDATA_S10 = pack19;
        WDATA_S11 = pack20;
        WDATA_S12 = pack21;
        WDATA_S13 = pack22;       
    end
    15:
    begin
        WDATA_S15 = pack1;
        WDATA_S16 = pack2;
        WDATA_S17 = pack3;
        WDATA_S18 = pack4;
        WDATA_S19 = pack5;
        WDATA_S20 = pack6;
        WDATA_S21 = pack7;
        WDATA_S22 = pack8;
        WDATA_S01 = pack9;
        WDATA_S02 = pack10;
        WDATA_S03 = pack11;
        WDATA_S04 = pack12;
        WDATA_S05 = pack13;
        WDATA_S06 = pack14;
        WDATA_S07 = pack15;
        WDATA_S08 = pack16;
        WDATA_S09 = pack17;
        WDATA_S10 = pack18;
        WDATA_S11 = pack19;
        WDATA_S12 = pack20;
        WDATA_S13 = pack21;
        WDATA_S14 = pack22;       
    end
    16:
    begin
        WDATA_S16 = pack1;
        WDATA_S17 = pack2;
        WDATA_S18 = pack3;
        WDATA_S19 = pack4;
        WDATA_S20 = pack5;
        WDATA_S21 = pack6;
        WDATA_S22 = pack7;
        WDATA_S01 = pack8;
        WDATA_S02 = pack9;
        WDATA_S03 = pack10;
        WDATA_S04 = pack11;
        WDATA_S05 = pack12;
        WDATA_S06 = pack13;
        WDATA_S07 = pack14;
        WDATA_S08 = pack15;
        WDATA_S09 = pack16;
        WDATA_S10 = pack17;
        WDATA_S11 = pack18;
        WDATA_S12 = pack19;
        WDATA_S13 = pack20;
        WDATA_S14 = pack21;
        WDATA_S15 = pack22;       
    end
    17:
    begin
        WDATA_S17 = pack1;
        WDATA_S18 = pack2;
        WDATA_S19 = pack3;
        WDATA_S20 = pack4;
        WDATA_S21 = pack5;
        WDATA_S22 = pack6;
        WDATA_S01 = pack7;
        WDATA_S02 = pack8;
        WDATA_S03 = pack9;
        WDATA_S04 = pack10;
        WDATA_S05 = pack11;
        WDATA_S06 = pack12;
        WDATA_S07 = pack13;
        WDATA_S08 = pack14;
        WDATA_S09 = pack15;
        WDATA_S10 = pack16;
        WDATA_S11 = pack17;
        WDATA_S12 = pack18;
        WDATA_S13 = pack19;
        WDATA_S14 = pack20;
        WDATA_S15 = pack21;
        WDATA_S16 = pack22;       
    end
    18:
    begin
        WDATA_S18 = pack1;
        WDATA_S19 = pack2;
        WDATA_S20 = pack3;
        WDATA_S21 = pack4;
        WDATA_S22 = pack5;
        WDATA_S01 = pack6;
        WDATA_S02 = pack7;
        WDATA_S03 = pack8;
        WDATA_S04 = pack9;
        WDATA_S05 = pack10;
        WDATA_S06 = pack11;
        WDATA_S07 = pack12;
        WDATA_S08 = pack13;
        WDATA_S09 = pack14;
        WDATA_S10 = pack15;
        WDATA_S11 = pack16;
        WDATA_S12 = pack17;
        WDATA_S13 = pack18;
        WDATA_S14 = pack19;
        WDATA_S15 = pack20;
        WDATA_S16 = pack21;
        WDATA_S17 = pack22;       
    end
    19:
    begin
        WDATA_S19 = pack1;
        WDATA_S20 = pack2;
        WDATA_S21 = pack3;
        WDATA_S22 = pack4;
        WDATA_S01 = pack5;
        WDATA_S02 = pack6;
        WDATA_S03 = pack7;
        WDATA_S04 = pack8;
        WDATA_S05 = pack9;
        WDATA_S06 = pack10;
        WDATA_S07 = pack11;
        WDATA_S08 = pack12;
        WDATA_S09 = pack13;
        WDATA_S10 = pack14;
        WDATA_S11 = pack15;
        WDATA_S12 = pack16;
        WDATA_S13 = pack17;
        WDATA_S14 = pack18;
        WDATA_S15 = pack19;
        WDATA_S16 = pack20;
        WDATA_S17 = pack21;
        WDATA_S18 = pack22;       
    end
    20:
    begin
        WDATA_S20 = pack1;
        WDATA_S21 = pack2;
        WDATA_S22 = pack3;
        WDATA_S01 = pack4;
        WDATA_S02 = pack5;
        WDATA_S03 = pack6;
        WDATA_S04 = pack7;
        WDATA_S05 = pack8;
        WDATA_S06 = pack9;
        WDATA_S07 = pack10;
        WDATA_S08 = pack11;
        WDATA_S09 = pack12;
        WDATA_S10 = pack13;
        WDATA_S11 = pack14;
        WDATA_S12 = pack15;
        WDATA_S13 = pack16;
        WDATA_S14 = pack17;
        WDATA_S15 = pack18;
        WDATA_S16 = pack19;
        WDATA_S17 = pack20;
        WDATA_S18 = pack21;
        WDATA_S19 = pack22;       
    end
    21:
    begin
        WDATA_S21 = pack1;
        WDATA_S22 = pack2;
        WDATA_S01 = pack3;
        WDATA_S02 = pack4;
        WDATA_S03 = pack5;
        WDATA_S04 = pack6;
        WDATA_S05 = pack7;
        WDATA_S06 = pack8;
        WDATA_S07 = pack9;
        WDATA_S08 = pack10;
        WDATA_S09 = pack11;
        WDATA_S10 = pack12;
        WDATA_S11 = pack13;
        WDATA_S12 = pack14;
        WDATA_S13 = pack15;
        WDATA_S14 = pack16;
        WDATA_S15 = pack17;
        WDATA_S16 = pack18;
        WDATA_S17 = pack19;
        WDATA_S18 = pack20;
        WDATA_S19 = pack21;
        WDATA_S20 = pack22;       
    end
    22:
    begin
        WDATA_S22 = pack1;
        WDATA_S01 = pack2;
        WDATA_S02 = pack3;
        WDATA_S03 = pack4;
        WDATA_S04 = pack5;
        WDATA_S05 = pack6;
        WDATA_S06 = pack7;
        WDATA_S07 = pack8;
        WDATA_S08 = pack9;
        WDATA_S09 = pack10;
        WDATA_S10 = pack11;
        WDATA_S11 = pack12;
        WDATA_S12 = pack13;
        WDATA_S13 = pack14;
        WDATA_S14 = pack15;
        WDATA_S15 = pack16;
        WDATA_S16 = pack17;
        WDATA_S17 = pack18;
        WDATA_S18 = pack19;
        WDATA_S19 = pack20;
        WDATA_S20 = pack21;
        WDATA_S21 = pack22;       
    end
    default:
    begin
        WDATA_S02 = 0;
        WDATA_S03 = 0;
        WDATA_S04 = 0;
        WDATA_S05 = 0;
        WDATA_S06 = 0;
        WDATA_S07 = 0;
        WDATA_S08 = 0;
        WDATA_S09 = 0;
        WDATA_S10 = 0;
        WDATA_S11 = 0;
        WDATA_S12 = 0;
        WDATA_S13 = 0;
        WDATA_S14 = 0;
        WDATA_S15 = 0;
        WDATA_S16 = 0;
        WDATA_S17 = 0;
        WDATA_S18 = 0;
        WDATA_S19 = 0;
        WDATA_S20 = 0;
        WDATA_S21 = 0;
        WDATA_S22 = 0;
        WDATA_S01 = 0;       
    end
   endcase
 end   
*/
 
 SW_Reg_4col search_block01 (
		.clk					(clk),
		.AddrOut		(RADDR_S01), 
		.AddrIn	(WADDR_S), 
		.DataIn	(WDATA_S01), 
		.WE			(WE_S01),
		.DataOut		(RDATA_S01));
		
  
   	SW_Reg_4col search_block02 (
		.clk					(clk),
		.AddrOut		(RADDR_S02), 
		.AddrIn	(WADDR_S), 
		.DataIn	(WDATA_S02), 
		.WE			(WE_S02),
		.DataOut		(RDATA_S02));
  
   	SW_Reg_4col search_block03 (
		.clk					(clk),
		.AddrOut		(RADDR_S03), 
		.AddrIn	(WADDR_S), 
		.DataIn	(WDATA_S03), 
		.WE			(WE_S03),
		.DataOut		(RDATA_S03));
  
   	SW_Reg_4col search_block04 (
		.clk					(clk),
		.AddrOut		(RADDR_S04), 
		.AddrIn	(WADDR_S), 
		.DataIn	(WDATA_S04), 
		.WE			(WE_S04),
		.DataOut		(RDATA_S04));
  
   	SW_Reg_4col search_block05 (
		.clk					(clk),
		.AddrOut		(RADDR_S05), 
		.AddrIn	(WADDR_S), 
		.DataIn	(WDATA_S05), 
		.WE			(WE_S05),
		.DataOut		(RDATA_S05));
  
   	SW_Reg_4col search_block06 (
		.clk					(clk),
		.AddrOut		(RADDR_S06), 
		.AddrIn	(WADDR_S), 
		.DataIn	(WDATA_S06), 
		.WE			(WE_S06),
		.DataOut		(RDATA_S06));
  
   	SW_Reg_4col search_block07 (
		.clk					(clk),
		.AddrOut		(RADDR_S07), 
		.AddrIn	(WADDR_S), 
		.DataIn	(WDATA_S07), 
		.WE			(WE_S07),
		.DataOut		(RDATA_S07));
  
   	SW_Reg_4col search_block08 (
		.clk					(clk),
		.AddrOut		(RADDR_S08), 
		.AddrIn	(WADDR_S), 
		.DataIn	(WDATA_S08), 
		.WE			(WE_S08),
		.DataOut		(RDATA_S08));
  
   	SW_Reg_4col search_block09 (
		.clk					(clk),
		.AddrOut		(RADDR_S09), 
		.AddrIn	(WADDR_S), 
		.DataIn	(WDATA_S09), 
		.WE			(WE_S09),
		.DataOut		(RDATA_S09));
  
   	SW_Reg_4col search_block10 (
		.clk					(clk),
		.AddrOut		(RADDR_S10), 
		.AddrIn	(WADDR_S), 
		.DataIn	(WDATA_S10), 
		.WE			(WE_S10),
		.DataOut		(RDATA_S10));
  
   	SW_Reg_4col search_block11 (
		.clk					(clk),
		.AddrOut		(RADDR_S11), 
		.AddrIn	(WADDR_S), 
		.DataIn	(WDATA_S11), 
		.WE			(WE_S11),
		.DataOut		(RDATA_S11));
  
   	SW_Reg_4col search_block12 (
		.clk					(clk),
		.AddrOut		(RADDR_S12), 
		.AddrIn	(WADDR_S), 
		.DataIn	(WDATA_S12), 
		.WE			(WE_S12),
		.DataOut		(RDATA_S12));
  
   	SW_Reg_4col search_block13 (
		.clk					(clk),
		.AddrOut		(RADDR_S13), 
		.AddrIn	(WADDR_S), 
		.DataIn	(WDATA_S13), 
		.WE			(WE_S13),
		.DataOut		(RDATA_S13));
  
   	SW_Reg_4col search_block14 (
		.clk					(clk),
		.AddrOut		(RADDR_S14), 
		.AddrIn	(WADDR_S), 
		.DataIn	(WDATA_S14), 
		.WE			(WE_S14),
		.DataOut		(RDATA_S14));
  
   	SW_Reg_4col search_block15 (
		.clk					(clk),
		.AddrOut		(RADDR_S15), 
		.AddrIn	(WADDR_S), 
		.DataIn	(WDATA_S15), 
		.WE			(WE_S15),
		.DataOut		(RDATA_S15));
  
   	SW_Reg_4col search_block16 (
		.clk					(clk),
		.AddrOut		(RADDR_S16), 
		.AddrIn	(WADDR_S), 
		.DataIn	(WDATA_S16), 
		.WE			(WE_S16),
		.DataOut		(RDATA_S16));
  
   	SW_Reg_4col search_block17 (
		.clk					(clk),
		.AddrOut		(RADDR_S17), 
		.AddrIn	(WADDR_S), 
		.DataIn	(WDATA_S17), 
		.WE			(WE_S17),
		.DataOut		(RDATA_S17));
  
   	SW_Reg_4col search_block18 (
		.clk					(clk),
		.AddrOut		(RADDR_S18), 
		.AddrIn	(WADDR_S), 
		.DataIn	(WDATA_S18), 
		.WE			(WE_S18),
		.DataOut		(RDATA_S18));
  
   	SW_Reg_4col search_block19 (
		.clk					(clk),
		.AddrOut		(RADDR_S19), 
		.AddrIn	(WADDR_S), 
		.DataIn	(WDATA_S19), 
		.WE			(WE_S19),
		.DataOut		(RDATA_S19));
  
   	SW_Reg_4col search_block20 (
		.clk					(clk),
		.AddrOut		(RADDR_S20), 
		.AddrIn	(WADDR_S), 
		.DataIn	(WDATA_S20), 
		.WE			(WE_S20),
		.DataOut		(RDATA_S20));
  
   	SW_Reg_4col search_block21 (
		.clk					(clk),
		.AddrOut		(RADDR_S21), 
		.AddrIn	(WADDR_S), 
		.DataIn	(WDATA_S21), 
		.WE			(WE_S21),
		.DataOut		(RDATA_S21));
  
   	SW_Reg_4col search_block22 (
		.clk					(clk),
		.AddrOut		(RADDR_S22), 
		.AddrIn	(WADDR_S), 
		.DataIn	(WDATA_S22), 
		.WE			(WE_S22),
		.DataOut		(RDATA_S22));
		
    

median Mdn (.vec1(vecin1), .vec2(vecin2), .vec3(vecin3), .median(pre_median), .underTh(pre_underTh));
endmodule


