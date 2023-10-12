#include <stdio.h>

// C needs to know function prototypes in order to pass arguments in proper
// registers.
#include "hellos.h"
#include "math.h"

int main(void)
{
	hello_syscall();
	hello_puts();

	int number = -15;
	printf("Sum of %d and 123: %d\n", number, sum(number, 123));
}
