`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   10:58:08 08/24/2015
// Design Name:   top
// Module Name:   D:/AfterSummerVerilog/TREE/top_test.v
// Project Name:  TREE
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: top
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module top_test;

	// Inputs
	reg clk;
	reg reset;

	// Outputs
	wire [7:0] Dis_data;
	wire [3:0] Dis_wich;

	// Instantiate the Unit Under Test (UUT)
	top uut (
		.clk(clk), 
		.reset(reset), 
		.Dis_data(Dis_data), 
		.Dis_wich(Dis_wich)
	);
always #5 clk = ~clk;
	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 0;
	
		// Wait 100 ns for global reset to finish
		#100;
      reset = 1;
		#10;
		reset = 0;
		// Add stimulus here

	end
      
endmodule

