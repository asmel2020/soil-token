// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.9;

import "@openzeppelin/contracts-upgradeable/utils/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Dispenser is
    Initializable,
    PausableUpgradeable,
    AccessControlUpgradeable,
    UUPSUpgradeable
{
    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
    bytes32 public constant UPGRADER_ROLE = keccak256("UPGRADER_ROLE");
    bytes32 public constant SEND_TOKENS_ROLE = keccak256("SEND_TOKENS_ROLE");
    
    IERC20 Ierc20;
    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize(
        address addressSoil,
        address defaultAdmin,
        address sendToken,
        address pauser,
        address upgrader
    ) public initializer {
        __Pausable_init();
        __AccessControl_init();
        __UUPSUpgradeable_init();
        Ierc20 = IERC20(addressSoil);


        _grantRole(DEFAULT_ADMIN_ROLE, defaultAdmin);
        _grantRole(SEND_TOKENS_ROLE, sendToken);
        _grantRole(PAUSER_ROLE, pauser);
        _grantRole(UPGRADER_ROLE, upgrader);
    }

    function pause() public onlyRole(PAUSER_ROLE) {
        _pause();
    }

    function unpause() public onlyRole(PAUSER_ROLE) {
        _unpause();
    }

    function sendTokens(
        address[] calldata accounts,
        uint256[] calldata values
    ) public  whenNotPaused onlyRole(SEND_TOKENS_ROLE) {
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

        for (uint256 i = 0; i < accountsLength; ) {
            Ierc20.transfer(accounts[i], values[i]);
            unchecked {
                i++;
            }
        }
    }

    function _authorizeUpgrade(
        address newImplementation
    ) internal override onlyRole(UPGRADER_ROLE) {}
}
