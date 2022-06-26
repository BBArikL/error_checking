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
// 	TODO: 1) structurer le code de fpga en 2 modules, 1 pour l'envoie et l;a reception, l'autre pour l'état selon la/les réponses
//	 	  2) attacher le module de réponse avec le module I2C, 
//		  3) Faire le code sur le OBC par rapport à la tâche du FPGA
//-----------------------------------------------------------------------------
`timescale 1 ns / 1 ps

//high level module that communicates directly with OBC
module QuestionGeneration(output[3:0] question, input clk);


	reg[3:0] localQuestion;	

	task generate_question;
		begin
			localQuestion = $random;
		end
	endtask

	always@(posedge clk)
		begin
			generate_question;
		end
	assign question = localQuestion;	
answerOBC
endmodule


//basically le errorchecking module
//Module that determines action to do according to the obc's state
module StateMachine(input reset,input clk, input[3:0] answerOBC, input [3:0] question, output override);
	
	
	reg[1:0] present_state, next_state;

	integer correctAnswerCount;
	integer incorrectAnswerCount;
	
	localparam checking = 2'b00;
	localparam reset = 2'b01;
	localparam shutdown = 2'b10;//va devoir envoyer un signal au OBC 1 de shutdown et  allumer OBC2 
	reg result; 

	//Module qui calcule la reponse  a la question localement
	//update la valeur de answer chaque fois que la question change
	task automatic local_answer;
		begin
			answer[0] = ~question[0];
			answer[1] = question[0] ^ question[1];
			answer[2] = question[1] ^ question[2];
			answer[3] = question[2] ^ question[3];
		end
	endtask

	task automatic check_function;
		begin
			// Gets our local answer
			local_answer();
			// Compare answer and gives back result
			result = (answer == answerOBC) ? 1 : 0;
		end
	endtask
	
	//state register, updates state on clk tik. Reset if reset is high or if a new answer arrived from the obc
	always@(posedge clk, posedge reset, answerOBC)
		begin
			present_state = (reset) ? sendQuestion : next_state;

		end 
		
	//based on present state do something
	always@(present_state)
		begin
			case(present_state)
				checking:
				begin

					check_function();

					if(result){
						correctAnswerCount = 1 + correctAnswerCount;
					} else {
						incorrectAnswerCount = 1 + incorrectAnswerCount;
					}

					integer succesRate = correctAnswerCount / (incorrectAnswerCount + correctAnswerCount)

					//if condition to modify
					if(10 < correctAnswerCount && succesRate > 0.9){
						next_state = reset;
					} else if(10 < incorrectAnswerCount && succesRate < 0.1){
						next_state = shutdown;
						else {
							next_state = checking;
						}
					}
				end
				reset:
				begin
					
					//one last check, might aswell because to change state a question has to have been asked
					check_function()

					if(!result){
						incorrectAnswerCount = 1 + incorrectAnswerCount;
						next_state = checking;
						break;
					}

					correctAnswerCount = 0;
					incorrectAnswerCount = 0;
					next_state = checking;
					
				end
				shutdown:
					begin
						override = 1;
					end	
			endcase			   	
		end
endmodule