module TestBench;

logic debug = 1; // debug flag. Enables more descriptive outputs when set to 1
  
  typedef struct packed{
    logic [31:0] data1;
    logic [31:0] data2;
    command_names_t command;
    logic [31:0] Odata;
    response_names_t response;
    int operation_begin;
    int operation_end;
  } scoreboard_t;
  
  scoreboard_t [3:0] test_scoreboard;
  
  typedef enum logic [1:0]
  {
    RESET_DELAY, FORCE_WAIT, ASSERT_COMMAND, WAIT_FOR_RESPONSE
  } state_names_t;
  
  state_names_t [3:0] state = 0;
  
	logic clock = 1'b0;
	logic reset = 1'b0;

  /*typedef struct packed
  {
    	logic [1:0] command;
  } rand_command_t;
  
  rand_command_t [3:0] rand_command;
  */
  logic [1:0] rand_command;

	logic [31:0] rand_data;
	
	input_packet_t [3:0] input_packet;
	output_packet_t [3:0] output_packet;
	
  	input_packet_t[3:0] last_input_packet;
  	output_packet_t [3:0] last_output_packet;
  
  typedef struct packed
{
	response_names_t response;
  //logic [63:0] data;
  //logic [31:0] data;
  logic [62:0] data; // calculated this to need at least 2^61 bits for 2^32 * 2^32, using one extra for padding
} output_test_packet_t;
  
  output_test_packet_t [3:0] test_output;
  
	const int n = 1;
  
  	int clock_count = 0;
  
  typedef struct packed
  {
    logic [7:0] number;
  } count_8bit_t;
  
  count_8bit_t [3:0] delay = 0;
  //count_8bit_t delay = 0;
	//int delay_mod = 0;
  
 //logic [7:0] count = 0;
  count_8bit_t [3:0] count = 0;

  
  	logic delay_begin = 0;
  	logic delay_end = 0;
  
	ALU ALU (.clock, .reset, .input_packet, .output_packet);

	always
		#5 clock = ~clock;
  
  /*
   @(negedge reset)
            begin
              $display("Reset check over at %d", clock_count);
              state[n] = FORCE_WAIT;
            end
*/
  
	always @(posedge clock)
	begin
      clock_count++;
      //$display("posedge clock");
      for(int n = 0; n < 4; n++)
        begin
      case(state[n])
        
        //this state keeps the machine from trying to do anything before reset is over
        RESET_DELAY: begin
          //if(reset == 0)
          //@(negedge reset)
            
          //$display("Reset delay state at %d", clock_count);
              //state[n] = FORCE_WAIT;
            
        end
        
        FORCE_WAIT: begin
          // delay ammount using 8 bit number
          //$display("begin force_wait");
          if(count[n] < delay[n].number)
            begin
              count[n]++;
            end
          else
            begin
              logic [7:0] rand_count = 0;
              delay[n].number++;
              //randomize the delay
              if(debug == 1) begin
              $display("delay ammount = %d, bank = %d", delay[n].number, n);
              end
              assert(std::randomize(rand_count));
              $cast(delay[n].number, rand_count);
              count[n] = 0;
              state[n] = ASSERT_COMMAND;
            end

  
            //$display("clock value = %b, clock count = %d", clock, clock_count);
  
          //$display("delay amount = %d", delay);

        end
          
        ASSERT_COMMAND: begin 
          	// set up random values
          	// Since command is an enum the dynamic $cast is needed to assign it a random bit value.
			
          //make sure the random value isnt a NOP!
          assert(std::randomize(rand_command) with { rand_command > 0; rand_command < 4; } );
            $cast(input_packet[n].command, rand_command);			
          		
			assert(std::randomize(rand_data));
			input_packet[n].data1 = rand_data;
			
			assert(std::randomize(rand_data));
			input_packet[n].data2 = rand_data;		
          
          	//set up scoreboard values
          test_scoreboard[n].data1 = input_packet[n].data1;
          test_scoreboard[n].data2 = input_packet[n].data2;
          test_scoreboard[n].command = input_packet[n].command;
          test_scoreboard[n].operation_begin = clock_count;
          
          	//move to next state
        	state[n] = WAIT_FOR_RESPONSE;
        end
        
        WAIT_FOR_RESPONSE:begin
          	//check for changes in the output data
            //check for when the output response goes from 0-> non-0 response
          if(output_packet[n].response == NO_RESPONSE)
              begin
                //last_output_packet[i]= output_packet[i];
                $display("No change in output data detected");
              end
      		else
              begin
                //write values to scoreboard to be checked
                test_scoreboard[n].operation_end = clock_count;
                test_scoreboard[n].Odata = output_packet[n].data;
                test_scoreboard[n].response = output_packet[n].response;
                
				if(debug == 1)
				begin
                // Use the .name method to show the name of the command or the response instead of its bit value.
                $display("Scoreboard test: bank = %d, .data1 = %h, .data2 = %h, .command = %s, .Odata = %h, .response = %s, .operation_begin = %d, .operation_end=%d", n, test_scoreboard[n].data1, test_scoreboard[n].data2, test_scoreboard[n].command.name, test_scoreboard[n].Odata, test_scoreboard[n].response.name, test_scoreboard[n].operation_begin, test_scoreboard[n].operation_end);
                end
				
                //check operation time
				check_task_time;

                //check if the operation passed
				check_task_passed;
                

                  

                state[n] = FORCE_WAIT;
              end
        end
      endcase
        end
      
    end
	// Read output data at the positive edge of the clock.
	// Drive input data at the negative edge of the clock.
	initial
	begin
		@(negedge clock); reset = 0;
      @(negedge clock); reset = 1; //test reset
		@(negedge clock); reset = 0;
      
      //once reset is over, start the state machine.
      $display("Reset check over at time = %d", clock_count);
      for(int i = 0; i < 4; i++)
        begin
          state[i] = FORCE_WAIT;
        end
      

          //check reset
      for(int i = 0; i < 4; i++)
          begin
            if(output_packet[i].data == 0) begin
            $display ("Reset test passed. alu_output_bank[%d]'s data = %h, reset = %b, time = %d", i, output_packet[i].data, reset, clock_count);
          end
        else begin
            $display ("!! Reset test failed !! alu_output_bank[%d]'s data = %h, reset = %b, time = %d", i, output_packet[i].data,  reset, clock_count);
        	end
          end
          
      //delay number of negative clock edges
      repeat (500)
      begin
        @(negedge clock);
      end
        $finish;
       
    end

