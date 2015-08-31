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
	parameter INITIAL_IDLE	= 3'b000;
	parameter OUTPUT_SET_1	= 3'b001;
	parameter OUTPUT_SET_2	= 3'b010;
	parameter OUTPUT_SET_3	= 3'b011;
	parameter WAIT_UTL_FIN 	= 3'b100;
	parameter STRUE_FINISH 	= 3'b101;
	//========NT=MASK========================================================
	parameter NT_PULL_UP	= 3'b001;
	//========REG_OF_STATE_DEFINE============================================
	reg [2:0] STATE;
	reg FINISH_ONE;
	//=======================================================================
	wire [3:0] Case_SEL;
	assign Case_SEL = {FINISH_ONE, STATE};
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
		case(Case_SEL) 
			4'b0001 :
				xo = Ori_Point;
			4'b0010 :
				xo = X1_2;
			4'b0011 :
				xo = Ori_Point;
			4'b1001 :
				xo = Ori_Point;
			4'b1010 :
				xo = X2_2;
			4'b1011 :
				xo = Ori_Point;
			default : 
				xo = Zero_Point;
		endcase
	end
	always @(*) begin
		case(Case_SEL) 
			4'b0001 :
				yo = Ori_Point;
			4'b0010 :
				yo = Ori_Point;
			4'b0011 :
				yo = Y1_3;
			4'b1001 :
				yo = Ori_Point;
			4'b1010 :
				yo = Ori_Point;
			4'b1011 :
				yo = Y2_3;
			default : 
				yo = Zero_Point;
		endcase
	end
	//======================================================

	//=======================================================================

	always @(*) begin
		case(STATE)
			NT_PULL_UP : nt = (!busy) ? 1'b1 : 1'b0;
			default : nt = 1'b0;
		endcase
	end
endmodule
