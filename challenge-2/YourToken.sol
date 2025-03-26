
pragma solidity 0.8.20; //Do not change the solidity version as it negatively impacts submission grading
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// learn more: https://docs.openzeppelin.com/contracts/4.x/erc20

contract YourToken is ERC20 {
    constructor() ERC20("Gold", "GLD") {
        _mint(0xF3242e3EF228820E2fc84232B6837eB92f887017, 1000 * 10 ** 18);
        // ^ Using our LocalHost burner address to mint the initial supply to.
    }
}
