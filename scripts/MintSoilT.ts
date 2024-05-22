/**
 *
 *  MyToken smart contract deployment and add to openzeppelin admin module
 *
 **/

import { ethers, run } from "hardhat";
import sleep from "../utils/sleep";
import * as fs from "fs";

async function main() {
  const { soil } = JSON.parse(fs.readFileSync("parameter.json", "utf8"));
  const contractName = "Soil";
  const Contract = await ethers.deployContract(contractName);

  let soils =Contract.attach(soil.address) as any

  await soils.mint(
    "0x9fE46736679d2D9a65F0992F2272dE9f3c7fa6e0",
    1000000000000000000000000000000000000n
  );
  console.log("mint")
  await sleep(2000);

  return;
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
