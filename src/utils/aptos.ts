import { Aptos, AptosConfig, Network } from "@aptos-labs/ts-sdk";

export const PLAYGROUND_CONTRACT_ADDRESS =
  "0xe54401e37afa2712eec8288518b4ff0032cf82961155a603b3c91513258f6caa";

const config = new AptosConfig({
  network: Network.TESTNET,
});
export const aptos = new Aptos(config);

const getCoinSupply = async () => {
  return aptos.view({
    payload: {
      function: "0x1::coin::supply",
      typeArguments: [
        `${PLAYGROUND_CONTRACT_ADDRESS}::coin_playground::TestCoin`,
      ],
      functionArguments: [],
    },
  });
};

const getFungibleAssetObjectAddress = async () => {
  return aptos.view({
    payload: {
      function: `${PLAYGROUND_CONTRACT_ADDRESS}::fungible_asset_playground::get_fa_obj_address`,
      typeArguments: [],
      functionArguments: [],
    },
  });
};

const getFungibleAssetSupply = async () => {
  let fungibleAssetObjectAddress = (
    await getFungibleAssetObjectAddress()
  )[0] as string;
  return aptos.view({
    payload: {
      function: "0x1::fungible_asset::supply",
      typeArguments: [],
      functionArguments: [fungibleAssetObjectAddress],
    },
  });
};
