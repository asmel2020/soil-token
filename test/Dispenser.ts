import { Contract } from "ethers";
import { ethers, upgrades } from "hardhat";
import { expect } from "chai";
import { Dispenser, Soil } from "../typechain-types";

let dispenser: Dispenser;
let soil: Soil;
let owner: any;

let user: any;

let userTwo: any;
describe("Dispenser", function () {
  async function deployDispenser(soilAddress: string, address: string) {
    const contractName: string = "Dispenser";
    const Contract = await ethers.getContractFactory(contractName);
    const contract = await upgrades.deployProxy(Contract, [
      soilAddress,
      address,

      address,
      address,
      address,
    ]);

    return contract.waitForDeployment() as any;
  }

  async function deploySoil() {
    const contractName = "Soil";
    const Contract = await ethers.deployContract(contractName);
    return Contract.waitForDeployment();
  }

  describe("deploy", function () {
    it("deploy token dispenser", async function () {
      const [owne, use, useTwo] = await ethers.getSigners();
      soil = (await deploySoil()) as any;
      dispenser = await deployDispenser(await soil.getAddress(), owne.address);

      owner = owne;
    });

    it("is Paused init", async function () {
      const isPaused = await dispenser.paused();
      expect(isPaused).to.equal(false);
    });

    it("Paused", async function () {
      await dispenser.pause();
      const isPaused = await dispenser.paused();
      expect(isPaused).to.equal(true);
    });

    it("unPaused", async function () {
      await dispenser.unpause();
      const isPaused = await dispenser.paused();
      expect(isPaused).to.equal(false);
    });

    it("mint soild", async function () {
      await soil.mint(dispenser.getAddress(), 10000000000000000000n);
      const balance = await soil.balanceOf(dispenser.getAddress());
      expect(balance).to.equal(10000000000000000000n);
    });

    it("sendToken", async function () {
      await dispenser.sendTokens([owner.address], [1000000000000000000n]);
      const balanceOwner = await soil.balanceOf(owner.address);
      const balanceDispenser = await soil.balanceOf(dispenser.getAddress());
      expect(balanceOwner).to.equal(1000000000000000000n);
      expect(balanceDispenser).to.equal(9000000000000000000n);
    });
    
  });
});
