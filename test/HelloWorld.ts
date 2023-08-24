import { ethers } from "hardhat";

describe("HelloWorld", function () {
  async function deploy() {
    const contractName = "HelloWorld";
    const Contract = await ethers.getContractFactory(contractName);
    return await Contract.deploy();
  }

  describe("deploy", function () {
    it("deploy", async function () {
      await deploy();
    });
  });
});
