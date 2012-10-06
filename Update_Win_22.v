module UW(clk,reset,WE,W_SELECT_ROW_OR_COL,R_ROW,R_COL, input_data, SearchOut, write_count);

input clk,reset,WE,W_SELECT_ROW_OR_COL; //kacinci row veya col'a yazacagini da ekleyebiliriz sonrasi icin
input [175:0] input_data;

input [4:0] R_ROW, R_COL;
reg [2:0] row, col;
output wire [(256*8)-1:0] SearchOut;

parameter WROW = 0, WCOL = 1;
input wire [4:0] write_count;
reg [0:175] preOut1,preOut2,preOut3,preOut4,preOut5,preOut6,preOut7,preOut8,preOut9,preOut10,preOut11,preOut12,preOut13,preOut14,preOut15,preOut16;
wire [0:175] RpreOut1,RpreOut2,RpreOut3,RpreOut4,RpreOut5,RpreOut6,RpreOut7,RpreOut8,RpreOut9,RpreOut10,RpreOut11,RpreOut12,RpreOut13,RpreOut14,RpreOut15,RpreOut16;
wire [0:175] junk1,junk2,junk3,junk4,junk5,junk6,junk7,junk8,junk9,junk10,junk11,junk12,junk13,junk14,junk15,junk16;

//reg [4:0] outCol1,outCol2,outCol3,outCol4,outCol5,outCol6,outCol7,outCol8,outCol9,outCol10,outCol11,outCol12,outCol13,outCol14,outCol15,outCol16;
//reg [4:0] outRow1,outRow2,outRow3,outRow4,outRow5,outRow6,outRow7,outRow8,outRow9,outRow10,outRow11,outRow12,outRow13,outRow14,outRow15,outRow16;
//reg [7:0] outRow1sh3,outRow2sh3,outRow3sh3,outRow4sh3,outRow5sh3,outRow6sh3,outRow7sh3,outRow8sh3,
//	outRow9sh3,outRow10sh3,outRow11sh3,outRow12sh3,outRow13sh3,outRow14sh3,outRow15sh3,outRow16sh3;
wire [7:0] shR_ROW;
	
	
	
reg [(175):0] search_array1;
reg [(175):0] search_array2;
reg [(175):0] search_array3;
reg [(175):0] search_array4;
reg [(175):0] search_array5;
reg [(175):0] search_array6;
reg [(175):0] search_array7;
reg [(175):0] search_array8;
reg [(175):0] search_array9;
reg [(175):0] search_array10;
reg [(175):0] search_array11;
reg [(175):0] search_array12;
reg [(175):0] search_array13;
reg [(175):0] search_array14;
reg [(175):0] search_array15;
reg [(175):0] search_array16;
reg [(175):0] search_array17;
reg [(175):0] search_array18;
reg [(175):0] search_array19;
reg [(175):0] search_array20;
reg [(175):0] search_array21;
reg [(175):0] search_array22;


always @(posedge clk, posedge reset)
begin
	if (reset)
	begin
		search_array1 <= 0;
		search_array2 <= 0;
		search_array3 <= 0;
		search_array4 <= 0;
		search_array5 <= 0;
		search_array6 <= 0;
		search_array7 <= 0;
		search_array8 <= 0;
		search_array9 <= 0;
		search_array10 <= 0;
		search_array11 <= 0;
		search_array12 <= 0;
		search_array13 <= 0;
		search_array14 <= 0;
		search_array15 <= 0;
		search_array16 <= 0;
		search_array17 <= 0;
		search_array18 <= 0;
		search_array19 <= 0;
		search_array20 <= 0;
		search_array21 <= 0;
		search_array22 <= 0;

	end
	else if (WE)
	begin

		if (W_SELECT_ROW_OR_COL == WCOL)
		begin
		case (write_count)
		0: search_array1 <= input_data;
		1: search_array2 <= input_data;
		2: search_array3 <= input_data;
		3: search_array4 <= input_data;
		4: search_array5 <= input_data;
		5: search_array6 <= input_data;
		6: search_array7 <= input_data;
		7: search_array8 <= input_data;
		8: search_array9 <= input_data;
		9: search_array10 <= input_data;
		10: search_array11 <= input_data;
		11: search_array12 <= input_data;
		12: search_array13 <= input_data;
		13: search_array14 <= input_data;
		14: search_array15<= input_data;
		15: search_array16 <= input_data;
		16: search_array17 <= input_data;
		17: search_array18 <= input_data;
		18: search_array19 <= input_data;
		19: search_array20 <= input_data;
		20: search_array21 <= input_data;
		21: search_array22 <= input_data;

		endcase
		end
		else
		begin
			search_array1[((22-write_count)<<3)-1 -: 8] <= input_data[(22<<3)-1 -: 8];
			search_array2[((22-write_count)<<3)-1 -: 8] <= input_data[(21<<3)-1 -: 8];
			search_array3[((22-write_count)<<3)-1 -: 8] <= input_data[(20<<3)-1 -: 8];
			search_array4[((22-write_count)<<3)-1 -: 8] <= input_data[(19<<3)-1 -: 8];
			search_array5[((22-write_count)<<3)-1 -: 8] <= input_data[(18<<3)-1 -: 8];
			search_array6[((22-write_count)<<3)-1 -: 8] <= input_data[(17<<3)-1 -: 8];
			search_array7[((22-write_count)<<3)-1 -: 8] <= input_data[(16<<3)-1 -: 8];
			search_array8[((22-write_count)<<3)-1 -: 8] <= input_data[(15<<3)-1 -: 8];
			search_array9[((22-write_count)<<3)-1 -: 8] <= input_data[(14<<3)-1 -: 8];
			search_array10[((22-write_count)<<3)-1 -: 8] <= input_data[(13<<3)-1 -: 8];
			search_array11[((22-write_count)<<3)-1 -: 8] <= input_data[(12<<3)-1 -: 8];
			search_array12[((22-write_count)<<3)-1 -: 8] <= input_data[(11<<3)-1 -: 8];
			search_array13[((22-write_count)<<3)-1 -: 8] <= input_data[(10<<3)-1 -: 8];
			search_array14[((22-write_count)<<3)-1 -: 8] <= input_data[(9<<3)-1 -: 8];
			search_array15[((22-write_count)<<3)-1 -: 8] <= input_data[(8<<3)-1 -: 8];
			search_array16[((22-write_count)<<3)-1 -: 8] <= input_data[(7<<3)-1 -: 8];
			search_array17[((22-write_count)<<3)-1 -: 8] <= input_data[(6<<3)-1 -: 8];
			search_array18[((22-write_count)<<3)-1 -: 8] <= input_data[(5<<3)-1 -: 8];
			search_array19[((22-write_count)<<3)-1 -: 8] <= input_data[(4<<3)-1 -: 8];
			search_array20[((22-write_count)<<3)-1 -: 8] <= input_data[(3<<3)-1 -: 8];
			search_array21[((22-write_count)<<3)-1 -: 8] <= input_data[(2<<3)-1 -: 8];
			search_array22[((22-write_count)<<3)-1 -: 8] <= input_data[(1<<3)-1 -: 8];
			
		end
	end
end


