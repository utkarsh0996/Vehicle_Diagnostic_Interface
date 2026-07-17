`timescale 1ns / 1ps

module fault_register(

    input clk,
    input reset,

    input frame_done,

    input fault_detected,
    input [3:0] fault_code,
    input [1:0] fault_level,

    output reg stored_fault,
    output reg [3:0] stored_code,
    output reg [1:0] stored_level

);

always @(posedge clk or posedge reset)
begin

    if(reset)
    begin
        stored_fault <= 1'b0;
        stored_code  <= 4'b0000;
        stored_level <= 2'b00;
    end

    else if(frame_done || fault_detected)
    begin
        stored_fault <= fault_detected;
        stored_code  <= fault_code;
        stored_level <= fault_level;
    end

end

endmodule