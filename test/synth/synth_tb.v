`timescale 1 ns / 1 ns

`include "synth.v"

module synth_tb;
reg reset;
reg clk;
wire[3:0] question;

wire[3:0] answer;
wire result;

QuestionGeneration uut(.clk(clk), .questionToOBC(question));
localAnswer uut2(.question(question), .answer(answer));
CheckModule uut3(.answerOBC(answer), .result(result), .clk(clk));
StateMachine uut4(.reset(reset), .clk(clk), .answerOBC(answer));
initial begin
        $dumpfile("synth_tb.vcd");
        $dumpvars(0, synth_tb);

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