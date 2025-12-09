# SystemVerilog Layered Verification: Priority Encoder

## Overview

This project implements a modular, layered testbench in SystemVerilog to verify the functionality of an 8-bit Priority Encoder[5]. The verification environment utilizes Object-Oriented Programming (OOP) principles, separating stimulus generation, driving, monitoring, and result checking into distinct classes[30].

---

## Design Under Test (DUT)

The DUT is a **Priority Encoder** with the following specifications:

- **Input:** 8-bit Request (`req`)[5]
- **Outputs:** 3-bit Encoded value (`enc`) and a Valid signal (`valid`)[5]
- **Logic:** The encoder prioritizes the Most Significant Bit (MSB). The output `enc` corresponds to the index of the highest active bit in the input `req`[7]

---

## Verification Environment Architecture

The testbench follows a standard verification hierarchy:

### 1. Transaction Object (`transaction.sv`)

Defines the packet structure containing randomized inputs (`req`) and observed outputs.

- **Constraints:** Uses weighted distribution constraints to ensure corner cases (0x00 and 0xFF) and random values are covered[37, 38]

### 2. Generator (`generator.sv`)

Responsible for creating transaction objects and randomizing them.

- Sends transactions to the Driver via a mailbox[9, 13]
- Configured to generate 25 transactions for this run[3]

### 3. Driver (`driver.sv`)

Receives transactions from the Generator and drives the signals onto the interface.

- Handles timing (wait states) before triggering the sampling event[23]

### 4. Monitor (`monitor.sv`)

Passively observes the interface signals.

- Captures `req`, `enc`, and `valid` signals after the sampling event and packages them into a transaction object to send to the Scoreboard[27]

### 5. Scoreboard (`scoreboard.sv`)

The self-checking mechanism of the testbench.

- **Reference Model:** Implements a behavioral model of the priority encoder (iterating from MSB down) to calculate expected results[44, 45]
- **Comparison:** Compares the DUT output against the expected model and tracks PASS/FAIL counts[46, 47]

### 6. Environment (`environment.sv`) & Top (`top.sv`)

- The **Environment** constructs and connects all components using mailboxes[32, 33]
- The **Top** module connects the DUT and the Environment via the Interface[2]

---

## Simulation Results

The simulation executed 25 randomized transactions with a **100% pass rate**.

### Summary

| Metric               | Count |
|---------------------|-------|
| Total Transactions  | 25    |
| Passed              | 25    |
| Failed              | 0     |

### Sample Log Output

```text
[GENERATOR] Generated Trans #2: REQ = 10111011
[MONITOR] Captured  #2: REQ = 10111011, ENC =   7, Valid = 1
[SCOREBOARD] PASSED #2: REQ = 10111011, ENC =   7, Valid = 1
...
[SCOREBOARD] Test Results:
  PASSED: 25
  FAILED: 0
  TOTAL:  25
```

---

## Architecture Diagram

```
┌─────────────┐
│  Generator  │
└──────┬──────┘
       │ mailbox
       ▼
┌─────────────┐     ┌─────────────┐
│   Driver    │────▶│ Interface   │◀────┐
└─────────────┘     └──────┬──────┘     │
                           │            │
                    ┌──────▼──────┐     │
                    │     DUT     │     │
                    │  (Priority  │     │
                    │   Encoder)  │     │
                    └─────────────┘     │
                                        │
┌─────────────┐                         │
│   Monitor   │─────────────────────────┘
└──────┬──────┘
       │ mailbox
       ▼
┌─────────────┐
│ Scoreboard  │
└─────────────┘
```

---

## Key Features

- **Modular Design:** Each verification component is independent and reusable
- **Mailbox Communication:** Ensures proper synchronization between components
- **Self-Checking:** Scoreboard automatically validates DUT outputs against a reference model
- **Constrained Randomization:** Transaction constraints ensure comprehensive coverage including corner cases
- **Event-Driven:** Uses SystemVerilog events for synchronization between Driver and Monitor

---

## Conclusion

The layered testbench successfully verified the 8-bit Priority Encoder with complete functional coverage. All 25 transactions passed, demonstrating correct implementation of priority encoding logic with MSB priority.
