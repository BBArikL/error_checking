//-----------------------------------------------------------------------------
//
// Title       : error_checking
// Design      : error_checking
// Author      : Louis
// Company     : Polytechnique
//
//-----------------------------------------------------------------------------
//
// File        : C:\Users\Dumont\Desktop\poly\PolyOrbit\error_checking\error_checking\src\error_checking.v
// Generated   : Thu Oct 14 19:13:03 2021
// From        : interface description file
// By          : Itf2Vhdl ver. 1.22
//
//-----------------------------------------------------------------------------
//
// Description : 
//
//-----------------------------------------------------------------------------
`timescale 1 ns / 1 ps
	

	
//module QuestionGeneration(input clk);
	
	//reg [3:0] question;
				
	//assign question = 4; //genrerate a bits question
		
//endmodule

//Module qui calcule la reponse  a la question localement
//update la valeur de answer chaque fois que la question change
module localAnswer(input[3:0] question, output[3:0] answer);
		assign answer[0] = ~question[0];
		assign answer[1] = question[0] ^ question[1];
		assign answer[2] = question[1] ^ question[2];
		assign answer[3] = question[2] ^ question[3];
endmodule

//Module qui verifie si la reponse local est la meme que celle du obc
module CheckFunction(input[3:0] answerOBC, output result,input[3:0] question);

	wire[3:0] answer;
	
	// Gets our local answer
	localAnswer l1(question, answer);

	// Define how we compare the two answers
	function reg answerCompare(input [3:0] answer,input [3:0] answerOBC);
		begin
			answerCompare = (answer == answerOBC) ? 1 : 0;
		end
	endfunction
	
	// Compare answer and gives back result
	assign result = answerCompare(answer,answerOBC);

endmodule


//high level module that communicates directly with OBC
module ErrorChecking(input[3:0] question, input [3:0] answerOBC, output override, output reset);
	wire [3:0] answer;


	//QuestionGeneration q(.question(question), .clk(clk));
	
	//CheckFunction  check(.answer(answer), .answerOBC(answerOBC), .result(result));
		
endmodule


//basically le errorchecking module
//Module that determines action to do according to the obc's state
module StateMachine(input reset,input clk);
	
	
	reg[1:0] present_state, next_state;

	
	integer i;
	integer correctAnswerCount;
	localparam start = 2'b00;
	localparam checking = 2'b01;
	localparam valid = 2'b10;
	localparam shutdown = 2'b11;//va devoir envoyer un signal au OBC 1 de shutdown et  allumer OBC2 
	wire result; //Result
	wire [3:0] answer = 3'b000;
	wire [3:0] answerOBC = 3'b000;
	
	task check_function(input[3:0] answer, input[3:0] answerOBC, output result);
		begin
			// Check_function
		end
	endtask
	
	//state register, updates state on clk tik. Reset if reset is high 
	always@(posedge clk, posedge reset)
		begin
			present_state = (reset) ? start : next_state;
		end 
		
	//based on present state do something
	always@(present_state)
		begin
			case(present_state)
				start:
				begin
					check_function(answer, answerOBC, result);
					
					if(result)
						next_state = valid;
					else
						next_state = checking;
				end
				
				checking:
				begin
					//comportement a voir
					//1: envoyer serie de question
					//stocker reponse dans un buffer, puis analyser le buffer
					//2: envoyer serie de question si toute les autre son bonne passer a valid sinon un autre etat de validation de pattern
					correctAnswerCount = 0;
					for(i=0; i < 10; i = i + 1)begin
						//envoyer question
						check_function(answer, answerOBC, result);
						
						if(result)
							correctAnswerCount = correctAnswerCount + 1;
					end

					/* 
					Maybe we should add a minimal treshold of correct answers (7) 
					and let it pass but also increment another variable that, if
					it goes above a certain point (10 times the board has failed for exemple),
					now we put it to shutdown. 
					*/ 
					if(correctAnswerCount == 10)
						next_state = valid;
					else
						next_state = shutdown; //maybe a little extreme but to see
				end
				
				shutdown:
				begin
					//devrait etre certain
					//Shutdown OBC
				end	
			endcase			   	
		end
endmodule

module ErrorChecking_tb ();
	
	//input wire [3:0] question
	reg [3:0] question;
	wire [3:0] answer;
	wire override; // Placeholders
	wire reset;
	 
	ErrorChecking dut(question, answer, override, reset);  
	integer i;
	initial begin
		for(i = 0; i <15; i = i+1)begin
			
			question = i;
			#10;
		end	
		$stop;//stops simulation
	end
	

// -- Enter your statements here -- //

endmodule