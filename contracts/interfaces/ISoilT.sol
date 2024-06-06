// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

interface ISoilT {
    struct MintBatchPrams {
        address accounts;
        uint256 values;
    }

    function mint(address to, uint256 amount) external;

    function burn(uint256 amount) external;

    function mintBatch(MintBatchPrams[] memory mintBatchPrams) external;
}
