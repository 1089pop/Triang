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
	//========REG_OF_STATE_DEFINE============================================
	reg [5:0] STATE;
	reg FINISH_ONE;
	//========X=AND=Y=VALUE=DEFINE===========================================
	wire [2:0] Ori_Point;
	wire [2:0] X1_2;
	wire [2:0] Y1_3;
	wire [2:0] X2_2;
	wire [2:0] Y2_3;
	wire [2:0] Zero_Point;
	assign Ori_Point = 3'b001;
	assign X1_2 = 3'b100;
	assign Y1_3 = 3'b111;
	assign X2_2 = 3'b111;
	assign Y2_3 = 3'b011;
	assign Zero_Point = 3'b000;
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
	//======================================================
	//always (*) no reset=======================do not use (*)
	//mux no rst
	always @(*) begin
		yo = Zero_Point;
		xo = Zero_Point;
		case({FINISH_ONE, STATE})
			{7'b0000010} : begin
				xo = Ori_Point;
				yo = Ori_Point;
			end
			{7'b0000100} : begin
				xo = X1_2;
				yo = Ori_Point;
			end
			{7'b0001000} : begin
				xo = Ori_Point;
				yo = Y1_3;
			end
			{7'b1000010} : begin
				xo = Ori_Point;
				yo = Ori_Point;
			end
			{7'b1000100} : begin
				xo = X2_2;
				yo = Ori_Point;
			end
			{7'b1001000} : begin
				xo = Ori_Point;
				yo = Y2_3;
			end
			default : begin
				yo = Zero_Point;
				xo = Zero_Point;
			end
		endcase
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
