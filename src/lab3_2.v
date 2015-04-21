`timescale 1ns / 1ps

/*
** Basic vending machine
**
** See doc/problem.pdf for further information.
**
** @author: Emre Can Kucukoglu
** @mail: eckucukoglu@gmail.com
*/

module BasicVendingMachine(
		input [2:0] KeyPad,
		input [1:0] Mode,
		input CLK,
		input RESET,
		output reg [7:0] Credit,
		output reg [5:0] Coins);

	initial begin
		Credit = 8'd0;
		Coins = 6'b000000;
	end

	always @(posedge CLK or posedge RESET)
	begin
	
	if (RESET)
			begin
				Credit = 8'd0;
				Coins = 6'b000000;	
			end
	else
	begin
	
		case (Mode)
		2'b00: ;
		2'b01: 
		begin
			case (KeyPad)
			3'b000: if ((Credit + 1) <= 255)
						Credit = Credit+1;
			3'b001: if((Credit + 2) <= 255)
						Credit = Credit+2;
			3'b010: if((Credit+5) <= 255)
					Credit = Credit+5;
			3'b011: if((Credit + 10) <= 255)
					Credit = Credit+10;
			3'b100: if((Credit + 20) <= 255)
					Credit = Credit+20;
			3'b101: if((Credit + 50) <= 255)
					Credit = Credit+50;
			3'b110: if((Credit + 100) <= 255)
					Credit = Credit+100;
			3'b111: if((Credit + 200) <= 255)
					Credit = Credit+200;
			endcase
		end
		
		2'b10: 
		begin
			case (KeyPad)
			3'b000: if (Credit >= 220)
						Credit = Credit-220;
			3'b001: if(Credit  >= 120)
						Credit = Credit-120;
			3'b010: if(Credit  >= 180)
					Credit = Credit-180;
			3'b011: if(Credit  >= 55)
					Credit = Credit-55;
			3'b100: if(Credit  >= 13)
					Credit = Credit-13;
			3'b101: if(Credit  >= 25)
					Credit = Credit-25;
			3'b110: if(Credit  >= 85)
					Credit = Credit-85;
			3'b111: if(Credit  >= 75)
					Credit = Credit-75;
			endcase
		end
		
		2'b11:
		begin
			if ( Credit >= 50)
			begin
				Credit = Credit - 50;
				Coins = 6'b100000;
			end
			
			else if ( Credit >= 20)
			begin
				Credit = Credit - 20;
				Coins = 6'b010000;
			end
			
			else if ( Credit >= 10)
			begin
				Credit = Credit - 10;
				Coins = 6'b001000;
			end
			
			else if ( Credit >= 5)
			begin
				Credit = Credit - 5;
				Coins = 6'b000100;
			end
			
			else if ( Credit >= 2)
			begin
				Credit = Credit - 2;
				Coins = 6'b000010;
			end
			
			else if ( Credit >= 1)
			begin
				Credit = Credit - 1;
				Coins = 6'b000001;
			end
		
			else if ( Credit == 0)
				Coins = 6'b000000;
		
		end
		
		endcase
	end
	
	end
	
endmodule