task check_task_passed;
begin
                case( test_scoreboard[n].command )
                  NOP: begin
                    $display("!!! Program Error, a NOP was tried to be processed !!!");
                  end
                  ADD:begin
					test_output[n].data = test_scoreboard[n].data1 + test_scoreboard[n].data2;
				  
					if(debug == 1) begin
						$display("Adding %d and %d = %d, on bank %d", test_scoreboard[n].data1, test_scoreboard[n].data2, test_scoreboard[n].Odata, n);
						$display("Actual added value should be: %d", test_output[n].data);
					end
                    case(test_scoreboard[n].response)
                     NO_RESPONSE: begin
                       $display("!!! Program Error, a NO_RESPONSE response was tried to be processed in Add on bank = %d !!!", n);
                     end
                      SUCCESS: begin
                        if(test_output[n].data == test_scoreboard[n].Odata) begin
							if(debug == 1) begin
							$display("SUCCESS properly detected in Add on bank = %d", n);
							end
						end
                        else
                          $display("!! SUCCESS improperly detected in Add on bank = %d !!", n);
                      end
                     OVERFLOW:  begin
                       if(test_output[n].data == test_scoreboard[n].Odata)
							$display("!! OVERFLOW improperly detected in Add on bank = %d !!", n);
                        else begin
							if(debug == 1) begin
								$display("OVERFLOW properly detected in Add on bank = %d", n);
							end
						end
                      end
                      default: begin
                        $display("!!! Program Error, an improper value was entered in the response field in Add on bank = %d !!!", n);
                  	  end
                    endcase
                  end
                  MULTIPLY: begin
					test_output[n].data = test_scoreboard[n].data1 * test_scoreboard[n].data2;
					
					if(debug == 1) begin
						$display("Multiplying %d and %d = %d, on bank %d", test_scoreboard[n].data1, test_scoreboard[n].data2, test_scoreboard[n].Odata, n);
						$display("Actual multiplied value should be: %d", test_output[n].data);
					end
                    case(test_scoreboard[n].response)
                     NO_RESPONSE: begin
                       $display("!!! Program Error, a NO_RESPONSE response was tried to be processed in Multiply on bank = %d !!!" , n);
                     end
                      SUCCESS: begin
                        if(test_output[n].data == test_scoreboard[n].Odata) begin
							if(debug == 1) begin
								$display("SUCCESS properly detected in Multiply on bank = %d", n);
							end
						end
                        else
                          $display("!! SUCCESS improperly detected in Multiply on bank = %d !!", n);
                      end
                     OVERFLOW:  begin
                       if(test_output[n].data == test_scoreboard[n].Odata)
                          $display("!! OVERFLOW improperly detected in Multiply on bank = %d !!", n);
                        else begin
							if(debug == 1) begin
								$display("OVERFLOW properly detected in Multiply on bank = %d", n);
							end
						end
                      end
                      default: begin
                        $display("!!! Program Error, an improper value was entered in the response field in Multiply on bank = %d  !!!", n);
                  	  end
                    endcase
                  end
                  AND:begin
				    test_output[n].data = test_scoreboard[n].data1 & test_scoreboard[n].data2;
					
					if(debug == 1) begin
						$display("ANDing %h and %h = %h, on bank %d", test_scoreboard[n].data1, test_scoreboard[n].data2, test_scoreboard[n].Odata, n);
						$display("Actual ANDed value should be: %h", test_output[n].data);
					end
                    case(test_scoreboard[n].response)
                     NO_RESPONSE: begin
                       $display("!!! Program Error, a NO_RESPONSE response was tried to be processed in AND on bank = %d !!!" , n);
                     end
                      SUCCESS: begin
                        if(test_output[n].data == test_scoreboard[n].Odata) begin
							if(debug == 1) begin
								$display("SUCCESS properly detected in AND on bank = %d", n);
							end
						end
                        else
                          $display("!! SUCCESS improperly detected in AND on bank = %d !!", n);
                      end
                     OVERFLOW:  begin
                       if(test_output[n].data == test_scoreboard[n].Odata)
                          $display("!! OVERFLOW improperly detected in AND on bank = %d !!", n);
                        else begin
							if(debug == 1) begin
								$display("OVERFLOW properly detected in AND on bank = %d", n);
							end
						end
                      end
                      default: begin
                        $display("!!! Program Error, an improper value was entered in the response field in AND on bank = %d  !!!", n);
                  	  end
                    endcase
                  end
				default: begin
                  $display("!!! Program Error, an unknown command was tried to be processed !!!");
                end
                endcase
end
endtask

task check_task_time;
begin
if( ( test_scoreboard[n].operation_end - test_scoreboard[n].operation_begin ) <= 5 && (test_scoreboard[n].operation_end - test_scoreboard[n].operation_begin ) >= 3 )
  begin
  if(debug == 1)
	begin
	$display("Operation time check passed, time = %d, bank = %d", ( test_scoreboard[n].operation_end - test_scoreboard[n].operation_begin ), n);
	end
  end
else
  begin
	$display("!! Operation %s time check failed !!, time = %d, bank = %d", test_scoreboard[n].command.name, (test_scoreboard[n].operation_end - test_scoreboard[n].operation_begin ) , n);
  end
  end
 endtask
  
 endmodule : TestBench 