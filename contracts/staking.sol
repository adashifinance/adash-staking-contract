//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract Staking is ReentrancyGuard, Ownable {
    using SafeERC20 for IERC20;
    using SafeMath for uint256;

    //staking token address
    IERC20 public token;

    // Staker info
    struct Staker {
        // The deposited tokens of the Staker
        uint256 deposited;
        // Last time of details update for Deposit
        uint256 timeOfLastUpdate;
        // Calculated, but unclaimed rewards. These are calculated each time
        // a user writes to the contract.
        uint256 unclaimedRewards;
    }

    // Rewards per year. A fraction calculated as x/10000 to get the percentage
    uint256 public rewardsPerYear;

    // Minimum amount to stake
    uint256 constant minStake = 10 ether;

    // Compounding frequency limit in seconds
    uint256 constant compoundFreq = 31536000; // 86400 hours 365 days

    // Mapping of address to Staker info
    mapping(address => Staker) internal stakers;

    constructor(address _token, uint256 _rewardsPerYear){
        token = IERC20(_token);
        rewardsPerYear = _rewardsPerYear;
    }


    // If address has no Staker struct, initiate one. If address already was a stake,
    // calculate the rewards and add them to unclaimedRewards, reset the last time of
    // deposit and then add _amount to the already deposited amount.
    // Burns the amount staked.
    function deposit(uint256 _amount) external nonReentrant {
        require(_amount >= minStake, "Amount smaller than minimimum deposit");
        require(
            token.balanceOf(msg.sender) >= _amount,
            "Can't stake more than you own"
        );
        if (stakers[msg.sender].deposited == 0) {
            stakers[msg.sender].deposited = _amount;
            stakers[msg.sender].timeOfLastUpdate = block.timestamp;
            stakers[msg.sender].unclaimedRewards = 0;
        } else {
            uint256 rewards = calculateRewards(msg.sender);
            stakers[msg.sender].unclaimedRewards.add(rewards);
            stakers[msg.sender].deposited.add(_amount);
            stakers[msg.sender].timeOfLastUpdate = block.timestamp;
        }
        token.safeTransferFrom(msg.sender, address(this), _amount);
    }

    // Compound the rewards and reset the last time of update for Deposit info
    function stakeRewards() external nonReentrant {
        require(stakers[msg.sender].deposited > 0, "You have no deposit");
        require(
            compoundRewardsTimer(msg.sender) == 0,
            "Tried to compound rewards too soon"
        );
        uint256 rewards = calculateRewards(msg.sender).add(stakers[msg.sender].unclaimedRewards);
        stakers[msg.sender].unclaimedRewards = 0;
        stakers[msg.sender].deposited.add(rewards);
        stakers[msg.sender].timeOfLastUpdate = block.timestamp;
    }

    // transfer rewards for msg.sender
    function claimRewards() external nonReentrant {
        uint256 rewards = calculateRewards(msg.sender).add(stakers[msg.sender].unclaimedRewards);
        require(rewards > 0, "You have no rewards");
        stakers[msg.sender].unclaimedRewards = 0;
        stakers[msg.sender].timeOfLastUpdate = block.timestamp;
        token.safeTransfer(msg.sender, rewards);
    }

    // Withdraw specified amount of staked tokens
    function withdraw(uint256 _amount) external nonReentrant {
        require(
            stakers[msg.sender].deposited >= _amount,
            "Can't withdraw more than you have"
        );
        uint256 _rewards = calculateRewards(msg.sender);
        stakers[msg.sender].deposited.sub(_amount);
        stakers[msg.sender].timeOfLastUpdate = block.timestamp;
        stakers[msg.sender].unclaimedRewards = _rewards;
        token.safeTransfer(msg.sender, _amount);
    }

    // Withdraw all stake and rewards the msg.sender
    function withdrawAll() external nonReentrant {
        require(stakers[msg.sender].deposited > 0, "You have no deposit");
        uint256 _rewards = calculateRewards(msg.sender).add(stakers[msg.sender].unclaimedRewards);
        uint256 _deposit = stakers[msg.sender].deposited;
        stakers[msg.sender].deposited = 0;
        stakers[msg.sender].timeOfLastUpdate = 0;
        uint256 _amount = _rewards + _deposit;
        token.safeTransfer(msg.sender, _amount);
    }

    // Function useful for fron-end that returns user stake and rewards by address
    function getDepositInfo(address _user)
        public
        view
        returns (uint256 _stake, uint256 _rewards)
    {
        _stake = stakers[_user].deposited;
        _rewards =
            calculateRewards(_user).add(stakers[msg.sender].unclaimedRewards);
        return (_stake, _rewards);
    }

    // Utility function that returns the timer for restaking rewards
    function compoundRewardsTimer(address _user)
        public
        view
        returns (uint256 _timer)
    {
        if (stakers[_user].timeOfLastUpdate + compoundFreq <= block.timestamp) {
            return 0;
        } else {
            return
                (stakers[_user].timeOfLastUpdate.add(compoundFreq)).sub(block.timestamp);
        }
    }

    // Calculate the rewards since the last update on Deposit info
    function calculateRewards(address _staker)
        internal
        view
        returns (uint256 rewards)
    {
        return (((block.timestamp.sub(stakers[_staker].timeOfLastUpdate)).mul(stakers[_staker].deposited).mul(rewardsPerYear)) / 10000);
    }

    function setRewardDuration(uint256 _rewardDuration) external onlyOwner{
        rewardsPerYear = _rewardDuration;
    }
}