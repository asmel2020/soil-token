// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

interface IStakingSoil {
    event StakingCreated(uint id, address owner, uint amounts);
    event StakingWithdrawn(uint id, address owner, uint amounts);

    struct Data {
        uint id; // id de el staking
        address owner; // address de el staking
        uint soilDeposited; // cantidad de soil depositados
        uint soilReward; // cantidad de soil a retirar
        uint startTime; // fecha del comienzo del staking
        uint endTime; // culminacion de staking
        bool isWithdrawn; // si ya se retiro
    }

    struct DepositStaking {
        address owner; // address de el staking
        uint amount; // cantidad de soil depositados
    }

    function createStaking(DepositStaking[] memory _depositStaking) external;

    function getStaking(address _owner) external view returns (Data[] memory);

    function getStakingId(uint _id) external view returns (Data memory);
}
