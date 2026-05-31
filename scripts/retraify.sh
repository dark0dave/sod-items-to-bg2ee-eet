#!/usr/bin/env bash
set -euo pipefail

weidu --nogame --untraify-tra k0_iskp/lang/english/weidu.tra --untraify-d k0_iskp/setup-k0_iskp.tp2
sed -i 's/ \/\*.*\*\///g' k0_iskp/setup-k0_iskp.tp2
weidu --nogame --traify-comment --traify-old-tra k0_iskp/lang/english/weidu.tra --traify k0_iskp/setup-k0_iskp.tp2
mv k0_iskp/setup-k0_iskp.tra k0_iskp/lang/english/weidu.tra
