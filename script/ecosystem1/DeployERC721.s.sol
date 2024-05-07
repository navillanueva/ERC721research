// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "../../src/ecosystem1/ERC721.sol";
import "forge-std/console.sol";

contract DeployERC721 is Script {
    function run() public {
        vm.startBroadcast();
        bytes32 merkleRoot = bytes32(uint256(vm.envUint("MERKLE_ROOT")));
        MyNFT nft = new MyNFT(merkleRoot);
        console.log(address(nft)); // Log the address clearly
        vm.stopBroadcast();
    }
}
