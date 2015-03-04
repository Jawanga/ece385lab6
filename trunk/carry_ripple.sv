module carry_ripple (input		[15:0] A, B,
							output	[15:0] S,
							output			 c_out);
							
		logic C4, C8, C12;
		
		ADDER4 RA_1(.A(A[3:0]), .B(B[3:0]), .S(S[3:0]), .c_in(0), .c_out(C4));
		ADDER4 RA_2(.A(A[7:4]), .B(B[7:4]), .S(S[7:4]), .c_in(C4), .c_out(C8));
		ADDER4 RA_3(.A(A[11:8]), .B(B[11:8]), .S(S[11:8]), .c_in(C8), .c_out(C12));
		ADDER4 RA_4(.A(A[15:12]), .B(B[15:12]), .S(S[15:12]), .c_in(C12), .c_out(c_out));
		
endmodule
