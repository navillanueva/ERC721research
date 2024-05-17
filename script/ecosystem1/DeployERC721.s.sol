// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import "../../src/ecosystem1/ERC721.sol";

contract DeployERC721 is Script {
    function run() public {
        vm.startBroadcast();
        bytes32 merkleRoot = bytes32(uint256(vm.envUint("MERKLE_ROOT")));
        MyNFT nft = new MyNFT(merkleRoot);
        console.log("Deployed ERC721 at:", address(nft));
        vm.stopBroadcast();
    }
}
