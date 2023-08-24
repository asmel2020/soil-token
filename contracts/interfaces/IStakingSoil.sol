// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

interface IStakingSoil {
    struct Data {
        uint id; // id de el staking
        uint soilDeposited; // cantidad de soil depositados
        uint soilReward; // cantidad de soil a retirar
        uint startTime; // fecha del comienzo del staking
        uint endTime; // culminacion de staking
    }

    function createStaking(
        address[] memory _owners,
        uint[] memory _amounts
    ) external;

    function getStakingIds(
        address _owner
    ) external view returns (uint[] memory);

    function getStaking(uint _id) external view returns (Data memory);
}
