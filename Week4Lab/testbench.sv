module TestBench;
  
  typedef struct packed{
    logic [31:0] data1;
    logic [31:0] data2;
    command_names_t command;
    logic [31:0] Odata;
    response_names_t response;
    int operation_begin;
    int operation_end;
  } scoreboard_t;
  
  scoreboard_t test_scoreboard;
  
  typedef enum logic [1:0]
  {
    FORCE_WAIT, ASSERT_COMMAND, WAIT_FOR_RESPONSE
  } state_names_t;
  
  state_names_t [3:0] state = 0;
  
	logic clock = 1'b0;
	logic reset = 1'b0;

	logic [1:0] rand_command;
	logic [31:0] rand_data;
	
	input_packet_t [3:0] input_packet;
	output_packet_t [3:0] output_packet;
	
  	input_packet_t[3:0] last_input_packet;
  	output_packet_t [3:0] last_output_packet;
  
	const int n = 0;
  
  	int clock_count = 0;

	ALU ALU (.clock, .reset, .input_packet, .output_packet);

	always
		#5 clock = ~clock;

	always @(posedge clock)
	begin
      int i = 0;
      $display("State = %s, Bank = %h", state[n].name, n);
      clock_count++;
      
		// Use the .name method to show the name of the command or the response instead of its bit value.
		//for(int i = 0; i < 4; i++)
      
      case(state[n])
        FORCE_WAIT: begin
          //delay ammount using 8 bit number
          state[n] = ASSERT_COMMAND;
        end
          
        ASSERT_COMMAND: begin 
          	// Since command is an enum the dynamic $cast is needed to assign it a random bit value.
			assert(std::randomize(rand_command));
			$cast(input_packet[n].command, rand_command);
          
          	//set up scoreboard values
            test_scoreboard.data1 = input_packet[i].data1;
          	test_scoreboard.data2 = input_packet[i].data2;
          	test_scoreboard.command = input_packet[i].command;
          	test_scoreboard.operation_begin = clock_count;
          
          	//move to next state
        	state[n] = WAIT_FOR_RESPONSE;
        end
        
        WAIT_FOR_RESPONSE:begin
          	//check for changes in the output data
          //should I do this check?
          if(last_output_packet[i].data == output_packet[i].data)
            //or should I check for when the output response goes from 0-> non-0 response?
              begin
                //$display("No change in output data detected");
              end
      		else
              begin
                //write values to scoreboard to be checked
                test_scoreboard.operation_end = clock_count;
                test_scoreboard.Odata = output_packet[i].data;
          		test_scoreboard.response = output_packet[i].response;
                $display("Change detected in output on ALU bank %d, old data = %h, new data = %h", i, last_output_packet[i].data, output_packet[i].data);
                $display("Scoreboard test: .data1 = %h, .data2 = %h, .command = %s, .Odata = %h, .response = %s",  test_scoreboard.data1, test_scoreboard.data2, test_scoreboard.command.name, test_scoreboard.Odata, test_scoreboard.response.name);

                last_output_packet[i]= output_packet[i];
                state[n] = FORCE_WAIT;
              end
        end
      endcase
    

    end
	// Read output data at the positive edge of the clock.
	// Drive input data at the negative edge of the clock.
	initial
	begin
		@(negedge clock); reset = 0;
      @(negedge clock); reset = 1; //test reset
		@(negedge clock); reset = 0;
      

          //check reset
      for(int i = 0; i < 4; i++)
          begin
            if(output_packet[i].data == 0)
          begin
            $display ("Reset test passed. alu_output_bank[%d]'s data = %h, reset = %b", i, output_packet[i].data, reset);
          end
        else
          begin
            $display ("!! Reset test failed !! alu_output_bank[%d]'s data = %h, reset = %b", i, output_packet[i].data,  reset);
        	end
          end
          
		repeat (20)
		begin
			@(negedge clock);
			
			assert(std::randomize(rand_data));
			input_packet[n].data1 = rand_data;
			
			assert(std::randomize(rand_data));
			input_packet[n].data2 = rand_data;			
		end
	
		$finish;
	end
endmodule : TestBench