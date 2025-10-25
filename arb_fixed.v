module arb_fixed(
  input clk,
  input rst_n,
  input [3:0] req,
  output reg [3:0] gnt
);
  
  // Result of the priority logic
  reg [3:0] next_gnt;
  
  // Combinational logic for fixed priority encoding
  assign next_gnt = req[3] ? 4'b1000 : (req[2] ? 4'b0100 : (req[1] ? 4'b0010 : (req[0] ? 4'b0001 : 4'b0000)));
  
  // Updates the 'gnt' output on the clock edge or resets it
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
      gnt <= 4'b0000;
    else
      gnt <= next_gnt;
  end
  
endmodule