`timescale 1ns / 1ps

/*
**
** This file is accompanied by the document
** "METU CENG232 FPGA Board User Manual"
**
** v1.0, 07-April-2012
**
** www.ceng.metu.edu.tr
*/

module Board232 (
	input mclk,
	input [3:0] btn,
	input [7:0] sw,
	output [7:0] led,
	output reg [6:0] seg,
	output reg [3:0] an,
	output dp,
	output [2:1] OutBlue,
	output [2:0] OutGreen,
	output [2:0] OutRed,
	output HS,
	output VS
    );

	// 7-segments, individual segments and dot
	// set to 0 to enable, 1 to disable a segment
	assign dp = 1'b1;
	
	// 7-segments, enable bits
	// set to 0 to enable, 1 to disable a display
	
	// LEDs
	assign led[7] = btn[3];  // Show Clock at leftmost LED
	assign led[6] = 1'b0;
	
	wire [7:0] lab3_credit;
	
	BasicVendingMachine BVM(
		sw[2:0],  			// input [2:0] KeyPad
		sw[7:6],			// input [1:0] Mode
		btn[3],				// input CLK
		btn[0],				// input RESET
		lab3_credit,		// output reg [7:0] Credit,
		led[5:0]			// output reg [5:0] Coins
		);
	
	
	//-----------------------------------------------------------------------------------------------
	//-----------------------------------------------------------------------------------------------
	// Rest of the file handles displaying of lab3_credit onto 7-segment displays
	//
	reg [18:0] sevenseg_refresh_counter;
	initial sevenseg_refresh_counter<= 0;
	always @(posedge mclk) sevenseg_refresh_counter = sevenseg_refresh_counter+1;
	
	wire [3:0] lab3_credit_ones;
	wire [3:0] lab3_credit_tens;
	wire [3:0] lab3_credit_hundreds;
	binary_to_BCD b2bcd(lab3_credit, lab3_credit_ones, lab3_credit_tens, lab3_credit_hundreds);
	reg [3:0] tmp_digit;
	
	always @(sevenseg_refresh_counter[18:17])
	begin
		case (sevenseg_refresh_counter[18:17])
			2'b00:
				begin
					an = 4'b1110;
					tmp_digit = lab3_credit_ones;
				end
			2'b01:
				begin
					an = 4'b1101;
					tmp_digit = lab3_credit_tens;
				end
			2'b10:
				begin
					an = 4'b1011;
					tmp_digit = lab3_credit_hundreds;
				end
			default:
				begin
					an = 4'b0111;
					tmp_digit = 0;
				end
		endcase
		
		case (tmp_digit)
			4'd0: seg <= ~7'h3F;
			4'd1: seg <= ~7'h06;
			4'd2: seg <= ~7'h5B;
			4'd3: seg <= ~7'h4F;
			4'd4: seg <= ~7'h66;
			4'd5: seg <= ~7'h6D;
			4'd6: seg <= ~7'h7D;
			4'd7: seg <= ~7'h07;
			4'd8: seg <= ~7'h7F;
			4'd9: seg <= ~7'h6F;
			default: seg <= ~7'b1111000;
		endcase
		
	end
	
	// VGA
	assign OutBlue = 0;
	assign OutGreen = 0;
	assign OutRed = 0;
	assign HS = 0;
	assign VS = 0;

endmodule


module binary_to_BCD(A,ONES,TENS,HUNDREDS);
	input [7:0] A;
	output [3:0] ONES, TENS, HUNDREDS;
	wire [3:0] c1,c2,c3,c4,c5,c6,c7;
	wire [3:0] d1,d2,d3,d4,d5,d6,d7;
	assign d1 = {1'b0,A[7:5]};
	assign d2 = {c1[2:0],A[4]};
	assign d3 = {c2[2:0],A[3]};
	assign d4 = {c3[2:0],A[2]};
	assign d5 = {c4[2:0],A[1]};
	assign d6 = {1'b0,c1[3],c2[3],c3[3]};
	assign d7 = {c6[2:0],c4[3]};
	binary_to_BCD_add3 m1(d1,c1);
	binary_to_BCD_add3 m2(d2,c2);
	binary_to_BCD_add3 m3(d3,c3);
	binary_to_BCD_add3 m4(d4,c4);
	binary_to_BCD_add3 m5(d5,c5);
	binary_to_BCD_add3 m6(d6,c6);
	binary_to_BCD_add3 m7(d7,c7);
	assign ONES = {c5[2:0],A[0]};
	assign TENS = {c7[2:0],c5[3]};
	assign HUNDREDS = {0,0,c6[3],c7[3]};
endmodule

module binary_to_BCD_add3(in,out);
	input [3:0] in;
	output [3:0] out;
	reg [3:0] out;
	always @ (in)
		case (in)
			4'b0000: out <= 4'b0000;
			4'b0001: out <= 4'b0001;
			4'b0010: out <= 4'b0010;
			4'b0011: out <= 4'b0011;
			4'b0100: out <= 4'b0100;
			4'b0101: out <= 4'b1000;
			4'b0110: out <= 4'b1001;
			4'b0111: out <= 4'b1010;
			4'b1000: out <= 4'b1011;
			4'b1001: out <= 4'b1100;
			default: out <= 4'b0000;
		endcase
endmodule
