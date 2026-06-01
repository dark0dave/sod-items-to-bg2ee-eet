#!/usr/bin/env bash
set -euo pipefail


function checkIE() {
  declare -i badfiles=0

  for file in $(find ./k0_iskp/ -iname "*.${1}" ); do
    [[ $( basename "${file}" | cut -f1 -d '.' | wc | awk '{ print $3}' ) -gt 9 ]] && echo "Error found: ${file} which is larger than 8 characters" && badfiles+=1;
  done

  if [[ "${badfiles}" -gt 0 ]]; then
    echo "Failed found bad files";
    exit 1;
  fi
}

function checkPathsInTp2() {
  for file in $(find . -type f -iname "*.tp2" | sort | uniq ); do
    for fileToMove in $(grep -E "COPY\W~.*\..{3}~\W~override" "${file}" | sed -E "s/^.*~(.*)~\W~.*$/\1/g"); do
      if [[ ! -f "${fileToMove}" ]]; then
        echo "${fileToMove} is not a file";
        exit 1;
      fi
    done
  done
}

function checkPathsInTpa() {
  for file in $(find . -type f -iname "*.tpa" | sort | uniq ); do
    for fileToMove in $(grep -E "COPY\W~.*\..{3}~\W~override" "${file}" | sed -E "s/^.*~(.*)~\W~.*$/\1/g"); do
      if [[ ! -f "${fileToMove}" ]]; then
        echo "${fileToMove} is not a file";
        exit 1;
      fi
    done
  done
}

function uniqueDesignated() {
  for file in $(find . -type f -iname "*.tp2" | sort | uniq ); do
    duplicates=$(grep -E "DESIGNATED\W+[0-9]+" "${file}" | sort | uniq -d);
    if [[ ! -z "${duplicates}" ]]; then
      echo "${duplicates} is duplicated in ${file}";
      exit 1;
    fi
  done
}

main() {
  checkIE "*bam"
  checkIE "*baf"
  checkIE "*cre"
  checkIE "*d"
  checkIE "*itm"
  checkIE "*spl"
  checkIE "*sto"
  checkIE "*wav"
  checkIE "*vvc"
  checkPathsInTp2
  checkPathsInTpa
  uniqueDesignated
}

main
