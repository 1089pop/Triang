`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:53:09 05/04/2015 
// Design Name: 
// Module Name:    Seven_Segment_4_bit_Display 
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
module Seven_Segment_4_bit_Display(input [1:0]clk,
											  input [3:0]dig_a,dig_b,dig_c,dig_d,
											 output [7:0]Dis_data,
											 output reg [3:0]Dis_wich
    );
reg [3:0]Dis_rewire;
always@(clk)
begin
	case(clk)
		2'b00:Dis_rewire=dig_a;
		2'b01:Dis_rewire=dig_b;
		2'b10:Dis_rewire=dig_c;
		2'b11:Dis_rewire=dig_d;
		default:Dis_rewire=4'b1111;
	endcase
end
always@(clk)
begin
	case(clk)
		2'b00:Dis_wich=4'b1110;
		2'b01:Dis_wich=4'b1101;
		2'b10:Dis_wich=4'b1011;
		2'b11:Dis_wich=4'b0111;
		default:Dis_wich=4'b1111;
	endcase
end
seven_segment DIg(Dis_rewire,Dis_data);
endmodule
