`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:39:03 08/24/2015 
// Design Name: 
// Module Name:    LIB 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module Frequency_Divider(input clk,rst,
								output [1:0]seven_clk,
								output count_clk
    );
	 parameter div_which=26;
	 parameter seven_clk_at=15;
	 
reg [div_which:0]count_ins;

always@(posedge clk or posedge rst)
begin
	if(rst)count_ins<=0;
	else count_ins<=count_ins+1'b1;
end

assign seven_clk=count_ins[seven_clk_at:seven_clk_at-1];
assign count_clk=count_ins[div_which];

endmodule


module Seven_Segment_4_bit_Display(input [1:0]clk,
											  input [3:0]dig_a,dig_b,dig_c,dig_d,
											 output [7:0]Dis_data,
											 output reg [3:0]Dis_wich
    );
reg [3:0]Dis_rewire;
always@(*)
begin
	case(clk)
		2'b00:Dis_rewire=dig_a;
		2'b01:Dis_rewire=dig_b;
		2'b10:Dis_rewire=dig_c;
		2'b11:Dis_rewire=dig_d;
		default:Dis_rewire=4'b1111;
	endcase
end


always@(*)
begin
	case(clk)
		2'b00:Dis_wich=4'b0001;
		2'b01:Dis_wich=4'b0010;
		2'b10:Dis_wich=4'b0100;
		2'b11:Dis_wich=4'b1000;
		default:Dis_wich=4'b1111;
	endcase
end
seven_segment DIg(Dis_rewire,Dis_data);
endmodule


module seven_segment(S,Display_data
    );
	 //work@low
	 input 	[3:0] 	S;
	 output 	[7:0] 	Display_data;
	 reg [7:0]Display_data;//DEFINE output as reg.
always @(S)
begin
	case(S)
	//######################%gfedcba
	4'b0000:Display_data=8'b11000000;
	4'b0001:Display_data=8'b11111001;
	4'b0010:Display_data=8'b10100100;
	4'b0011:Display_data=8'b10110000;
	4'b0100:Display_data=8'b10011001;
	4'b0101:Display_data=8'b10010010;
	4'b0110:Display_data=8'b10000010;
	4'b0111:Display_data=8'b11111000;
	4'b1000:Display_data=8'b10000000;
	4'b1001:Display_data=8'b10010000;
	default:Display_data=8'b11111111;
	endcase
end
endmodule

