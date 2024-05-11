#!/bin/sh

set -e

echo "##### Upgrade module #####"

# Profile is the account you used to execute transaction
# Run "aptos init" to create the profile, then get the profile name from .aptos/config.yaml
PUBLISHER_PROFILE=testnet-profile-2

ANS_ADDR="0x5f8fd2347449685cf41d4db97926ec3a096eaf381332be4f1318ad4d16a8497c"

CONTRACT_ADDRESS=$(cat contract_address.txt)

aptos move upgrade-object-package \
  --object-address $CONTRACT_ADDRESS \
  --named-addresses "playground_addr=$CONTRACT_ADDRESS, aptos_names=$ANS_ADDR, aptos_names_admin=$ANS_ADDR, aptos_names_funds=$ANS_ADDR, router_signer=$ANS_ADDR, aptos_names_v2_1=$ANS_ADDR, router=$ANS_ADDR"\
  --profile $PUBLISHER_PROFILE \
  --assume-yes --skip-fetch-latest-git-deps
