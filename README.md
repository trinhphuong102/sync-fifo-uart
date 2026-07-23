# Parameterized Synchronous FIFO in SystemVerilog

## 📌 Overview
This repository contains the RTL design and verification environment for a **Synchronous FIFO (First-In-First-Out)** memory buffer, written in SystemVerilog. 

This module is designed as a foundational component for a future UART transceiver system but is entirely parameterizable for general-purpose digital data buffering. The design strictly adheres to RTL coding guidelines for robust synthesis and timing analysis.

## ✨ Key Hardware Features
* **Parameterizable Architecture:** Both `DATA_WIDTH` (word size) and `ADDR_WIDTH` (FIFO depth = $2^N$) can be configured at instantiation, ensuring high reusability across different digital modules.
* **Optimized Flag Generation (MSB-Trick):** Utilizes $N+1$ bit pointers for an $N$-bit address space. This allows the `full` and `empty` status flags to be generated combinationally and instantaneously, avoiding the latency and logic overhead of counter-based approaches.
* **Safe Sequential Logic:** Implemented using standard `always_ff` blocks with non-blocking assignments to prevent race conditions.
* **Overflow/Underflow Protection:** The internal logic strictly gates write and read operations based on the current full/empty status, protecting the circular buffer from data corruption.

## 📂 Directory Structure
```text
sync-fifo-uart/
├── rtl/
│   └── fifo.sv       # RTL design of the Synchronous FIFO
├── tb/
│   └── tb_fifo.sv    # Testbench for behavioral simulation
└── README.md