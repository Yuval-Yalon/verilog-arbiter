module arb_rr(
  input clk,
  input rst_n,
  input [3:0] req,
  output reg [3:0] gnt
);
  
  // Result of the priority logic
  reg [3:0] next_gnt;
  // Stores the index of the last requestor that was granted
  reg [1:0] last_gnt;
  
  // Combinational block that decides who gets granted next
  always @(*) begin
    next_gnt = 4'b0000;
    case (last_gnt)
      // Last grant was 0. Priority is now: 1 -> 2 -> 3 -> 0
      2'b00: begin
        if (req[1]) next_gnt = 4'b0010;
        else if (req[2]) next_gnt = 4'b0100;
        else if (req[3]) next_gnt = 4'b1000;
        else if (req[0]) next_gnt = 4'b0001;
      end
      // Last grant was 1. Priority is now: 2 -> 3 -> 0 -> 1
      2'b01: begin
        if (req[2]) next_gnt = 4'b0100;
        else if (req[3]) next_gnt = 4'b1000;
        else if (req[0]) next_gnt = 4'b0001;
        else if (req[1]) next_gnt = 4'b0010;
      end
      // Last grant was 2. Priority is now: 3 -> 0 -> 1 -> 2
      2'b10: begin
        if (req[3]) next_gnt = 4'b1000;
        else if (req[0]) next_gnt = 4'b0001;
        else if (req[1]) next_gnt = 4'b0010;
        else if (req[2]) next_gnt = 4'b0100;
      end
      // Last grant was 3. Priority is now: 0 -> 1 -> 2 -> 3
      2'b11: begin
        if (req[0]) next_gnt = 4'b0001;
        else if (req[1]) next_gnt = 4'b0010;
        else if (req[2]) next_gnt = 4'b0100;
        else if (req[3]) next_gnt = 4'b1000;
      end
    endcase
  end
  
  // Updates the gnt output and last gnt on the clock edge or resets it
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      gnt <= 4'b0000;
      last_gnt <= 2'b11;
    end
    else begin
      gnt <= next_gnt;
      if (|next_gnt) begin
        if (next_gnt[0]) last_gnt <= 2'b00;
        else if (next_gnt[1]) last_gnt <= 2'b01;
        else if (next_gnt[2]) last_gnt <= 2'b10;
        else if (next_gnt[3]) last_gnt <= 2'b11;     
      end
    end
  end
  
endmodule