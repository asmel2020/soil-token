/** 
 * 
 *  MyToken smart contract deployment and add to openzeppelin admin module
 * 
 **/

import { ethers, run} from "hardhat";
import fs from 'fs';
import {sleep} from 'sleep';
async function main() {
  const contractName='Soil'

  const Contract = await ethers.getContractFactory(contractName);

  const contract = await Contract.deploy();

  const d=await contract.deployed();
  
  console.log(`${contractName} contract deploy address: `,contract.address);

  const token ={
    soil:{
      address: contract.address,
    }
  }

  fs.writeFileSync('parameter.json', JSON.stringify(token, null, 2));

  console.log(`${contractName} : start Verify address: `,contract.address);
  
  sleep(30);
 
  try {
    await run("verify:verify", {
      address: contract.address,
      constructorArguments: [
      ],
    });
  } catch (error) {
    console.log(`${contractName} : Error Verify address: `,contract.address);
  }
 
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

