#!/bin/sh

set -e

echo "##### Upgrade module #####"

# Profile is the account you used to execute transaction
# Run "aptos init" to create the profile, then get the profile name from .aptos/config.yaml
PUBLISHER_PROFILE=testnet-profile-1

PUBLISHER_ADDR=0x$(aptos config show-profiles --profile=$PUBLISHER_PROFILE | grep 'account' | sed -n 's/.*"account": \"\(.*\)\".*/\1/p')
ANS_ADDR="0x5f8fd2347449685cf41d4db97926ec3a096eaf381332be4f1318ad4d16a8497c"

# to fill, you can find it from the output of deployment script
PLAYGROUND_CONTRACT_OBJECT_ADDR="0x0f4c6d7773f7f0d6881fbaaa6ac9c7b8c8fb7aea0950dbac60180a72eca0595b"
aptos move upgrade-object-package \
  --object-address $PLAYGROUND_CONTRACT_OBJECT_ADDR \
  --named-addresses "playground_addr=$PLAYGROUND_CONTRACT_OBJECT_ADDR, aptos_names=$ANS_ADDR, aptos_names_admin=$ANS_ADDR, aptos_names_funds=$ANS_ADDR, router_signer=$ANS_ADDR, aptos_names_v2_1=$ANS_ADDR, router=$ANS_ADDR"\
  --profile $PUBLISHER_PROFILE \
  --assume-yes
