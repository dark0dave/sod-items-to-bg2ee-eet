#!/usr/bin/env bash
set -euo pipefail

main() {
  for folder in $(find k0_iskp -type d -name '*[[:upper:]]*'); do
    mv -i "${folder}" $( echo "${folder}" | tr 'A-Z' 'a-z');
  done
  for file in $(find k0_iskp -type f -name '*[[:upper:]]*'); do
    mv -i "${file}" $( echo "${file}" | tr 'A-Z' 'a-z');
  done
}

main
