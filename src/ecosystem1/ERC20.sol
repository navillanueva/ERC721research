// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract MyERC20 is ERC20, Ownable {
    // Initially the deployer is set as the owner
    constructor(address initialOwner) ERC20("MyToken", "MTK") {
        // Transfer ownership to the staking contract
        transferOwnership(initialOwner);
    }

    // Ensure only the owner (staking contract) can mint new tokens.
    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }
}
