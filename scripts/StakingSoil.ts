/**
 *
 *  MyToken smart contract deployment and add to openzeppelin admin module
 *
 **/

import { ethers, run, upgrades } from "hardhat";
import fs from "fs";
import sleep from "../utils/sleep";

async function main() {
  const result = fs.readFileSync("parameter.json", "utf8");

  const parameter = JSON.parse(result);

  const contractName = "StakingSoil";

  const Contract = await ethers.getContractFactory(contractName);
  const contract = await upgrades.deployProxy(
    Contract as any,
    [parameter.soil.address],
    { kind: "uups" }
  );

  await contract.waitForDeployment();
  await sleep(2000);
  parameter["stakingSoil"] = {
    address: contract.target,
  };

  console.log(`${contractName} contract deploy address: `, contract.target);

  fs.writeFileSync("parameter.json", JSON.stringify(parameter, null, 2));

  console.log(`${contractName} : start Verify address: `, contract.target);

  try {
    await run("verify:verify", {
      address: contract.target,
    });
  } catch (error) {
    console.log(`${contractName} : Error Verify address: `, contract.target);
  }
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
