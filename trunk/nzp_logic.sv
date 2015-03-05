module nzp_logic (input		[15:0]		Data,
						input						LD_CC,
						output logic			n, z, p);

		always_ff @ (posedge LD_CC)
		begin
			if (LD_CC)
			begin
				if (Data == 16'h0000)
				begin
					n <= 1'b0;
					z <= 1'b1;
					p <= 1'b0;
				end
				else if (Data[15] == 1'b1)
				begin
					n <= 1'b1;
					z <= 1'b0;
					p <= 1'b0;
				end
				else if (Data[15] == 1'b0)
				begin
					n <= 1'b0;
					z <= 1'b0;
					p <= 1'b1;
				end
			end
		end
		
endmodule
