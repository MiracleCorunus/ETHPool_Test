// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ETHPool is ReentrancyGuard, Ownable {
    using Counters for Counters.Counter;

    struct UserInfo {
        bool isDeposited; // The status of user deoposited or not
        bool isWithdrawed; // The status of user withdrawed or not
        uint256 depositedAmount; // The amount of deposited ETH per user
        uint256 rewardAmount; // The amount of Reward for user account
    }

    uint256 public totalDeposited;
    mapping(address => UserInfo) public userInfo;
    mapping(uint256 => address) public depositedUsers;

    Counters.Counter public depositedUserCount;

    constructor() {}

    function depositETH() public payable {
        require(msg.value != 0, "Amount of Deposit can't be zero!");
        require(
            !userInfo[msg.sender].isDeposited &&
                !userInfo[msg.sender].isWithdrawed,
            "User already deposit the ETH to pool or user already withdraw!"
        );

        userInfo[msg.sender] = UserInfo(true, false, msg.value, 0);
        totalDeposited += msg.value;
        depositedUsers[depositedUserCount.current()] = msg.sender;
        depositedUserCount.increment();
    }

    function depositReward() public payable onlyOwner {
        require(msg.value != 0, "Amount of Reward can't be zero!");
        require(
            depositedUserCount.current() != 0,
            "There is no user who deposite to pool!"
        );
        for (uint256 i = 0; i < depositedUserCount.current(); i++) {
            if (
                userInfo[depositedUsers[i]].isDeposited &&
                !userInfo[depositedUsers[i]].isWithdrawed
            ) {
                UserInfo storage _userInfo = userInfo[depositedUsers[i]];
                _userInfo.rewardAmount +=
                    (msg.value * _userInfo.depositedAmount) /
                    totalDeposited;
            }
        }
    }

    function withdraw() external payable {
        require(
            userInfo[msg.sender].isDeposited &&
                !userInfo[msg.sender].isWithdrawed
        );
        UserInfo storage _userInfo = userInfo[msg.sender];
        uint256 amount = _userInfo.depositedAmount + _userInfo.rewardAmount;
        payable(msg.sender).transfer(amount);
        _userInfo.isWithdrawed = true;
        totalDeposited -= _userInfo.depositedAmount;
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function getBalanceOfUser() public view returns (uint256) {
        return msg.sender.balance;
    }
}
