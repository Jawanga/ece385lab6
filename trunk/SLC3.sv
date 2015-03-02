module SLC3 (input					Clk, Run, Reset, Continue,
				 output logic	[6:0]	HEX0, HEX1, HEX2, HEX3);
				 
		wire	[15:0]	Data_Bus;
		logic	[15:0]	IR_out;
		logic [19:0]	ADDR;
		logic				CE, UB, LB, OE, WE;
		logic				Reset_h;
		
		always_comb
		begin
		  Reset_h = ~Reset;
		end
		
		/*
		module CPU (input logic		[15:0]	S,
			input							Clk, Reset, Run, Continue,
			output logic	[11:0]	LED,
			output logic				CE, UB, LB, OE, WE,
			output logic	[15:0]	MAR_out, IR_out,
			output logic	[19:0]	ADDR,
			inout logic		[15:0]	Data);
		*/
		
		CPU		test(.S(), .Clk, .Run, .Reset, .Continue, .LED(), .CE, .UB, .LB, .OE, .WE, .IR_out, .ADDR, .Data(Data_Bus));
		
		/*		 
		module  Mem2IO ( 	input Clk, Reset,
					input [19:0]  A, 
					input CE, UB, LB, OE, WE,
					input [15:0]  Switches,
					inout [15:0] Data_CPU, Data_Mem,
					output [3:0]  HEX0, HEX1, HEX2, HEX3 );
		*/
		Mem2IO		mem (.Clk, .Reset(Reset_h), .A(ADDR), .CE, .UB, .LB, .OE, .WE, .Switches(S), .Data_CPU(Data_Bus), .Data_Mem(Data_Bus), .HEX0, .HEX1, .HEX2, .HEX3);
		/*

		module test_memory ( input 			Clk,
				 input          Reset, 
						inout  [15:0]  I_O,
						input  [19:0]  A,
						input          CE,
											UB,
											LB,
											OE,
											WE );
		*/
		test_memory		sample_mem(.Clk, .Reset(Reset_h), .I_O(Data_Bus), .A(ADDR), .CE, .UB, .LB, .OE, .WE);
		
		HexDriver        Hex0 (
                        .In0(IR_out[3:0]),
                        .Out0(HEX0) );
		HexDriver        Hex1 (
                        .In0(IR_out[7:4]),
                        .Out0(HEX1) );
		HexDriver        Hex2 (
                        .In0(IR_out[11:8]),
                        .Out0(HEX2) );
		HexDriver        Hex3 (
                        .In0(IR_out[15:12]),
                        .Out0(HEX3) );
								
endmodule
