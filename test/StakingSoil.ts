import { Contract } from "ethers";
import { ethers, upgrades } from "hardhat";
import { Soil, StakingSoil } from "../typechain-types";
import { expect } from "chai";

let contract: Contract;
let soil: Contract;

describe("StakingSoil", function () {
  async function deploySoil() {
    const contractName = "Soil";
    const Contract = await ethers.getContractFactory(contractName);
    const contract = await Contract.deploy();
    return contract.deployed();
  }

  async function deployStaking(tokenSoil: string) {
    const contractName = "StakingSoil";
    const Contract = await ethers.getContractFactory(contractName);
    const contract = await upgrades.deployProxy(Contract, [tokenSoil], {
      kind: "uups",
    });
    return await contract.deployed();
  }

  describe("deploy", function () {
    it("deploy", async function () {
      soil = (await deploySoil()) as Soil;
      contract = (await deployStaking(soil.address)) as StakingSoil;
      await soil.grantRole(soil.MINTER_ROLE(), contract.address);
    });

    it("init token soil supply", async function () {
      const supply = await soil.totalSupply();
      expect(Number(supply)).to.equal(0);
    });

    it("get msg.sender STAKING_ROLE", async function () {
      const [owner] = await ethers.getSigners();
      const value = await contract.hasRole(
        "0x44509109151603d86942053cb40ae1fe8451c825aa675f1fc49d14fb37a3513e",
        owner.address
      );
      expect(value).to.equal(true);
    });

    it("init amount of Staking Id", async function () {
      const value = await contract.amountOfStakingIds();
      expect(Number(value)).to.equal(0);
    });

    it("init amount of Staking soil", async function () {
      const value = await contract.amountOfStakingSoil();
      expect(Number(value)).to.equal(0);
    });

    it("creates new Staking", async function () {
      await contract.createStaking(
        [
          "0xff954c6F305f6C7126060C79e6480D1B94A1C3b6",
          "0x156DC3bD6D985CF4BED2E9a6E114Dc6fa89a077D",
        ],
        ["850", "500"]
      );
      const value = await contract.amountOfStakingIds();
      expect(Number(value)).to.equal(2);
    });

    it("creates new createStakingMany", async function () {
      await contract.createStakingMany([
        {
          owner: "0xff954c6F305f6C7126060C79e6480D1B94A1C3b6",
          amount: "1000",
        },
      ]);  console.log('value');
      const value = await contract.amountOfStakingIds();
      console.log(value);
      expect(Number(value)).to.equal(3);
    });

    it("get Staking", async function () {
      const StakingDate = await contract.StakingData("1");
      expect(Number(StakingDate["soilDeposited"])).to.equal(850);
      expect(Number(StakingDate["soilReward"])).to.equal(1700);
    });

    it("get mount soil Staking", async function () {
      const amountOfStakingSoil = await contract.amountOfStakingSoil();
      expect(Number(amountOfStakingSoil)).to.equal(1350);
    });

    it("get new token soil supply", async function () {
      const supply = await soil.totalSupply();
      expect(Number(supply)).to.equal(1350);
    });

    it("creates new Staking", async function () {
      const [owner] = await ethers.getSigners();
      await contract.createStaking(
        ["0xff954c6F305f6C7126060C79e6480D1B94A1C3b6", owner.address],
        ["10000", "150"]
      );
      const value = await contract.amountOfStakingIds();
      expect(Number(value)).to.equal(4);
    });

    it("get new token soil supply", async function () {
      const supply = await soil.totalSupply();
      expect(Number(supply)).to.equal(11500);
    });

    it("get token amount contract Staking", async function () {
      const supply = await soil.balanceOf(contract.address);
      expect(Number(supply)).to.equal(11500);
    });

    /*  it("claim Reward", async function () {
      const stakingIds=await contract.claimReward("4");
    });

    it("get claimReward success", async function () {
      const stakingIds=await contract.StakingData('4');
      expect(stakingIds["isWithdrawn"]).to.equal(true);
    });


    it("balanceOf token soil reward", async function () {
      const [owner] = await ethers.getSigners();
      const balance=await soil.balanceOf(owner.address);
      expect(Number(balance)).to.equal(300);
    }); */
  });
});
