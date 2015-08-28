`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:37:55 04/20/2015 
// Design Name: 
// Module Name:    seven_segment 
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
