// SPDX-License-Identifier: MIT
pragma solidity 0.8.20; //Do not change the solidity version as it negatively impacts submission grading

// @Dev Built by Domum Digital. Est. 2021.
// Originally deployed at 0xb35338C074A8cFcb46aA56424cF4DA48d888CC6f

contract ExampleExternalContract {
    bool public completed;

    function complete() public payable {
        completed = true;
    }
}

