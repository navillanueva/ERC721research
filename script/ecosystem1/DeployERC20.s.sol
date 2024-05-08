// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import "../../src/ecosystem1/ERC20.sol";

contract DeployERC20 is Script {
    function run() public {
        vm.startBroadcast();
        MyERC20 token = new MyERC20();
        console.log("Deployed ERC20 at:", address(token));
        vm.stopBroadcast();
    }
}
