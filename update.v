module Update(clk,reset,en,uvec);
    input clk,reset,en;
    output reg [5:0] uvec;
    wire [4:0] count;
    wire [14:0] out;    
    lfsr lfsr1(clk,en,reset,out);

    
assign count = out[4:0];

always @(count)
   begin
	/*case(count)
	0: uvec = 6'b110101; // (-3,-2)
	1: uvec = 6'b111101; // (-3,-1)
	2: uvec = 6'b000101; // (-3,0)
	3: uvec = 6'b001101; // (-3,1)
	4: uvec = 6'b010101; // (-3,2)
	5: uvec = 6'b110111; // (-1,-2)
	6: uvec = 6'b111111; // (-1,-1)
	7: uvec = 6'b000111; // (-1,0)
	8: uvec = 6'b001111; // (-1,1)
	9: uvec = 6'b010111; // (-1,2)
	10: uvec = 6'b110000; // (0,-2)
	11: uvec = 6'b111000; // (0,-1)
	12: uvec = 6'b000000; // (0,0)
	13: uvec = 6'b001000; // (0,1)
	14: uvec = 6'b010000; // (0,2)
	15: uvec = 6'b110001; // (1,-2)
	16: uvec = 6'b111001; // (1,-1)
	17: uvec = 6'b000001; // (1,0)
	18: uvec = 6'b001001; // (1,1)
	19: uvec = 6'b010001; // (1,2)
	20: uvec = 6'b110011; // (3,-2)
	21: uvec = 6'b111011; // (3,-1)
	22: uvec = 6'b000011; // (3,0)
	23: uvec = 6'b001011; // (3,1)
	24: uvec = 6'b010011; // (3,2)
	default: uvec = 6'b000000;
	endcase*/
	case(count)
	0: uvec = 6'b111101; // (-3,-1)
	1: uvec = 6'b000101; // (-3,0)
	2: uvec = 6'b001101; // (-3,1)
	3: uvec = 6'b010101; // (-3,2)
	4: uvec = 6'b110110; // (-2,-2)
	5: uvec = 6'b111110; // (-2,-1)
	6: uvec = 6'b000110; // (-2,0)
	7: uvec = 6'b001110; // (-2,1)
	8: uvec = 6'b010110; // (-2,2)
	9: uvec = 6'b110111; // (-1,-2)
	10: uvec = 6'b111111; // (-1,-1)
	11: uvec = 6'b000111; // (-1,0)
	12: uvec = 6'b001111; // (-1,1)
	13: uvec = 6'b010111; // (-1,2)
	14: uvec = 6'b110000; // (0,-2)
	15: uvec = 6'b111000; // (0,-1)
	16: uvec = 6'b001000; // (0,1)
	17: uvec = 6'b010000; // (0,2)
	18: uvec = 6'b110001; // (1,-2)
	19: uvec = 6'b111001; // (1,-1)
	20: uvec = 6'b000001; // (1,0)
	21: uvec = 6'b001001; // (1,1)
	22: uvec = 6'b010001; // (1,2)
	23: uvec = 6'b110010; // (2,-2)
	24: uvec = 6'b111010; // (2,-1)
	25: uvec = 6'b000010; // (2,0)
	26: uvec = 6'b001010; // (2,1)
	27: uvec = 6'b010010; // (2,2)
	28: uvec = 6'b111011; // (3,-1)
	29: uvec = 6'b000011; // (3,0)
	30: uvec = 6'b001011; // (3,1)
	31: uvec = 6'b010011; // (3,2)
	default: uvec = 6'b000000;
	endcase
end

    
endmodule