always @*
begin
	case(R_COL)
	19:
	begin
		preOut1 = search_array1;
		preOut2 = search_array2;
		preOut3 = search_array3;
		preOut4 = search_array4;
		preOut5 = search_array5;
		preOut6 = search_array6;
		preOut7 = search_array7;
		preOut8 = search_array8;
		preOut9 = search_array9;
		preOut10 = search_array10;
		preOut11 = search_array11;
		preOut12 = search_array12;
		preOut13 = search_array13;
		preOut14 = search_array14;
		preOut15 = search_array15;
		preOut16 = search_array16;
	end
	20:
	begin
		preOut1 = search_array2;
		preOut2 = search_array3;
		preOut3 = search_array4;
		preOut4 = search_array5;
		preOut5 = search_array6;
		preOut6 = search_array7;
		preOut7 = search_array8;
		preOut8 = search_array9;
		preOut9 = search_array10;
		preOut10 = search_array11;
		preOut11 = search_array12;
		preOut12 = search_array13;
		preOut13 = search_array14;
		preOut14 = search_array15;
		preOut15 = search_array16;
		preOut16 = search_array17;
	end
	21:
	begin
		preOut1 = search_array3;
		preOut2 = search_array4;
		preOut3 = search_array5;
		preOut4 = search_array6;
		preOut5 = search_array7;
		preOut6 = search_array8;
		preOut7 = search_array9;
		preOut8 = search_array10;
		preOut9 = search_array11;
		preOut10 = search_array12;
		preOut11 = search_array13;
		preOut12 = search_array14;
		preOut13 = search_array15;
		preOut14 = search_array16;
		preOut15 = search_array17;
		preOut16 = search_array18;
	end
	0:
	begin
		preOut1 = search_array4;
		preOut2 = search_array5;
		preOut3 = search_array6;
		preOut4 = search_array7;
		preOut5 = search_array8;
		preOut6 = search_array9;
		preOut7 = search_array10;
		preOut8 = search_array11;
		preOut9 = search_array12;
		preOut10 = search_array13;
		preOut11 = search_array14;
		preOut12 = search_array15;
		preOut13 = search_array16;
		preOut14 = search_array17;
		preOut15 = search_array18;
		preOut16 = search_array19;
	end
	1:
	begin
		preOut1 = search_array5;
		preOut2 = search_array6;
		preOut3 = search_array7;
		preOut4 = search_array8;
		preOut5 = search_array9;
		preOut6 = search_array10;
		preOut7 = search_array11;
		preOut8 = search_array12;
		preOut9 = search_array13;
		preOut10 = search_array14;
		preOut11 = search_array15;
		preOut12 = search_array16;
		preOut13 = search_array17;
		preOut14 = search_array18;
		preOut15 = search_array19;
		preOut16 = search_array20;
	end
	2:
	begin
		preOut1 = search_array6;
		preOut2 = search_array7;
		preOut3 = search_array8;
		preOut4 = search_array9;
		preOut5 = search_array10;
		preOut6 = search_array11;
		preOut7 = search_array12;
		preOut8 = search_array13;
		preOut9 = search_array14;
		preOut10 = search_array15;
		preOut11 = search_array16;
		preOut12 = search_array17;
		preOut13 = search_array18;
		preOut14 = search_array19;
		preOut15 = search_array20;
		preOut16 = search_array21;
	end
	3:
	begin
		preOut1 = search_array7;
		preOut2 = search_array8;
		preOut3 = search_array9;
		preOut4 = search_array10;
		preOut5 = search_array11;
		preOut6 = search_array12;
		preOut7 = search_array13;
		preOut8 = search_array14;
		preOut9 = search_array15;
		preOut10 = search_array16;
		preOut11 = search_array17;
		preOut12 = search_array18;
		preOut13 = search_array19;
		preOut14 = search_array20;
		preOut15 = search_array21;
		preOut16 = search_array22;
	end
	4:
	begin
		preOut1 = search_array8;
		preOut2 = search_array9;
		preOut3 = search_array10;
		preOut4 = search_array11;
		preOut5 = search_array12;
		preOut6 = search_array13;
		preOut7 = search_array14;
		preOut8 = search_array15;
		preOut9 = search_array16;
		preOut10 = search_array17;
		preOut11 = search_array18;
		preOut12 = search_array19;
		preOut13 = search_array20;
		preOut14 = search_array21;
		preOut15 = search_array22;
		preOut16 = search_array1;
	end
	5:
	begin
		preOut1 = search_array9;
		preOut2 = search_array10;
		preOut3 = search_array11;
		preOut4 = search_array12;
		preOut5 = search_array13;
		preOut6 = search_array14;
		preOut7 = search_array15;
		preOut8 = search_array16;
		preOut9 = search_array17;
		preOut10 = search_array18;
		preOut11 = search_array19;
		preOut12 = search_array20;
		preOut13 = search_array21;
		preOut14 = search_array22;
		preOut15 = search_array1;
		preOut16 = search_array2;
	end
	6:
	begin
		preOut1 = search_array10;
		preOut2 = search_array11;
		preOut3 = search_array12;
		preOut4 = search_array13;
		preOut5 = search_array14;
		preOut6 = search_array15;
		preOut7 = search_array16;
		preOut8 = search_array17;
		preOut9 = search_array18;
		preOut10 = search_array19;
		preOut11 = search_array20;
		preOut12 = search_array21;
		preOut13 = search_array22;
		preOut14 = search_array1;
		preOut15 = search_array2;
		preOut16 = search_array3;
	end
	7:
	begin
		preOut1 = search_array11;
		preOut2 = search_array12;
		preOut3 = search_array13;
		preOut4 = search_array14;
		preOut5 = search_array15;
		preOut6 = search_array16;
		preOut7 = search_array17;
		preOut8 = search_array18;
		preOut9 = search_array19;
		preOut10 = search_array20;
		preOut11 = search_array21;
		preOut12 = search_array22;
		preOut13 = search_array1;
		preOut14 = search_array2;
		preOut15 = search_array3;
		preOut16 = search_array4;
	end
	8:
	begin
		preOut1 = search_array12;
		preOut2 = search_array13;
		preOut3 = search_array14;
		preOut4 = search_array15;
		preOut5 = search_array16;
		preOut6 = search_array17;
		preOut7 = search_array18;
		preOut8 = search_array19;
		preOut9 = search_array20;
		preOut10 = search_array21;
		preOut11 = search_array22;
		preOut12 = search_array1;
		preOut13 = search_array2;
		preOut14 = search_array3;
		preOut15 = search_array4;
		preOut16 = search_array5;
	end
	9:
	begin
		preOut1 = search_array13;
		preOut2 = search_array14;
		preOut3 = search_array15;
		preOut4 = search_array16;
		preOut5 = search_array17;
		preOut6 = search_array18;
		preOut7 = search_array19;
		preOut8 = search_array20;
		preOut9 = search_array21;
		preOut10 = search_array22;
		preOut11 = search_array1;
		preOut12 = search_array2;
		preOut13 = search_array3;
		preOut14 = search_array4;
		preOut15 = search_array5;
		preOut16 = search_array6;
	end
	10:
	begin
		preOut1 = search_array14;
		preOut2 = search_array15;
		preOut3 = search_array16;
		preOut4 = search_array17;
		preOut5 = search_array18;
		preOut6 = search_array19;
		preOut7 = search_array20;
		preOut8 = search_array21;
		preOut9 = search_array22;
		preOut10 = search_array1;
		preOut11 = search_array2;
		preOut12 = search_array3;
		preOut13 = search_array4;
		preOut14 = search_array5;
		preOut15 = search_array6;
		preOut16 = search_array7;
	end
	11:
	begin
		preOut1 = search_array15;
		preOut2 = search_array16;
		preOut3 = search_array17;
		preOut4 = search_array18;
		preOut5 = search_array19;
		preOut6 = search_array20;
		preOut7 = search_array21;
		preOut8 = search_array22;
		preOut9 = search_array1;
		preOut10 = search_array2;
		preOut11 = search_array3;
		preOut12 = search_array4;
		preOut13 = search_array5;
		preOut14 = search_array6;
		preOut15 = search_array7;
		preOut16 = search_array8;
	end
	12:
	begin
		preOut1 = search_array16;
		preOut2 = search_array17;
		preOut3 = search_array18;
		preOut4 = search_array19;
		preOut5 = search_array20;
		preOut6 = search_array21;
		preOut7 = search_array22;
		preOut8 = search_array1;
		preOut9 = search_array2;
		preOut10 = search_array3;
		preOut11 = search_array4;
		preOut12 = search_array5;
		preOut13 = search_array6;
		preOut14 = search_array7;
		preOut15 = search_array8;
		preOut16 = search_array9;
	end
	13:
	begin
		preOut1 = search_array17;
		preOut2 = search_array18;
		preOut3 = search_array19;
		preOut4 = search_array20;
		preOut5 = search_array21;
		preOut6 = search_array22;
		preOut7 = search_array1;
		preOut8 = search_array2;
		preOut9 = search_array3;
		preOut10 = search_array4;
		preOut11 = search_array5;
		preOut12 = search_array6;
		preOut13 = search_array7;
		preOut14 = search_array8;
		preOut15 = search_array9;
		preOut16 = search_array10;
	end
	14:
	begin
		preOut1 = search_array18;
		preOut2 = search_array19;
		preOut3 = search_array20;
		preOut4 = search_array21;
		preOut5 = search_array22;
		preOut6 = search_array1;
		preOut7 = search_array2;
		preOut8 = search_array3;
		preOut9 = search_array4;
		preOut10 = search_array5;
		preOut11 = search_array6;
		preOut12 = search_array7;
		preOut13 = search_array8;
		preOut14 = search_array9;
		preOut15 = search_array10;
		preOut16 = search_array11;
	end
	15:
	begin
		preOut1 = search_array19;
		preOut2 = search_array20;
		preOut3 = search_array21;
		preOut4 = search_array22;
		preOut5 = search_array1;
		preOut6 = search_array2;
		preOut7 = search_array3;
		preOut8 = search_array4;
		preOut9 = search_array5;
		preOut10 = search_array6;
		preOut11 = search_array7;
		preOut12 = search_array8;
		preOut13 = search_array9;
		preOut14 = search_array10;
		preOut15 = search_array11;
		preOut16 = search_array12;
	end
	16:
	begin
		preOut1 = search_array20;
		preOut2 = search_array21;
		preOut3 = search_array22;
		preOut4 = search_array1;
		preOut5 = search_array2;
		preOut6 = search_array3;
		preOut7 = search_array4;
		preOut8 = search_array5;
		preOut9 = search_array6;
		preOut10 = search_array7;
		preOut11 = search_array8;
		preOut12 = search_array9;
		preOut13 = search_array10;
		preOut14 = search_array11;
		preOut15 = search_array12;
		preOut16 = search_array13;
	end
	17:
	begin
		preOut1 = search_array21;
		preOut2 = search_array22;
		preOut3 = search_array1;
		preOut4 = search_array2;
		preOut5 = search_array3;
		preOut6 = search_array4;
		preOut7 = search_array5;
		preOut8 = search_array6;
		preOut9 = search_array7;
		preOut10 = search_array8;
		preOut11 = search_array9;
		preOut12 = search_array10;
		preOut13 = search_array11;
		preOut14 = search_array12;
		preOut15 = search_array13;
		preOut16 = search_array14;
	end
	18:
	begin
		preOut1 = search_array22;
		preOut2 = search_array1;
		preOut3 = search_array2;
		preOut4 = search_array3;
		preOut5 = search_array4;
		preOut6 = search_array5;
		preOut7 = search_array6;
		preOut8 = search_array7;
		preOut9 = search_array8;
		preOut10 = search_array9;
		preOut11 = search_array10;
		preOut12 = search_array11;
		preOut13 = search_array12;
		preOut14 = search_array13;
		preOut15 = search_array14;
		preOut16 = search_array15;
	end
	default:
	begin
		preOut1 = search_array4;
		preOut2 = search_array5;
		preOut3 = search_array6;
		preOut4 = search_array7;
		preOut5 = search_array8;
		preOut6 = search_array9;
		preOut7 = search_array10;
		preOut8 = search_array11;
		preOut9 = search_array12;
		preOut10 = search_array13;
		preOut11 = search_array14;
		preOut12 = search_array15;
		preOut13 = search_array16;
		preOut14 = search_array17;
		preOut15 = search_array18;
		preOut16 = search_array19;
	end
	endcase	
