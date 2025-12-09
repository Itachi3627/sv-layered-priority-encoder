# SystemVerilog Layered Verification: Priority Encoder

## Overview
[cite_start]This project implements a modular, layered testbench in SystemVerilog to verify the functionality of an 8-bit Priority Encoder[cite: 5]. [cite_start]The verification environment utilizes Object-Oriented Programming (OOP) principles, separating stimulus generation, driving, monitoring, and result checking into distinct classes[cite: 30].


## Design Under Test (DUT)
The DUT is a **Priority Encoder** with the following specifications:
* [cite_start]**Input:** 8-bit Request (`req`)[cite: 5].
* [cite_start]**Outputs:** 3-bit Encoded value (`enc`) and a Valid signal (`valid`)[cite: 5].
* **Logic:** The encoder prioritizes the Most Significant Bit (MSB). [cite_start]The output `enc` corresponds to the index of the highest active bit in the input `req`[cite: 7].

## Verification Environment Architecture
The testbench follows a standard verification hierarchy:

### 1. Transaction Object (`transaction.sv`)
Defines the packet structure containing randomized inputs (`req`) and observed outputs.
* [cite_start]**Constraints:** Uses weighted distribution constraints to ensure corner cases (0x00 and 0xFF) and random values are covered[cite: 37, 38].

### 2. Generator (`generator.sv`)
Responsible for creating transaction objects and randomizing them.
* [cite_start]Sends transactions to the Driver via a mailbox[cite: 9, 13].
* [cite_start]Configured to generate 25 transactions for this run[cite: 3].

### 3. Driver (`driver.sv`)
Receives transactions from the Generator and drives the signals onto the interface.
* [cite_start]Handles timing (wait states) before triggering the sampling event[cite: 23].

### 4. Monitor (`monitor.sv`)
Passively observes the interface signals.
* [cite_start]Captures `req`, `enc`, and `valid` signals after the sampling event and packages them into a transaction object to send to the Scoreboard[cite: 27].

### 5. Scoreboard (`scoreboard.sv`)
The self-checking mechanism of the testbench.
* [cite_start]**Reference Model:** Implements a behavioral model of the priority encoder (iterating from MSB down) to calculate expected results[cite: 44, 45].
* [cite_start]**Comparison:** Compares the DUT output against the expected model and tracks PASS/FAIL counts[cite: 46, 47].

### 6. Environment (`environment.sv`) & Top (`top.sv`)
* [cite_start]The **Environment** constructs and connects all components using mailboxes[cite: 32, 33].
* [cite_start]The **Top** module connects the DUT and the Environment via the Interface[cite: 2].

## Simulation Results
The simulation executed 25 randomized transactions with a 100% pass rate.

**Summary:**
* **Total Transactions:** 25
* **Passed:** 25


**Sample Log Output:**
```text
[GENERATOR] Generated Trans #2: REQ = 10111011
[MONITOR] Captured  #2: REQ = 10111011, ENC =   7, Valid = 1
[SCOREBOARD] PASSED #2: REQ = 10111011, ENC =   7, Valid = 1
...
[SCOREBOARD] Test Results:
  PASSED: 25
  FAILED: 0
  TOTAL:  25
