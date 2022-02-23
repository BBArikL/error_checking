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
	
//send question to obc
module sendToOBC(input[3:0] localquestion, output[3:0] question);
	assign question = localquestion;
endmodule

module QuestionGeneration(input clk, output[3:0] questionToOBC);
	
	reg [3:0] question;
	always@(posedge clk)
		begin
				
			question = $random; //genrerate a bits question  with $random
		end
	assign questionToOBC = question;
	sendToOBC send(.localquestion(question), .question(questionToOBC));
		
endmodule

//Module qui calcule la reponse  a la question localement
//update la valeur de answer chaque fois que la question change
module localAnswer(input[3:0] question, output[3:0] answer);
		assign answer[0] = ~question[0];
		assign answer[1] = question[0] ^ question[1];
		assign answer[2] = question[1] ^ question[2];
		assign answer[3] = question[2] ^ question[3];
endmodule

//Module qui verifie si la reponse local est la meme que celle du obc
	
module CheckModule(input[3:0] answerOBC, output result,input clk);


wire[3:0] answer;
wire[3:0] question;

QuestionGeneration q1(.clk(clk), .questionToOBC(question));


//generate local answer
localAnswer l1(question, answer);

	//compare OBC to local
	function reg answerCompare(input [3:0] answer,input [3:0] answerOBC);
		begin
			if(answer == answerOBC)
				answerCompare <= 1;
			else
				answerCompare <= 0;
		end
	endfunction
	//output result
	assign result = answerCompare(answer,answerOBC);

endmodule	
//high level module that communicates directly with OBC
module ErrorChecking( input[3:0] question, input [3:0] answerOBC, output override, output reset);
 			
wire [3:0] answer;


	
			
																																										   

	//QuestionGeneration q(.question(question), .clk(clk));
	

	
	//CheckFunction  check(.answer(answer), .answerOBC(answerOBC), .result(result));
		
endmodule


//basically le errorchecking module
//Module that determines action to do according to the obc's state
module StateMachine(input reset,input clk, input[3:0] answerOBC);
	
	
	reg[1:0] present_state, next_state;

	
	integer i;
	integer correctAnswerCount;
	localparam start = 2'b00;
	localparam checking = 2'b01;
	localparam valid = 2'b10;
	localparam shutdown = 2'b11;//va devoir envoyer un signal au OBC 1 de shutdown et  allumer OBC2 
	reg result;//
	wire question; 

	
	
	//state register, updates state on clk tik
	always@(posedge clk,posedge reset)
		begin
				if(reset)
					present_state = 2'b00;//b00 start state
				else
					present_state = next_state;
		end
	
	//based on present state do something
	always@(present_state)
		begin  
			case(present_state)
				start:
				begin	
					CheckModule  check1(answerOBC, result, clk);
					if(result == 1)
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
					for(i=0; i < 10; i = i + 1)begin
						//envoyer question
						//CheckModule check2(.answer(answer), .answerOBC(answerOBC), .result(result));
						if(result)
							correctAnswerCount = correctAnswerCount + 1;
						if(correctAnswerCount == 10)
							next_state = valid;
						else
							next_state = shutdown; //maybe a little extreme but to see
						
						
					end
					
						
			
				end
				//devrait etre certain
				shutdown:
				begin
				end	
			endcase			   	
		end
endmodule




