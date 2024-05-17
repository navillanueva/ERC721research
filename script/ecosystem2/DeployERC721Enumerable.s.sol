// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import "../../src/ecosystem2/ERC721Enumerable.sol";

contract DeployERC721Enumerable is Script {
    function run() public {
        vm.startBroadcast();
        MyEnumerableNFT E_nft = new MyEnumerableNFT(merkleRoot);
        console.log("Deployed ERC721Enumerable at:", address(W_nft));
        vm.stopBroadcast();
    }
}
