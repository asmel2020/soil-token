// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

interface ISoilT {
    function mint(address to, uint256 amount) external;
    function burn(uint256 amount) external;
    function mintBatch(
        address[] memory accounts,
        uint256[] memory values
    ) external;
}
