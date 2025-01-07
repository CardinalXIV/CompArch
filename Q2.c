#include <stdio.h>
#include <time.h>

int main() {
  int n, i, flag = 0;
  struct timespec start,end;
  double cpu_time_used;

  printf("Enter a positive integer: ");
  scanf("%d", &n);

  clock_gettime(CLOCK_MONOTONIC, &start);

  if (n == 0 || n == 1)
  {

    flag = 1;

  }

  for (i = 2; i <= n / 2; ++i) {
    // if n is divisible by i, then n is not prime
    // change flag to 0 for non-prime number
    if (n % i == 0) {
      flag = 0;
      break;
    }
  }
  clock_gettime(CLOCK_MONOTONIC, &end);
  cpu_time_used=(end.tv_sec-start.tv_sec)+(end.tv_nsec-start.tv_nsec)/1e9;
  printf("\nExecution time: %.9f seconds\n",cpu_time_used);
  // flag is 1 for prime numbers
  if (flag == 1)
    printf("%d is a prime number.\n", n);
  else
    printf("%d is not a prime number.\n", n);
  return 0;
}
