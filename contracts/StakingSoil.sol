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
    bytes32 public constant CREATE_STAKING_ROLE = keccak256("CREATE_STAKING_ROLE");

    mapping(uint => Data) public StakingData; // id => date
    mapping(address => uint[]) public OwnerStakingIds; // address => id[]

    uint public amountOfStakingIds;
    uint public amountOfStakingSoil;

    ISoil public tokenSoil;
    IERC20 public Ierc20;


    address public walletProyect;
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
        walletProyect = 0xc62F81fc1929817448119B429464df50C31de4ea;
    }

    function _authorizeUpgrade(
        address newImplementation
    ) internal override onlyRole(UPGRADER_ROLE) {}

    function createStaking(
        DepositStaking[] memory _depositStaking
    ) public onlyRole(CREATE_STAKING_ROLE) {
        uint _id = amountOfStakingIds;
        uint amountSoil;

        for (uint i = 0; i < _depositStaking.length; ) {
            DepositStaking memory deposit = _depositStaking[i];

            unchecked {
                _id++;
                i++;
                amountSoil += deposit.amount;
            }

            StakingData[_id] = Data(
                _id,
                deposit.owner,
                deposit.amount,
                deposit.amount * 2,
                block.timestamp,
                block.timestamp + (365 * 1 days),
                false
            );

            OwnerStakingIds[deposit.owner].push(_id);

            emit StakingCreated(_id, deposit.owner, deposit.amount);
        }

        amountOfStakingIds = _id;
        amountOfStakingSoil += amountSoil;

        tokenSoil.mint(address(this), amountSoil);
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

    function emergencyWithdrawal(
        uint _amount
    ) public onlyRole(DEFAULT_ADMIN_ROLE) {
        Ierc20.transfer(msg.sender, _amount);
    }

    
    function mintSoilWalletProyect(uint _amount) external onlyRole(CREATE_STAKING_ROLE){
        tokenSoil.mint(walletProyect, _amount);
    }

    function emergencyWithdrawalBNB() public onlyRole(DEFAULT_ADMIN_ROLE) {
        Address.sendValue(payable(msg.sender), address(this).balance);
    }

    function getStaking(address _owner) public view returns (Data[] memory) {
        Data[] memory _data = new Data[](OwnerStakingIds[_owner].length);
        for (uint i = 0; i < OwnerStakingIds[_owner].length; i++) {
            _data[i] = StakingData[OwnerStakingIds[_owner][i]];
        }
        return _data;
    }

    function getStakingId(uint _id) public view returns (Data memory) {
        return StakingData[_id];
    }
}
