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
	wire[3:0] question;
	input wire [3:0] answer;
	output override;
	reg [3:0] answerOBC;
	wire result;
	

	QuestionGeneration uut1(question, clk);

	StateMachine uut2(.reset(reset), .clk(clk), .answerOBC(answerOBC), .question(question), .override(override));
	//override should always be 0
	//after 10 iterations the state should change from checking to reset.

	//	always@(posedge clk)
	task automatic local_answer;
		begin
			answerOBC[0] = ~question[0];
			answerOBC[1] = question[0] ^ question[1];
			answerOBC[2] = question[1] ^ question[2];
			answerOBC[3] = question[2] ^ question[3];
		end
	endtask

	initial begin
			$dumpfile("error_checking_tb.vcd");
			$dumpvars(0, ErrorChecking_tb);
			local_answer();
			clk = 0;
			clk = 1;
			//answer = answerOBC;
			#10;
			clk = 0;
			local_answer();
			#10;
			clk = 1;
			local_answer();
			#10;
			clk= 0;
			#10;
			local_answer();
			clk = 1;
			#10;
			clk = 0;
			#10;
			local_answer();
			clk = 1;
			#10;
			clk= 0;
			#10;
			local_answer();
			clk = 1;
			#10;
			clk = 0;
			#10;
			local_answer();
			clk = 1;
			#10;
			clk= 0;
			#10;
			local_answer();
			clk = 1;
			#10;
			
			$display("test coplete");
	end
	
endmodule

