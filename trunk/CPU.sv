module CPU (input							Clk, Reset, Run, Continue,
				output logic	[15:0]	LED,
				output logic				CE, UB, LB, OE, WE,
				output logic	[19:0]	ADDR,
				//output logic	[6:0]		HEX0, HEX1, HEX2, HEX3,
				inout wire		[15:0]	Data);
		
		logic					Reset_h, Continue_h, Run_h;
		logic					LD_MAR, LD_MDR, LD_IR, LD_BEN, LD_CC, LD_REG, LD_PC;
		logic		[1:0]		PCMUXselect, DRMUXselect, SR1MUXselect, ADDR2MUXselect;
		logic					SR2MUXselect, ADDR1MUXselect, MARMUXselect;
		logic		[15:0]	PC_w, PC_x, PC_plus1;
		logic		[15:0]	PCd_in, PCd_out;
		logic		[15:0]	MDR_out;
		logic					GatePC, GateMDR, GateALU, GateMARMUX;
		logic		[15:0]	IR_out;
		logic		[2:0]		DR, SR1_in;
		logic		[15:0]	SR1_out, SR2_out;
		logic		[15:0]	ALUA_in, ALUB_in, ALU_out;
		logic		[15:0]	ADDR1_out, ADDR2_out;
		logic		[1:0]		ALUK;
		logic					n, z, p;
		logic		[15:0]	adder_out;
		logic		[15:0]	MARMUX_out;
		logic		[15:0]	ADDR_sum;
		logic					BEN_out;
		
		//assign	PC_w = Data;
		
		always_comb
		begin
			  Reset_h = ~Reset;  // The push buttons are active low, but active-high logic is easier
			  Continue_h = ~Continue;  // to work with
			  Run_h = ~Run;
		end
		
		/*
		module ISDU ( 	input	Clk, 
                        Reset,
						Run,
						Continue,
						ContinueIR,
									
				input [3:0]  Opcode, 
				input        IR_5,
				  
				output logic 	LD_MAR,
								LD_MDR,
								LD_IR,
								LD_BEN,
								LD_CC,
								LD_REG,
								LD_PC,
									
				output logic 	GatePC,
								GateMDR,
								GateALU,
								GateMARMUX,
									
				output logic [1:0] 	PCMUX,
				                    DRMUX,
									SR1MUX,
				output logic 		SR2MUX,
									ADDR1MUX,
				output logic [1:0] 	ADDR2MUX,
				output logic 		MARMUX,
				  
				output logic [1:0] 	ALUK,
				  
				output logic 		Mem_CE,
									Mem_UB,
									Mem_LB,
									Mem_OE,
									Mem_WE
				)
		*/
		
		ISDU		isdu(.Clk, .Reset(Reset_h), .Run(Run_h), .Continue(), .ContinueIR(Continue_h), .Opcode(IR_out[15:12]), .IR_5(IR_out[4]), .BEN_out,
						  .LD_MAR, .LD_MDR, .LD_IR, .LD_BEN, .LD_CC, .LD_REG, .LD_PC, .GatePC, .GateMDR, .GateALU, .GateMARMUX, .PCMUX(PCMUXselect), .DRMUX(DRMUXselect),
						  .SR1MUX(SR1MUXselect), .SR2MUX(SR2MUXselect), .ADDR1MUX(ADDR1MUXselect), .ADDR2MUX(ADDR2MUXselect), .MARMUX(MARMUXselect), .ALUK, .Mem_CE(CE),
						  .Mem_UB(UB), .Mem_LB(LB), .Mem_OE(OE), .Mem_WE(WE));
		/*
		module reg_16 (input Clk, Reset, Load,
              input  [15:0]  D,
              output logic [15:0]  Data_Out);
		*/
		
		reg_16		MAR(.Clk, .Reset(Reset_h), .Load(LD_MAR), .D(Data), .Data_Out(ADDR[15:0]));
		reg_16		MDR(.Clk, .Reset(Reset_h), .Load(LD_MDR), .D(Data), .Data_Out(MDR_out));
		reg_16		PC(.Clk, .Reset(Reset_h), .Load(LD_PC), .D(PCd_in), .Data_Out(PCd_out));
		reg_16		IR(.Clk, .Reset(Reset_h), .Load(LD_IR), .D(Data), .Data_Out(IR_out));
		reg_1			BEN_reg(.Clk, .Reset(Reset_h), .Load(LD_BEN), .D(BEN), .Data_Out(BEN_out));
		
		/*
		module plus1(input logic	[15:0]	PC_in,
				 output logic	[15:0]	PC_out
		*/

		plus1		increment(.PC_in(PCd_out), .PC_out(PC_plus1));
		
		/*
		module four_one_mux_16(input 	[15:0] 	w, x, y, z,
					input		[1:0]	select,
					output	[15:0] 	out);
		*/
		
		four_one_mux_16	PCMUX(.w(PC_plus1), .x(ADDR_sum), .y(Data), .z(), .select(PCMUXselect), .out(PCd_in));
		four_one_mux_3		DRMUX(.w(IR_out[11:9]), .x(3'b110), .y(3'b111), .z(), .select(DRMUXselect), .out(DR));
		four_one_mux_3		SR1MUX(.w(IR_out[11:9]), .x(IR_out[8:6]), .y(3'b110), .z(), .select(SR1MUXselect), .out(SR1_in));
		two_one_mux_16		SR2MUX(.x(SR2_out), .y(16'($signed(IR_out[4:0]))), .select(SR2MUXselect), .out(ALUB_in));
		two_one_mux_16		ADDR1MUX(.x(PCd_out), .y(SR1_out), .select(ADDR1MUXselect), .out(ADDR1_out));
		four_one_mux_16	ADDR2MUX(.w(16'h0000), .x(16'($signed(IR_out[5:0]))), .y(16'($signed(IR_out[8:0]))), .z(16'($signed(IR_out[10:0]))), .select(ADDR2MUXselect), .out(ADDR2_out));
		two_one_mux_16		MARMUX(.x(ADDR_sum), .y({8'b00000000, IR_out[7:0]}), .select(MARMUXselect), .out(MARMUX_out));
		
		/*
		module tristate_buffer(input logic	[15:0]	tri_in,
							  input						gate,
							  output logic	[15:0]	tri_out);
		*/
		tristate_buffer	PC_tri(.tri_in(PCd_out), .gate(GatePC), .tri_out(Data));
		tristate_buffer	MARMUX_tri(.tri_in(MARMUX_out), .gate(GateMARMUX), .tri_out(Data));
		tristate_buffer	MDR_tri(.tri_in(MDR_out), .gate(GateMDR), .tri_out(Data));
		tristate_buffer	ALU_tri(.tri_in(ALU_out), .gate(GateALU), .tri_out(Data));
		
		/*
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
        */
		
		/*
		module regfile (input	[2:0]	DR, SR1_in, SR2_in,
				input	[15:0]	D_in,
				input			LD_REG, Reset,
				output	[15:0]	SR1_out, SR2_out);
		*/

		regfile			regf(.DR, .SR1_in, .SR2_in(IR_out[2:0]), .D_in(Data), .LD_REG, .Reset(Reset_h), .SR1_out, .SR2_out);
		
		/*
		module ALU (input		[15:0]	A_In, B_In,
				input		[1:0]		F,
				output	[15:0]	F_A_B);
		*/
		ALU				alu(.A_In(ALUA_in), .B_In(ALUB_in), .F(ALUK), .F_A_B(ALU_out));
		
		/*
		module nzp_logic (input		[15:0]	Data,
						input					LD_CC,
						output				n, z, p)
		*/
		
		nzp_logic		nzp(.*);
		
		assign LED = IR_out[15:0];
		assign ALUA_in = SR1_out;
		assign ADDR_sum = ADDR1_out + ADDR2_out;
		assign BEN = (n & IR_out[11]) || (z & IR_out[10]) || (p & IR_out[9]);

endmodule
