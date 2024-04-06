#!/bin/sh

set -e

echo "##### Running tests #####"

PUBLISHER_ADDR="0x100"
ANS_ADDR="0x101"

aptos move test \
  --package-dir move \
  --named-addresses "playground_addr=$PUBLISHER_ADDR, aptos_names=$ANS_ADDR, aptos_names_admin=$ANS_ADDR, aptos_names_funds=$ANS_ADDR, router_signer=$ANS_ADDR, aptos_names_v2_1=$ANS_ADDR, router=$ANS_ADDR"
#  --dev
