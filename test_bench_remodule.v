`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    07:51:54 08/24/2015 
// Design Name: 
// Module Name:    test_bench_remodule
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//Type1 : triangle reset is in global
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module test_bench_remodule(clk, reset, busy, nt, xo, yo
    );
	input  clk, reset, busy;
	output reg nt;
	output reg [2:0] xo, yo;
	//========STATE=DEFINE===================================================
	parameter INITIAL_IDLE	= 6'b000001;
	parameter OUTPUT_SET_1	= 6'b000010;
	parameter OUTPUT_SET_2	= 6'b000100;
	parameter OUTPUT_SET_3	= 6'b001000;
	parameter WAIT_UTL_FIN 	= 6'b010000;
	parameter STRUE_FINISH 	= 6'b100000;
	//========NT=MASK========================================================
	parameter NT_PULL_UP	= 6'b000010;
	//========X=AND=Y=VALUE=DEFINE===========================================
	
	//reg => wire (vallue is const
	reg [2:0] reg_X1 [1:3];
	reg [2:0] reg_Y1 [1:3];

	reg [2:0] reg_X2 [1:3];
	reg [2:0] reg_Y2 [1:3];

	reg [5:0] STATE;

	reg FINISH_ONE;
	
	//state update
	always @(negedge clk or posedge reset) begin
		if (reset) begin
			// reset
			STATE 		<= INITIAL_IDLE;
			FINISH_ONE 	<= 1'b0;
		end
		else begin
			case(STATE)
				INITIAL_IDLE : begin
					STATE <= OUTPUT_SET_1;
				end
				OUTPUT_SET_1 : begin
					STATE <= OUTPUT_SET_2;
				end
				OUTPUT_SET_2 : begin
					STATE <= OUTPUT_SET_3;
				end
				OUTPUT_SET_3 : begin
					STATE <= WAIT_UTL_FIN;
				end
				WAIT_UTL_FIN : begin
					case({!busy,FINISH_ONE})
						2'b10 : begin
							STATE <= INITIAL_IDLE;
							FINISH_ONE <= 1'b1;
						end	
						2'b11 : begin
							STATE <= STRUE_FINISH;
						end
					endcase
					
				end
			endcase
		end
	end
	// use assign 
	always @(posedge clk or posedge reset) begin
		if (reset) begin
			// reset
			reg_X1[1] <= 3'b001;
			reg_Y1[1] <= 3'b001;
			reg_X1[2] <= 3'b100;
			reg_Y1[2] <= 3'b001;
			reg_X1[3] <= 3'b001;
			reg_Y1[3] <= 3'b111;
			reg_X2[1] <= 3'b001;
			reg_Y2[1] <= 3'b001;
			reg_X2[2] <= 3'b111;
			reg_Y2[2] <= 3'b001;
			reg_X2[3] <= 3'b001;
			reg_Y2[3] <= 3'b011;
		end
	end
	//======================================================
	//always (*) no reset=======================do not use (*)
	//mux no rst
	always @(*) begin
		if (reset) begin
			// reset
			xo = 3'b000;
			yo = 3'b000;
		end
		else begin
			xo = 3'b000;
			yo = 3'b000;
			case({FINISH_ONE, STATE})
				{7'b0000010} : begin
					xo = reg_X1[1];
					yo = reg_Y1[1];
				end
				{7'b0000100} : begin
					xo = reg_X1[2];
					yo = reg_Y1[2];
				end
				{7'b0001000} : begin
					xo = reg_X1[3];
					yo = reg_Y1[3];
				end
				{7'b1000010} : begin
					xo = reg_X2[1];
					yo = reg_Y2[1];
				end
				{7'b1000100} : begin
					xo = reg_X2[2];
					yo = reg_Y2[2];
				end
				{7'b1001000} : begin
					xo = reg_X2[3];
					yo = reg_Y2[3];
				end
				endcase
		end
	end
	//======================================================

	//=======================================================================

	always @(*) begin
		if (reset) begin
			// reset
			nt = 0;
		end
		else begin
			nt = 0;
			casex(STATE)
				NT_PULL_UP : begin
					if (!busy)
						nt = 1;
				end
			endcase
		end
	end
endmodule
