# Verilog 4-Request Arbiter

A Verilog implementation of **Fixed-Priority** and **Round-Robin** arbiters, designed to demonstrate and compare common resource arbitration strategies.

---

## Features

-   **Two Arbiter Types:**
    -   `arb_fixed`: Simple, stateless Fixed-Priority arbitration.
    -   `arb_rr`: Stateful Round-Robin arbitration ensuring fairness.
-   **4-bit Datapath:** Handles 4 concurrent request inputs.
-   **One-Hot Grant:** Output `gnt` vector is one-hot, guaranteeing mutual exclusion.
-   **Synchronous Design:** All logic is synchronous to `posedge clk` with an asynchronous active-low reset.
-   **Side-by-Side Testbench:** A comprehensive testbench instantiates both arbiters to compare their behavior under identical random stimuli.

---

## Project Modules

| Module | Description |
| :--- | :--- |
| `arb_fixed.v` | Fixed-Priority Arbiter. Grants to the highest-priority requestor (`req[3]`). |
| `arb_rr.v` | Round-Robin Arbiter. Grants in a fair, rotating order. |
| `arb_tb.sv` | Testbench that drives both arbiters with the same `req` vector for comparison. |

---

## Common Arbiter Interface

Both `arb_fixed.v` and `arb_rr.v` share an identical interface, allowing them to be interchangeable.

### **Ports**
| Name | Direction | Width | Description |
| :--- | :--- | :--- | :--- |
| `clk` | input | 1-bit | System clock signal |
| `rst_n` | input | 1-bit | Active-low asynchronous reset |
| `req` | input | 4-bit | Request vector (one bit per requestor) |
| `gnt` | output | 4-bit | One-hot grant vector (one bit per requestor) |

---

## Arbitration Strategies

This project implements the two most common arbitration schemes.

### 1. Fixed-Priority (`arb_fixed`)
This is the simplest arbiter. It uses purely combinational logic to grant access based on a static priority, defined as:
`req[3] > req[2] > req[1] > req[0]`

-   **Pro:** Very simple, low-logic implementation.
-   **Con:** Can lead to **starvation**, where a low-priority requestor (`req[0]`) is never granted access if higher-priority requestors are constantly active.

### 2. Round-Robin (`arb_rr`)
This arbiter uses a state register (`last_gnt`) to "remember" the last requestor that was granted access. It ensures **fairness** by starting its priority search from the *next* requestor in the sequence.

-   **State Machine:**
    -   On reset, `last_gnt` is set to `3`. The first search starts at `0`.
    -   If `req[1]` is granted, `last_gnt` is updated to `1`.
    -   The next search will begin at `req[2]`, then `req[3]`, then `req[0]`, and finally `req[1]`.
-   **Pro:** Guarantees fairness. No requestor will be starved.
-   **Con:** Requires a state register and more complex logic.
