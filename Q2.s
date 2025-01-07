.data
.align 3 
input:.string	"Enter a positive integer: "
.align 3 
format:.string	"%d"
.align 3 
itisprime:.string	"%d is a prime number.\n"
.align 3 
itisnotprime:.string	"%d is not a prime number.\n"
.align 3 
exeTime:.string	"\nExecution time: %.9f seconds\n"

.text
.global	print_prime_status
.global	main
.global getexetime
.extern printf                  // External function printf;
.extern scanf                   // External function scanf;
.extern clock_gettime           // External function clock_gettime;

// Main function of the program	
main:
    stp	x29, x30, [sp, -80]!   	// Store pair x29 and x30 to the stack, and allocate 80 bytes of space;
    mov	x29, sp                 // Set x29 (frame pointer) to the current stack pointer;

    ldr x0, =input              // Load address of 'input' message into x0;
    bl	printf                  // Call printf to print the 'input' message;

    add	x1, sp, #44             // Set x1 to point to the stack location 44 bytes from sp;
    ldr x0, =format             // Load address of 'format' string into x0;
    bl	scanf                   // Call scanf to read an integer input from the user;

    add	x1, sp, #48             // Set x1 to point to the stack location 48 bytes from sp;
    mov	w0, 1                   // Set w0 to 1 (CLOCK_MONOTONIC for clock_gettime);
    bl	clock_gettime           // Call clock_gettime to get the start time;

    mov	w19, #0                  // Initialize w19 to 0 = notprime (Flag to show if prime or not);
    ldr	w1, [sp, #44]           // Load the user input integer into w1;
    cmp	w1, #1                   // Compare the input integer with 1;
    ble	getexetime              // If input is less or equal to 1, branch to getexetime (not prime);

    cmp	w1, #3                  // Check if 1<input<=3, basically 2/3;
    ble	itsprime                // If input is less or equal to 3, branch to itsprime (is prime);
    tbz	x1, #0, getexetime      // Test bit 0 of x1, branch to getexetime if it is 0 (input is even, hence not prime);
    mov	w0, #2                  // Set w0 to 2, initial test divisor;
    b incrementsq               // Branch to the start of the prime checking loop;

division:
    sdiv w19, w1, w0            // Divide w1 by w0, result in w19;
    msub w19, w19, w0, w1      	// Multiply w19 by w0, subtract from w1, result in w19 (remainder check);
    cbz	w19, getexetime         // If the remainder is 0 (meaning a divisor was found), branch to getexetime (not prime);

incrementsq:
    add	w0, w0, #1              // Increment the test divisor by 1;
    mul	w2, w0, w0              // Square the divisor and store in w2;
    cmp	w1, w2                  // Compare the input integer with the squared divisor;
    bge	division                // If input is greater or equal to w2, repeat loop with next divisor;

itsprime:
    mov w19, #1                 // Set w19 to 1, indicating the number is prime;
    b getexetime		// Branch to the code that gets the execution time;

// Function for printing prime status;
print_prime_status:
    cbz w1, print_notprime      // If w1 =0 branch to print_notprime;
    mov	w1, w0                  // Move value from w0 to w1 (prepare to print prime message);
    ldr x0, =itisprime         	// Load address of 'itisprime' message into x0;
    b printf                    // Branch to printf function to print the message;
    
print_notprime:
    mov	w1, w0              	// Move value from w0 to w1 (preparing to print not prime message);
    ldr x0, =itisnotprime      	// Load address of 'itisinotprime' message into x0;
    b printf                    // Branch to printf function to print the message;
    
// Function to get the execution time and calculate elapsed time;
getexetime:
    add x1, sp, #64            // Set x1 to point to the stack location 64 bytes from sp, for the end time struct;
    mov w0, #1                 // Set w0 to 1, which corresponds to CLOCK_MONOTONIC for clock_gettime;
    bl clock_gettime           // Call clock_gettime to get the end time;

    ldp x3, x2, [sp, #48]      // Load the start time seconds (x3) and nanoseconds (x2) from the stack;
    mov x0, 225833675390976    // Load the lower half of a constant into x0 (1e9 in this context);
    movk x0, 0x41cd, lsl #48   // Move and keep to load the upper half of the constant (1e9) into x0;
    ldr x1, [sp, #72]          // Load the end time seconds from the stack into x1;
    fmov d1, x0                // Move the constant (1e9) into floating-point register d1 for division;

    ldr x0, =exeTime           // Load the address of the exeTime format string into x0;
    sub x1, x1, x2             // Subtract start nanoseconds from end nanoseconds;
    ldr x2, [sp, #64]          // Load the end time nanoseconds from the stack;

    scvtf d0, x1               // Convert the nanoseconds difference from integer to float in d0;
    sub x2, x2, x3             // Subtract start seconds from end seconds;
    fdiv d0, d0, d1            // Divide the nanoseconds difference by 1e9 to convert to seconds;

    scvtf d1, x2               // Convert the seconds difference from integer to float;
    fadd d0, d0, d1            // Add the seconds difference to the nanoseconds difference (now both in seconds);

    bl printf                  // Call printf to print the execution time using the exeTime format string;

    ldr w0, [sp, #44]          // Load the user's input number into w0 for the print_prime_status function;
    mov w1, w19                // Move the result from w19 (result of is_prime) into w1 for print_prime_status;
    bl print_prime_status      // Call print_prime_status to print whether the input is prime or not;

    mov w0, #0                 // Set w0 to 0, preparing for return from main (conventionally indicates success);
    ldr x19, [sp, #16]         // Restore the value of x19 from the stack;
    ldp x29, x30, [sp], #80    // Restore the frame pointer (x29) and return address (x30) and deallocate the stack space;

    ret                        // Return from the function;