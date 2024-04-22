/**
 *
 *  MyToken smart contract deployment and add to openzeppelin admin module
 *
 **/

import { ethers, upgrades, run } from "hardhat";
import sleep from "../utils/sleep";
import * as fs from "fs";
export const dispenser = async () => {
  const contractName: string = "Dispenser";
  const [owner] = await ethers.getSigners();

  const Contract = await ethers.getContractFactory(contractName);

  const { soil } = JSON.parse(fs.readFileSync("parameter.json", "utf8"));

  const contract = await upgrades.deployProxy(Contract, [
    soil.address,
    owner.address,
    owner.address,
    owner.address,
    owner.address,
  ]);

  await contract.waitForDeployment();

  console.log(`${contractName} contract deploy address: `, contract.target);
  /*  console.log(`${contractName} : start Verify address: `, contract.target); */

  await sleep(2000);
  return
  /*  try {
    await run("verify:verify", {
      address: contract.target,
      constructorArguments: [],
    });
  } catch (error) {
    console.log(`${contractName} : Error Verify address: `, contract.target);
  } */
};

dispenser().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