end

assign shR_ROW = R_ROW << 3;

assign { RpreOut1, junk1 } = { preOut1, preOut1 } << shR_ROW;
assign { RpreOut2, junk2 } = { preOut2, preOut2 } << shR_ROW;
assign { RpreOut3, junk3 } = { preOut3, preOut3 } << shR_ROW;
assign { RpreOut4, junk4 } = { preOut4, preOut4 } << shR_ROW;
assign { RpreOut5, junk5 } = { preOut5, preOut5 } << shR_ROW;
assign { RpreOut6, junk6 } = { preOut6, preOut6 } << shR_ROW;
assign { RpreOut7, junk7 } = { preOut7, preOut7 } << shR_ROW;
assign { RpreOut8, junk8 } = { preOut8, preOut8 } << shR_ROW;
assign { RpreOut9, junk9 } = { preOut9, preOut9 } << shR_ROW;
assign { RpreOut10, junk10 } = { preOut10, preOut10 } << shR_ROW;
assign { RpreOut11, junk11 } = { preOut11, preOut11 } << shR_ROW;
assign { RpreOut12, junk12 } = { preOut12, preOut12 } << shR_ROW;
assign { RpreOut13, junk13 } = { preOut13, preOut13 } << shR_ROW;
assign { RpreOut14, junk14 } = { preOut14, preOut14 } << shR_ROW;
assign { RpreOut15, junk15 } = { preOut15, preOut15 } << shR_ROW;
assign { RpreOut16, junk16 } = { preOut16, preOut16 } << shR_ROW;

