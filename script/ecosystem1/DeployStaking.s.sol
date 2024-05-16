// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import "../../src/ecosystem1/Staking.sol";
import "../../src/ecosystem1/ERC721.sol";
import "../../src/ecosystem1/ERC20.sol";

contract DeployStaking is Script {
    function run() public {
        vm.startBroadcast();

        address nftAddress = vm.envAddress("NFT_ADDRESS");
        address erc20Address = vm.envAddress("ERC20_ADDRESS");

        console.log("Received NFT Address:", nftAddress);
        console.log("Received ERC20 Address:", erc20Address);

        Staking staking = new Staking(nftAddress, erc20Address);
        console.log("Deployed staking contract at:", address(staking));

        vm.stopBroadcast();
    }
}
