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
	//always (*) no reset=======================do not use (*){FINISH_ONE, STATE};
	//mux no rst
	always @(*) begin
		case(FINISH_ONE)
			1'b0 : begin
				case(STATE) 
					OUTPUT_SET_1 : begin
						xo = Ori_Point;
						yo = Ori_Point;
					end
					OUTPUT_SET_2 : begin
						xo = X1_2;
						yo = Ori_Point;
					end
					OUTPUT_SET_3 : begin
						xo = Ori_Point;
						yo = Y1_3;
					end
					default : begin
						xo = Zero_Point;
						yo = Zero_Point;
					end
				endcase
			end
			1'b1 : begin
				case(STATE) 
					OUTPUT_SET_1 : begin
						xo = Ori_Point;
						yo = Ori_Point;
					end
					OUTPUT_SET_2 :begin
						xo = X2_2;
						yo = Ori_Point;
					end
					OUTPUT_SET_3 : begin
						xo = Ori_Point;
						yo = Y2_3;
					end
					default : begin
						xo = Zero_Point;
						yo = Zero_Point;
					end
				endcase
			end
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
