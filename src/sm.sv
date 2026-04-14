module buttonSM (
    input  logic clk,
    input  logic in,
    output logic led_out,
    output logic [3:0] duty_cycle
);
    typedef enum logic [5:0]{START, OFF, OFFRelease, ON, ONRelease} state_t;

logic [63:0] clk_div_counter;
wire clk_0s25;

initial begin
    clk_div_counter <= 0; // initialize clk_div_counter to 0
end

always_ff @(posedge clk) begin
    clk_div_counter <= clk_div_counter + 1;
end

assign clk_0s25 = clk_div_counter[22]; // Assuming a 64-cycle division for 25% duty cycle


    state_t state = START;
    always @(posedge clk_0s25) begin
        case (state)
            START:
            begin
            state <= OFF;
            duty_cycle <= 0; // initialize duty cycle to 0
            end
            OFF:
            begin
            state <= state_t'(in ? OFFRelease : OFF);
            if (in)
                begin
                if (duty_cycle == 4'd9) duty_cycle <= 0;
                else
                duty_cycle <= duty_cycle + 1; // 0% duty cycle
                
                state <= state_t'(OFFRelease);
                end
            else
            state <= state_t'(OFF);
            end
            OFFRelease:state <= state_t'(in ? OFFRelease : ON);
            ON:
            begin
            if (in)
                begin
                if (duty_cycle == 4'd9) duty_cycle <= 0;
                else
                duty_cycle <= duty_cycle + 1; // 0% duty cycle
                
                state <= state_t'(ONRelease);
                end
            else
            state <= state_t'(ON);
            end
            ONRelease:state <= state_t'(in ? ONRelease : OFF);
            default: state <= START;
        endcase
    end

/*
    always_comb begin
        case(state)
            START: led_out = 0;
            OFF: led_out = 0;
            OFFRelease: led_out = 1;
            ON: led_out = 1;
            ONRelease: led_out = 0;
            default: led_out = 0;
        endcase 
    end
*/

logic [3:0] pwm_counter = 0;

always @(posedge clk) begin
    if (pwm_counter == 4'd9)
        pwm_counter <= 0;
    else
        pwm_counter <= pwm_counter + 1;

    if (pwm_counter < duty_cycle)
        led_out <= 1;
    else
        led_out <= 0;
end

endmodule