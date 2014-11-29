/*

Recursive square using a sequence of differences of squares.

f = x -> x^2

f(x + 1) - x^2 = 2x + 1

the sum from i=1 to n of 2(i - 1) + 1 = n^2

Proof by induction:

k = 1: 2(0) + 1 = 1
k = 2: 2(0) + 1 + 2(1) + 1 = 4
k + 1 = 2 + 1 = 3: 2(0) + 1 + 2(1) + 1 + 2(2) + 1 = 9

*/

#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <stdint.h>

uint64_t square_sum(uint64_t num) {
	uint64_t n = 0;
	for (uint64_t i = 0; i < num; i++) {
		n += (2 * i) + 1;
	}
	return n;
}

int usage(char *name) {
	printf("usage: %s num\n", name);
	return 1;
}

int main(int argc, char **argv) {

	if (argc != 2) {
		return usage(argv[0]);
	} else {
		uint64_t num = strtoll(argv[1], NULL, 10);
		printf("square(%lld) is %lld\n", num, square_sum(num));
	}
}
