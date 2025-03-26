// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

// @dev Built by Domum Digital. Est. 2021.
// Originally deployed at 0x3457AF83E34E4ff23ED498863eA410f87875b5d5

import "hardhat/console.sol";
import "./ExampleExternalContract.sol";

contract Staker {
    ExampleExternalContract public exampleExternalContract;

    // Track user balances
    mapping(address => uint256) public balances;

    // Set threshold at 1 ether
    uint256 public constant threshold = 1 ether;

    // Set deadline to 30 seconds after deployment
    uint256 public deadline = block.timestamp + 30 seconds;

    // Boolean flags for contract state
    bool public openForWithdraw;
    bool public completed;

    // Event emitted when someone stakes funds
    event Stake(address indexed staker, uint256 amount);

    constructor(address exampleExternalContractAddress) {
        exampleExternalContract = ExampleExternalContract(exampleExternalContractAddress);
    }

    // Add the modifier here
    modifier notCompleted() {
        require(!exampleExternalContract.completed(), "Staking already completed!");
        _;
    }

    function stake() public payable {
        // Ensure the user is sending ETH
        require(msg.value > 0, "NOT ENOUGH!!!");

        // Add the staked amount to the user's balance
        balances[msg.sender] += msg.value;

        // Emit the event for the frontend to detect
        emit Stake(msg.sender, msg.value);
    }

    function execute() public notCompleted {
        // Check if the deadline has passed
        require(block.timestamp >= deadline, "Deadline has not passed yet");

        // Check if the contract hasn't been completed already
        require(!completed, "Contract already completed");

        // Check if threshold is met
        if (address(this).balance >= threshold) {
            // If threshold is met, complete the external contract
            completed = true;
            exampleExternalContract.complete{ value: address(this).balance }();
        } else {
            // If threshold is not met, open the contract for withdrawals
            openForWithdraw = true;
        }
    }

    function withdraw() public notCompleted {
        // Check if the deadline has passed and the contract is open for withdrawals
        require(openForWithdraw, "Not open for withdraw");

        // Get the user's balance
        uint256 userBalance = balances[msg.sender];

        // Check if the user has a balance to withdraw
        require(userBalance > 0, "No balance to withdraw");

        // Reset the user's balance before transferring
        balances[msg.sender] = 0;

        // Transfer the user's balance back to them
        (bool success, ) = payable(msg.sender).call{ value: userBalance }("");
        require(success, "Transfer failed");
    }

    function timeLeft() public view returns (uint256) {
        // If deadline has passed, return 0
        if (block.timestamp >= deadline) {
            return 0;
        }

        // Otherwise, return time left
        return deadline - block.timestamp;
    }

    // Special function that receives ETH when someone sends ETH directly to the contract address.
    receive() external payable {
        stake();
    }
}

// After some `deadline` allow anyone to call an `execute()` function
// If the deadline has passed and the threshold is met, it should call `exampleExternalContract.complete{value: address(this).balance}()`

// If the `threshold` was not met, allow everyone to call a `withdraw()` function to withdraw their balance

// Add a `timeLeft()` view function that returns the time left before the deadline for the frontend

// Add the `receive()` special function that receives eth and calls stake()
