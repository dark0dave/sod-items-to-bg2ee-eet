#!/usr/bin/env bash
set -euo pipefail

main() {
  for file in $(find . -type f -iname "setup*.tp2" | sort | uniq ); do
    local start=""
    local comp_number=0
    while read line; do
      echo "${start}"
      if [[ "${line}" == *"BEGIN ~"* ]]; then
        start="true"
        continue;
      fi
      if [[ "${start}" = "true" && "${line}" == *"DESIGNATED"* ]]; then
        comp_number=$(echo $line | awk '{print $NF}')
        rm -f "k0_iskp/lib/comp_${comp_number}.tpa"
        touch "k0_iskp/lib/comp_${comp_number}.tpa" || true
        start="skip"
        continue;
      fi
      if [[ "${start}" = "skip" && "${line}" == *"REQUIRE_PREDICATE"* ]]; then
        start="buffer"
        continue;
      fi
      if [[ "${start}" = "buffer" && "${line}" != "" ]]; then
        echo -e "${line}" >> "k0_iskp/lib/comp_${comp_number}.tpa"
      fi
    done < "${file}"
  done
}

main
