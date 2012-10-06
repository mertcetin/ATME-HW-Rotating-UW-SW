`timescale 1ns/1ps
`define FRAMECOUNT 4
`define IMGWIDTH 1280
`define IMGHEIGHT 720
`define BLOCKSINROW 80
`define BLOCKSINCOL 45
module test3DRS;
//////////////////////////////////////////////////

reg [7:0] frameset [`FRAMECOUNT-1:0] [0:`IMGWIDTH*`IMGHEIGHT-1];
reg [7:0] search_frame [0:`IMGWIDTH*`IMGHEIGHT-1];
reg [7:0] ref_frame [0:`IMGWIDTH*`IMGHEIGHT-1];
reg [7:0] resized_frame [0:(`IMGWIDTH+72)*(`IMGHEIGHT+72)-1];

reg [7:0] reference [0:255];
reg [7:0] search [0:7743]; //88*88
////////////////////////////////////////////////
//Outputs

integer FetchPosition_Row,FetchPosition_Column;	
wire outready;
wire [13:0]  MVread;
reg [13:0] VecAddr;
wire [15:0] outSAD;
wire blockend,frameend;
////////////////////////////////////////////////
//Inputs
reg clk, reset, start,firstframe;
	
reg refwrite,searchwrite;
reg [3:0] refaddress;
reg [6:0] searchaddress;
reg [127:0] refdata;
reg [63:0] searchdata;
reg curfilled,srcfilled;
////////////////////////////////////////////////
//Vars
integer i,j,k,m,n,f1,f2,f3,a,b,c,rowblock,frameno;

/////////////////////////////////////////////


always #(40/2) clk= ~clk;

initial
begin

// /////////initial conditions/////////////
clk = 1;
reset = 1;
start = 0;

refwrite = 0;
searchwrite = 0;
refaddress = 0;
refdata = 0;
searchaddress = 0;
searchdata = 0;
firstframe = 0;

$readmemh("frames.txt",frameset);


#45;

reset = 0;

/*            Search  Cases

------------------------------------------------------------
|  1  |                              2                               | 3  |
------------------------------------------------------------
|      |                                                               |      |
|      |                                                               |      |
|  4  |                            0                                |  5  |
|      |                                                               |      |
|      |                                                               |      |
-------------------------------------------------------------
|  6  |                           7                                  |  8  |
-------------------------------------------------------------	

*/

#40;
firstframe = 1;
start = 1;
VecAddr = 0;
//wait(DUT.controller.frameend);
wait(frameend);
#45;
firstframe = 0;

for (frameno = 1; frameno <3 ; frameno++)
begin
search_frame = frameset[frameno];
ref_frame = frameset[(frameno + 1)];    
//resized_frame = RESIZE(search_frame);
for (i=0;i<(`IMGHEIGHT+72);i++)
begin
		   for (j=0;j<(`IMGWIDTH+72);j++)
			begin
			   if (i<36)
			   	   FetchPosition_Row = (36-1-i);
			   else if (i>=36+`IMGHEIGHT)
			   	   FetchPosition_Row = (2*`IMGHEIGHT+36-1-i);
			   else
			   	   FetchPosition_Row = i - 36;
			   if (j<36)
			       FetchPosition_Column = (36-1-j);
			   else if(j>= `IMGWIDTH+36)
			   	   FetchPosition_Column = (2*`IMGWIDTH+36-1-j);
			   else
			   	   FetchPosition_Column = j-36;
			   
			   resized_frame[i*(`IMGWIDTH+72)+j] = search_frame[FetchPosition_Row*`IMGWIDTH+FetchPosition_Column];
         end
end
//b=0;
//rowblock = 0;
for (rowblock = 0; rowblock < `BLOCKSINCOL; rowblock++)
//for (rowblock = 0; rowblock < 2; rowblock++)
begin
	for (b = 0; b< `BLOCKSINROW; b++)
	begin
		for (a = 0; a<16; a++)
		begin
			refaddress = a;
			refwrite = 1;
			//refdata = ref_frame[a*`IMGWIDTH+b*16 +: 16];
			for (c = 0; c <8 ; c++)
			begin
			refdata = ((refdata << 8) + ref_frame[((rowblock*16+c)*`IMGWIDTH+b*16)+a]);/*, ref_frame[(a*`IMGWIDTH+b*16)+1], ref_frame[(a*`IMGWIDTH+b*16)+2], ref_frame[(a*`IMGWIDTH+b*16)+3],
									 ref_frame[(a*`IMGWIDTH+b*16)+4], ref_frame[(a*`IMGWIDTH+b*16)+5], ref_frame[(a*`IMGWIDTH+b*16)+6], ref_frame[(a*`IMGWIDTH+b*16)+7],
									  ref_frame[(a*`IMGWIDTH+b*16)+8], ref_frame[(a*`IMGWIDTH+b*16)+9], ref_frame[(a*`IMGWIDTH+b*16)+10], ref_frame[(a*`IMGWIDTH+b*16)+11],
									   ref_frame[(a*`IMGWIDTH+b*16)+12], ref_frame[(a*`IMGWIDTH+b*16)+13], ref_frame[(a*`IMGWIDTH+b*16)+14], ref_frame[(a*`IMGWIDTH+b*16)+15]};
			*/
			end
			#40;
			for (c = 8; c <16 ; c++)
			begin
			refdata = ((refdata << 8) + ref_frame[((rowblock*16+c)*`IMGWIDTH+b*16)+a]);/*, ref_frame[(a*`IMGWIDTH+b*16)+1], ref_frame[(a*`IMGWIDTH+b*16)+2], ref_frame[(a*`IMGWIDTH+b*16)+3],
									 ref_frame[(a*`IMGWIDTH+b*16)+4], ref_frame[(a*`IMGWIDTH+b*16)+5], ref_frame[(a*`IMGWIDTH+b*16)+6], ref_frame[(a*`IMGWIDTH+b*16)+7],
									  ref_frame[(a*`IMGWIDTH+b*16)+8], ref_frame[(a*`IMGWIDTH+b*16)+9], ref_frame[(a*`IMGWIDTH+b*16)+10], ref_frame[(a*`IMGWIDTH+b*16)+11],
									   ref_frame[(a*`IMGWIDTH+b*16)+12], ref_frame[(a*`IMGWIDTH+b*16)+13], ref_frame[(a*`IMGWIDTH+b*16)+14], ref_frame[(a*`IMGWIDTH+b*16)+15]};
			*/
			end
			#40;
		end
		refwrite = 0;
		curfilled = 1;
		#40;
		curfilled = 0;
		searchwrite = 1;
		for (c = ((b==0) ? 0 : 72); c<88 ; c++)
		begin 
		   
		   for (a = 0; a<22; a = a +2)
		   begin
		      //searchdata = ((searchdata << 8) + resized_frame[(rowblock*16+a)*(`IMGWIDTH+72)+b*16+c]);
				searchdata = ({resized_frame[(rowblock*16+a+66)*(`IMGWIDTH+72)+b*16+c],resized_frame[(rowblock*16+a+44)*(`IMGWIDTH+72)+b*16+c],
								resized_frame[(rowblock*16+a+22)*(`IMGWIDTH+72)+b*16+c],resized_frame[(rowblock*16+a)*(`IMGWIDTH+72)+b*16+c],
								resized_frame[(rowblock*16+a+67)*(`IMGWIDTH+72)+b*16+c],resized_frame[(rowblock*16+a+45)*(`IMGWIDTH+72)+b*16+c],
								resized_frame[(rowblock*16+a+23)*(`IMGWIDTH+72)+b*16+c],resized_frame[(rowblock*16+a+1)*(`IMGWIDTH+72)+b*16+c]});
				#20;
				if((c== 87) && (a == 21)) searchwrite = 0;
				#20;
		   end
		   
		end
		searchwrite = 0;
		srcfilled = 1;
		//#10;

		#40;
		srcfilled = 0;
		//wait(DUT.controller.blockend);
		wait(blockend);
		#45;
		//$stop;
	end
	
