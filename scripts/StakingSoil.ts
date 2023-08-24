/**
 *
 *  MyToken smart contract deployment and add to openzeppelin admin module
 *
 **/

import { ethers, run, upgrades } from "hardhat";
import fs from "fs";
import { sleep } from "sleep";

async function main() {
  const result = fs.readFileSync("parameter.json", "utf8");

  const parameter = JSON.parse(result);

  const contractName = "StakingSoil";

  const Contract = await ethers.getContractFactory(contractName);
  const contract = await upgrades.deployProxy(
    Contract,
    [parameter.soil.address],
    { kind: "uups" }
  );
 
  parameter["stakingSoil"] = {
    address: contract.address,
  };
 
  await contract.deployed();

  console.log(`${contractName} contract deploy address: `, contract.address);

  fs.writeFileSync("parameter.json", JSON.stringify(parameter, null, 2));

  console.log(`${contractName} : start Verify address: `,contract.address);
  
  sleep(30);

  try {
    await run("verify:verify", {
      address: contract.address,

    });
  } catch (error) {
    console.log(`${contractName} : Error Verify address: `,contract.address);
  }
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
