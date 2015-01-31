module TestBench;

	logic clock = 1'b0;
	logic reset = 1'b0;

	logic [1:0] rand_command;
	logic [31:0] rand_data;
	
	input_packet_t [3:0] input_packet;
	output_packet_t [3:0] output_packet;

	const int n = 1;

	ALU ALU (.clock, .reset, .input_packet, .output_packet);

	always
		#5 clock = ~clock;

	always @(posedge clock)
	begin
		// Use the .name method to show the name of the command or the response instead of its bit value.
		$display ("Data1 = %h, Data2 = %h, Command = %h, DataOut = %h, Response = %s", input_packet[n].data1, input_packet[n].data2, input_packet[n].command, output_packet[n].data, output_packet[n].response.name);
	end

	// Read output data at the positive edge of the clock.
	// Drive input data at the negative edge of the clock.
	initial
	begin
		@(negedge clock); reset = 0;
		@(negedge clock); reset = 1;
		@(negedge clock); reset = 0;     
		
		repeat (20)
		begin
			@(negedge clock);
			
			assert(std::randomize(rand_data));
			input_packet[n].data1 = rand_data;
			
			assert(std::randomize(rand_data));
			input_packet[n].data2 = rand_data;			
			
			// Since command is an enum the dynamic $cast is needed to assign it a random bit value.
			assert(std::randomize(rand_command));
			$cast(input_packet[n].command, rand_command);			
		end
	
		$finish;
	end
endmodule : TestBench