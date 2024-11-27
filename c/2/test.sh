
assert () {
  if [[ $2 != $3 ]]; then
    echo "$1 failed. ($2 != $3)"
  else
    echo -n .
  fi
}

# 1. cat /dev/null
assert input_size_is_0_test $(cat /dev/null | ./cat | wc -c) 0
cat /dev/null | ./cat
assert exit_status_test $? 0

# 2. echo -n 1 | ./cat
assert input_size_is_1_test $(echo -n 1 | ./cat | wc -c) 1

# 3. 128KiB (=131072)
assert input_size_is_131072_test $(cat /dev/zero | head -c 131072 | ./cat | wc -c) 131072

# 4. 128KiB+1 (=131073)
assert input_size_is_131073_test $(cat /dev/zero | head -c 131073 | ./cat | wc -c) 131073

