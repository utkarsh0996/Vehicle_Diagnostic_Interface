`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:00:20 07/15/2026 
// Design Name: 
// Module Name:    vehical_diagnostic_top 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
//-----------------------------------------------------
// Vehicle Diagnostic Interface - Top Module
//-----------------------------------------------------

module vehicle_diagnostic_top(

    input clk,
    input reset,
    input rx,

    output green_led,
    output yellow_led,
    output red_led

);

//-----------------------------------------------------
// Internal Wires
//-----------------------------------------------------

wire baud_tick;

wire [7:0] rx_data;
wire rx_done;

wire [7:0] dtc0;
wire [7:0] dtc1;
wire [7:0] dtc2;
wire [7:0] dtc3;
wire [7:0] dtc4;

wire frame_done;

wire fault_detected;
wire [3:0] fault_code;
wire [1:0] fault_level;

wire stored_fault;
wire [3:0] stored_code;
wire [1:0] stored_level;


//-----------------------------------------------------
// Baud Generator
//-----------------------------------------------------

baud_generator BG(

    .clk(clk),
    .reset(reset),
    .baud_tick(baud_tick)

);


//-----------------------------------------------------
// UART Receiver
//-----------------------------------------------------

uart_receiver UART(

    .clk(clk),
    .reset(reset),

    .baud_tick(baud_tick),

    .rx(rx),

    .rx_data(rx_data),

    .rx_done(rx_done)

);


//-----------------------------------------------------
// Frame Decoder
//-----------------------------------------------------

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


//-----------------------------------------------------
// Diagnostic Decoder
//-----------------------------------------------------

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


//-----------------------------------------------------
// Fault Register
//-----------------------------------------------------

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


//-----------------------------------------------------
// LED Controller
//-----------------------------------------------------

led_controller LC(

    .stored_fault(stored_fault),
    .stored_level(stored_level),

    .green_led(green_led),
    .yellow_led(yellow_led),
    .red_led(red_led)

);

endmodule