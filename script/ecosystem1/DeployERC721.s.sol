// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "../../src/ecosystem1/ERC721.sol";

contract DeployERC721 is Script {
    function run() public {
        vm.startBroadcast();
        // for deployments purposes only the merkle root is hardcoded into the local blockcahain
        bytes32 merkleRoot = bytes32(uint256(vm.envUint("MERKLE_ROOT")));
        MyNFT nft = new MyNFT(merkleRoot);
        vm.stopBroadcast();
    }
}
