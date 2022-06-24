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
`include "./error_checking.v"

//{{ Section below this comment is automatically maintained
//   and may be overwritten
//{module {error_checking_tb}}
module ErrorChecking_tb;

	reg reset;
	reg clk;
	output[3:0] question;
	output override;
	input [3:0] answerOBC;
	wire result;
	reset=0;
	

	ErrorChecking uut1(question, answerOBC, override, reset, clk);


	initial begin
			$dumpfile("error_checking_tb.vcd");
			$dumpvars(0, error_checking_tb);
			
			clk = 1;
			#20;
			clk = 0;
			#20;
			clk = 1;
			#20;
			clk=0;
			#20;
			clk = 1;
			#20;
			$display("test coplete");
	end
	
endmodule

