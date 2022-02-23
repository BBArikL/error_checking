//-----------------------------------------------------------------------------
//
// Title       : error_checking_tb
// Design      : error_checking
// Author      : GrosPoser
// Company     : Polytechnique
//
//-----------------------------------------------------------------------------
//
// File        : C:\Users\Dumont\Desktop\poly\PolyOrbit\error_checking\error_checking\src\error_checking_tb.v
// Generated   : Wed Oct 27 19:53:57 2021
// From        : interface description file
// By          : Itf2Vhdl ver. 1.22
//
//-----------------------------------------------------------------------------
//
// Description : 
//
//-----------------------------------------------------------------------------
`timescale 1 ns / 1 ps

//{{ Section below this comment is automatically maintained
//   and may be overwritten
//{module {error_checking_tb}}
module ErrorChecking_tb;
	
	//input wire [3:0] question
	reg [3:0] question;
	wire [3:0] answer; 
	 
	//localAnswer dut(question, answer);  
	integer i;
	initial begin
		for(i = 0; i <15; i = i+1)begin
			
			question = i;
			//answer = localAnswer dut(.question(question), .answer(answer));  

			#10;
		end	
		$stop;//stops simulation
	end
	

// -- Enter your statements here -- //

endmodule
