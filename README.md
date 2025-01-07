# Assembly vs Compiler: Execution Time Benchmarking

## Project Overview
This project explores the efficiency of assembly language programming compared to compiler-generated code. The objective is to test if a number is a prime number in both assembly and a high-level language (C) and analyze the execution times of the 2 files. The focus is on understanding the trade-offs between manual assembly optimization and compiler efficiency.

## Goals
- Implement a task in both C and assembly.
- Measure and compare execution times.
- Explore whether hand-optimized assembly can outperform compiler-generated machine code.

## Prerequisites
- Raspberry Pi 4 Model B running Raspbian OS.
- `gcc` compiler for compiling C code.
- `as` (GNU assembler) for assembling the assembly code.
- `time` command or a suitable timing tool to measure execution time.

## File Descriptions
- **`Q2.c`**: C source file containing the high-level implementation of the task.
- **`Q2.s` / `Q2asm`**: Assembly file(s) containing the hand-written implementation of the task.
- **`Q2.exe`**: Compiled executable (either C or assembly).
- **Other files**: Any supporting materials or data.

## Compilation and Execution

### Compiling the C Code
1. Compile the C program using GCC:
   ```bash
   gcc -o Q2_c_exec Q2.c
   ```

# Assembly vs Compiler: Execution Time Benchmarking

## Project Overview
This project explores the efficiency of assembly language programming compared to compiler-generated code. The objective is to implement a specific task in both assembly and a high-level language (C) and analyze the execution times of the resulting binaries. The focus is on understanding the trade-offs between manual assembly optimization and compiler efficiency.

## Goals
- Implement a task in both C and assembly.
- Measure and compare execution times.
- Explore whether hand-optimized assembly can outperform compiler-generated machine code.

## Prerequisites
- Raspberry Pi 4 Model B running Raspbian OS.
- `gcc` compiler for compiling C code.
- `as` (GNU assembler) for assembling the assembly code.
- `time` command or a suitable timing tool to measure execution time.

## File Descriptions
- **`Q2.c`**: C source file containing the high-level implementation of the task.
- **`Q2.s` / `Q2asm`**: Assembly file(s) containing the hand-written implementation of the task.
- **`Q2.exe`**: Compiled executable (either C or assembly).

## Compilation and Execution

### Compiling the C Code
1. Compile the C program using GCC:
   ```bash
   gcc -o Q2_c_exec Q2.c
   ```

2.	Execute the program:
    ```bash
    ./Q2_c_exec
    ```

Assembling and Linking the Assembly Code
1.	Assemble the assembly code into an object file:
    ```bash  
    as -o Q2_asm.o Q2.s
    ```

2.	Link the object file to create an executable:
    ```bash
    ld -o Q2_asm_exec Q2_asm.o
    ```

3.	Run the executable:
    ```bash
    ./Q2_asm_exec
    ```

Measuring Execution Time

Use the time command to measure execution time for both binaries:
```bash
time ./Q2_c_exec
time ./Q2_asm_exec
```
Compare the results to determine whether hand-optimized assembly outperforms compiler-generated code.

Key Learnings
	•	Insights into low-level programming using assembly.
	•	Practical experience in analyzing compiler optimizations.
	•	Understanding the trade-offs between development time and runtime efficiency.

Future Improvements
	•	Experiment with different optimization levels for GCC (e.g., -O1, -O2, -O3) to compare with the assembly implementation.
	•	Explore using SIMD instructions in assembly for potential further optimizations.
	•	Expand the task complexity to observe performance differences on larger workloads.
