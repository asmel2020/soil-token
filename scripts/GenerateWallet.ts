/**
 *
 *  MyToken smart contract deployment and add to openzeppelin admin module
 *
 **/

import { ethers, run } from "hardhat";
import fs from "fs";
import sleep from "../utils/sleep";

async function main() {
  const contractName = "Soil";

  const { privateKey, publicKey, address, mnemonic, path } =
    ethers.Wallet.createRandom();

  console.log({
    address,
    publicKey,
    privateKey,
    mnemonic,
    path,
  });
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
