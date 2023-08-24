import { ethers } from "hardhat";

describe("Soil", function () {
  async function deploy() {
    const contractName = "Soil";
    const Contract = await ethers.getContractFactory(contractName);
    return await Contract.deploy();
  }

  describe("deploy", function () {
    it("deploy", async function () {
      await deploy();
    });
  });
});
