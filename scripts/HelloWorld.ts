/** 
 * 
 *  MyToken smart contract deployment and add to openzeppelin admin module
 * 
 **/

import { ethers} from "hardhat";

async function main() {

  const contractName='HelloWorld'

  const Contract = await ethers.getContractFactory(contractName);

  const contract = await Contract.deploy();

  console.log(`${contractName} contract deploy address: `,contract.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

