`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:42:23 08/24/2015 
// Design Name: 
// Module Name:    top 
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
module top(clk, rst, Dis_data, Dis_wich
    );
	input clk, rst;
	
	output [7:0]Dis_data;
	output [3:0]Dis_wich;
	
	wire reset;
	assign reset = !rst;
	wire [1:0] seven_clk;
	wire count_clk , busy , nt , po ;
	reg [3:0] dig_a,dig_b,dig_c,dig_d;
	wire [2:0] x_re, y_re, xo, yo;
	//always (*) no reset=======================
	always @(*) begin
		if (reset) begin
			dig_a = 4'b1111;
			dig_b = 4'b1111;
			dig_c = 4'b1111;
			dig_d = 4'b1111;
		end
		else begin
			dig_a = 4'b1111;
			dig_b = 4'b1111;
			if (po) begin
				dig_a = {1'b0 , xo};
				dig_b = {1'b0 , yo};
			end
		end
	end
	//==========================================
	test_bench_remodule TBR(.clk(count_clk), .reset(reset) , .busy(busy) , .nt(nt) , .xo(x_re) , .yo(y_re) );
	triangle TRI(.clk(count_clk), .reset(reset) , .nt(nt) , .xi(x_re) , .yi(y_re) , .busy(busy) , .po(po) , .xo(xo) , .yo(yo) );

	Frequency_Divider FDV(.clk(clk), .rst(reset), .seven_clk(seven_clk), .count_clk(count_clk));
	Seven_Segment_4_bit_Display SS4D(.clk(seven_clk), .dig_a(dig_a), .dig_b(dig_b), .dig_c(dig_c), .dig_d(dig_d), .Dis_data(Dis_data), .Dis_wich(Dis_wich));

endmodule
