`timescale 1ns / 1ps

/*
** Basic vending machine testbench
**
** See doc/problem.pdf for further information.
**
** @author: Emre Can Kucukoglu
** @mail: eckucukoglu@gmail.com
*/

module lab3_testbench;

	// Inputs. For regs, initial value
	reg [2:0] KeyPad;
	reg [1:0] Mode;
	reg CLK;
	reg RESET;

	// Outputs
	wire [7:0] Credit;
	wire [5:0] Coins;

	// Instantiate the BasicVendingMachine
	BasicVendingMachine BVM (
		KeyPad, 
		Mode, 
		CLK, 
		RESET, 
		Credit, 
		Coins
	);
	
	always #5 CLK = ~CLK;

	initial begin
		// set monitor
		$monitor("Time=%t | Mode=%b Keypad=%b  | Coins=%b  Credit=%d ", $time, Mode, KeyPad, Coins, Credit);
	
		// Initialize Inputs
		KeyPad = 3'b000;
		Mode = 2'b00; // DO-NOTHING MODE
		CLK = 1;	// At 5, 15, 25 clk will become 1->0. At 10, 20, 30, 40, ... clk will become 0->1.
		RESET = 0;

		#2; // wait a little so that all inputs change at 12, 22, 32, ...
		
		//----------
		
		$display("Adding money");
		
		Mode = 2'b01;  // MONEY-DEPOSIT MODE
		KeyPad = 3'b101;  // 50 TL
		#10; // wait for 1 clock
		if (Credit != 50) $display("Failed to add 50TL into machine");
		
		// Test RESET
		RESET = 1;
		#1;
		if (Credit != 0) $display("*Asynchronous RESET* did not work, Credit > 0");
		RESET = 0;
		Mode = 2'b00; // DO-NOTHING MODE
		#9; // get back to sync with clock
		
		Mode = 2'b01;  // MONEY-DEPOSIT MODE
		KeyPad = 3'b110;  // 100 TL
		#10; // wait for 1 clock
		if (Credit != 100) $display("Failed to add 100TL into machine");
		
		KeyPad = 3'b010;  // 5 TL
		#10; // wait for 1 clock
		if (Credit != 105) $display("Failed to add 5TL into machine");
		
		$display("Getting items");
		
		Mode = 2'b10; // PRODUCT-RECEIVE MODE
		KeyPad = 3'b100;  // WATER 13TL
		#10; // wait for 1 clock
		if (Credit != 92) $display("Failed to get item WATER (worth 13TL) from machine");
		
		KeyPad = 3'b111;  // CRACKER 75TL
		#10; // wait for 1 clock
		if (Credit != 17) $display("Failed to get item CRACKER (worth 75TL) from machine");
		
		$display("Getting coins");
		Mode = 2'b11; // RETURN-REMAINDER MODE
		#10; // wait for 1 clock
		if (Coins != 6'b001000) $display("Failed to get 10TL coin");
		if (Credit != 7) $display("Credits wrong after getting 10TL coin");
		
		#10; // wait for 1 clock
		if (Coins != 6'b000100) $display("Failed to get 5TL coin");
		if (Credit != 2) $display("Credits wrong after getting 5TL coin");
		
		#10; // wait for 1 clock
		if (Coins != 6'b000010) $display("Failed to get 2TL coin");
		if (Credit != 0) $display("Credits wrong after getting 2TL coin");
		
		#10; // wait for 1 clock
		if (Coins != 6'b000000) $display("Machine returned extra coin");
		if (Credit != 0) $display("Credits wrong after trying to get extra coin");

	end
      
endmodule

