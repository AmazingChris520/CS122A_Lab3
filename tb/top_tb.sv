`include "src/top.sv"
`timescale 1ns/1ps         // Set tick to 1ns. Set sim resolution to 1ps.

/**
 * Note:
 *  The TB below is only an example of a testbench written in SV.
 *  Adapt this for your lab assignments as you see fit.
 *  An example clk signal has been added to show what a signal decl and usage looks like.
 *     You are welcome to delete the clk signal if it's not needed.
 *     For instance, purely combinational circuits do not need clks.
 *     So for labs without sequential elements, you can remove them.
 */

module top_tb;

/** declare tb signals below */
logic clk_tb;
logic button_1_tb;
logic led_1_tb;
logic [3:0] duty_cycle_1_tb; // initialize duty_cycle_1_tb to 0
logic button_2_tb;
logic led_2_tb;
logic [3:0] duty_cycle_2_tb; // initialize duty_cycle_2_tb to 0
/** declare module(s) below */

top dut                    // declare an inst of top called "dut" (device under test)
(
    /** hook up tb signals to dut signals */
    .clk(clk_tb),           // connect dut's clk wire to clk_tb
    .button_1(button_1_tb),       // connect dut's button wire to button_1_tb
    .led_1(led_1_tb),             // connect dut's led wire to led_1_tb
    .duty_cycle_1(duty_cycle_1_tb), // connect dut's duty_cycle wire to duty_cycle_1_tb
    .button_2(button_2_tb),       // connect dut's button wire to button_2_tb
    .led_2(led_2_tb),             // connect dut's led wire to led_2_tb
    .duty_cycle_2(duty_cycle_2_tb) // connect dut's duty_cycle wire to duty_cycle_2_tb
);

localparam CLK_PERIOD = 10;
always #(CLK_PERIOD/2) clk_tb=~clk_tb;          // toggle clk_tb every #(CLK_PERIOD/2) ticks

initial begin
    $dumpfile("build/top.vcd"); // intermediate file for waveform generation
    $dumpvars(0, top_tb);       // capture all signals under top_tb
end

initial begin
    /** testbench logic goes below */
    clk_tb<=1'b1;       // sets clk_tb to 1
        button_1_tb <= 1'b0;  // set button to 1
        button_2_tb <= 1'b0;  // set button to 1
    #(CLK_PERIOD*3);    // waits for CLK_PERIOD * 3 ticks

    for (int i = 0; i < 10; i++) begin
        button_1_tb <= 1'b1;  // set button to 1
        button_2_tb <= 1'b0;  // set button to 1
        #(CLK_PERIOD*3);    // wait for 3 cycles

        button_1_tb <= 1'b0;  // set button to 0
        button_2_tb <= 1'b1;  // set button to 0
        #(CLK_PERIOD*3);    // wait for 3 cycles
    end

    $finish;            // end simulation, otherwise it runs indefinitely
end

endmodule
