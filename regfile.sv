module regfile (input	[2:0]		DR, SR1_in, SR2_in,
					 input	[15:0]	D_in,
					 input				LD_REG, Reset,
					 output	[15:0]	SR1_out, SR2_out);

		reg [15:0] data_registers [0:7];

		always_ff @ (posedge Reset or posedge LD_REG)
			begin
				if (Reset)
				begin
					for (int i = 0; i < $size(data_registers); i++)
					begin
						data_registers[i] = 16'b0;
					end
				end
				else if (LD_REG)
					data_registers[DR] = D_in;
			end

		always_comb
			begin
				SR1_out = data_registers[SR1_in];
				SR2_out = data_registers[SR2_in];
			end

endmodule
