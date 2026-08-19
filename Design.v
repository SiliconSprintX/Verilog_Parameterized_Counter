// Code your design here
`timescale 1ns/1ps

module parameterized_counter #(
    parameter WIDTH = 8
)(
    input  wire             clk,
    input  wire             rst,
    input  wire             enable,
    input  wire             up_down,

    output reg  [WIDTH-1:0] count
);

    //====================================================
    // Counter Logic
    //====================================================

    always @(posedge clk or posedge rst) begin

        // Asynchronous active-high reset
        if (rst) begin
            count <= {WIDTH{1'b0}};
        end

        // Counter enabled
        else if (enable) begin

            // UP COUNT
            if (up_down) begin
                count <= count + 1'b1;
            end

            // DOWN COUNT
            else begin
                count <= count - 1'b1;
            end

        end

        // Counter disabled
        else begin
            count <= count;
        end

    end

endmodule
