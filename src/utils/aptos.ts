import { Aptos, AptosConfig, Network } from "@aptos-labs/ts-sdk";

export const PLAYGROUND_CONTRACT_ADDRESS =
  "0xcff52b2cca5126a222752a9d04c680b134127b59e7a8457d940163316f1b4f60";

const config = new AptosConfig({
  network: Network.MAINNET,
});
export const aptos = new Aptos(config);

export const getCoinSupply = async () => {
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

export const getFungibleAssetObjectAddress = async () => {
  return aptos.view({
    payload: {
      function: `${PLAYGROUND_CONTRACT_ADDRESS}::fungible_asset_playground::get_fa_obj_address`,
      typeArguments: [],
      functionArguments: [],
    },
  });
};

export const getFungibleAssetSupply = async () => {
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

export const bulkResolveAnsName = async () => {
  return aptos.view({
    payload: {
      function: `${PLAYGROUND_CONTRACT_ADDRESS}::ans_playground::bulk_resolve_ans_name`,
      typeArguments: [],
      functionArguments: [
        ["abcded", "abcded"],
        [null, null],
      ],
    },
  });
};

export const getAccountTxs = async () => {
  return aptos
    .getAccountTransactions({
      accountAddress:
        "0x30fc5066aa21bdf9d2ab60353a81601927ea2877966adea38ae821f55b976891",
    })
    .then((result) => {
      return result.map((tx) => {
        return tx.hash;
      });
    });
};

export const getAccountTxsCount = async () => {
  return aptos.getAccountTransactionsCount({
    accountAddress:
      "0x30fc5066aa21bdf9d2ab60353a81601927ea2877966adea38ae821f55b976891",
  });
};
