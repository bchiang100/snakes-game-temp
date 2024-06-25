`timescale 1ns / 10ps

module tb ();

    // Testbench parameters
    localparam CLK_PERIOD = 10; // 100 Hz clk
    logic tb_checking_outputs; 
    integer tb_test_num;
    string tb_test_case;

    // DUT ports
    logic tb_clk, tb_rst_i;
    logic tb_goodCollButton, tb_badCollButton;
    logic [3:0] tb_displayOut;
    logic [6:0] tb_ss0, tb_ss1;


    // Reset DUT Task
    task reset_dut;
        @(negedge tb_clk);
        tb_rst_i = 1'b0; 
        @(negedge tb_clk);
        @(negedge tb_clk);
        tb_rst_i = 1'b1;
        @(posedge tb_clk);
    endtask
    
// Task to check current score output
    // task check_dispScore;
    // input logic[6:0] exp_dispScore; 
    // begin
    //     @(negedge tb_clk);
    //     tb_checking_outputs = 1'b1;
    //     if(tb_dispScore == exp_dispScore)
    //         $info("Correct displayed score: %0d.", exp_dispScore);
    //     else
    //         $error("Incorrect displayed score. Expected: %0d. Actual: %0d.", exp_dispScore, tb_dispScore); 
        
    //     #(1);
    //     tb_checking_outputs = 1'b0;  
    // end
    // endtask

    // Clock generation block
    always begin
        tb_clk = 1'b0; 
        #(CLK_PERIOD / 2.0);
        tb_clk = 1'b1; 
        #(CLK_PERIOD / 2.0); 
    end

    // DUT Portmap
    score_tracker_top DUT(.clk(tb_clk),
                .rst(tb_rst_i),
                .goodCollButton(tb_goodCollButton),
                .badCollButton(tb_badCollButton),
                .displayOut(tb_displayOut),
                .ss0(tb_ss0),
                .ss1(tb_ss1));

    // Main Test Bench Process
    initial begin
        // Signal dump
        $dumpfile("dump.vcd");
        $dumpvars;

        // Initialize test bench signals
        tb_rst_i = 1'b1;
        tb_goodCollButton = 1'b0;
        tb_badCollButton = 1'b0;
        tb_checking_outputs = 1'b0;
        tb_test_num = -1;
        tb_test_case = "Initializing";

        // Wait some time before starting first test case
        #(0.1);

        // ************************************************************************
        // Test Case 0: Power-on-Reset of the DUT
        // ************************************************************************
        tb_test_num += 1;
        tb_test_case = "Test Case 0: Power-on-Reset of the DUT";
        $display("\n\n%s", tb_test_case);

        tb_rst_i = 1'b0;  // activate reset

        // Wait for a bit before checking for correct functionality
        #(2);
        //check_dispScore('0);
    

        // Check that the reset value is maintained during a clock cycle
        @(negedge tb_clk);
        //check_dispScore('0);
        


        // ************************************************************************
        // Test Case 1: Updating displayOut
        // ************************************************************************
        tb_test_num += 1;
        reset_dut;
        #(CLK_PERIOD); // allow for some delay
        tb_test_case = "Test Case 1: Updating currentScore and highScore";
        $display("\n\n%s", tb_test_case);

        tb_goodCollButton = 1'b1;
        #(CLK_PERIOD);
        tb_goodCollButton = 1'b0;
        
        tb_goodCollButton = 1'b1;
        #(CLK_PERIOD);
        tb_goodCollButton = 1'b0;

        tb_goodCollButton = 1'b1;
        #(CLK_PERIOD);
        tb_goodCollButton = 1'b0;

        tb_goodCollButton = 1'b1;
        #(CLK_PERIOD);
        tb_goodCollButton = 1'b0;

        tb_badCollButton = 1'b1;
        #(CLK_PERIOD);
        tb_badCollButton = 1'b0;

        tb_goodCollButton = 1'b1;
        #(CLK_PERIOD);
        tb_goodCollButton = 1'b0;

        tb_goodCollButton = 1'b1;
        #(CLK_PERIOD);
        tb_goodCollButton = 1'b0;
        $finish; 
    end

endmodule 