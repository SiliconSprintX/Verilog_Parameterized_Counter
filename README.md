# Parameterized Up/Down Counter using Verilog HDL

![Verilog](https://img.shields.io/badge/HDL-Verilog-blue)
![Design](https://img.shields.io/badge/Design-RTL-green)
![Counter](https://img.shields.io/badge/Counter-Up%2FDown-orange)
![Width](https://img.shields.io/badge/Width-Parameterized-purple)
![Verification](https://img.shields.io/badge/Verification-Testbench-success)

---

## 📌 Project Overview

This project implements a **parameterized synchronous Up/Down Counter using Verilog HDL**.

The counter supports **up counting, down counting, enable control, and asynchronous reset**. The counter width can be configured using a parameter, making the design reusable for different applications and data widths.

---

## 🎯 Objectives

The main objectives of this project are:

* Understand sequential RTL design.
* Implement an Up/Down counter.
* Implement enable functionality.
* Implement reset functionality.
* Understand parameterized Verilog designs.
* Verify counter behavior using a testbench.
* Analyze counter operation using simulation waveforms.

---

## ✨ Features

* Parameterized counter width
* Up counting
* Down counting
* Enable control
* Asynchronous active-high reset
* Synchronous counter operation
* Automatic overflow and underflow wrap-around
* Verilog RTL implementation
* Self-checking testbench
* Multiple test scenarios
* VCD waveform generation
* GTKWave-compatible simulation

---

# 🧠 Counter Operation

The counter behavior depends on three control signals:

```text
rst
enable
up_down
```

### Operation Table

| `rst` | `enable` | `up_down` | Operation          |
| :---: | :------: | :-------: | ------------------ |
|   1   |     X    |     X     | Reset counter to 0 |
|   0   |     0    |     X     | Hold current value |
|   0   |     1    |     1     | Count Up           |
|   0   |     1    |     0     | Count Down         |

---

# 🔢 Parameterized Width

The counter width is controlled by:

```verilog
parameter WIDTH = 8
```

For example:

### 4-bit Counter

```verilog
parameter WIDTH = 4
```

Range:

```text
0 → 15
```

### 8-bit Counter

```verilog
parameter WIDTH = 8
```

Range:

```text
0 → 255
```

### 16-bit Counter

```verilog
parameter WIDTH = 16
```

Range:

```text
0 → 65535
```

This makes the RTL reusable without changing the actual counter logic.

---

# 🏗️ Block Diagram

```text
                  +----------------------+
                  |  Parameterized       |
                  |      Counter         |
                  |                      |
    clk -------->|                      |
    rst -------->|                      |
    enable ----->|    Counter Logic     |-----> count
    up_down ---->|                      |
                  |                      |
                  +----------------------+
```

---

# 🔄 Counter Flow

```text
                  RESET
                    |
                    v
              +-----------+
              |  COUNT=0  |
              +-----+-----+
                    |
                 enable?
                /       \
              NO         YES
              |           |
              v           v
          HOLD COUNT    up_down?
                       /       \
                     UP         DOWN
                      |           |
                      v           v
                 COUNT + 1    COUNT - 1
                      |           |
                      +-----+-----+
                            |
                            v
                         NEXT CLK
```

---

# 🔌 Interface

| Signal    |   Width | Direction | Description                    |
| --------- | ------: | --------- | ------------------------------ |
| `clk`     |       1 | Input     | System clock                   |
| `rst`     |       1 | Input     | Active-high asynchronous reset |
| `enable`  |       1 | Input     | Enables counting               |
| `up_down` |       1 | Input     | `1` = Up, `0` = Down           |
| `count`   | `WIDTH` | Output    | Current counter value          |

---

# ⚙️ Design Details

## Reset

When:

```text
rst = 1
```

the counter immediately resets to:

```text
count = 0
```

The reset is asynchronous because it is included in:

```verilog
always @(posedge clk or posedge rst)
```

---

## Enable

When:

```text
enable = 0
```

the counter holds its current value.

Example:

```text
count = 5

enable = 0

5 → 5 → 5 → 5
```

---

## Up Counting

When:

```text
enable  = 1
up_down = 1
```

the counter increments on every positive edge of the clock.

```text
0 → 1 → 2 → 3 → 4 → 5 → ...
```

---

## Down Counting

When:

```text
enable  = 1
up_down = 0
```

the counter decrements on every positive edge of the clock.

```text
5 → 4 → 3 → 2 → 1 → 0
```

---

# 🔁 Overflow and Underflow

For a 4-bit counter:

### Overflow

```text
1111 + 1 = 0000
```

Therefore:

```text
14 → 15 → 0 → 1 → 2
```

### Underflow

```text
0000 - 1 = 1111
```

Therefore:

```text
2 → 1 → 0 → 15 → 14
```

This wrap-around occurs naturally because the counter has a fixed parameterized width.

---

# 🧪 Verification

The testbench verifies the following scenarios:

### Test 1 — Reset

Checks that the counter resets to zero.

```text
Expected:

count = 0
```

### Test 2 — Count Up

Checks incrementing functionality.

```text
0 → 1 → 2 → 3 → 4 → 5
```

### Test 3 — Enable Disabled

Checks that the counter holds its value.

```text
5 → 5 → 5 → 5
```

### Test 4 — Count Down

Checks decrementing functionality.

```text
5 → 4 → 3 → 2 → 1 → 0
```

### Test 5 — Wrap-Around

Checks counter underflow/overflow behavior.

For a 4-bit counter:

```text
0 → 15 → 14 → 13
```

---

# 📊 Expected Simulation Output

Example simulation output:

```text
TEST 1 PASSED: Counter reset to 0

--------------------------------------------
TEST 2: COUNT UP
--------------------------------------------
Time = 25 | Enable = 1 | Up_Down = 1 | Count = 1
Time = 35 | Enable = 1 | Up_Down = 1 | Count = 2
Time = 45 | Enable = 1 | Up_Down = 1 | Count = 3
Time = 55 | Enable = 1 | Up_Down = 1 | Count = 4
Time = 65 | Enable = 1 | Up_Down = 1 | Count = 5

--------------------------------------------
TEST 3: COUNTER DISABLED
--------------------------------------------
Time = 75 | Enable = 0 | Count = 5
Time = 85 | Enable = 0 | Count = 5
Time = 95 | Enable = 0 | Count = 5

--------------------------------------------
TEST 4: COUNT DOWN
--------------------------------------------
Time = 105 | Enable = 1 | Up_Down = 0 | Count = 4
Time = 115 | Enable = 1 | Up_Down = 0 | Count = 3
Time = 125 | Enable = 1 | Up_Down = 0 | Count = 2
Time = 135 | Enable = 1 | Up_Down = 0 | Count = 1
Time = 145 | Enable = 1 | Up_Down = 0 | Count = 0

--------------------------------------------
SIMULATION COMPLETED
--------------------------------------------
```

---

# 📈 Waveform Verification

The testbench generates:

```text
parameterized_counter.vcd
```

The following signals can be observed in GTKWave:

```text
clk
rst
enable
up_down
count
```

Expected behavior:

```text
clk       _|‾|_|‾|_|‾|_|‾|_|‾|_|‾|_|‾|_

rst       ‾‾‾‾‾|________________________

enable    ______|‾‾‾‾‾‾‾‾‾|______|‾‾‾‾

up_down   ‾‾‾‾‾|‾‾‾‾‾‾‾‾‾|______|____

count     0     1 2 3 4 5 5 5 5 4 3 2
```

### Waveform checks

* `rst = 1` → `count = 0`
* `enable = 1`, `up_down = 1` → count increases
* `enable = 0` → count holds
* `enable = 1`, `up_down = 0` → count decreases

---

# 📁 Project Structure

```text
Parameterized-Counter/
│
├── design.sv
├── testbench.sv
├── parameterized_counter.vcd
└── README.md
```

### `design.sv`

Contains the RTL implementation of the parameterized Up/Down counter.

### `testbench.sv`

Contains clock generation, reset, stimulus, test cases, result checking, and waveform generation.

### `parameterized_counter.vcd`

Generated waveform file used for signal-level verification.

### `README.md`

Project documentation.

---

# 🛠️ Tools & Technologies

* **Verilog HDL**
* **SystemVerilog-compatible simulation**
* **Icarus Verilog**
* **ModelSim / Questa**
* **GTKWave**
* **EDA Playground**
* **Git & GitHub**

---

# ▶️ How to Run

## Using Icarus Verilog

### Compile

```bash
iverilog -g2012 -o counter_sim design.sv testbench.sv
```

### Run

```bash
vvp counter_sim
```

### View Waveform

```bash
gtkwave parameterized_counter.vcd
```

---

# 💻 Running on EDA Playground

1. Create a new Verilog/SystemVerilog project.
2. Add `design.sv`.
3. Add `testbench.sv`.
4. Select a simulator such as Icarus Verilog.
5. Run the simulation.
6. Check the console output.
7. Open the generated waveform.
8. Observe `clk`, `rst`, `enable`, `up_down`, and `count`.

---

# 📚 Concepts Demonstrated

This project demonstrates:

* Sequential logic
* Parameterized RTL
* Counters
* Up/Down control
* Enable control
* Asynchronous reset
* Clocked logic
* Fixed-width arithmetic
* Overflow
* Underflow
* Testbench development
* Simulation
* Self-checking verification
* VCD waveform generation
* GTKWave analysis

---

# ⚠️ Current Limitations

The current design is intentionally simple for learning and RTL practice.

* Single counter output
* No programmable upper/lower limits
* No terminal-count output
* No overflow flag
* No underflow flag
* No synchronous reset option
* No load-data functionality

---

# 🚀 Future Improvements

The project can be extended with:

### 1. Programmable Maximum Count

Allow the user to define a maximum counting value.

```text
0 → 1 → 2 → ... → MAX → 0
```

### 2. Load Function

Add a `load` input and `load_data` input:

```text
load = 1
       ↓
count = load_data
```

### 3. Overflow and Underflow Flags

Add:

```text
overflow
underflow
```

outputs.

### 4. Terminal Count

Add a `terminal_count` signal when the counter reaches its configured limit.

### 5. Synchronous Reset Option

Allow the reset behavior to be configured as synchronous or asynchronous.

### 6. SystemVerilog Verification

The testbench can be upgraded with:

* Assertions
* Functional coverage
* Tasks
* Functions
* Randomized stimulus
* Scoreboard
* Reference model

---

# 🎓 Learning Outcomes

By completing this project, I gained practical understanding of:

* Parameterized Verilog design
* Sequential RTL coding
* Up/Down counter architecture
* Clocked processes
* Reset handling
* Enable-controlled logic
* Fixed-width arithmetic
* Counter overflow and underflow
* Testbench development
* Waveform-based debugging
* RTL verification

---

# 📌 Project Summary

The **Parameterized Up/Down Counter** is a reusable RTL design that supports configurable data width, up/down counting, enable control, and asynchronous reset. The design was verified through multiple simulation scenarios covering reset, counting, hold operation, and wrap-around behavior.

---

# 🔮 Project Roadmap

```text
Parameterized Counter
        ↓
Add Load Function
        ↓
Add Max/Min Limits
        ↓
Add Overflow/Underflow Flags
        ↓
Add Terminal Count
        ↓
SystemVerilog Assertions
        ↓
Functional Coverage
        ↓
Constrained-Random Verification
```

---

# 👩‍💻 Author

**Saakshi**

**Domain:** RTL Design | Verilog | SystemVerilog | VLSI

**Project:** Parameterized Up/Down Counter using Verilog HDL

---

## 📄 License

This project is created for **educational, learning, portfolio, and RTL/VLSI practice purposes**.