/*always @*
begin
	case(R_ROW)
	19:
	begin
		outRow1 = 0;
		outRow2 = 1;
		outRow3 = 2;
		outRow4 = 3;
		outRow5 = 4;
		outRow6 = 5;
		outRow7 = 6;
		outRow8 = 7;
		outRow9 = 8;
		outRow10 = 9;
		outRow11 = 10;
		outRow12 = 11;
		outRow13 = 12;
		outRow14 = 13;
		outRow15 = 14;
		outRow16 = 15;
	end
	20:
	begin
		outRow1 = 1;
		outRow2 = 2;
		outRow3 = 3;
		outRow4 = 4;
		outRow5 = 5;
		outRow6 = 6;
		outRow7 = 7;
		outRow8 = 8;
		outRow9 = 9;
		outRow10 = 10;
		outRow11 = 11;
		outRow12 = 12;
		outRow13 = 13;
		outRow14 = 14;
		outRow15 = 15;
		outRow16 = 16;
	end
	21:
	begin
		outRow1 = 2;
		outRow2 = 3;
		outRow3 = 4;
		outRow4 = 5;
		outRow5 = 6;
		outRow6 = 7;
		outRow7 = 8;
		outRow8 = 9;
		outRow9 = 10;
		outRow10 = 11;
		outRow11 = 12;
		outRow12 = 13;
		outRow13 = 14;
		outRow14 = 15;
		outRow15 = 16;
		outRow16 = 17;
	end
	0:
	begin
		outRow1 = 3;
		outRow2 = 4;
		outRow3 = 5;
		outRow4 = 6;
		outRow5 = 7;
		outRow6 = 8;
		outRow7 = 9;
		outRow8 = 10;
		outRow9 = 11;
		outRow10 = 12;
		outRow11 = 13;
		outRow12 = 14;
		outRow13 = 15;
		outRow14 = 16;
		outRow15 = 17;
		outRow16 = 18;
	end
	1:
	begin
		outRow1 = 4;
		outRow2 = 5;
		outRow3 = 6;
		outRow4 = 7;
		outRow5 = 8;
		outRow6 = 9;
		outRow7 = 10;
		outRow8 = 11;
		outRow9 = 12;
		outRow10 = 13;
		outRow11 = 14;
		outRow12 = 15;
		outRow13 = 16;
		outRow14 = 17;
		outRow15 = 18;
		outRow16 = 19;
	end
	2:
	begin
		outRow1 = 5;
		outRow2 = 6;
		outRow3 = 7;
		outRow4 = 8;
		outRow5 = 9;
		outRow6 = 10;
		outRow7 = 11;
		outRow8 = 12;
		outRow9 = 13;
		outRow10 = 14;
		outRow11 = 15;
		outRow12 = 16;
		outRow13 = 17;
		outRow14 = 18;
		outRow15 = 19;
		outRow16 = 20;
	end
	3:
	begin
		outRow1 = 6;
		outRow2 = 7;
		outRow3 = 8;
		outRow4 = 9;
		outRow5 = 10;
		outRow6 = 11;
		outRow7 = 12;
		outRow8 = 13;
		outRow9 = 14;
		outRow10 = 15;
		outRow11 = 16;
		outRow12 = 17;
		outRow13 = 18;
		outRow14 = 19;
		outRow15 = 20;
		outRow16 = 21;
	end
	4:
	begin
		outRow1 = 7;
		outRow2 = 8;
		outRow3 = 9;
		outRow4 = 10;
		outRow5 = 11;
		outRow6 = 12;
		outRow7 = 13;
		outRow8 = 14;
		outRow9 = 15;
		outRow10 = 16;
		outRow11 = 17;
		outRow12 = 18;
		outRow13 = 19;
		outRow14 = 20;
		outRow15 = 21;
		outRow16 = 0;
	end
	5:
	begin
		outRow1 = 8;
		outRow2 = 9;
		outRow3 = 10;
		outRow4 = 11;
		outRow5 = 12;
		outRow6 = 13;
		outRow7 = 14;
		outRow8 = 15;
		outRow9 = 16;
		outRow10 = 17;
		outRow11 = 18;
		outRow12 = 19;
		outRow13 = 20;
		outRow14 = 21;
		outRow15 = 0;
		outRow16 = 1;
	end
	6:
	begin
		outRow1 = 9;
		outRow2 = 10;
		outRow3 = 11;
		outRow4 = 12;
		outRow5 = 13;
		outRow6 = 14;
		outRow7 = 15;
		outRow8 = 16;
		outRow9 = 17;
		outRow10 = 18;
		outRow11 = 19;
		outRow12 = 20;
		outRow13 = 21;
		outRow14 = 0;
		outRow15 = 1;
		outRow16 = 2;
	end
	7:
	begin
		outRow1 = 10;
		outRow2 = 11;
		outRow3 = 12;
		outRow4 = 13;
		outRow5 = 14;
		outRow6 = 15;
		outRow7 = 16;
		outRow8 = 17;
		outRow9 = 18;
		outRow10 = 19;
		outRow11 = 20;
		outRow12 = 21;
		outRow13 = 0;
		outRow14 = 1;
		outRow15 = 2;
		outRow16 = 3;
	end
	8:
	begin
		outRow1 = 11;
		outRow2 = 12;
		outRow3 = 13;
		outRow4 = 14;
		outRow5 = 15;
		outRow6 = 16;
		outRow7 = 17;
		outRow8 = 18;
		outRow9 = 19;
		outRow10 = 20;
		outRow11 = 21;
		outRow12 = 0;
		outRow13 = 1;
		outRow14 = 2;
		outRow15 = 3;
		outRow16 = 4;
	end
	9:
	begin
		outRow1 = 12;
		outRow2 = 13;
		outRow3 = 14;
		outRow4 = 15;
		outRow5 = 16;
		outRow6 = 17;
		outRow7 = 18;
		outRow8 = 19;
		outRow9 = 20;
		outRow10 = 21;
		outRow11 = 0;
		outRow12 = 1;
		outRow13 = 2;
		outRow14 = 3;
		outRow15 = 4;
		outRow16 = 5;
	end
	10:
	begin
		outRow1 = 13;
		outRow2 = 14;
		outRow3 = 15;
		outRow4 = 16;
		outRow5 = 17;
		outRow6 = 18;
		outRow7 = 19;
		outRow8 = 20;
		outRow9 = 21;
		outRow10 = 0;
		outRow11 = 1;
		outRow12 = 2;
		outRow13 = 3;
		outRow14 = 4;
		outRow15 = 5;
		outRow16 = 6;
	end
	11:
	begin
		outRow1 = 14;
		outRow2 = 15;
		outRow3 = 16;
		outRow4 = 17;
		outRow5 = 18;
		outRow6 = 19;
		outRow7 = 20;
		outRow8 = 21;
		outRow9 = 0;
		outRow10 = 1;
		outRow11 = 2;
		outRow12 = 3;
		outRow13 = 4;
		outRow14 = 5;
		outRow15 = 6;
		outRow16 = 7;
	end
	12:
	begin
		outRow1 = 15;
		outRow2 = 16;
		outRow3 = 17;
		outRow4 = 18;
		outRow5 = 19;
		outRow6 = 20;
		outRow7 = 21;
		outRow8 = 0;
		outRow9 = 1;
		outRow10 = 2;
		outRow11 = 3;
		outRow12 = 4;
		outRow13 = 5;
		outRow14 = 6;
		outRow15 = 7;
		outRow16 = 8;
	end
	13:
	begin
		outRow1 = 16;
		outRow2 = 17;
		outRow3 = 18;
		outRow4 = 19;
		outRow5 = 20;
		outRow6 = 21;
		outRow7 = 0;
		outRow8 = 1;
		outRow9 = 2;
		outRow10 = 3;
		outRow11 = 4;
		outRow12 = 5;
		outRow13 = 6;
		outRow14 = 7;
		outRow15 = 8;
		outRow16 = 9;
	end
	14:
	begin
		outRow1 = 17;
		outRow2 = 18;
		outRow3 = 19;
		outRow4 = 20;
		outRow5 = 21;
		outRow6 = 0;
		outRow7 = 1;
		outRow8 = 2;
		outRow9 = 3;
		outRow10 = 4;
		outRow11 = 5;
		outRow12 = 6;
		outRow13 = 7;
		outRow14 = 8;
		outRow15 = 9;
		outRow16 = 10;
	end
	15:
	begin
		outRow1 = 18;
		outRow2 = 19;
		outRow3 = 20;
		outRow4 = 21;
		outRow5 = 0;
		outRow6 = 1;
		outRow7 = 2;
		outRow8 = 3;
		outRow9 = 4;
		outRow10 = 5;
		outRow11 = 6;
		outRow12 = 7;
		outRow13 = 8;
		outRow14 = 9;
		outRow15 = 10;
		outRow16 = 11;
	end
	16:
	begin
		outRow1 = 19;
		outRow2 = 20;
		outRow3 = 21;
		outRow4 = 0;
		outRow5 = 1;
		outRow6 = 2;
		outRow7 = 3;
		outRow8 = 4;
		outRow9 = 5;
		outRow10 = 6;
		outRow11 = 7;
		outRow12 = 8;
		outRow13 = 9;
		outRow14 = 10;
		outRow15 = 11;
		outRow16 = 12;
	end
	17:
	begin
		outRow1 = 20;
		outRow2 = 21;
		outRow3 = 0;
		outRow4 = 1;
		outRow5 = 2;
		outRow6 = 3;
		outRow7 = 4;
		outRow8 = 5;
		outRow9 = 6;
		outRow10 = 7;
		outRow11 = 8;
		outRow12 = 9;
		outRow13 = 10;
		outRow14 = 11;
		outRow15 = 12;
		outRow16 = 13;
	end
	18:
	begin
		outRow1 = 21;
		outRow2 = 0;
		outRow3 = 1;
		outRow4 = 2;
		outRow5 = 3;
		outRow6 = 4;
		outRow7 = 5;
		outRow8 = 6;
		outRow9 = 7;
		outRow10 = 8;
		outRow11 = 9;
		outRow12 = 10;
		outRow13 = 11;
		outRow14 = 12;
		outRow15 = 13;
		outRow16 = 14;
	end
	default:
	begin
		outRow1 = 0;
		outRow2 = 1;
		outRow3 = 2;
		outRow4 = 3;
		outRow5 = 4;
		outRow6 = 5;
		outRow7 = 6;
		outRow8 = 7;
		outRow9 = 8;
		outRow10 = 9;
		outRow11 = 10;
		outRow12 = 11;
		outRow13 = 12;
		outRow14 = 13;
		outRow15 = 14;
		outRow16 = 15;
	end
	endcase
end
always @*
begin
outRow1sh3 = outRow1 << 3;
outRow2sh3 = outRow2 << 3;
outRow3sh3 = outRow3 << 3;
outRow4sh3 = outRow4 << 3;
outRow5sh3 = outRow5 << 3;
outRow6sh3 = outRow6 << 3;
outRow7sh3 = outRow7 << 3;
outRow8sh3 = outRow8 << 3;
outRow9sh3 = outRow9 << 3;
outRow10sh3 = outRow10 << 3;
outRow11sh3 = outRow11 << 3;
outRow12sh3 = outRow12 << 3;
outRow13sh3 = outRow13 << 3;
outRow14sh3 = outRow14 << 3;
outRow15sh3 = outRow15 << 3;
outRow16sh3 = outRow16 << 3;
end*/

