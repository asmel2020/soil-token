// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./interfaces/IStakingSoil.sol";
import "./interfaces/ISoil.sol";
contract StakingSoil is Initializable, AccessControlUpgradeable, UUPSUpgradeable,IStakingSoil {
    bytes32 public constant UPGRADER_ROLE = keccak256("UPGRADER_ROLE");
    bytes32 public constant CREATE_STAKING_ROLE = keccak256("CREATE_STAKING_ROLE");

    mapping(uint => Data) public StakingDate; // id => date
    mapping(address => uint[]) public OwnerStakingIds; // address => id[]

    uint public amountOfStakingIds;
    uint public amountOfStakingSoil;
    
    address public ow;
    ISoil public tokenSoil;
    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor(){
        _disableInitializers();
    }

    function initialize(address _tokenSoil) initializer public {
        __AccessControl_init();
        __UUPSUpgradeable_init();

        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(UPGRADER_ROLE, msg.sender);
        _grantRole(CREATE_STAKING_ROLE, msg.sender);

        tokenSoil = ISoil(_tokenSoil);
    }

    function _authorizeUpgrade(address newImplementation)
        internal
        onlyRole(UPGRADER_ROLE)
        override
    {}

     function createStaking(
        address[] memory _owners,
        uint[] memory _amounts
    ) public onlyRole(CREATE_STAKING_ROLE) {
        require(
            _owners.length == _amounts.length,
            "StakingSoil: _owners and _amounts length mismatch"
        );

        uint _id = amountOfStakingIds;
        uint amountSoil;

        for (uint i = 0; i < _owners.length;) {

            uint amount = _amounts[i];
            address owners = _owners[i];

            unchecked {
                _id++;
                i++;
                amountSoil += amount;
            }

            StakingDate[_id] = Data(
                _id,
                amount,
                amount * 2,
                block.timestamp,
                block.timestamp + (365 * 1 days)
            );

           OwnerStakingIds[owners].push(_id);
        }

        amountOfStakingIds = _id;
        amountOfStakingSoil += amountSoil;

        tokenSoil.mint(address(this), amountSoil);
    }

    function getStakingIds(address _owner)
        public
        view
        returns (uint[] memory)
    {
        return OwnerStakingIds[_owner];
    }

    function getStaking(uint _id) public view returns (Data memory) {
        return StakingDate[_id];
    }

}