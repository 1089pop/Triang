`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   10:15:53 08/24/2015
// Design Name:   test_bench_remodule
// Module Name:   D:/AfterSummerVerilog/TREE/tbntb.v
// Project Name:  TREE
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: test_bench_remodule
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tbntb;

	// Inputs
	reg clk;
	reg reset;
	reg busy;

	// Outputs
	wire nt;
	wire [2:0] xo;
	wire [2:0] yo;

	// Instantiate the Unit Under Test (UUT)
	test_bench_remodule uut (
		.clk(clk), 
		.reset(reset), 
		.busy(busy), 
		.nt(nt), 
		.xo(xo), 
		.yo(yo)
	);
always #10 clk = ~clk;
	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 0;
		busy = 0;
		
		// Wait 100 ns for global reset to finish
		#100;
      reset = 1;
		#10;
		reset = 0;
		#20;
		busy = 1;
		#100;
		busy = 0;
		#20;
		busy = 1;
		#50;
		// Add stimulus here

	end
      
endmodule

