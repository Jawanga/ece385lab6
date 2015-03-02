module ALU (input	[15:0]	A_in, B_in,
			input	[1:0]	F,
			output	[15:0]	F_A_B);

		always_comb
			begin
				unique case(F)
					2'b00:		F_A_B = A_In + B_In;
					2'b01: 		F_A_B = A_In & B_In;
					2'b10: 		F_A_B = ~A_In;
					2'b11:	 	F_A_B = 1'b0;
					default: 	F_A_B = A_In;
				endcase
			end

endmodule
