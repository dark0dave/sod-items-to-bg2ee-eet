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

function appendBamDescription() {
  for file in $(find . -type f -iname "*comp_20*.tpa" ); do
    item=$(grep -E "COPY.*k0_iskp/itm/.*itm" "${file}" | awk -F "/" '{print $3}' | awk -F "~" '{print $1}')
    [[ ! -f "k0_iskp/itm/${item}" ]] && continue;
    bam=$(hexdump -s 88 -n 8 -C "k0_iskp/itm/${item}" | head -1 | awk -F "|" '{print $2}'| sed "s/\.//g" | tr '[:upper:]' '[:lower:]')
    if [[ -f "k0_iskp/bam/${bam}.bam" ]] then
      cat <<EOF >> "${file}"

ACTION_IF NOT FILE_EXISTS_IN_GAME ~${bam}.bam~ BEGIN
  COPY ~k0_iskp/bam/${bam}.bam~ ~override~
END
EOF
    fi
  done
}

function checkForBam() {
  for file in $(find . -type f -iname "*.itm" ); do
    inv=$(hexdump -s 58 -n 8 -C "${file}"  | head -1 | awk -F "|" '{print $2}'| sed "s/\.//g" | tr '[:upper:]' '[:lower:]');
    desc=$(hexdump -s 88 -n 8 -C "${file}" | head -1 | awk -F "|" '{print $2}' | sed "s/\.//g" | tr '[:upper:]' '[:lower:]');
    [[ -z "${inv}" ]] && continue;
    if [[ ! -f "k0_iskp/bam/${inv}.bam" ]] then
      echo "${file}: MISSING ${inv}";
    fi
    [[ -z "${desc}" ]] && continue;
    if [[ ! -f "k0_iskp/bam/${desc}.bam" ]] then
      echo "${file}: MISSING ${desc}";
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
