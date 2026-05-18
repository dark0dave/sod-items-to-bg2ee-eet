#!/usr/bin/env bash
set -euo pipefail

validate() {
  echo $1
  extension=$( echo "${1}" | awk -F '.' '{print $NF}' )
  if [[ " ${SUPPORTED[*]} " =~ [[:space:]]${extension}[[:space:]] ]]; then
    weidu --nogame --parse-check "${extension}" "${1}"
  fi
}

main() {
  for file in $( find . -type f -iname "*.d" ); do
    validate "${file}"
  done
  for file in $( find . -type f -iname "*.tp2" ); do
    validate "${file}"
  done
  for file in $( find . -type f -iname "*.tpa" ); do
    validate "${file}"
  done
  for file in $( find . -type f -iname "*.tpp" ); do
    validate "${file}"
  done
}

main
