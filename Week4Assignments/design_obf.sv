typedef enum logic [1:0]
{
	NOP, ADD, MULTIPLY, AND  
} command_names_t;

typedef struct packed
{
	command_names_t command;
	logic [31:0] data1;
	logic [31:0] data2;
} input_packet_t;

typedef enum logic [1:0]
{
	NO_RESPONSE, SUCCESS, OVERFLOW, UNUSED
} response_names_t;

typedef struct packed
{
	response_names_t response;
	logic [31:0] data;
} output_packet_t;

module ALU (input logic clock, input logic reset, input input_packet_t [3:0] input_packet, output output_packet_t [3:0] output_packet);	
	
	typedef enum logic [1:0] {IDLE, COMP} States;  	input_packet_t [3:0] latch_input;  	int countDown[3:0];  	bit [63:0] overflow;  	  	States [3:0] state;  	  	always_ff @(posedge clock, posedge reset)  	begin  		for (int n = 0; n < 4; n++)  		begin  			if (reset)  			begin				  				state <= IDLE;  				  				if (n == 2)  				begin  					output_packet[n].data <= '1;  					output_packet[n].response <= SUCCESS;  				end  				else  				begin  					output_packet[n].data <= '0;  					output_packet[n].response <= NO_RESPONSE;  				end		  			end
			else   			begin   				state[n] <= state[n];   				output_packet[n].response = NO_RESPONSE;   				   				case (state[n])   					IDLE:   					begin   						if (input_packet[n].command != NOP)   						begin   							latch_input[n] = input_packet[n];   							if (n == 3)   								assert(std::randomize(countDown[n]) with {countDown[n] > 2; countDown[n] < 7;});   							else   								assert(std::randomize(countDown[n]) with {countDown[n] > 2; countDown[n] < 6;});   							   							state[n] <= COMP;   						   						end					   					end   					   					COMP:   					begin   						countDown[n]--;   						   						if (countDown[n] == 0)   						begin   							case (latch_input[n].command)   								   								ADD:   								begin   									if (n == 1)   									begin   										output_packet[n].data = latch_input[n].data1 + latch_input[n].data2;   										output_packet[n].response = SUCCESS;   									end   									else   									begin   										output_packet[n].data = latch_input[n].data1 + latch_input[n].data2;   										overflow = latch_input[n].data1 + latch_input[n].data2;   										   										if (overflow > 32'hFFFFFFFF)   											output_packet[n].response = OVERFLOW;   										else   											output_packet[n].response = SUCCESS;										   										   									end									   								end   								   								MULTIPLY:   								begin   									output_packet[n].data = latch_input[n].data1 * latch_input[n].data2;   									overflow = latch_input[n].data1 * latch_input[n].data2;   										   									if (overflow > 32'hFFFFFFFF)   										output_packet[n].response = OVERFLOW;   									else   										output_packet[n].response = SUCCESS;	   								end   								   								AND:   								begin   									output_packet[n].data = latch_input[n].data1 & latch_input[n].data2;   									output_packet[n].response = SUCCESS;   								end							   							endcase						   						   							state[n] <= IDLE;   						end   						else   							state[n] <= COMP;					   					end			   				endcase			   			end		   		end   	end
endmodule : ALU