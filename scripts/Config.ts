import { ethers, run } from "hardhat";
import fs from "fs";
async function main() {
  const contractName = "Soil";

  const result = fs.readFileSync("parameter.json", "utf8");
  const parameter = JSON.parse(result);
  const Contract = await ethers.getContractFactory(contractName);
  const contract = Contract.attach(parameter.soil.address);
  const grantRole = await contract.grantRole(
    contract.MINTER_ROLE(),
    parameter.stakingSoil.address
  );
  grantRole.wait(1);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