end

#40;
#45;
end


#40;
$fclose(DUT.mvarray.vecmem.file);


$stop;

end //end of initial statement


top3DRS DUT(.clk,.reset,.start,.cur_WE(refwrite),.search_WE(searchwrite),.cur_data_in(refdata),.search_addr_in(searchaddress),.search_data_in(searchdata),.curfilled,.srcfilled,.firstframe,.testAddr(VecAddr),.testMV(MVread),.blockendout(blockend),.frameendout(frameend));

function [7:0] [0:(`IMGWIDTH+72)*(`IMGHEIGHT+72)-1]RESIZE ;
   input [7:0] frame [0:`IMGWIDTH*`IMGHEIGHT-1];
   
   begin
       for (i=0;i<(`IMGHEIGHT+72);i++)
       begin
		   for (j=0;j<(`IMGWIDTH+72);j++)
			begin
			   if (i<36)
			   	   FetchPosition_Row = (36-1-i);
			   else if (i>=36+`IMGHEIGHT)
			   	   FetchPosition_Row = (2*`IMGHEIGHT+36-1-i);
			   else
			   	   FetchPosition_Row = i - 36;
			   if (j<36)
			       FetchPosition_Column = (36-1-j);
			   else if(j>= `IMGWIDTH+36)
			   	   FetchPosition_Column = (2*`IMGWIDTH+36-1-j);
			   else
			   	   FetchPosition_Column = j-36;
			   
			   RESIZE[i*(`IMGWIDTH+72)+j] = frame[FetchPosition_Row*`IMGWIDTH+FetchPosition_Column];
			end
		end
		   
 
   end	
endfunction	   
		   
		   
endmodule
