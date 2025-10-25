module arb_tb();
  
  reg clk;
  reg rst_n;
  reg [3:0] req;
  wire [3:0] gnt_fixed;
  wire [3:0] gnt_rr;
  
  // Creating a 10ns clock
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end
  
  // Instantiate the Fixed Arbiter
  arb_fixed u_fixed(
    .clk(clk),
    .rst_n(rst_n),
    .req(req),
    .gnt(gnt_fixed)
  );
  
  // Instantiate the Round Robin Arbiter
  arb_rr u_rr(
    .clk(clk),
    .rst_n(rst_n),
    .req(req),
    .gnt(gnt_rr)    
  );
  
  // Print the signal values to the console whenever any of them change
  initial begin
    $monitor("Time=%0t | req=%b | gnt_fixed=%b | gnt_rr=%b", $time, req, gnt_fixed, gnt_rr);
    
    // Reset test
    req = 0;
    rst_n = 0;
    #20
    rst_n = 1;
    
    // Send 100 random request
    @(posedge clk);
    repeat (100) begin
      @(posedge clk);
      req <= $random;
    end

    // Send specific test to check Round Robin
    @(posedge clk);
    req <= 4'b1111;
    @(posedge clk);
    req <= 4'b1010;
    @(posedge clk);
    req <= 4'b1010;
    @(posedge clk);
    req <= 4'b1010;
    @(posedge clk);
    req <= 4'b0000;
    
    $finish;
  end
  
endmodule