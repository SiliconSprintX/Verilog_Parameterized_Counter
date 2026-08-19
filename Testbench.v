// Code your testbench here
// or browse Examples
`timescale 1ns/1ps

module parameterized_counter_tb;

    //====================================================
    // Parameters
    //====================================================

    parameter WIDTH = 4;


    //====================================================
    // Testbench Signals
    //====================================================

    reg clk;
    reg rst;
    reg enable;
    reg up_down;

    wire [WIDTH-1:0] count;


    //====================================================
    // DUT
    //====================================================

    parameterized_counter #(
        .WIDTH(WIDTH)
    ) dut (
        .clk     (clk),
        .rst     (rst),
        .enable  (enable),
        .up_down (up_down),
        .count   (count)
    );


    //====================================================
    // Clock Generation
    //====================================================

    initial begin

        clk = 1'b0;

        forever #5 clk = ~clk;

    end


    //====================================================
    // Test Sequence
    //====================================================

    initial begin

        // Initial values
        rst     = 1'b1;
        enable  = 1'b0;
        up_down = 1'b1;


        //================================================
        // TEST 1: RESET
        //================================================

        #10;

        rst = 1'b0;

        #10;

        if (count == 4'd0)
            $display("TEST 1 PASSED: Counter reset to 0");
        else
            $display("TEST 1 FAILED: Counter = %d", count);


        //================================================
        // TEST 2: COUNT UP
        //================================================

        enable  = 1'b1;
        up_down = 1'b1;

        $display("--------------------------------------------");
        $display("TEST 2: COUNT UP");
        $display("--------------------------------------------");

        repeat (5) begin

            @(posedge clk);

            #1;

            $display(
                "Time = %0t | Enable = %b | Up_Down = %b | Count = %d",
                $time,
                enable,
                up_down,
                count
            );

        end


        //================================================
        // TEST 3: DISABLE
        //================================================

        enable = 1'b0;

        $display("--------------------------------------------");
        $display("TEST 3: COUNTER DISABLED");
        $display("--------------------------------------------");

        repeat (3) begin

            @(posedge clk);

            #1;

            $display(
                "Time = %0t | Enable = %b | Count = %d",
                $time,
                enable,
                count
            );

        end


        //================================================
        // TEST 4: COUNT DOWN
        //================================================

        enable  = 1'b1;
        up_down = 1'b0;

        $display("--------------------------------------------");
        $display("TEST 4: COUNT DOWN");
        $display("--------------------------------------------");

        repeat (5) begin

            @(posedge clk);

            #1;

            $display(
                "Time = %0t | Enable = %b | Up_Down = %b | Count = %d",
                $time,
                enable,
                up_down,
                count
            );

        end


        //================================================
        // TEST 5: DOWN COUNTER WRAP-AROUND
        //================================================

        $display("--------------------------------------------");
        $display("TEST 5: WRAP-AROUND TEST");
        $display("--------------------------------------------");

        // Continue counting down
        repeat (3) begin

            @(posedge clk);

            #1;

            $display(
                "Time = %0t | Count = %d",
                $time,
                count
            );

        end


        //================================================
        // END SIMULATION
        //================================================

        #20;

        $display("--------------------------------------------");
        $display("SIMULATION COMPLETED");
        $display("--------------------------------------------");

        $finish;

    end


    //====================================================
    // Waveform Generation
    //====================================================

    initial begin

        $dumpfile("parameterized_counter.vcd");

        $dumpvars(0, parameterized_counter_tb);

    end

endmodule
