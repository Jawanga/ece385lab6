module tristate_buffer(input logic	[15:0]	tri_in,
							  input						gate,
							  output logic	[15:0]	tri_out);
							  
		assign tri_out = (gate) ? tri_in : 16'bZZZZZZZZZZZZZZZZ;
		
endmodule
