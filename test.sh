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

	# test for squaring ability
	TEST=("${CMD} 5" "${CMD} 6")
	ANS=("25" "36")
	for ((i=0;i<${#TEST[@]};++i)); do
		# test code
		t="${TEST[i]}"
		a="${ANS[i]}"
		echo "${t}"
		if test "$(${t})" -eq "${a}"; then
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

	# test for sign support
	TEST=("${CMD} -5" "${CMD} -6")
	ANS=("25" "36")
	for ((i=0;i<${#TEST[@]};++i)); do
		# test code
		t="${TEST[i]}"
		a="${ANS[i]}"
		echo "${t}"
		if test "$(${t})" -eq "${a}"; then
			pass
		else
			fail
		fi
	done

	# fail for too large or too small numbers
	# llong range (-9223372036854775808, 9223372036854775807)
	TEST=("${CMD} 9223372036854775808" "${CMD} -9223372036854775809")
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
