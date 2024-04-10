import { ethers, run } from "hardhat";
import fs from "fs";
import sleep from "../utils/sleep";
async function main() {
  await sleep(5000);

  const contractNameSoil = "Soil";
  const result = fs.readFileSync("parameter.json", "utf8");
  const parameter = JSON.parse(result);
  const ContractSoil = await ethers.getContractFactory(contractNameSoil);
  const contractSoil = ContractSoil.attach(parameter.soil.address);


  const grantRole = await contractSoil.grantRole(
    await contractSoil.MINTER_ROLE(),
    parameter.stakingSoil.address
  );
  await sleep(5000);
  const contractNameStaking = "StakingSoil";
  const ContractStaking = await ethers.getContractFactory(contractNameStaking);
  const contractStaking = ContractStaking.attach(parameter.stakingSoil.address);

  await contractStaking.grantRole(
    await contractStaking.CREATE_STAKING_ROLE(),
    "0xc62F81fc1929817448119B429464df50C31de4ea"
  );
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
