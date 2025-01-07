.data                                                  // Declare data section that is used for declaring initialized data or constants;

.align 3
input:.string "Enter a positive integer: "             // Initialize a string variable called input;
  
.align 3
format:.string "%d"                                    // Define the string format for scanf;
  
.align 3
isprime:.string "%d is a prime number.\n"              // Initialize a string variable called isprime;

.align 3
notprime:.string "%d is not a prime number.\n"         // Initialize a string variable called notprime;

.align 3
exetime:.string "\nExecution time: %.9f seconds\n"     // Initialize a string variable called exetime;



.text           // Indicates the section where the actual instructions of the program resides;
.global main    // Allows the main symbol to be accessed by other files;
main:
  stp  x29, x30, [sp, -80]!     // Store the pair of registers x29 and x30 containing the Link Register and the Program Counter into the stack at the stack pointer offset by 80 bytes and update the stack pointer to the new location;
  mov  x29, sp                  // Copies the current value of the stack pointer into the register x29 so that the function has a fixed reference point to its local variables and saved register values;
  
  // Print prompt;
  ldr x0, =input                // Load the address of input for input prompt into x0;
  bl printf                     // Call printf to print the string;

  // Read input integer;
  ldr x0, =format               // Load the format string for scanf;
  add x1, sp, #60               // Load address for input buffer which is 60 bytes above the current stack pointer into register x1;
  bl scanf                      // Call scanf to parse the user input;
  
  // Check if user input is 0;
  ldr w0, [sp, #60]             // Load the value of user input into x0 (for comparing);
  cmp  w0, #0                   // Check if input integer is 0;
  beq flag_set                  // If user input is 0, set isntprime flag;

  // Check if user input is 1 and initialise divisor;
  ldr w0, [sp, #60]             // Reload user input;
  cmp w0, #1                    // Check if user input is 1;
  bne init_divisor              // If not equal, initialize divisor;
  
flag_set:
  // Change the value of the flag to indicate if a number is not prime;
  mov w0, #1                    // Use w0 as an indicator 1 = not prime;
  str w0, [sp, #72]             // Store flag value 72 bytes above the stack pointer;

init_divisor:
  // Initialise Divisor to 2;
  mov  w0, #2                   // Initialize divisor variable to 2;
  str  w0, [sp, #76]            // Store the divisor variable in stack 76 bytes above stack pointer for use in other functions;
  b divide                      // Start division loop;

check:
  // Check whether remainder after division is 0;
  ldr w0, [sp, #60]             // Load user input into register w0;
  ldr w1, [sp, #76]             // Load current divisor into register w1;
  
  sdiv w2, w0, w1               // Divide the input by current divisor and store in w2;
  
  ldr w1, [sp, #76]             // Reload current divisor since it value might have changed cause of sdiv;
  
  mul w1, w2, w1                // Multiply Quotient (w2) and Divisor (w1) and store in w1;
  sub w0, w0, w1                // Subtract the product (w1) from input (w0) to find remainder and store in w0;
  
  cmp w0, #0                    // Check if remainder is 0;
  bne increment                 // If remainder is not 0, branch to increment divisor; 
  
  mov w0, #1                    // Move the value 1 into register x0;
  str w0, [sp, #72]             // Update the flag value to 0;
  b prime                       // Exit loop and branch to prime;
    
increment: 
  // Increase the value of the divisor by 1;
  ldr w0, [sp, #76]             // Load divisor from stack;
  add w0, w0, #1                // Increment divisor by 1;
  str w0, [sp, #76]             // Save new divisor into stack;
  
divide:      
  // Round towards zero when performing integer division by 2;
  ldr  w0, [sp, #60]            // Load divisor variable from register x10; 
  
  lsr w1, w0, #31               // Extract sign bit by performing a logic shift right by 31 bits since w0 contains a 32 bit number and store it in w1;
  add w0, w1, w0                // Increment the number by 1 if sign bit is 0;
  asr w0, w0, #1                // Arithmetic Shift Right by one position to divide the value in w0 by 2;
  
  mov w1, w0                    // Store the value of the division into register w1;
  ldr w0, [sp, #76]             // Load original divisor variable into register w0;
  cmp w0, w1                    // Compare divisor against half of original number;
  ble check                     // If divisor less than or equal to input/2, proceed to check branch; 
  
prime:
  // Output number is prime
  ldr w0, [sp, #72]             // Load flag from stack;
  cmp w0, #0                    // Compare flag to 0;
  bne isnotprime                // If flag is not 0, branch to notprime;
  
  ldr x0, =isprime              // Load the isprime string into register x0;
  ldr w1, [sp, #60]             // Load user input into register w1;
  bl  printf                    // Calls printf function which prints string stored in x0 and w1 as w0 contains placeholders;
  b  timer

isnotprime: 
  // Output number is not prime ;
  ldr x0, =notprime             // Load the isprime string into register x0;
  ldr w1, [sp, #60]             // Load user input into register w1;    
  bl  printf                    // Calls printf function which prints string stored in x0 and w1 as w0 contains placeholders;

timer:
  // Measure the execution time of the program;
  
  // Get current time;
  add x1, sp, #40               // Store location of current time into stack 40 bytes offset from the current stack pointer and it's address into register x1;
  mov w0, #1                    // Sets CLOCK_REALTIME identifier;
  bl clock_gettime              // Calls clock_gettime function;
  
  // Get timestamp for after program is done;
  add x0, sp, #24               // Store location of current time into stack 24 bytes offest from the current stack pointer and it's address into register x0; 
  mov x1, x0                    // Store address of second timestamp into register x1;
  mov w0, #1                    // Sets CLOCK_REALTIME identifier;
  bl clock_gettime              // Calls clock_gettime function;
  
  // Calculating time difference (seconds);
  ldr x1, [sp, #24]             // Load second timestamp in seconds into x1;
  ldr x0, [sp, #40]             // Load first timestamp in seconds into x0;
  sub x0, x1, x0                // Subtract x0 from x1 and store result in x0;
  fmov d0, x0                   // Move value into d0 (floating point register);
  scvtf d1, d0                  // Convert into floating point format and store in d1;
  
  // Calculating time difference (nanoseconds);
  ldr  x1, [sp, #32]            // Load second timestamp in nanoseconds into x1;
  ldr  x0, [sp, #48]            // Load first timestamp in nanoseconds into x0;
  sub  x0, x1, x0               // Subtract x0 from x1 and store result in x0;
  fmov d0, x0                   // Move value into d0 (floating point register);
  scvtf d0, d0                  // Convert into floating point format and store in d0;
  
  // Converting seconds difference to nanoseconds and adding prev result;
  mov  x0, 225833675390976      // Move the constant value 225833675390976 into register x0;
  movk  x0, 0x41cd, lsl 48      // Move the constant value 0x41cd into the top half of register x0, effectively combining it with the previous value;
  fmov  d2, x0                  // Move the combined value from integer register x0 to floating point register d2;
  fdiv  d0, d0, d2              // Divide the nanosecond difference by a constant value (225833675390976) and store the result in d0;
  fadd  d0, d1, d0              // Add the previously calculated second difference to the current result and store it in d0;

  
  str  d0, [sp, #64]            // Store the final result (time difference) on the stack at position sp+64;
  ldr  d0, [sp, #64]            // Load the final result from the stack into register d0;
  ldr x0, =exetime              // Load the string exetime into register x0;
  bl  printf                    // Call printf function to print out the execution time;
  mov  w0, 0                    // Set return value to zero indicating success;
  ldp  x29, x30, [sp], 80       // Restore stack pointer and return from function.
  ret                           // Return from function;
