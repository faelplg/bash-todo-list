#!/usr/bin/env bash

list="0"

while [[ $# -gt 0 ]]; do
	if [[ $1 == "list" ]]; then
		list="1"
	fi
	shift
done

echo "list=${list}"
