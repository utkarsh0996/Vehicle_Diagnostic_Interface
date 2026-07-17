`timescale 1ns / 1ps

module verilog_text_fixture;

// Clock and Reset
reg clk;
reg reset;

// UART Receiver Output (Simulated)
reg rx_done;
reg [7:0] rx_data;

// Outputs
wire [7:0] dtc0,dtc1,dtc2,dtc3,dtc4;
wire frame_done;

wire fault_detected;
wire [3:0] fault_code;
wire [1:0] fault_level;

wire stored_fault;
wire [3:0] stored_code;
wire [1:0] stored_level;

wire green_led;
wire yellow_led;
wire red_led;

//--------------------------------------------------
// Clock Generation
//--------------------------------------------------

always #10 clk = ~clk;

//--------------------------------------------------
// Frame Decoder
//--------------------------------------------------

frame_decoder FD(

.clk(clk),
.reset(reset),

.rx_done(rx_done),
.rx_data(rx_data),

.dtc0(dtc0),
.dtc1(dtc1),
.dtc2(dtc2),
.dtc3(dtc3),
.dtc4(dtc4),

.frame_done(frame_done)

);

//--------------------------------------------------
// Diagnostic Decoder
//--------------------------------------------------
diagnostic_decoder DD(

    .clk(clk),
    .reset(reset),

    .frame_done(frame_done),

    .dtc0(dtc0),
    .dtc1(dtc1),
    .dtc2(dtc2),
    .dtc3(dtc3),
    .dtc4(dtc4),

    .fault_detected(fault_detected),
    .fault_code(fault_code),
    .fault_level(fault_level)

);

//--------------------------------------------------
// Fault Register
//--------------------------------------------------

fault_register FR(

.clk(clk),
.reset(reset),

.frame_done(frame_done),

.fault_detected(fault_detected),
.fault_code(fault_code),
.fault_level(fault_level),

.stored_fault(stored_fault),
.stored_code(stored_code),
.stored_level(stored_level)

);

//--------------------------------------------------
// LED Controller
//--------------------------------------------------

led_controller LC(

.stored_fault(stored_fault),
.stored_level(stored_level),

.green_led(green_led),
.yellow_led(yellow_led),
.red_led(red_led)

);

//--------------------------------------------------
// Task to Send One Character
//--------------------------------------------------

task send_char;

input [7:0] ch;

begin

rx_data = ch;
rx_done = 1;

#20;

rx_done = 0;

#40;

end

endtask

//--------------------------------------------------
// Simulation
//--------------------------------------------------

initial
begin

clk = 0;
reset = 1;

rx_done = 0;
rx_data = 8'h00;

#100;

reset = 0;

// Send P0301

send_char("P");
send_char("0");
send_char("3");
send_char("0");
send_char("1");

#5000;

$stop;

end

endmodule