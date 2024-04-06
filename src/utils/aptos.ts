import { Aptos, AptosConfig, Network } from "@aptos-labs/ts-sdk";

export const PLAYGROUND_CONTRACT_ADDRESS =
  "0xe54401e37afa2712eec8288518b4ff0032cf82961155a603b3c91513258f6caa";
export const APT = "0x1::aptos_coin::AptosCoin";
export const APT_UNIT = 100_000_000;

const config = new AptosConfig({
  network: Network.TESTNET,
});
export const aptos = new Aptos(config);
