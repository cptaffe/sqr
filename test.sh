#!/usr/bin/env bash

# test script for sqr

# set -o errexit # testing, failures are good.
set -o pipefail
set -o nounset
# set -o xtrace

usage() {
	echo "${0} command logfile"
}

# config
if test "${#}" -eq 2; then
	CMD="${1}"
	LOG_FILE="${2}"
else
	usage;
	exit 1
fi

# totals
PASS=0
FAIL=0

# what to do on failure
fail() {
	((FAIL++))
	echo "fail!"
}

# what to do on success
pass() {
	((PASS++))
	echo "pass!"
}

summary() {
	echo "passes: ${PASS}"
	echo "failures: ${FAIL}"

	# exit unhappily on failures.
	if test "${FAIL}" -gt 0; then
		exit 1
	fi
}

# do_tests runs all tests
# as a function, io can be redirected as needed.
do_tests() {

	# squares properly
	TEST=("${CMD} 5")
	for t in "${TEST[@]}"; do
		# test code
		echo "${t}"
		if test "$(${t})" -eq 25; then
			pass
		else
			fail
		fi
	done

	# test flag order (short)
	TEST=("${CMD} -i 5" "${CMD} -r 5" "${CMD} 5 -i" "${CMD} 5 -r")
	for t in "${TEST[@]}"; do
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
	for t in "${TEST[@]}"; do
		# test code
		echo "${t}"
		if test "$(${t})" -eq 25; then
			pass
		else
			fail
		fi
	done

	# text argument (fail is success)
	TEST=("${CMD} hello" "${CMD} 5 -h" "${CMD} 5 --hello")
	for t in "${TEST[@]}"; do
		# test code
		echo "${t}"
		${t} 2>&1 # redirects error message to whatever stdio is redirected to.
		if test "${?}" -ne 0; then
			pass
		else
			fail
		fi
	done
}

do_tests > "${LOG_FILE}"

summary # summarize testing