assign SearchOut[(16<<7)-1 -: 128] = RpreOut1[24 +: 128];
assign SearchOut[(15<<7)-1 -: 128] = RpreOut2[24 +: 128];
assign SearchOut[(14<<7)-1 -: 128] = RpreOut3[24 +: 128];
assign SearchOut[(13<<7)-1 -: 128] = RpreOut4[24 +: 128];
assign SearchOut[(12<<7)-1 -: 128] = RpreOut5[24 +: 128];
assign SearchOut[(11<<7)-1 -: 128] = RpreOut6[24 +: 128];
assign SearchOut[(10<<7)-1 -: 128] = RpreOut7[24 +: 128];
assign SearchOut[(9<<7)-1 -: 128] = RpreOut8[24 +: 128];
assign SearchOut[(8<<7)-1 -: 128] = RpreOut9[24 +: 128];
assign SearchOut[(7<<7)-1 -: 128] = RpreOut10[24 +: 128];
assign SearchOut[(6<<7)-1 -: 128] = RpreOut11[24 +: 128];
assign SearchOut[(5<<7)-1 -: 128] = RpreOut12[24 +: 128];
assign SearchOut[(4<<7)-1 -: 128] = RpreOut13[24 +: 128];
assign SearchOut[(3<<7)-1 -: 128] = RpreOut14[24 +: 128];
assign SearchOut[(2<<7)-1 -: 128] = RpreOut15[24 +: 128];
assign SearchOut[(1<<7)-1 -: 128] = RpreOut16[24 +: 128];


