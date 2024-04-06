import { PLAYGROUND_CONTRACT_ADDRESS, aptos } from "@/utils/aptos";
import { useWallet } from "@aptos-labs/wallet-adapter-react";
import { Button } from "@chakra-ui/react";

export const Run = () => {
  const { account, signAndSubmitTransaction } = useWallet();

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
