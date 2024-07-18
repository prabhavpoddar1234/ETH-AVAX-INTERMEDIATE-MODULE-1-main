// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract Crowdfunding {
    address public owner;
    mapping(address => uint) public contributions;
    uint public totalContributors;
    uint public minimumContribution;
    uint public raisedAmount;
    uint public goal;
    uint public deadline;

    // Events
    event ContributionReceived(address indexed contributor, uint amount);

    constructor(uint _goal, uint _duration) {
        owner = msg.sender;
        goal = _goal;
        deadline = block.timestamp + _duration;
        minimumContribution = 100 wei;
    }

    function contribute() external payable {
        require(block.timestamp < deadline, "Funding period has ended.");
        require(msg.value >= minimumContribution, "Minimum contribution not met!");

        if (contributions[msg.sender] == 0) {
            totalContributors++;
        }
        contributions[msg.sender] += msg.value;
        raisedAmount += msg.value;

        emit ContributionReceived(msg.sender, msg.value);
    }
    
    function checkGoalReached() external view returns (bool) {
        return raisedAmount >= goal;
    }

    function getBalance() external view returns(uint) {
        return address(this).balance;
    }

    // Fallback function to accept contributions
    receive() external payable {
        contribute();
    }
}
