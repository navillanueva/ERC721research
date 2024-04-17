// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "../../src/ecoystem1/ERC721.sol";

contract DeployERC721 is Script {
    function run() public {
        vm.startBroadcast();

        bytes32 merkleRoot = 0x123...;  // Placeholder for the actual Merkle root
        MyNFT nft = new MyNFT(merkleRoot);

        vm.stopBroadcast();
    }
}
