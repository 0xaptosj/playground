"use client";

import {
  PLAYGROUND_CONTRACT_ADDRESS,
  aptos,
  bulkResolveAnsName,
  getAccountTxs,
  getAccountTxsCount,
} from "@/utils/aptos";
import { useWallet } from "@aptos-labs/wallet-adapter-react";
import { Button } from "@chakra-ui/react";

export const Run = () => {
  const { account, signAndSubmitTransaction } = useWallet();
  // bulkResolveAnsName().then((result) => {
  //   console.log(result);
  // });
  // getAccountTxs().then((result) => {
  //   console.log("user tx", result.length);
  // });
  // getAccountTxsCount().then((result) => {
  //   console.log("user tx count", result);
  // });

  const onSubmit = async () => {
    if (!account) {
      throw new Error("Wallet not connected");
    }
    const response = await signAndSubmitTransaction({
      sender: account.address,
      data: {
        function: `${PLAYGROUND_CONTRACT_ADDRESS}::playground_1::my_function`,
        typeArguments: [],
        functionArguments: [[true, true]],
      },
      // data: {
      //   function: "0x3::token::create_collection_script",
      //   typeArguments: [],
      //   functionArguments: [
      //     "name",
      //     "description",
      //     "https://www.google.com",
      //     123,
      //     [true, true],
      //   ],
      // },
    });
    await aptos
      .waitForTransaction({
        transactionHash: response.hash,
      })
      .then(() => {
        console.log("Bought");
      });
  };

  return (
    <Button width={160} onClick={onSubmit}>
      Buy
    </Button>
  );
};
