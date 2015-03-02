module plus1(input logic	[15:0]	PC_in,
				 output logic	[15:0]	PC_out);
				 
		assign PC_out = PC_in + 1'b1;
		
endmodule
