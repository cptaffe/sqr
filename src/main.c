/*

square using a sequence of differences of squares.

f: x -> x^2

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
#include <errno.h>
#include <string.h>
#include <limits.h>

const char *i_flag = "-i";
const char *i_long_flag = "--iterative";
const char *r_flag = "-r";
const char *r_long_flag = "--recursive";

// recursive calculuation of series
uint64_t square_sum_rec(uint64_t num) {
	if (num == 0) {
		return 0;
	} else {
		return ((num - 1) << 1) + 1 + square_sum_rec(num  - 1);
	}
}

// iterative calculation of series
uint64_t square_sum(uint64_t num) {
	uint64_t n = 0;
	for (uint64_t i = 0; i < num; i++) {
		n += (i << 1) + 1;
	}
	return n;
}

void usage(char *name) {
	fprintf(stderr, "usage: %s num [%s | %s | %s | %s]\n", name, i_flag, i_long_flag, r_flag, r_long_flag);
}

int main(int argc, char **argv) {

	if (argc < 2) {
		usage(argv[0]);
		return EXIT_FAILURE;
	} else {

		uint64_t (*func)(uint64_t) = square_sum; // square function

		int num_args = 0; // number of numbers as arguments
		uint64_t num; // num arg

		// handle command line options
		for (int i = 1; i < argc; i++) {

			// parse option
			if (argv[i][0] == '-' && !isdigit(argv[i][1])) {
				if (strcmp(argv[i], r_flag) == 0
				|| strcmp(argv[i], r_long_flag) == 0) {
					func = square_sum_rec;
				} else if (strcmp(argv[i], i_flag) == 0
				|| strcmp(argv[i], i_long_flag) == 0) {
					func = square_sum;
				} else {
					// unknown argument, error.
					fprintf(stderr, "unrecognized argument '%s'\n", argv[i]);
					usage(argv[0]);
					return EXIT_FAILURE;
				}
			} else {
				// check if a number, else error
				char *end = NULL;
				errno = 0;
				num = strtoll(argv[i], &end, 10);
				// catch conversion error
				if (errno != 0) { // some set errno for specific failure
					if (errno == ERANGE && num == LLONG_MAX) {
						fprintf(stderr, "number too large, max: %lld\n", LLONG_MAX);
					} else if (errno == ERANGE && num == LLONG_MIN) {
						fprintf(stderr, "number too small, min: %lld\n", LLONG_MIN);
					} else if (errno == EINVAL) {
						fprintf(stderr, "unrecognized argument '%s'\n", argv[i]);
						usage(argv[0]);
					} else {
						fprintf(stderr, "%s\n", strerror(errno));
						usage(argv[0]);
					}
					return EXIT_FAILURE;
				} else if (argv[i] == end) {
					fprintf(stderr, "unrecognized argument '%s'\n", argv[i]);
					usage(argv[0]);
					return EXIT_FAILURE;
				} else {
					num_args++;
				}
			}
		}

		// check if args are satisfied
		if (num_args != 1) { // accepts only one numerical argument
			usage(argv[0]);
			return EXIT_FAILURE;
		} else {
			printf("%lld\n", func(abs(num)));
		}
	}
}
