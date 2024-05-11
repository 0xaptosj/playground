#!/bin/sh

set -e

echo "##### Running move script #####"

CONTRACT_ADDRESS=$(cat contract_address.txt)
ANS_ADDR="0x5f8fd2347449685cf41d4db97926ec3a096eaf381332be4f1318ad4d16a8497c"

# Need to compile the package first
aptos move compile \
   --named-addresses "playground_addr=$CONTRACT_ADDRESS, aptos_names=$ANS_ADDR, aptos_names_admin=$ANS_ADDR, aptos_names_funds=$ANS_ADDR, router_signer=$ANS_ADDR, aptos_names_v2_1=$ANS_ADDR, router=$ANS_ADDR"

# Profile is the account you used to execute transaction
# Run "aptos init" to create the profile, then get the profile name from .aptos/config.yaml
SENDER_PROFILE=testnet-profile-1

# Run the script
aptos move run-script \
	--assume-yes \
  --profile $SENDER_PROFILE \
  --compiled-script-path build/playground/bytecode_scripts/transfer_object.mv
