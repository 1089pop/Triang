`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:32:36 08/21/2015 
// Design Name: 
// Module Name:    Triangle 
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
module triangle (clk, reset, nt, xi, yi, busy, po, xo, yo);
  input  clk, reset, nt;
	input  [2:0]xi, yi;
	output reg busy, po;
	output reg[2:0]xo, yo;

	parameter INITIAL_IDLE = 2'b00;
	parameter LOAD_NODE_LS = 2'b01;
	parameter RCALCULATING = 2'b10;
	parameter FINISH_CALCU = 2'b11;

//	parameter ONLY_X_IS_LESS_THAN_MAX =2'b
	parameter ONLY_Y_IS_LESS_THAN_MAX = 3'b101;
	parameter CASE_X_IS_LESS_THAN_MAX = 3'b11X;
	parameter CASE_LOAD_X_AND_Y_VALUE = 3'b0XX ;

	parameter PACKED_SIZED_OF_ARRAY = 2;
	parameter SIZE_OF_UNPACKED_LEND = 3;

	reg [PACKED_SIZED_OF_ARRAY:0] x [1:SIZE_OF_UNPACKED_LEND] ;
	reg [PACKED_SIZED_OF_ARRAY:0] y [1:SIZE_OF_UNPACKED_LEND] ;

	reg [1:0] SEL, NOW_STATE, NEXT_STATE;

	wire START_CALCU;
	wire X_IS_LESS_THAN_MAX;
	wire Y_IS_LESS_THAN_MAX;
	
	wire [5:0]LEFT_VALUE;
	wire [5:0]RIGH_VALUE;

	always @(posedge clk or posedge reset) begin
		if (reset) begin
			// reset
			SEL <= 0;
			x[1] <= 0;
			x[2] <= 0;
			x[3] <= 0;
			y[1] <= 0;
			y[2] <= 0;
			y[3] <= 0;
		end
		else if (nt) begin
			SEL <= 2'b01;
			x[1] <= xi;
			y[1] <= yi;
		end
		else begin
			case(SEL)
				2'b01 : begin
					SEL <= 2'b10;
					x[2] <= xi;
					y[2] <= yi;
				end
				2'b10 : begin
					SEL <= 2'b11;
					x[3] <= xi;
					y[3] <= yi;
				end
			endcase
		end
	end


	assign START_CALCU = NOW_STATE == RCALCULATING;
	assign X_IS_LESS_THAN_MAX = xo < x[2];
	assign Y_IS_LESS_THAN_MAX = yo < y[3];

	always @(negedge clk or posedge reset) begin
		if (reset) begin
			// reset
			xo <= 0;
			yo <= 0;
		end
		else begin
			casex({START_CALCU,X_IS_LESS_THAN_MAX,Y_IS_LESS_THAN_MAX})
				CASE_X_IS_LESS_THAN_MAX : begin
					xo <= xo + 1'b1;
				end
				ONLY_Y_IS_LESS_THAN_MAX : begin
					xo <= x[1];
					yo <= yo + 1'b1;
					 
				end
				CASE_LOAD_X_AND_Y_VALUE : begin
					xo <= x[1];
					yo <= y[1];
				end
			endcase
		end
	end

	//=======================================================================
	//state update
	always @(negedge clk or posedge reset) begin
		if (reset) begin
			// reset
			NOW_STATE <= INITIAL_IDLE;
		end
		else begin
			NOW_STATE <= NEXT_STATE;
		end
	end
	//NEXT_STATE is what
	always @(*) begin
		NEXT_STATE = NOW_STATE;
		case(NOW_STATE)
			INITIAL_IDLE : begin
				if(nt)begin
					NEXT_STATE = LOAD_NODE_LS;
				end
			end
			LOAD_NODE_LS : begin
				if(SEL == 2'b11)begin
					NEXT_STATE = RCALCULATING;
				end
			end
			RCALCULATING : begin
				if({!X_IS_LESS_THAN_MAX,!Y_IS_LESS_THAN_MAX} == 2'b11)begin
					NEXT_STATE = INITIAL_IDLE;
				end
			end
		endcase
	end
	//=======================================================================

	assign LEFT_VALUE = (x[2]-xo)*(y[3]-y[2]);
	assign RIGH_VALUE = (yo-y[2])*(x[2]-x[3]);
	always @(*) begin
		po = 0;
		case(NOW_STATE)
			RCALCULATING : begin
				if(LEFT_VALUE >= RIGH_VALUE) begin
					po = 1;
				end
			end
		endcase
	end

	always @(*) begin
		busy = 0;
		case(NOW_STATE)
			LOAD_NODE_LS : begin
				if(!nt)busy = 1;
			end
			RCALCULATING : busy = 1;
		endcase
	end
endmodule
