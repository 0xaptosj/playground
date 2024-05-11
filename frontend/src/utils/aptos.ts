import { Aptos, AptosConfig, Network } from "@aptos-labs/ts-sdk";

export const PLAYGROUND_CONTRACT_ADDRESS =
  "0xcff52b2cca5126a222752a9d04c680b134127b59e7a8457d940163316f1b4f60";

const config = new AptosConfig({
  network: Network.TESTNET,
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

export const getStakingReward = async () =>
  // delegatorAddr: string,
  // poolAddress: string
  {
    const delegatorAddr =
      "0x42b7cd08d63005d04c8dd0ed5e7e1acab3cf20bf77dab114ba5a2806d0b97be2";
    const poolAddress =
      "0x9bfd93ebaa1efd65515642942a607eeca53a0188c04c21ced646d2f0b9f551e8";
    aptos.getDelegatedStakingActivities({
      delegatorAddress: delegatorAddr,
      poolAddress: poolAddress,
    });

    const [activeStake, inactiveStake, pendingInactiveStake] = await aptos.view(
      {
        payload: {
          function: "0x1::delegation_pool::get_stake",
          typeArguments: [],
          functionArguments: [poolAddress, delegatorAddr],
        },
        options: {
          ledgerVersion: 0, // last ledger version of the epoch
        },
      }
    );
  };

export const getNftMintingEvents = async () => {
  const nftCollectionAddress =
    "0x9b716a3434409bb6c7feaf4174962b635aaf489ddc3174e8fb8c411811638f4b";
  const events = await aptos.queryIndexer({
    query: {
      query: `
query MyQuery {
  token_activities_v2(
    limit: 10
    where: {current_token_data: {collection_id: {_eq: "${nftCollectionAddress}"}}, type: {_eq: "0x4::collection::MintEvent"}}
  ) {
    type
    transaction_version
    token_amount
    from_address
    to_address
  }
}
`,
    },
  });
  console.log("minting events", events);
};
