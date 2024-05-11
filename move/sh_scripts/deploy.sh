#!/bin/sh

set -e

echo "##### Deploy module under a new object #####"

# Profile is the account you used to execute transaction
# Run "aptos init" to create the profile, then get the profile name from .aptos/config.yaml
PUBLISHER_PROFILE=testnet-profile-1

PUBLISHER_ADDR=0x$(aptos config show-profiles --profile=$PUBLISHER_PROFILE | grep 'account' | sed -n 's/.*"account": \"\(.*\)\".*/\1/p')
ANS_ADDR="0x5f8fd2347449685cf41d4db97926ec3a096eaf381332be4f1318ad4d16a8497c"

 OUTPUT=$(aptos move create-object-and-publish-package \
   --address-name playground_addr \
   --named-addresses "playground_addr=$PUBLISHER_ADDR, aptos_names=$ANS_ADDR, aptos_names_admin=$ANS_ADDR, aptos_names_funds=$ANS_ADDR, router_signer=$ANS_ADDR, aptos_names_v2_1=$ANS_ADDR, router=$ANS_ADDR"\
   --profile $PUBLISHER_PROFILE \
 	--assume-yes)

 # Extract the deployed contract address and save it to a file
 echo "$OUTPUT" | grep "Code was successfully deployed to object address" | awk '{print $NF}' | sed 's/\.$//' > contract_address.txt
 echo "Contract deployed to address: $(cat contract_address.txt)"
 echo "Contract address saved to contract_address.txt"

#aptos move create-object-and-publish-package \
#  --address-name playground_addr \
#  --named-addresses "playground_addr=$PUBLISHER_ADDR, aptos_names=$ANS_ADDR, aptos_names_admin=$ANS_ADDR, aptos_names_funds=$ANS_ADDR, router_signer=$ANS_ADDR, aptos_names_v2_1=$ANS_ADDR, router=$ANS_ADDR"\
#  --profile $PUBLISHER_PROFILE \
#	--assume-yes