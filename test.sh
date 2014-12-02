#!/usr/bin/env bash

# test script for sqr

# set -o errexit # testing, failures are good.
set -o pipefail
set -o nounset
# set -o xtrace

# config
CMD="./sqr"

# totals
PASS=0
FAIL=0

# what to do on failure
fail() {
	$((FAIL++))
	echo "fail!"
}

# what to do on success
pass() {
	$((PASS++))
	echo "pass!"
}

sum() {
	echo # whitespace
	echo "passes: ${PASS}"
	echo "failures: ${FAIL}"
}

# tests

# squares properly
if test "$(${CMD} 5)" -eq 25; then
	pass
else
	fail
fi

# test flag order (short)
TEST=("${CMD} -i 5" "${CMD} -r 5" "${CMD} 5 -i" "${CMD} 5 -r")
for t in "${TEST}"; do
	# test code
	echo "${t}"
	if test "$(${t})" -eq 25; then
		pass
	else
		fail
	fi
done

# test flag order (long)
TEST=("${CMD} --iterative 5" "${CMD} --recursive 5" "${CMD} 5 --iterative" "${CMD} 5 --recursive")
for t in "${TEST}"; do
	# test code
	echo "${t}"
	if test "$(${t})" -eq 25; then
		pass
	else
		fail
	fi
done

# number argument
TEST="${CMD} hello"
for t in "${TEST}"; do
	# test code
	echo "${t}"
	${t}
	if test "${?}" -ne 0; then
		pass
	else
		fail
	fi
done

sum # summarize testing
