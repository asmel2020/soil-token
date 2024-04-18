import { Contract } from "ethers";
import { ethers } from "hardhat";
import { expect } from "chai";

let soil: Contract;

let owner: any;

let user: any;

let userTwo: any;
describe("StakingSoil", function () {

  async function deploySoil() {
    const contractName = "Soil";
    const Contract = await ethers.deployContract(contractName);
    return Contract.waitForDeployment();
  }

  describe("deploy", function () {
    it("deploy token soil", async function () {
      soil = await deploySoil();
      const [owne, use, useTwo] = await ethers.getSigners();
      owner = owne;
      user = use;
      userTwo = useTwo;
    });

    it("init token soil supply", async function () {
      const supply = await soil.totalSupply();
      expect(Number(supply)).to.equal(0);
    });

    it("mint soil", async function () {
      await soil.mint(user.address, "5000000000000000000");
      const supply = await soil.totalSupply();
      expect(Number(supply)).to.equal(5000000000000000000);
    });

    it("mint Batch soil", async function () {
      const address = [];
      const value = [];

      for (let index = 0; index < 1000; index++) {
        address.push(userTwo.address);
        value.push("5000000000000000000");
      }

      await soil.mintBatch(address, value);
    });
  });
  
});
