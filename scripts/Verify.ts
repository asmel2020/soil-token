import { ethers, upgrades, run } from "hardhat";
import sleep from "../utils/sleep";
import * as fs from "fs";


export const verify = async () => {

  const contractName: string = "Dispenser";

  const Contract = await ethers.getContractFactory(contractName);

  const { soil } = JSON.parse(fs.readFileSync("parameter.json", "utf8"));

   try {
    await run("verify:verify", {
      address: soil.address,
      constructorArguments: [],
    });
  } catch (error) {
    console.log(`${contractName} : Error Verify address: `, soil.address);
  }
};

verify().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});