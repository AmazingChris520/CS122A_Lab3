`include "src/decoder.sv"
`include "src/sm.sv"

module top (
    /** Input Ports */
    input wire button_1,
    input wire button_2,
    input wire dip,
    input wire clk,
    /** Output Ports */
    output logic led_1,
    output logic led_2,
    output logic [3:0] duty_cycle_1,
    output logic [3:0] duty_cycle_2,
    output logic [7:0] seg7,
    output logic [3:0] inputDisplay

);  
/** Logic */


buttonSM stateMachine1 (
    .clk(clk),
    .in(~button_1),
    .led_out(led_1),
    .duty_cycle(duty_cycle_1)
);

buttonSM stateMachine2 (
    .clk(clk),
    .in(~button_2),
    .led_out(led_2),
    .duty_cycle(duty_cycle_2)
);


always_comb begin
    if (~dip)
        inputDisplay = duty_cycle_1;
    else
        inputDisplay = duty_cycle_2;
end

decoder dec (
    .inp(inputDisplay), //input of switch
    .clk(clk),
    .dip(dip),
    .seg7(seg7) //Show the 7bit out on decoder
);


endmodule