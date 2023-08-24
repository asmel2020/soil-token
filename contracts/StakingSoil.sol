// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "./interfaces/IStakingSoil.sol";
import "./interfaces/ISoil.sol";

contract StakingSoil is
    Initializable,
    AccessControlUpgradeable,
    UUPSUpgradeable,
    IStakingSoil
{
    bytes32 public constant UPGRADER_ROLE = keccak256("UPGRADER_ROLE");
    bytes32 public constant CREATE_STAKING_ROLE =
        keccak256("CREATE_STAKING_ROLE");

    mapping(uint => Data) public StakingData; // id => date
    mapping(address => uint[]) public OwnerStakingIds; // address => id[]

    uint public amountOfStakingIds;
    uint public amountOfStakingSoil;

    ISoil public tokenSoil;
    IERC20 public Ierc20;

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize(address _tokenSoil) public initializer {
        __AccessControl_init();
        __UUPSUpgradeable_init();

        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(UPGRADER_ROLE, msg.sender);
        _grantRole(CREATE_STAKING_ROLE, msg.sender);

        tokenSoil = ISoil(_tokenSoil);
        Ierc20 = IERC20(_tokenSoil);
    }

    function _authorizeUpgrade(
        address newImplementation
    ) internal override onlyRole(UPGRADER_ROLE) {}

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

        for (uint i = 0; i < _owners.length; ) {
            uint amount = _amounts[i];
            address owners = _owners[i];

            unchecked {
                _id++;
                i++;
                amountSoil += amount;
            }

            StakingData[_id] = Data(
                _id,
                owners,
                amount,
                amount * 2,
                block.timestamp,
                block.timestamp + (365 * 1 days),
                false
            );

            OwnerStakingIds[owners].push(_id);

            emit StakingCreated(_id, owners, amount);
        }

        amountOfStakingIds = _id;
        amountOfStakingSoil += amountSoil;

        tokenSoil.mint(address(this), amountSoil);
    }

    function emergencyWithdrawal(uint _amount) public onlyRole(DEFAULT_ADMIN_ROLE){
        Ierc20.transfer(msg.sender, _amount);
    }

    function emergencyWithdrawalBNB() public onlyRole(DEFAULT_ADMIN_ROLE){
        Address.sendValue(payable(msg.sender), address(this).balance);
    }

    function claimReward(uint _idStaking) external {
        Data storage stakingData = StakingData[_idStaking];

        require(!stakingData.isWithdrawn, "StakingSoil: already withdrawn");
        require(stakingData.owner == msg.sender, "StakingSoil: not owner");
        require(
            block.timestamp >= stakingData.endTime,
            "StakingSoil: not end time"
        );

        stakingData.isWithdrawn = true;

        Ierc20.transfer(msg.sender, stakingData.soilReward);

        amountOfStakingSoil -= stakingData.soilReward;

        emit StakingWithdrawn(_idStaking, msg.sender, stakingData.soilReward);
    }

    function getStakingIds(address _owner) public view returns (uint[] memory) {
        return OwnerStakingIds[_owner];
    }

    function getStaking(uint _id) public view returns (Data memory) {
        return StakingData[_id];
    }
}
