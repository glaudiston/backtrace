# Backtrace Utils

A lightweight collection of utilities to implement execution stack traces across different environments. Currently, this repository 
focuses on providing a robust backtrace mechanism for **Bash**.

## 🚀 Bash Implementation

The Bash utility allows developers to print a detailed call stack during script execution. Unlike the native `caller` builtin, this 
implementation captures not only the function name and line number but also the **arguments** passed to each function.

### Features
- **Argument Tracking**: Displays the actual values passed to each function in the stack.
- **Relative Pathing**: Resolves script paths relative to the current working directory for better readability.
- **Clean Output**: Formats the trace into a readable table.

### How it Works
The utility enables `shopt -s extdebug`, which populates the `BASH_ARGV` and `BASH_ARGC` arrays. By iterating through the stack and 
mapping these arrays, the `backtrace` function can reconstruct the flow of execution.

### Usage

1. **Source the script** in your bash project:
   ```bash
   . ./bash/backtrace.sh
   ```

2. **Call the `backtrace` function** anywhere in your code:
   ```bash
   my_function() {
       backtrace
   }
   ```

### Example Output
When running the provided `backtrace_test.sh`, the output looks like this:

```text
FILE                      FUNCTION  ARGS
bash/backtrace_test.sh:8   fn_c      4 5 6 7
bash/backtrace_test.sh:11  fn_b      1 2 3
bash/backtrace_test.sh:14  fn_a      zero
bash/backtrace_test.sh:17  main      
```

## 🛠 Roadmap
This repository is intended to remain a specialized utility library. Future additions may include:
- [ ] Backtrace implementations for other languages (e.g., Golang).
- [ ] Integration with other shell environments.

## 📜 License
This project is licensed under **Creative Commons**. 

---
*Note: This project depends on the `pragma_once` utility to ensure scripts are sourced only once per session.*
