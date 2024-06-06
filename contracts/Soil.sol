// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "./interfaces/ISoilT.sol";

contract SoilT is ERC20, AccessControl, ISoilT {
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant BURN_ROLE = keccak256("BURN_ROLE");

    constructor() ERC20("SoilT", "SL") {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(MINTER_ROLE, msg.sender);
        _grantRole(BURN_ROLE, msg.sender);
    }

    function mint(address to, uint256 amount) public onlyRole(MINTER_ROLE) {
        _mint(to, amount);
    }

    function burn(uint256 amount) public onlyRole(BURN_ROLE) {
        _burn(_msgSender(), amount);
    }

    function mintBatch(
        MintBatchPrams[] calldata mintBatchPrams
    ) public onlyRole(MINTER_ROLE) {
        uint256 accountsLength = mintBatchPrams.length;

        require(accountsLength <= 1000, "SoilT::limit exceeded");

        for (uint256 i = 0; i < accountsLength; ) {
            _mint(mintBatchPrams[i].accounts, mintBatchPrams[i].values);

            unchecked {
                i++;
            }
        }
    }
}
