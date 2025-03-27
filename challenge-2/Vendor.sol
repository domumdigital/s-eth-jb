pragma solidity 0.8.20; //Do not change the solidity version as it negatively impacts submission grading
// SPDX-License-Identifier: MIT

// @dev Built by Domum Digital. Est. 2021.

// import "@openzeppelin/contracts/access/Ownable.sol";
import "./YourToken.sol";

contract Vendor {
    event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);

    uint256 public constant tokensPerEth = 100;

    YourToken public yourToken;

    constructor(address tokenAddress) {
        yourToken = YourToken(tokenAddress);
    }

    // ToDo: create a payable buyTokens() function:
    function buyTokens() public payable {
        require(msg.value > 0, "MORE ETH REQUIRED");

        uint256 amountOfTokens = msg.value * tokensPerEth;

        uint256 vendorBalance = yourToken.balanceOf(address(this));
        require(vendorBalance >= amountOfTokens, "Vendor has insufficient tokens");

        emit BuyTokens(msg.sender, msg.value, amountOfTokens);

        yourToken.transfer(msg.sender, tokensPerEth);
    }

    // ToDo: create a withdraw() function that lets the owner withdraw ETH

    // ToDo: create a sellTokens(uint256 _amount) function:
}
