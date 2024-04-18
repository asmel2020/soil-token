// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "./interfaces/ISoil.sol";
contract Soil is ERC20, AccessControl, ISoil {
    
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant BURN_ROLE = keccak256("BURN_ROLE");

    constructor() ERC20("Soil", "SL") {
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
        address[] calldata accounts,
        uint256[] calldata values
    ) public onlyRole(MINTER_ROLE) {
        uint256 accountsLength = accounts.length;
        uint256 valuesLength = values.length;

        require(accountsLength >= 1, "Soil::accounts cannot be empty");
        require(valuesLength >= 1, "Soil::values cannot be empty");

        require(accountsLength <= 1000, "Soil::limit exceeded");
        require(valuesLength <= 1000, "Soil::limit exceeded");

        require(
            accountsLength == valuesLength,
            "Soil::the amount of data is not equal"
        );

        for (uint256 i = 0; i < accountsLength;) {
            _mint(accounts[i], values[i]);

            unchecked {
                i++;
            }
        }
    }
}
