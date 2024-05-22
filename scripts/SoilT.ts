/**
 *
 *  MyToken smart contract deployment and add to openzeppelin admin module
 *
 **/

import { ethers, run } from "hardhat";
import sleep from "../utils/sleep";
import * as fs from "fs";

async function main() {
  const contractName = "SoilT";
  const Contract = await ethers.deployContract(contractName);
  const contract = await Contract.waitForDeployment();

  console.log(`${contractName} contract deploy address: `, contract.target);


  fs.writeFileSync(
    "parameter.json",
    JSON.stringify({
      soil: {
        address: contract.target,
      },
    })
  );

  await sleep(2000);
  console.log(`${contractName} : start Verify address: `, contract.target);

  try {
    await run("verify:verify", {
      address: contract.target,
      constructorArguments: [],
    });
  } catch (error) {
    console.log(`${contractName} : Error Verify address: `, contract.target);
  }

  return
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