/*assign SearchOut[(16<<7)-1 -: 128] = {preOut1[outRow1sh3 +: 8],preOut1[outRow2sh3 +: 8],preOut1[outRow3sh3 +: 8],preOut1[outRow4sh3 +: 8],preOut1[outRow5sh3 +: 8],preOut1[outRow6sh3 +: 8],preOut1[outRow7sh3 +: 8],preOut1[outRow8sh3 +: 8],
									preOut1[outRow9sh3 +: 8],preOut1[outRow10sh3 +: 8],preOut1[outRow11sh3 +: 8],preOut1[outRow12sh3 +: 8],preOut1[outRow13sh3 +: 8],preOut1[outRow14sh3 +: 8],preOut1[outRow15sh3 +: 8],preOut1[outRow16sh3 +: 8]};
assign SearchOut[(15<<7)-1 -: 128] = {preOut2[outRow1sh3 +: 8],preOut2[outRow2sh3 +: 8],preOut2[outRow3sh3 +: 8],preOut2[outRow4sh3 +: 8],preOut2[outRow5sh3 +: 8],preOut2[outRow6sh3 +: 8],preOut2[outRow7sh3 +: 8],preOut2[outRow8sh3 +: 8],
									preOut2[outRow9sh3 +: 8],preOut2[outRow10sh3 +: 8],preOut2[outRow11sh3 +: 8],preOut2[outRow12sh3 +: 8],preOut2[outRow13sh3 +: 8],preOut2[outRow14sh3 +: 8],preOut2[outRow15sh3 +: 8],preOut2[outRow16sh3 +: 8]};
assign SearchOut[(14<<7)-1 -: 128] = {preOut3[outRow1sh3 +: 8],preOut3[outRow2sh3 +: 8],preOut3[outRow3sh3 +: 8],preOut3[outRow4sh3 +: 8],preOut3[outRow5sh3 +: 8],preOut3[outRow6sh3 +: 8],preOut3[outRow7sh3 +: 8],preOut3[outRow8sh3 +: 8],
									preOut3[outRow9sh3 +: 8],preOut3[outRow10sh3 +: 8],preOut3[outRow11sh3 +: 8],preOut3[outRow12sh3 +: 8],preOut3[outRow13sh3 +: 8],preOut3[outRow14sh3 +: 8],preOut3[outRow15sh3 +: 8],preOut3[outRow16sh3 +: 8]};
assign SearchOut[(13<<7)-1 -: 128] = {preOut4[outRow1sh3 +: 8],preOut4[outRow2sh3 +: 8],preOut4[outRow3sh3 +: 8],preOut4[outRow4sh3 +: 8],preOut4[outRow5sh3 +: 8],preOut4[outRow6sh3 +: 8],preOut4[outRow7sh3 +: 8],preOut4[outRow8sh3 +: 8],
									preOut4[outRow9sh3 +: 8],preOut4[outRow10sh3 +: 8],preOut4[outRow11sh3 +: 8],preOut4[outRow12sh3 +: 8],preOut4[outRow13sh3 +: 8],preOut4[outRow14sh3 +: 8],preOut4[outRow15sh3 +: 8],preOut4[outRow16sh3 +: 8]};
assign SearchOut[(12<<7)-1 -: 128] = {preOut5[outRow1sh3 +: 8],preOut5[outRow2sh3 +: 8],preOut5[outRow3sh3 +: 8],preOut5[outRow4sh3 +: 8],preOut5[outRow5sh3 +: 8],preOut5[outRow6sh3 +: 8],preOut5[outRow7sh3 +: 8],preOut5[outRow8sh3 +: 8],
									preOut5[outRow9sh3 +: 8],preOut5[outRow10sh3 +: 8],preOut5[outRow11sh3 +: 8],preOut5[outRow12sh3 +: 8],preOut5[outRow13sh3 +: 8],preOut5[outRow14sh3 +: 8],preOut5[outRow15sh3 +: 8],preOut5[outRow16sh3 +: 8]};
assign SearchOut[(11<<7)-1 -: 128] = {preOut6[outRow1sh3 +: 8],preOut6[outRow2sh3 +: 8],preOut6[outRow3sh3 +: 8],preOut6[outRow4sh3 +: 8],preOut6[outRow5sh3 +: 8],preOut6[outRow6sh3 +: 8],preOut6[outRow7sh3 +: 8],preOut6[outRow8sh3 +: 8],
									preOut6[outRow9sh3 +: 8],preOut6[outRow10sh3 +: 8],preOut6[outRow11sh3 +: 8],preOut6[outRow12sh3 +: 8],preOut6[outRow13sh3 +: 8],preOut6[outRow14sh3 +: 8],preOut6[outRow15sh3 +: 8],preOut6[outRow16sh3 +: 8]};
assign SearchOut[(10<<7)-1 -: 128] = {preOut7[outRow1sh3 +: 8],preOut7[outRow2sh3 +: 8],preOut7[outRow3sh3 +: 8],preOut7[outRow4sh3 +: 8],preOut7[outRow5sh3 +: 8],preOut7[outRow6sh3 +: 8],preOut7[outRow7sh3 +: 8],preOut7[outRow8sh3 +: 8],
									preOut7[outRow9sh3 +: 8],preOut7[outRow10sh3 +: 8],preOut7[outRow11sh3 +: 8],preOut7[outRow12sh3 +: 8],preOut7[outRow13sh3 +: 8],preOut7[outRow14sh3 +: 8],preOut7[outRow15sh3 +: 8],preOut7[outRow16sh3 +: 8]};
assign SearchOut[(9<<7)-1 -: 128] = {preOut8[outRow1sh3 +: 8],preOut8[outRow2sh3 +: 8],preOut8[outRow3sh3 +: 8],preOut8[outRow4sh3 +: 8],preOut8[outRow5sh3 +: 8],preOut8[outRow6sh3 +: 8],preOut8[outRow7sh3 +: 8],preOut8[outRow8sh3 +: 8],
									preOut8[outRow9sh3 +: 8],preOut8[outRow10sh3 +: 8],preOut8[outRow11sh3 +: 8],preOut8[outRow12sh3 +: 8],preOut8[outRow13sh3 +: 8],preOut8[outRow14sh3 +: 8],preOut8[outRow15sh3 +: 8],preOut8[outRow16sh3 +: 8]};
assign SearchOut[(8<<7)-1 -: 128] = {preOut9[outRow1sh3 +: 8],preOut9[outRow2sh3 +: 8],preOut9[outRow3sh3 +: 8],preOut9[outRow4sh3 +: 8],preOut9[outRow5sh3 +: 8],preOut9[outRow6sh3 +: 8],preOut9[outRow7sh3 +: 8],preOut9[outRow8sh3 +: 8],
									preOut9[outRow9sh3 +: 8],preOut9[outRow10sh3 +: 8],preOut9[outRow11sh3 +: 8],preOut9[outRow12sh3 +: 8],preOut9[outRow13sh3 +: 8],preOut9[outRow14sh3 +: 8],preOut9[outRow15sh3 +: 8],preOut9[outRow16sh3 +: 8]};
assign SearchOut[(7<<7)-1 -: 128] = {preOut10[outRow1sh3 +: 8],preOut10[outRow2sh3 +: 8],preOut10[outRow3sh3 +: 8],preOut10[outRow4sh3 +: 8],preOut10[outRow5sh3 +: 8],preOut10[outRow6sh3 +: 8],preOut10[outRow7sh3 +: 8],preOut10[outRow8sh3 +: 8],
									preOut10[outRow9sh3 +: 8],preOut10[outRow10sh3 +: 8],preOut10[outRow11sh3 +: 8],preOut10[outRow12sh3 +: 8],preOut10[outRow13sh3 +: 8],preOut10[outRow14sh3 +: 8],preOut10[outRow15sh3 +: 8],preOut10[outRow16sh3 +: 8]};
assign SearchOut[(6<<7)-1 -: 128] = {preOut11[outRow1sh3 +: 8],preOut11[outRow2sh3 +: 8],preOut11[outRow3sh3 +: 8],preOut11[outRow4sh3 +: 8],preOut11[outRow5sh3 +: 8],preOut11[outRow6sh3 +: 8],preOut11[outRow7sh3 +: 8],preOut11[outRow8sh3 +: 8],
									preOut11[outRow9sh3 +: 8],preOut11[outRow10sh3 +: 8],preOut11[outRow11sh3 +: 8],preOut11[outRow12sh3 +: 8],preOut11[outRow13sh3 +: 8],preOut11[outRow14sh3 +: 8],preOut11[outRow15sh3 +: 8],preOut11[outRow16sh3 +: 8]};
assign SearchOut[(5<<7)-1 -: 128] = {preOut12[outRow1sh3 +: 8],preOut12[outRow2sh3 +: 8],preOut12[outRow3sh3 +: 8],preOut12[outRow4sh3 +: 8],preOut12[outRow5sh3 +: 8],preOut12[outRow6sh3 +: 8],preOut12[outRow7sh3 +: 8],preOut12[outRow8sh3 +: 8],
									preOut12[outRow9sh3 +: 8],preOut12[outRow10sh3 +: 8],preOut12[outRow11sh3 +: 8],preOut12[outRow12sh3 +: 8],preOut12[outRow13sh3 +: 8],preOut12[outRow14sh3 +: 8],preOut12[outRow15sh3 +: 8],preOut12[outRow16sh3 +: 8]};
assign SearchOut[(4<<7)-1 -: 128] = {preOut13[outRow1sh3 +: 8],preOut13[outRow2sh3 +: 8],preOut13[outRow3sh3 +: 8],preOut13[outRow4sh3 +: 8],preOut13[outRow5sh3 +: 8],preOut13[outRow6sh3 +: 8],preOut13[outRow7sh3 +: 8],preOut13[outRow8sh3 +: 8],
									preOut13[outRow9sh3 +: 8],preOut13[outRow10sh3 +: 8],preOut13[outRow11sh3 +: 8],preOut13[outRow12sh3 +: 8],preOut13[outRow13sh3 +: 8],preOut13[outRow14sh3 +: 8],preOut13[outRow15sh3 +: 8],preOut13[outRow16sh3 +: 8]};
assign SearchOut[(3<<7)-1 -: 128] = {preOut14[outRow1sh3 +: 8],preOut14[outRow2sh3 +: 8],preOut14[outRow3sh3 +: 8],preOut14[outRow4sh3 +: 8],preOut14[outRow5sh3 +: 8],preOut14[outRow6sh3 +: 8],preOut14[outRow7sh3 +: 8],preOut14[outRow8sh3 +: 8],
									preOut14[outRow9sh3 +: 8],preOut14[outRow10sh3 +: 8],preOut14[outRow11sh3 +: 8],preOut14[outRow12sh3 +: 8],preOut14[outRow13sh3 +: 8],preOut14[outRow14sh3 +: 8],preOut14[outRow15sh3 +: 8],preOut14[outRow16sh3 +: 8]};
assign SearchOut[(2<<7)-1 -: 128] = {preOut15[outRow1sh3 +: 8],preOut15[outRow2sh3 +: 8],preOut15[outRow3sh3 +: 8],preOut15[outRow4sh3 +: 8],preOut15[outRow5sh3 +: 8],preOut15[outRow6sh3 +: 8],preOut15[outRow7sh3 +: 8],preOut15[outRow8sh3 +: 8],
									preOut15[outRow9sh3 +: 8],preOut15[outRow10sh3 +: 8],preOut15[outRow11sh3 +: 8],preOut15[outRow12sh3 +: 8],preOut15[outRow13sh3 +: 8],preOut15[outRow14sh3 +: 8],preOut15[outRow15sh3 +: 8],preOut15[outRow16sh3 +: 8]};
assign SearchOut[(1<<7)-1 -: 128] = {preOut16[outRow1sh3 +: 8],preOut16[outRow2sh3 +: 8],preOut16[outRow3sh3 +: 8],preOut16[outRow4sh3 +: 8],preOut16[outRow5sh3 +: 8],preOut16[outRow6sh3 +: 8],preOut16[outRow7sh3 +: 8],preOut16[outRow8sh3 +: 8],
									preOut16[outRow9sh3 +: 8],preOut16[outRow10sh3 +: 8],preOut16[outRow11sh3 +: 8],preOut16[outRow12sh3 +: 8],preOut16[outRow13sh3 +: 8],preOut16[outRow14sh3 +: 8],preOut16[outRow15sh3 +: 8],preOut16[outRow16sh3 +: 8]};
*/
/*assign SearchOut[(16<<7)-1 -: 128] = {preOut1[((outRow1<<3)) +: 8],preOut1[((outRow2<<3)) +: 8],preOut1[((outRow3<<3)) +: 8],preOut1[((outRow4<<3)) +: 8],preOut1[((outRow5<<3)) +: 8],preOut1[((outRow6<<3)) +: 8],preOut1[((outRow7<<3)) +: 8],preOut1[((outRow8<<3)) +: 8],
									preOut1[((outRow9<<3)) +: 8],preOut1[((outRow10<<3)) +: 8],preOut1[((outRow11<<3)) +: 8],preOut1[((outRow12<<3)) +: 8],preOut1[((outRow13<<3)) +: 8],preOut1[((outRow14<<3)) +: 8],preOut1[((outRow15<<3)) +: 8],preOut1[((outRow16<<3)) +: 8]};
assign SearchOut[(15<<7)-1 -: 128] = {preOut2[(outRow1<<3) +: 8],preOut2[(outRow2<<3) +: 8],preOut2[(outRow3<<3) +: 8],preOut2[(outRow4<<3) +: 8],preOut2[(outRow5<<3) +: 8],preOut2[(outRow6<<3) +: 8],preOut2[(outRow7<<3) +: 8],preOut2[(outRow8<<3) +: 8],
									preOut2[(outRow9<<3) +: 8],preOut2[(outRow10<<3) +: 8],preOut2[(outRow11<<3) +: 8],preOut2[(outRow12<<3) +: 8],preOut2[(outRow13<<3) +: 8],preOut2[(outRow14<<3) +: 8],preOut2[(outRow15<<3) +: 8],preOut2[(outRow16<<3) +: 8]};
assign SearchOut[(14<<7)-1 -: 128] = {preOut3[(outRow1<<3) +: 8],preOut3[(outRow2<<3) +: 8],preOut3[(outRow3<<3) +: 8],preOut3[(outRow4<<3) +: 8],preOut3[(outRow5<<3) +: 8],preOut3[(outRow6<<3) +: 8],preOut3[(outRow7<<3) +: 8],preOut3[(outRow8<<3) +: 8],
									preOut3[(outRow9<<3) +: 8],preOut3[(outRow10<<3) +: 8],preOut3[(outRow11<<3) +: 8],preOut3[(outRow12<<3) +: 8],preOut3[(outRow13<<3) +: 8],preOut3[(outRow14<<3) +: 8],preOut3[(outRow15<<3) +: 8],preOut3[(outRow16<<3) +: 8]};
assign SearchOut[(13<<7)-1 -: 128] = {preOut4[(outRow1<<3) +: 8],preOut4[(outRow2<<3) +: 8],preOut4[(outRow3<<3) +: 8],preOut4[(outRow4<<3) +: 8],preOut4[(outRow5<<3) +: 8],preOut4[(outRow6<<3) +: 8],preOut4[(outRow7<<3) +: 8],preOut4[(outRow8<<3) +: 8],
									preOut4[(outRow9<<3) +: 8],preOut4[(outRow10<<3) +: 8],preOut4[(outRow11<<3) +: 8],preOut4[(outRow12<<3) +: 8],preOut4[(outRow13<<3) +: 8],preOut4[(outRow14<<3) +: 8],preOut4[(outRow15<<3) +: 8],preOut4[(outRow16<<3) +: 8]};
assign SearchOut[(12<<7)-1 -: 128] = {preOut5[(outRow1<<3) +: 8],preOut5[(outRow2<<3) +: 8],preOut5[(outRow3<<3) +: 8],preOut5[(outRow4<<3) +: 8],preOut5[(outRow5<<3) +: 8],preOut5[(outRow6<<3) +: 8],preOut5[(outRow7<<3) +: 8],preOut5[(outRow8<<3) +: 8],
									preOut5[(outRow9<<3) +: 8],preOut5[(outRow10<<3) +: 8],preOut5[(outRow11<<3) +: 8],preOut5[(outRow12<<3) +: 8],preOut5[(outRow13<<3) +: 8],preOut5[(outRow14<<3) +: 8],preOut5[(outRow15<<3) +: 8],preOut5[(outRow16<<3) +: 8]};
assign SearchOut[(11<<7)-1 -: 128] = {preOut6[(outRow1<<3) +: 8],preOut6[(outRow2<<3) +: 8],preOut6[(outRow3<<3) +: 8],preOut6[(outRow4<<3) +: 8],preOut6[(outRow5<<3) +: 8],preOut6[(outRow6<<3) +: 8],preOut6[(outRow7<<3) +: 8],preOut6[(outRow8<<3) +: 8],
									preOut6[(outRow9<<3) +: 8],preOut6[(outRow10<<3) +: 8],preOut6[(outRow11<<3) +: 8],preOut6[(outRow12<<3) +: 8],preOut6[(outRow13<<3) +: 8],preOut6[(outRow14<<3) +: 8],preOut6[(outRow15<<3) +: 8],preOut6[(outRow16<<3) +: 8]};
assign SearchOut[(10<<7)-1 -: 128] = {preOut7[(outRow1<<3) +: 8],preOut7[(outRow2<<3) +: 8],preOut7[(outRow3<<3) +: 8],preOut7[(outRow4<<3) +: 8],preOut7[(outRow5<<3) +: 8],preOut7[(outRow6<<3) +: 8],preOut7[(outRow7<<3) +: 8],preOut7[(outRow8<<3) +: 8],
									preOut7[(outRow9<<3) +: 8],preOut7[(outRow10<<3) +: 8],preOut7[(outRow11<<3) +: 8],preOut7[(outRow12<<3) +: 8],preOut7[(outRow13<<3) +: 8],preOut7[(outRow14<<3) +: 8],preOut7[(outRow15<<3) +: 8],preOut7[(outRow16<<3) +: 8]};
assign SearchOut[(9<<7)-1 -: 128] = {preOut8[(outRow1<<3) +: 8],preOut8[(outRow2<<3) +: 8],preOut8[(outRow3<<3) +: 8],preOut8[(outRow4<<3) +: 8],preOut8[(outRow5<<3) +: 8],preOut8[(outRow6<<3) +: 8],preOut8[(outRow7<<3) +: 8],preOut8[(outRow8<<3) +: 8],
									preOut8[(outRow9<<3) +: 8],preOut8[(outRow10<<3) +: 8],preOut8[(outRow11<<3) +: 8],preOut8[(outRow12<<3) +: 8],preOut8[(outRow13<<3) +: 8],preOut8[(outRow14<<3) +: 8],preOut8[(outRow15<<3) +: 8],preOut8[(outRow16<<3) +: 8]};
assign SearchOut[(8<<7)-1 -: 128] = {preOut9[(outRow1<<3) +: 8],preOut9[(outRow2<<3) +: 8],preOut9[(outRow3<<3) +: 8],preOut9[(outRow4<<3) +: 8],preOut9[(outRow5<<3) +: 8],preOut9[(outRow6<<3) +: 8],preOut9[(outRow7<<3) +: 8],preOut9[(outRow8<<3) +: 8],
									preOut9[(outRow9<<3) +: 8],preOut9[(outRow10<<3) +: 8],preOut9[(outRow11<<3) +: 8],preOut9[(outRow12<<3) +: 8],preOut9[(outRow13<<3) +: 8],preOut9[(outRow14<<3) +: 8],preOut9[(outRow15<<3) +: 8],preOut9[(outRow16<<3) +: 8]};
assign SearchOut[(7<<7)-1 -: 128] = {preOut10[(outRow1<<3) +: 8],preOut10[(outRow2<<3) +: 8],preOut10[(outRow3<<3) +: 8],preOut10[(outRow4<<3) +: 8],preOut10[(outRow5<<3) +: 8],preOut10[(outRow6<<3) +: 8],preOut10[(outRow7<<3) +: 8],preOut10[(outRow8<<3) +: 8],
									preOut10[(outRow9<<3) +: 8],preOut10[(outRow10<<3) +: 8],preOut10[(outRow11<<3) +: 8],preOut10[(outRow12<<3) +: 8],preOut10[(outRow13<<3) +: 8],preOut10[(outRow14<<3) +: 8],preOut10[(outRow15<<3) +: 8],preOut10[(outRow16<<3) +: 8]};
assign SearchOut[(6<<7)-1 -: 128] = {preOut11[(outRow1<<3) +: 8],preOut11[(outRow2<<3) +: 8],preOut11[(outRow3<<3) +: 8],preOut11[(outRow4<<3) +: 8],preOut11[(outRow5<<3) +: 8],preOut11[(outRow6<<3) +: 8],preOut11[(outRow7<<3) +: 8],preOut11[(outRow8<<3) +: 8],
									preOut11[(outRow9<<3) +: 8],preOut11[(outRow10<<3) +: 8],preOut11[(outRow11<<3) +: 8],preOut11[(outRow12<<3) +: 8],preOut11[(outRow13<<3) +: 8],preOut11[(outRow14<<3) +: 8],preOut11[(outRow15<<3) +: 8],preOut11[(outRow16<<3) +: 8]};
assign SearchOut[(5<<7)-1 -: 128] = {preOut12[(outRow1<<3) +: 8],preOut12[(outRow2<<3) +: 8],preOut12[(outRow3<<3) +: 8],preOut12[(outRow4<<3) +: 8],preOut12[(outRow5<<3) +: 8],preOut12[(outRow6<<3) +: 8],preOut12[(outRow7<<3) +: 8],preOut12[(outRow8<<3) +: 8],
									preOut12[(outRow9<<3) +: 8],preOut12[(outRow10<<3) +: 8],preOut12[(outRow11<<3) +: 8],preOut12[(outRow12<<3) +: 8],preOut12[(outRow13<<3) +: 8],preOut12[(outRow14<<3) +: 8],preOut12[(outRow15<<3) +: 8],preOut12[(outRow16<<3) +: 8]};
assign SearchOut[(4<<7)-1 -: 128] = {preOut13[(outRow1<<3) +: 8],preOut13[(outRow2<<3) +: 8],preOut13[(outRow3<<3) +: 8],preOut13[(outRow4<<3) +: 8],preOut13[(outRow5<<3) +: 8],preOut13[(outRow6<<3) +: 8],preOut13[(outRow7<<3) +: 8],preOut13[(outRow8<<3) +: 8],
									preOut13[(outRow9<<3) +: 8],preOut13[(outRow10<<3) +: 8],preOut13[(outRow11<<3) +: 8],preOut13[(outRow12<<3) +: 8],preOut13[(outRow13<<3) +: 8],preOut13[(outRow14<<3) +: 8],preOut13[(outRow15<<3) +: 8],preOut13[(outRow16<<3) +: 8]};
assign SearchOut[(3<<7)-1 -: 128] = {preOut14[(outRow1<<3) +: 8],preOut14[(outRow2<<3) +: 8],preOut14[(outRow3<<3) +: 8],preOut14[(outRow4<<3) +: 8],preOut14[(outRow5<<3) +: 8],preOut14[(outRow6<<3) +: 8],preOut14[(outRow7<<3) +: 8],preOut14[(outRow8<<3) +: 8],
									preOut14[(outRow9<<3) +: 8],preOut14[(outRow10<<3) +: 8],preOut14[(outRow11<<3) +: 8],preOut14[(outRow12<<3) +: 8],preOut14[(outRow13<<3) +: 8],preOut14[(outRow14<<3) +: 8],preOut14[(outRow15<<3) +: 8],preOut14[(outRow16<<3) +: 8]};
assign SearchOut[(2<<7)-1 -: 128] = {preOut15[(outRow1<<3) +: 8],preOut15[(outRow2<<3) +: 8],preOut15[(outRow3<<3) +: 8],preOut15[(outRow4<<3) +: 8],preOut15[(outRow5<<3) +: 8],preOut15[(outRow6<<3) +: 8],preOut15[(outRow7<<3) +: 8],preOut15[(outRow8<<3) +: 8],
									preOut15[(outRow9<<3) +: 8],preOut15[(outRow10<<3) +: 8],preOut15[(outRow11<<3) +: 8],preOut15[(outRow12<<3) +: 8],preOut15[(outRow13<<3) +: 8],preOut15[(outRow14<<3) +: 8],preOut15[(outRow15<<3) +: 8],preOut15[(outRow16<<3) +: 8]};
assign SearchOut[(1<<7)-1 -: 128] = {preOut16[(outRow1<<3) +: 8],preOut16[(outRow2<<3) +: 8],preOut16[(outRow3<<3) +: 8],preOut16[(outRow4<<3) +: 8],preOut16[(outRow5<<3) +: 8],preOut16[(outRow6<<3) +: 8],preOut16[(outRow7<<3) +: 8],preOut16[(outRow8<<3) +: 8],
									preOut16[(outRow9<<3) +: 8],preOut16[(outRow10<<3) +: 8],preOut16[(outRow11<<3) +: 8],preOut16[(outRow12<<3) +: 8],preOut16[(outRow13<<3) +: 8],preOut16[(outRow14<<3) +: 8],preOut16[(outRow15<<3) +: 8],preOut16[(outRow16<<3) +: 8]};
*/

			
endmodule

